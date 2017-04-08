library(twitteR)
library(RMySQL)
library(tm)
library(devtools)
library(SentimentAnalysis)

source("load_environment.R")

register_mysql_backend(db_name, db_host, db_user, db_pass)

sci_tweets <- load_tweets_db(as.data.frame = TRUE, table_name = sci_table_name)

org_tweets <- load_tweets_db(as.data.frame = TRUE, table_name = org_table_name)

cleanText <- function(document) {
  # tolower
  x = tolower(document)
  # remove rt
  x = gsub("rt", "", x)
  # remove at
  x = gsub("@\\w+", "", x)
  # remove punctuation
  x = gsub("[[:punct:]]", "", x)
  # remove numbers
  x = gsub("[[:digit:]]", "", x)
  # remove links http
  x = gsub("http\\w+", "", x)
  # remove tabs
  x = gsub("[ |\t]{2,}", "", x)
  # remove blank spaces at the beginning
  x = gsub("^ ", "", x)
  # remove blank spaces at the end
  x = gsub(" $", "", x)
  return(x)
}

sci_texts <- cleanText(sci_tweets$text)
sci_senti <- analyzeSentiment(sci_texts, removeStopwords = TRUE)

org_texts <- cleanText(org_tweets$text)
org_senti <- analyzeSentiment(org_texts, removeStopwords = TRUE)

plotSentiment(sci_senti$SentimentGI)
plotSentiment(org_senti$SentimentGI)

sci_senti_table <- table(convertToBinaryResponse(sci_senti$SentimentGI))
org_senti_table <- table(convertToBinaryResponse(org_senti$SentimentGI))

sci_happiest <- sci_texts[[which.max(sci_senti$SentimentGI)]]
sci_saddest <- sci_texts[[which.min(sci_senti$SentimentGI)]]

org_happiest <- org_texts[[which.max(org_senti$SentimentGI)]]
org_saddest <- org_texts[[which.min(org_senti$SentimentGI)]]