library(twitteR)
library(RMySQL)
library(tm)

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

chars_per_tweet_sci <- sapply(sci_texts, nchar)
chars_per_tweet_org <- sapply(org_texts, nchar)

words_list_sci <- strsplit(sci_texts, " ")
stop_sci <- removeWords(unlist(words_list_sci), c(stopwords("english")))

words_list_org <- strsplit(org_texts, " ")
stop_org <- removeWords(unlist(words_list_org), c(stopwords("english")))

words_per_tweet_sci <- sapply(words_list_sci, length)
words_per_tweet_org <- sapply(words_list_org, length)

uniq_words_sci <- unique(stop_sci)
uniq_words_org <- unique(stop_org)

barplot(table(words_per_tweet_sci), border = NA, main = "Distribution of words per tweet for scientific tweets", cex.main=1)
barplot(table(words_per_tweet_org), border = NA, main = "Distribution of words per tweet for organizational tweets", cex.main=1)

mfw_sci <- sort(table(stop_sci), decreasing = TRUE)
top20_sci <- head(mfw_sci, 20)

mfw_org <- sort(table(stop_org), decreasing = TRUE)
top20_org <- head(mfw_org, 20)