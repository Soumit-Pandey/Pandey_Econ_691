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

