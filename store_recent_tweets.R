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

scientific_ids_table <- array(c("754937215302631424", 
                                "20769532",
                                "52889950",
                                "487833518",
                                "1737474631",
                                "806253116182188032",
                                "87706747",
                                "523433085",
                                "224991073",
                                "1608950586",
                                "403163083",
                                "48473838",
                                "273984889",
                                "18049298",
                                "3121167195"))

orgz_ids_table <- array(c("15862891"))

setup_twitter_oauth(api_key, api_secret, access_token, access_secret)

register_mysql_backend("biotweets", "127.0.0.1", "root", "topkek")

gatherAllTweets <- function(accountId) { 
    res = list()
    tweets <- userTimeline(accountId, 3200, excludeReplies = TRUE)
    res <- list(res, tweets)
    message(paste("GOT ", length(tweets), " elements!"))
    message("Sleeping for 5 minutes, got initial request!")
    Sys.sleep(300)
    while(length(tweets) != 0) {
       tweetsDF <- twListToDF(tweets)
       orderedIds <- mixedorder(tweetsDF$id)
       minId <- tweetsDF$id[orderedIds[1]]
       tweets <- userTimeline(accountId, 3200, excludeReplies = TRUE, maxID = as.numeric(minId) - 1)
       if(length(tweets) == 0) {
         print("GOT ZERO")
       } else if(length(tweets) < 100 && length(tweets) >= 1){
         res <- list(res, tweets)
         message(paste("GOT ", length(tweets), " elements!"))
         message("got low count of tweets!")
         tweets = list()
       } else {
         res <- list(res, tweets)
         message(paste("GOT ", length(tweets), " elements!"))
         message("Sleeping for 5 minutes, got a request!")
         Sys.sleep(300)
       }
    }
    message("Finished while loop")
    return(res)
}

gatherAllTweetsWithTry <- function(accountId) {
  out <- tryCatch({
    gatherAllTweets(accountId)
  },
  warning=function(cond) {
    message("Hit a warning, sleeping for 15 minutes")
    Sys.sleep(630)
    gatherAllTweetsWithTry(accountId)
  },
  error=function(cond) {
    message("Hit an error, sleeping for 15 minutes")
    Sys.sleep(630)
    gatherAllTweetsWithTry(accountId)
  }
  )
  return(out)
}

for (account_id in scientific_ids_table) {
  message(paste("Getting tweets for user: ", account_id))
  tweets <- gatherAllTweetsWithTry(account_id)
  store_tweets_db(tweets)
  message("Done")
}