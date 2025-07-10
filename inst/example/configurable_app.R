library(shiny)
library(mdeditor)

ui <- fluidPage(
  titlePanel("Configurable Markdown Editor Demo"),
  
  sidebarLayout(
    sidebarPanel(
      width = 3,
      style = "max-height: 100vh; overflow-y: auto;",
      h4("Editor Configuration"),
      
      # Basic Settings
      h5("Basic Settings"),
      textInput("editor_id", "Editor ID:", value = "configurable_editor"),
      textInput("editor_label", "Editor Label:", value = "Configurable Markdown Editor"),
      textAreaInput("initial_markdown", "Initial Markdown:", 
                   value = "# Welcome to the Configurable Editor\n\nThis editor demonstrates all available configuration options.\n\n- **Bold text**\n- *Italic text*\n- `Code snippets`\n\n```javascript\nconsole.log('Hello World!');\n```",
                   rows = 5),
      
      # Appearance Settings
      h5("Appearance"),
      numericInput("height", "Height (px):", value = 400, min = 100, max = 800),
      selectInput("width", "Width:", choices = c("100%" = "100%", "50%" = "50%", "75%" = "75%"), selected = "100%"),
      selectInput("preview", "Preview Mode:", 
                 choices = c("Edit" = "edit", "Live" = "live", "Preview" = "preview"), 
                 selected = "edit"),
      selectInput("theme", "Theme:", 
                 choices = c("Light" = "light", "Dark" = "dark"), 
                 selected = "light"),
      checkboxInput("visible", "Show Toolbar:", value = TRUE),
      checkboxInput("spellCheck", "Spell Check:", value = FALSE),
      
      # Behavior Settings
      h5("Behavior"),
      checkboxInput("disabled", "Disabled:", value = FALSE),
      checkboxInput("autoFocus", "Auto Focus:", value = FALSE),
      checkboxInput("autoSave", "Auto Save:", value = TRUE),
      checkboxInput("dragDrop", "Drag & Drop:", value = TRUE),
      checkboxInput("shortcuts", "Keyboard Shortcuts:", value = TRUE),
      checkboxInput("enableScroll", "Enable Scroll:", value = TRUE),
      checkboxInput("enableSearch", "Enable Search:", value = TRUE),
      
      # Preview Options
      h5("Preview Options"),
      checkboxInput("lineNumbers", "Line Numbers:", value = FALSE),
      checkboxInput("highlightEnable", "Code Highlighting:", value = TRUE),
      selectInput("codeTheme", "Code Theme:", 
                 choices = c("GitHub" = "github", 
                           "VS Code" = "vscode",
                           "Atom One Dark" = "atom-one-dark",
                           "Atom One Light" = "atom-one-light",
                           "Dracula" = "dracula",
                           "Monokai" = "monokai",
                           "Nord" = "nord",
                           "Solarized Dark" = "solarized-dark",
                           "Solarized Light" = "solarized-light"),
                 selected = "github"),
      
      # Custom Styling
      h5("Custom Styling"),
      textInput("fontSize", "Font Size:", value = "14px"),
      textInput("className", "CSS Class:", value = ""),
      textInput("border", "Border:", value = "1px solid #ccc"),
      textInput("borderRadius", "Border Radius:", value = "4px"),
      
      # Actions
      h5("Actions"),
      actionButton("reset_config", "Reset Configuration", class = "btn-warning"),
      br(), br(),
      actionButton("get_value", "Get Current Value", class = "btn-info"),
      actionButton("set_sample", "Set Sample Content", class = "btn-success")
    ),
    
    mainPanel(
      width = 9,
      h3("Markdown Editor"),
      uiOutput("markdown_editor_ui"),
      
      hr(),
      
      h3("Current Configuration"),
      verbatimTextOutput("current_config"),
      
      hr(),
      
      h3("Editor Output"),
      verbatimTextOutput("editor_output"),
      
      hr(),
      
      h3("Raw Markdown"),
      verbatimTextOutput("raw_markdown")
    )
  )
)

