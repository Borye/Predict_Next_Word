library(shiny)
library(RWeka)
library(data.table)
library(wordcloud)
library(rCharts)

#setwd("C:/Users/Borye/Documents/GitHub/Data-Science-Specialization/10-DataScienceCapstone/Shiny")

load("data/one.RData")
load("data/two.RData")
load("data/three.RData")
load("data/one_training.RData")
load("data/two_training.RData")
load("data/three_training.RData")
load("data/one_training_table.RData")
load("data/two_training_table.RData")
load("data/three_training_table.RData")


one_learn <- data.frame(Token = "aaa", Freq = 0)
two_learn <- data.frame(Token = "aaa", Freq = 0)
three_learn <- data.frame(Token = "aaa", Freq = 0)
learn <- data.frame(Token = "aaa", Freq = 0)
Prediction <- NULL
num <- 0
test <- data.frame(statistic = c("Number of N-gram", "MAX"), value = c("1", "100"))

source("prediction.R")

capwords <- function(s, strict = FALSE) {
    cap <- function(s) paste(toupper(substring(s, 1, 1)),
{s <- substring(s, 2); if(strict) tolower(s) else s},
sep = "", collapse = " " )
sapply(strsplit(s, split = " "), cap, USE.NAMES = !is.null(names(s)))
}


