# Homework 1

rm(list=ls())  # clears all previous work

# installing and loading packages:

install.packages("tidyverse")
library(tidyverse)

# Reading in Data of 2020

data2020 <- read.csv(file = "./Build/Input/ge2020cty.csv")
view(data2020) # to view data as a excel sheet

# Creating a new dataframe with only select vectors, namely, "OfficeName", "County", "Votes", and "PartyName" directly from the dataset, and a new vector "Total.Votes" by summing the total votes of each county. From "OfficeName", only "PRESIDENT AND VICE PRESIDENT"is kept, and from "PartyName", only "DEMOCRATIC" and "REPUBLICAN" is kept. 

data2020 <- data2020 %>%
  select(County, OfficeName, Votes, PartyName) %>%
  filter(OfficeName == "PRESIDENT AND VICE PRESIDENT") %>%
  group_by(County, OfficeName) %>%
  mutate(Total.Votes = sum(Votes)) %>%
  ungroup() %>%
  filter(PartyName %in% c("DEMOCRATIC", "REPUBLICAN")) %>%
  mutate(Share = Votes/Total.Votes,
         County = toupper(County)) %>%
  select(County, PartyName, Total.Votes , Share)

head(data2020)  # to check the first 6 rows of the new dataframe

# Reading in Data of 2024 and carrying out the same exercise as done with data of 2020

data2024 <- read.csv(file = "./Build/Input/ge2024cty.csv")
view(data2024)

data2024 <- data2024 %>%
  select(County, OfficeName, Votes, PartyName) %>%
  filter(OfficeName == "PRESIDENT AND VICE PRESIDENT") %>%
  group_by(County, OfficeName) %>%
  mutate(Total.Votes = sum(Votes)) %>%
  ungroup() %>%
  filter(PartyName %in% c("DEMOCRATIC", "REPUBLICAN")) %>%
  mutate(Share = Votes/Total.Votes,
         County = toupper(County)) %>%
  select(County, PartyName, Total.Votes, Share)

head(data2024) 

# Pivoting new dataframes created from 2020 and 2024 data to join them

data2020 <- data2020 %>%
  pivot_wider(id_cols = c("County", "Total.Votes"),
              names_from = "PartyName",
              values_from = "Share",
              names_prefix = "Y20")

head(data2020)

data2024 <- data2024 %>%
  pivot_wider(id_cols = c("County", "Total.Votes"),
              names_from = "PartyName",
              values_from = "Share",
              names_prefix = "Y24")

head(data2024)

# Joining the two new dataframes from 2020 and 2024

final.data <- data2020 %>%
  left_join(data2024, by = "County")

head(final.data)

# saving the joined dataframe

save(final.data,
     file = "./Build/Output/20-24 Election.RData")
