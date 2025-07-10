#' Markdown Editor Input
#'
#' Creates a markdown editor input for Shiny applications using reactR
#'
#' @param id The input id
#' @param label The label for the input
#' @param markdown Initial markdown content (default: "")
#' @param config A named list of configuration options (highest priority)
#' @param ... Any configuration options as named arguments (overrides defaults, but overridden by config)
#' @importFrom reactR createReactShinyInput
#' @importFrom htmltools htmlDependency tags
#'
#' @details
#' The final configuration is determined by merging:
#' 1. Package defaults
#' 2. Any named arguments in ... (overrides defaults)
#' 3. Any values in the config list (overrides ... and defaults)
#'
#' @export
mdeditorInput <- function(
  id, label, markdown = "",
  config = list(),
  ...
) {
  if (is.null(config)) config <- list()
  stopifnot(is.list(config))
  # 1. Package defaults
  default_config <- list(
    preview = "edit",
    height = 300,
    theme = "light",
    visible = TRUE,
    spellCheck = FALSE,
    disabled = FALSE,
    autoFocus = FALSE,
    autoSave = FALSE,
    dragDrop = TRUE,
    shortcuts = TRUE,
    enableScroll = TRUE,
    enableSearch = TRUE,
    lineNumbers = FALSE,
    highlightEnable = TRUE,
    codeTheme = "github",
    className = "",
    commands = c("title", "bold", "italic", "hr", "unorderedListCommand", "orderedListCommand"),  # Default selected commands
    style = list(
      fontSize = "14px",
      border = "1px solid #ccc",
      borderRadius = "4px"
    )
  )

  # 2. Inline ... arguments
  dot_args <- list(...)
  merged_config <- modifyList(default_config, dot_args)

  # 3. Merge config list (overrides ... and defaults)
  if (length(config) > 0) {
    merged_config <- modifyList(merged_config, config)
  }
  
  # 4. Ensure commands is never NULL or empty - always use defaults if not specified
  if (is.null(merged_config$commands) || length(merged_config$commands) == 0) {
    merged_config$commands <- c("title", "bold", "italic", "hr", "unorderedListCommand", "orderedListCommand")
  }

  reactR::createReactShinyInput(
    inputId = id,
    class = "markdowneditor",
    dependencies = htmltools::htmlDependency(
      name = "markdowneditor-input",
      version = "1.0.0",
      src = c(file = "www/mdeditor/markdowneditor"),
      package = "mdeditor",
      script = "markdowneditor.js"
    ),
    default = markdown,
    configuration = merged_config,
    container = htmltools::tags$div
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