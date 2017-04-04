library(twitteR)
library(RMySQL)
library(gtools)

setwd("~/git/twitter-senti-bio")
readRenviron(paste(getwd(), "/.Renviron", sep=""))

api_key <- Sys.getenv("api_key")
api_secret <- Sys.getenv("api_secret")

access_token <- Sys.getenv("access_token")
access_secret <- Sys.getenv("access_secret")

db_user <- Sys.getenv("db_user")
db_pass <- Sys.getenv("db_pass")
db_name <- Sys.getenv("db_name")

scientific_ids_table <- table(factor(c("754937215302631424")))

setup_twitter_oauth(api_key, api_secret, access_token, access_secret)

register_mysql_backend("biotweets", "127.0.0.1", "root", "topkek")

tweets <- userTimeline("754937215302631424", 5, excludeReplies = TRUE)

tweetsDF <- twListToDF(tweets)

orderedIds <- mixedorder(tweetsDF$id)

minId <- tweetsDF$id[orderedIds[1]]

olderTweets <- userTimeline("754937215302631424", 5, excludeReplies = TRUE, maxID = as.numeric(minId) - 1)