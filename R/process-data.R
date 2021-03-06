# define the function
#' @param df A data frame for the function to search through
#' @param pattern The pattern to look for. Should be what the variable name
#'   starts with.
#' @keywords internal
#' @noRd
sanitize_names <- function(df, pattern) {
  var_indices <- grep(paste0("^", pattern), names(df))
  nms <- names(df)[var_indices]
  digit <- gsub(".+_m(\\d?\\d?\\d)$", "\\1", nms)
  digit <- unique(digit[nchar(digit) == 1])

  out <- gsub(paste0(pattern, "_"), paste0(pattern, digit, "_"), nms)
  out <- gsub("_m\\d?\\d?\\d", "", out)
  gsub("___", ".", out)
}

sanitize_schedule <- function(x) {
  if (x == "baseline" | x == "end" | grepl("^\\d\\d? weeks$", x)) {
    return(x)
  }
  paste(x, "weeks")
}

#' Returns parent survey data
#'
#' @param d The full data. Output from [rts::get_rts_data()]
#' @param schedule The assessment schedule. Defaults to \code{baseline}.
#'   Should be one of \code{"baseline"}, \code{"2"}, \code{"4"}, \code{"8"},
#'   \code{"12"}, \code{"24"}, \code{"36"}, \code{"52"}, \code{"104"} or
#'   \code{"end"}.
#' @param severity The severity of the TBI. Defaults to \code{"mild"}.
#'   Should be one of \code{"mild"} or \code{"moderate/severe"}.
#' @param respondent The survey to retrieve. Should be one of \code{"parent"},
#'   \code{"student"}, \code{"teacher1"}, or \code{"teacher2"}.
#' @param survey One of \code{"survey"}, \code{"information"}, or
#'   \code{"satisfaction"}
#' @export
get_survey <- function(d, severity = "mild", schedule = "baseline",
                       respondent = "parent", survey = "survey") {

  data_collected <- paste(respondent, survey)

  row_select <- redcap_dict$arm == severity &
    redcap_dict$assessment == sanitize_schedule(schedule) &
    grepl(paste0("^", data_collected), redcap_dict$instrument)

  # Jeff to work on building out error messages if data doesn't exist
  tst <- redcap_dict[redcap_dict$arm == severity, ]
  if (!sanitize_schedule(schedule) %in% tst$assessment) {
    stop("schedule don't work",
         call. = FALSE)
  }

  selection <- redcap_dict[row_select, ]

  d_rows <- d[["redcap_event_name"]] == selection[["redcap_event_name"]] &
    d[selection$completed_var] == 2

  first <- grep(paste0("^", selection$first_var_selection, "$"), names(d))
  last <- grep(paste0("^", selection$final_var_selection, "$"), names(d))

  out <- d[d_rows, c(1, first:last)]

  nms <- unique(
    vapply(strsplit(names(out), "_"), function(x) x[1], FUN.VALUE = character(1)
    )
  )
  nms <- nms[-1]
  nms_sanitized <- unlist(lapply(nms, function(x) sanitize_names(out, x)))

  names(out) <- c("id", nms_sanitized)
  out
}
