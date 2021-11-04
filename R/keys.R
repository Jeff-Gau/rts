#' Access your key from .Renviron
#'
#' This function is primarily used as the default argument for
#'   [get_rts_data()], but can be run at any time to access your
#'   specific key. Note that you should first set your key with 
#'   [redcap_set_key()].
#'
#' @export
#'
#' @examples
#' \dontrun{
#' library(rts)
#' redcap_key()
#' }
#'
redcap_key <- function() {
  key <- Sys.getenv("redcap_rts_token")
  if (nchar(key) < 1) {
    return(stop(paste0(
      "Key not found in R Environment. Please inspect ",
      "`usethis::edit_r_environ()` and ensure your api token is called ",
      "\"redcap_rts_token\" or provide the key to the function directly."
    ), call. = FALSE))
  }
  key
}

#' Function to set a key for accessing the Return to School data from REDCap
#'
#' This function adds your key to your .Renviron so it is accessible by
#' [redcap_key()]. You should only need to run this function once. Make sure to
#' restart your local R session after running this function for the changes
#' to take effect.
#'
#' @param key A string of your specific key
#' @param overwrite Defaults to \code{FALSE}. If there is a key already in the
#'   .Renviron, should it be overwritten?
#'
#' @export
#'
#' @examples
#' library(rts)
#' \dontrun{
#' redcap_set_key("abcdefghikjlmnop")
#' }
redcap_set_key <- function(key, overwrite = FALSE) {
  token <- paste0('redcap_rts_token = "', key, '"')

  # create .Renviron if it doesn't already exist
  if (!any(grepl("\\.Renviron", system("ls -a $HOME", intern = TRUE)))) {
    system("touch $HOME/.Renviron")
  }

  home <- system("eval echo $HOME", intern = TRUE)
  renviron <- readLines(file.path(home, ".Renviron"))

  current_token <- grep("redcap_rts_token", renviron)
  if (length(current_token) > 0) {
    if (overwrite) {
      renviron[current_token] <- token
    } else {
      stop("`redcap_rts_token` already exists in .Renviron. ",
        "Run again with `overwrite = TRUE` to overwrite the existing key.",
        call. = FALSE
      )
    }
  } else {
    placement <- length(renviron) + 1
    renviron[placement] <- token
  }
  writeLines(renviron, file.path(home, ".Renviron"))
  message("Make sure to restart R for changes to take effect")
}
