create_regex_all <- function(...) {
  strings <- list(...)
  escaped_strings <- sapply(strings, function(s) gsub("([\\W])", "\\\\\\1", s))
  regex_pattern <- paste0("(?=.*", escaped_strings, ")", collapse = "")
  return(regex_pattern)
}
returnSettingsList <- function( ) {
  db_settings <- list(
    optum = list(
      cdm_schema = 'optum_dod_2024q1_cdm_540',
      write_schema = 'insight_gateway_app',
      cohort_tables = 'cohorttable'
    ),
    ccmr = list(
      cdm_schema = 'marketscan_ccmr_2023q4_cdm_540',
      write_schema = 'insight_gateway_app',
      cohort_tables = 'mm_two_visits'
    ),
    hv = list(
      cdm_schema = 'healthverity_202407_cdm_540',
      write_schema = 'insight_gateway_app',
      cohort_tables = 'quazi_rec'
    )
  )
}
getSpecDataframe <- function(
  cdmConnCdmSpec,
  domainToSearch = 'Measurement',
  patternToSearch = c('transglutaminase')
) {
  measurements <- cdm$concept %>%
    filter(domain_id  == 'Measurement' &
             stringr::str_detect(tolower(concept_name), pattern)) %>%
    inner_join(cdm$measurement, join_by(
      concept_id == measurement_concept_id
    )) %>% select(
      measurement_name = concept_name,
      concept_id,
      unit_source_value,
      unit_concept_id,
      value_as_concept_id
    ) %>% distinct() %>% as.data.frame() %>%
    dplyr::arrange(measurement_name)
}
getDbList <- function() {
  dbList <- list(
    optum = 'optum_prod',
    ccmr = 'truven_prod',
    hv = 'healthverity_prod'
  )
}

