#' Run the application
#'
#' @description
#' Run the Shiny Application
#'
#' @import shiny
#'
#' @export
#'
run_example <- function() {

  # Look for the shiny application
  app_dir <- system.file("shiny-examples", "app", package = "qgshiny")

  # Error if the directory cannot be found
  if (app_dir == "") {
    stop("Could not find example directory. Try re-installing `qgshiny`.", call. = FALSE)
  }

  # Run the app
  runApp(appDir = app_dir, display.mode = "normal")

}
