# clear all
rm(list=ls())
install.packages("tinyverse")
libary(tinyverse)
install.packages("tidyverse")
library(tidyverse)

# read in data
e.data <- read.csv(file = "./Build/Input/ge2024cty.csv")

View(e.data)

e.data[,4]
e.data[657,4]
e.data$BallotGroup
e.data$BallotGroup[657]
e.data[1:4,]
summary(e.data)

# wrangle data
e.data.2 <- e.data %>%
  select(County, OfficeName, Votes, PartyName, BallotGroup) %>%
  group_by(County, OfficeName) %>%
    mutate(Total.Votes = sum(Votes)) %>%
  ungroup() %>%
  mutate(share = Votes/Total.Votes,
         County = toupper(County)) %>%
  filter(BallotGroup == "A",
  !is.na(share))
head(e.data.2)


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
         temp = gsub(" County", "", temp),
         County = toupper(temp),
         County = case_when(County == "DE WITT" ~ "DEWITT",
                            County == "JO DAVIESS" ~ "JODAVIESS",
                            TRUE ~ County))
head(cen.dat.2)

# == is logic & = is assignment

# merge the data
core <- cen.dat.2 %>%
  left_join(., e.data.2, by = "County") %>%
  mutate(vote.rate = Total.Votes / pop)

# regression analysis
fast.male <- cen.dat %>%
  st_drop_geometry() %>%   #This removes the sf features to speed up processing
    filter(variable %in% temp) %>%
  summarise(male = sum(estimate), .by = c(NAME))

summarise(core)
head(core)

#Visualization Quickly
core.2 <- core %>%
  select(County, vote.rate) %>%
  distinct()

ggplot(core.2) +
  geom_sf(aes(fill = vote.rate)) +
  theme_minimal()






