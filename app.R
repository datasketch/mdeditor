library(shiny)
library(mdeditor)

ui <- fluidPage(
  titlePanel("reactR Input Example"),
  markdowneditorInput("textInput"),
  textOutput("textOutput")
)

server <- function(input, output, session) {
  output$textOutput <- renderText({
    sprintf("You entered: %s", input$textInput)
  })
}

shinyApp(ui, server)
