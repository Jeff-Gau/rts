% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/keys.R
\name{redcap_key}
\alias{redcap_key}
\title{Access your key from .Renviron}
\usage{
redcap_key()
}
\description{
This function is primarily used as the default argument for
\code{\link[=get_rts_data]{get_rts_data()}}, but can be run at any time to access your
specific key. Note that you should first set your key with
\code{\link[=redcap_set_key]{redcap_set_key()}}.
}
\examples{
\dontrun{
library(rts)
redcap_key()
}

}
