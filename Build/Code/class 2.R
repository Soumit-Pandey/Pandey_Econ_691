# clear all
rm(list=ls())
install.packages("tinyverse")
libary(tinyverse)

# read in data
e.data <- read.csv(file = "./Build/Input/ge2024cty.csv")

View(e.data)

e.data[,4]
e.data[657,4]
e.data$BallotGroup
e.data$BallotGroup[657]
e.data[1:4,]
summary(e.data)


