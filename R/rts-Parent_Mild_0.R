# define the function
#' @param df A data frame for the function to search through
#' @param pattern The pattern to look for. Should be what the variable name
#'   starts with.
#' @keywords internal
#' @noRd
sanitize_names <- function(df, pattern) {
  var_indices <- grep(paste0("^", pattern), names(df))
  nms <- names(df)[var_indices]
  out <- gsub(paste0(pattern, "_"), paste0(pattern, "0_"), nms)
  out <- gsub("_m0", "", out)
  gsub("___", ".", out)
}

#' Returns parent survey data
#'
#' @param d The full data. Output from [get_rts_data]
#' @param schedule The assessment schedule. Defaults to \code{baseline}.
#'   Should be one of \code{"baseline"}, \code{"2"}, \code{"4"}, \code{"8"}, 
#'   \code{"12"}, \code{"24"}, or \code{"end"}. 
#' @param severity The severity of the TBI. Defaults to \code{"mild/moderate"}.
#'   Should be one of \code{"mild/moderate"} or \code{"severe"}.
#' @export
get_parent <- function(d, schedule = "baseline", severity = "mild/moderate") {
  # if (severity == "mild/moderate") {
  #   mild0_parent_survey_complete == 2
  # } else if (severity == "severe") {
  #   mild0_parent_survey_complete == 1
  # }

  # the arguments passed to subset will depend on the values passed to
  # \code{schedule} and \code{severity}
  row_select <- d$redcap_event_name == "baseline_arm_1" &
                  d$mild0_parent_survey_complete == 2
  col_select <- c(
    1,
    grep("pdem_1_m0", names(d)):grep("sssu_4_m0", names(d))
  )
  d2 <- d[row_select, col_select]

  # d2 <- subset(
  #   d,
  #   redcap_event_name == "baseline_arm_1" & mild0_parent_survey_complete == 2,
  #   select = c(record_id, pdem_1_m0:sssu_4_m0)
  # )
  # eventually we will automatically sanitize all names
  nms <- unique(
    vapply(strsplit(names(d2), "_"), function(x) x[1], FUN.VALUE = character(1)
    )
  )
  nms <- nms[-1]
  nms_sanitized <- unlist(lapply(nms, function(x) sanitize_names(d2, x)))

  names(d2) <- c("id", nms_sanitized)
  d2
}


# nrow(d)
# ncol(d)

# nrow(d2)
# ncol(d2)

#Renaming and computing new variables
# ppcsi_vars <- grep("^ppcsi", names(d2))
# tmp <- names(d2)[ppcsi_vars]
# tmp2 <- gsub("ppcsi_", "ppcsi0_", tmp)
# tmp2 <- gsub("_m0", "", tmp2)



# apply the function
# sanitize_names(d2, "pclass")

