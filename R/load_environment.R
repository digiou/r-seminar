readRenviron(paste(getwd(), "/.Renviron", sep=""))

api_key <- Sys.getenv("api_key")
api_secret <- Sys.getenv("api_secret")

access_token <- Sys.getenv("access_token")
access_secret <- Sys.getenv("access_secret")

db_user <- Sys.getenv("db_user")
db_pass <- Sys.getenv("db_pass")
db_name <- Sys.getenv("db_name")
db_host <- Sys.getenv("db_host")
sci_table_name <- Sys.getenv("sci_table_name")
org_table_name <- Sys.getenv("org_table_name")