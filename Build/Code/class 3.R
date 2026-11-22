
install.packages("tidycensus")
library(tidycensus)
library(tidyverse)

census_api_key("85a58505e00fcaedc198948f45a5d5bcb908cf20", install = TRUE)

acs<- load_variables(year = 2024, dataset = "acs5")
head(acs)

# define the list of variables to pull from the acs
temp <- paste("B01001", str_pad(7:25, width = 3, side = "left", pad = "0"), sep = "_")
temp2 <- paste("B01001", str_pad(31:49, width = 3, side = "left", pad = "0"), sep = "_")
vars <- c(temp, temp2)

# call the US Census API
cen.dat <- get_acs(geography = "county",
                   variables = vars,
                   state = "17",
                   year = 2024,
                   geometry = TRUE)
head(cen.dat)

cen.dat.2 <- cen.dat %>%
  summarise(pop = sum(estimate), .by = c(NAME, geometry)) %>%
  mutate(temp = str_split_i(NAME, ",", 1),
         temp = gsub(" county", "", temp),
         county = toupper(temp),
         county = case_when(county == "DE WITT" ~ "DEWITT",
                            county == "JO DAVIESS" ~ "JODAVIESS",
                            TRUE ~ county))
head(cen.dat.2)

# == is logic & = is assignment

# merge the data
core <- cen.dat.2 %>%
  left_join(., e.data.2, by = "county") %>%
  mutate(vote.rate = Total.Votes / pop)

load(e.data.2)