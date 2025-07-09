#' Markdown Editor Input
#'
#' Creates a markdown editor input for Shiny applications using reactR
#'
#' @param id The input id
#' @param label The label for the input
#' @param markdown Initial markdown content (default: "")
#' @param config Configuration options for the markdown editor
#' @importFrom reactR createReactShinyInput
#' @importFrom htmltools htmlDependency tags
#'
#' @export
mdeditorInput <- function(id, label, markdown = "", config = list()) {
  reactR::createReactShinyInput(
    id,
    "markdowneditor",
    htmltools::htmlDependency(
      name = "markdowneditor-input",
      version = "1.0.0",
      src = "www/mdeditor/markdowneditor",
      package = "mdeditor",
      script = "markdowneditor.js"
    ),
    markdown,
    config,
    htmltools::tags$div
  )
}

#' Update Markdown Editor Input
#'
#' Updates a markdown editor input on the server side
#'
#' @param session The Shiny session object
#' @param inputId The input id to update
#' @param value The new markdown value
#' @param configuration Configuration options for the markdown editor
#' @export
updateMdeditorInput <- function(session, inputId, value, configuration = NULL) {
  message <- list(value = value)
  if (!is.null(configuration)) message$configuration <- configuration
  session$sendInputMessage(inputId, message);
}