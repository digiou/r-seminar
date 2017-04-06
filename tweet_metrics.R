library(twitteR)
library(RMySQL)
library(tm)
library(ggplot2)

source("load_environment.R")

sci_tweets <- load_tweets_db(table_name = sci_table_name)