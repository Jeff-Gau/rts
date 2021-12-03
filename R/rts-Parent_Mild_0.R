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
#' @param d The full data. Output from [rts::get_rts_data()]
#' @param schedule The assessment schedule. Defaults to \code{baseline}.
#'   Should be one of \code{"baseline"}, \code{"2"}, \code{"4"}, \code{"8"},
#'   \code{"12"}, \code{"24"}, or \code{"end"}.
#' @param severity The severity of the TBI. Defaults to \code{"mild"}.
#'   Should be one of \code{"mild"} or \code{"moderate/severe"}.
#' @export
get_parent <- function(d, schedule = "baseline", severity = "mild") {

  # severity_selection <- ifelse(
  #   severity == "mild", 1, ifelse(
  #     severity == "moderate/severe", 2,
  #     stop("`severity` must be one of `\"mild\"` or `\"moderate/severe\"`",
  #          call. = FALSE)
  #   )
  # )

  if (schedule == "baseline") {
    schedule_selection <- "baseline_arm_1"
  } else if (schedule == "end") {
    schedule_selection <- "end_of_study_arm_1"
  } else {
    schedule_selection <- paste0(schedule, "_weeks_arm_1")
  }


  return(var_select)
  # the arguments passed to subset will depend on the values passed to
  # \code{schedule} and \code{severity}
  row_select <- d$redcap_event_name == schedule_selection &
                  d$mild0_parent_survey_complete == 2

  # col_select <- c(
  #   1,
  #   grep("pdem_1_m0", names(d)):grep("sssu_4_m", names(d))
  # )

  # Jeff to fill in
  col_select <- switch(
    paste0(severity, "-", schedule),
    "mild-baseline" = grep("pdem_1_m0", names(d)):grep("sssu_4_m0", names(d)),
    "moderate/severe-baseline" = "xxx",
    "mild-2" = "yyy"
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
get_parent(d, severity = "mild", schedule = 2)
