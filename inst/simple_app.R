# inst/simple_app.R
library(shiny)
library(mdeditor)

ui <- fluidPage(
  titlePanel("Simple Markdown Editor Demo"),
  
  mdeditorInput(
    id = "markdown1",
    label = "Edit your markdown:",
    markdown = "## Hello Markdown!\n\nType some *markdown* here."
  ),
  
  hr(),
  
  h4("Preview Output:"),
  verbatimTextOutput("markdown_value")
)

server <- function(input, output, session) {
  # Display current markdown value
  output$markdown_value <- renderPrint({
    cat("Current Markdown Value:\n")
    cat(input$markdown1)
  })
}

shinyApp(ui, server)
