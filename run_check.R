source(here::here('R/functions.R'))
library(CDMConnector)
library(DBI)
library(tidyverse)
library(RPostgres)
setList <- returnSettingsList()
dbList <- getDbList()

# avalible databases
# optum = 'optum_prod',
# ccmr = 'truven_prod',
# hv = 'healthverity_prod'
db <- 'optum'
db_host <- keyring::key_get('db_server') # "takeda-redshift-{...}.redshift.amazonaws.com" # you need to have it
db_port <- "5439"
db_name_prod <- pluck(dbList, db)
db_user <- keyring::key_get('etl_user') # you need to have it
db_password <- keyring::key_get('etl_password') # you need to have it

con <- dbConnect(
  RPostgres::Redshift(),
  host = db_host,
  port = db_port,
  dbname = db_name_prod,
  user = db_user,
  password = db_password
)

if (!dbIsValid(con)) {
  stop("No Valid connection")
}
cdm <- CDMConnector::cdm_from_con(
  con,
  cdm_schema = pluck(pluck(setList, db), 'cdm_schema'),
  write_schema = pluck(pluck(setList, db), 'write_schema'),
  cohort_tables = pluck(pluck(setList, db), 'cohort_tables'))


specDf <- getSpecDataframe(
  cdmConnCdmSpec = cdm,
  patternToSearch = 'transglutaminase'
)
data.table::fwrite(specDf , '')
dbDisconnect(con)

