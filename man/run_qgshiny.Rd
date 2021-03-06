% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/runExample.R
\name{run_qgshiny}
\alias{run_qgshiny}
\title{Run the application}
\usage{
run_qgshiny(display.mode = c("normal", "showcase"))
}
\arguments{
\item{display.mode}{The mode in which to display the application. If \code{"showcase"}, application code is
displayed along with the output. If \code{"normal"} (default), the code is hidden.}
}
\description{
Runs the 'shiny' application interactively.
}
\examples{
if (interactive()) {
 run_qgshiny()
}

}
