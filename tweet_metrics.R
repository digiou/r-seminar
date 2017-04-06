library(twitteR)
library(RMySQL)
library(tm)
library(ggplot2)

source("load_environment.R")

register_mysql_backend(db_name, db_host, db_user, db_pass)

sci_tweets <- load_tweets_db(as.data.frame = TRUE, table_name = sci_table_name)

#org_tweets <- load_tweets_db(as.data.frame = TRUE, table_name = org_table_name)

sci_corpus <- Corpus(VectorSource(sci_tweets$text))

#org_corpus <- Corpus(VectorSource(org_tweets$text))

cleanDatum <- function(document) {
  clean_doc <- stripWhitespace(document)
  clean_doc <- tolower(clean_doc)
  clean_doc <- removeWords(clean_doc, stopwords(kind = "en"))
  clean_doc <- removePunctuation(clean_doc)
  clean_doc <- removeNumbers(clean_doc)
  return(clean_doc)
}

cleanCorpus <- function(corpus) {
  clean_corpus <- tm_map(corpus, cleanDatum)
  return(clean_corpus)
}

sci_corpus <- cleanCorpus(sci_corpus)