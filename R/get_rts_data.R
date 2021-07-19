#' Return full REDCap data
#'
#' Returns the full data across all surveys
#' @param redcap_api_token The API token from REDCap, passed as a string
#' @return A data frame with the raw data
#' @export

get_rts_data <- function(redcap_api_token) {
  redcap_read(
    redcap_uri = "https://redcap.uoregon.edu/api/",
    token = redcap_api_token,
    format = "json"
  )
}
