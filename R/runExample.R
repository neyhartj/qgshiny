#' Run the application
#'
#' @description
#' Run the Shiny Application
#'
#' @param display.mode The mode in which to display the application. If \code{"showcase"}, application code is
#' diplayed along with the output. If \code{"normal"} (default), the code is hidden.
#'
#' @import shiny
#'
#' @export
#'
run_example <- function(display.mode = c("normal", "showcase")) {

  # Look for the shiny application
  app_dir <- system.file("shiny-examples", "app", package = "qgshiny")

  display.mode <- match.arg(display.mode)

  # Error if the directory cannot be found
  if (app_dir == "") {
    stop("Could not find example directory. Try re-installing `qgshiny`.", call. = FALSE)
  }

  # Run the app
  runApp(appDir = app_dir, display.mode = display.mode)

}