server <- function(input, output, session) {
  
  # Reactive configuration object
  config <- reactive({
    list(
      height = input$height,
      width = input$width,
      preview = input$preview,
      theme = input$theme,
      visible = input$visible,
      spellCheck = input$spellCheck,
      disabled = input$disabled,
      autoFocus = input$autoFocus,
      autoSave = input$autoSave,
      dragDrop = input$dragDrop,
      shortcuts = input$shortcuts,
      enableScroll = input$enableScroll,
      enableSearch = input$enableSearch,
      previewOptions = list(
        lineNumbers = input$lineNumbers,
        highlightEnable = input$highlightEnable,
        codeTheme = input$codeTheme
      ),
      className = if (input$className != "") input$className else NULL,
      style = list(
        fontSize = if (input$fontSize != "") input$fontSize else NULL,
        border = input$border,
        borderRadius = input$borderRadius
      )
    )
  })
  
  # Render the markdown editor UI - reactive to all configuration changes
  output$markdown_editor_ui <- renderUI({
    # Force reactivity by explicitly referencing all inputs
    list(
      input$editor_id,
      input$editor_label,
      input$initial_markdown,
      input$height,
      input$width,
      input$preview,
      input$theme,
      input$visible,
      input$spellCheck,
      input$disabled,
      input$autoFocus,
      input$autoSave,
      input$dragDrop,
      input$shortcuts,
      input$enableScroll,
      input$enableSearch,
      input$lineNumbers,
      input$highlightEnable,
      input$codeTheme,

      input$fontSize,
      input$className,
      input$border,
      input$borderRadius
    )
    
    mdeditorInput(
      id = input$editor_id,
      label = input$editor_label,
      markdown = input$initial_markdown,
      config = config()
    )
  })
  
  # Display current configuration
  output$current_config <- renderPrint({
    cat("Current Configuration:\n")
    cat("=====================\n")
    str(config())
  })
  
  # Display editor output
  output$editor_output <- renderPrint({
    req(input[[input$editor_id]])
    cat("Editor Value:\n")
    cat("=============\n")
    cat(input[[input$editor_id]])
  })
  
  # Display raw markdown
  output$raw_markdown <- renderPrint({
    req(input[[input$editor_id]])
    cat("Raw Markdown (quoted):\n")
    cat("======================\n")
    cat(dQuote(input[[input$editor_id]]))
  })
  

  
  # Reset configuration button
  observeEvent(input$reset_config, {
    updateTextInput(session, "editor_id", value = "configurable_editor")
    updateTextInput(session, "editor_label", value = "Configurable Markdown Editor")
    updateTextAreaInput(session, "initial_markdown", 
                       value = "# Welcome to the Configurable Editor\n\nThis editor demonstrates all available configuration options.")
    updateNumericInput(session, "height", value = 400)
    updateSelectInput(session, "width", selected = "100%")
    updateSelectInput(session, "preview", selected = "edit")
    updateSelectInput(session, "theme", selected = "light")
    updateCheckboxInput(session, "visible", value = TRUE)
    updateCheckboxInput(session, "spellCheck", value = FALSE)
    updateCheckboxInput(session, "disabled", value = FALSE)
    updateCheckboxInput(session, "autoFocus", value = FALSE)
    updateCheckboxInput(session, "autoSave", value = TRUE)
    updateCheckboxInput(session, "dragDrop", value = TRUE)
    updateCheckboxInput(session, "shortcuts", value = TRUE)
    updateCheckboxInput(session, "enableScroll", value = TRUE)
    updateCheckboxInput(session, "enableSearch", value = TRUE)
    updateCheckboxInput(session, "lineNumbers", value = FALSE)
    updateCheckboxInput(session, "highlightEnable", value = TRUE)
    updateSelectInput(session, "codeTheme", selected = "github")

    updateTextInput(session, "fontSize", value = "14px")
    updateTextInput(session, "className", value = "")
    updateTextInput(session, "border", value = "1px solid #ccc")
    updateTextInput(session, "borderRadius", value = "4px")
  })
  
  # Get current value button
  observeEvent(input$get_value, {
    req(input[[input$editor_id]])
    showModal(modalDialog(
      title = "Current Editor Value",
      pre(input[[input$editor_id]]),
      easyClose = TRUE,
      footer = modalButton("Close")
    ))
  })
  
  # Set sample content button
  observeEvent(input$set_sample, {
    sample_content <- paste(
      "# Sample Markdown Content",
      "",
      "This is a **sample** markdown document with various elements:",
      "",
      "## Lists",
      "- Item 1",
      "- Item 2",
      "  - Subitem 2.1",
      "  - Subitem 2.2",
      "",
      "## Code Blocks",
      "```r",
      "# R code example",
      "library(shiny)",
      "ui <- fluidPage('Hello World')",
      "server <- function(input, output) {}",
      "shinyApp(ui, server)",
      "```",
      "",
      "## Tables",
      "| Feature | Status |",
      "|---------|--------|",
      "| Bold | ✅ |",
      "| Italic | ✅ |",
      "| Code | ✅ |",
      "| Lists | ✅ |",
      "",
      "## Links and Images",
      "[GitHub](https://github.com)",
      "",
      "> This is a blockquote",
      "",
      "---",
      "",
      "*End of sample content*",
      sep = "\n"
    )
    
    updateTextAreaInput(session, "initial_markdown", value = sample_content)
  })
}

shinyApp(ui, server) 