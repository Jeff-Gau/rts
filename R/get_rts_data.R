#' Return full REDCap data
#'
#' Returns the full data across all surveys
#' @param redcap_api_token The API token from REDCap, passed as a string
#' @return A data frame with the raw data
#' @export

get_rts_data <- function(redcap_api_token = get_token()) {
  redcap_read(
    redcap_uri = "https://redcap.uoregon.edu/api/",
    token = redcap_api_token,
    format = "json"
  )$data
}

get_token <- function() {
  key <- Sys.getenv("redcap_rts_token")
  if(nchar(key) < 1) {
    return(stop(paste0(
      "Key not found in R Environment. Please inspect ",
      "`usethis::edit_r_environ()` and ensure your api token is called ",
      "'redcap_rts_token' or provide the key to the function directly."
    ), call. = FALSE
    ))
  }
  key
}
