#' Launch the Amazon Health Impact Shiny App
#'
#' @export
launch_app <- function() {
  app_dir <- system.file("shiny", package = "jgb")

  if (app_dir == "" || !file.exists(file.path(app_dir, "app.R"))) {
    stop("Could not find Shiny app. Make sure inst/shiny/app.R exists and reinstall the package.")
  }

  shiny::runApp(app_dir, display.mode = "normal")
}
