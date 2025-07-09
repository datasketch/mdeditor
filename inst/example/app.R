library(shiny)
library(mdeditor)

ui <- fluidPage(
  titlePanel("Markdown Editor Input Example"),
  sidebarLayout(
    sidebarPanel(
      mdeditorInput(
        id = "markdown1",
        label = "Edit your markdown:",
        markdown = "## Hello Markdown!\nEdit me.",
        config = list(height = 300)
      )
    ),
    mainPanel(
      h3("Markdown Output"),
      verbatimTextOutput("markdown_value")
    )
  )
)

server <- function(input, output, session) {
  output$markdown_value <- renderPrint({
    input$markdown1
  })
}

shinyApp(ui, server) 