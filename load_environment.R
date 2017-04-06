readRenviron(paste(getwd(), "/.Renviron", sep=""))

api_key <- Sys.getenv("api_key")
api_secret <- Sys.getenv("api_secret")

access_token <- Sys.getenv("access_token")
access_secret <- Sys.getenv("access_secret")

db_user <- Sys.getenv("db_user")
db_pass <- Sys.getenv("db_pass")
sci_db_name <- Sys.getenv("sci_db_name")
org_db_name <- Sys.getenv("org_db_name")