library(twitteR)
library(RMySQL)
library(tm)
library(wordcloud)
library(RColorBrewer)

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
sci <- paste(sci_texts, collapse = " ")

org_texts <- cleanText(org_tweets$text)
org <- paste(org_texts, collapse = " ")

all <- c(sci, org)
all <- removeWords(all, c(stopwords("english"), "sci", "org"))

corpus <- Corpus(VectorSource(all))

tdm = TermDocumentMatrix(corpus)
tdm = as.matrix(tdm)
colnames(tdm) <- c("Scientists", "Pseudoscientists")

cloud <- comparison.cloud(tdm, random.order = FALSE, colors = c("blue", "red"), title.size = 1.5, max.words = 600)