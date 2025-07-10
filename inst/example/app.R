library(shiny)
library(mdeditor)

ui <- fluidPage(
  titlePanel("Markdown Editor Input - All Configuration Options"),
  
  # Custom CSS for full-height sidebar with scroll
  tags$head(
    tags$style(HTML("
      .sidebar-container {
        height: 100vh;
        overflow-y: auto;
        padding: 20px;
        background-color: #f8f9fa;
        border-right: 1px solid #dee2e6;
      }
      
      .main-container {
        height: 100vh;
        overflow-y: auto;
        padding: 20px;
      }
      
      .sidebar-container::-webkit-scrollbar {
        width: 8px;
      }
      
      .sidebar-container::-webkit-scrollbar-track {
        background: #f1f1f1;
      }
      
      .sidebar-container::-webkit-scrollbar-thumb {
        background: #c1c1c1;
        border-radius: 4px;
      }
      
      .sidebar-container::-webkit-scrollbar-thumb:hover {
        background: #a8a8a8;
      }
    "))
  ),
  
  fluidRow(
    # Sidebar with full height and scroll
    column(
      width = 4,
      div(
        class = "sidebar-container",
        
        # Basic Settings
        h4("Basic Settings"),
        textInput("label", "Label:", value = "Edit your markdown:"),
        textAreaInput("initial_markdown", "Initial Markdown:", 
                     value = "## Hello Markdown!\n\nThis is a **comprehensive** example with all configuration options.\n\n- List item 1\n- List item 2\n\n```javascript\nconsole.log('Code block');\n```",
                     rows = 4),
        
        hr(),
        
        # Editor Behavior
        h4("Editor Behavior"),
        selectInput("preview", "Preview Mode:", 
                   choices = c("Edit" = "edit", "Live" = "live", "Preview" = "preview"), 
                   selected = "edit"),
        numericInput("height", "Height (px):", value = 400, min = 100, max = 800),
        selectInput("theme", "Theme:", 
                   choices = c("Light" = "light", "Dark" = "dark"), 
                   selected = "light"),
        
        hr(),
        
        # Font Settings
        h4("Font Settings"),
        textInput("fontSize", "Font Size:", value = "14px"),
        
        hr(),
        
        # Toolbar Customization
        h4("Toolbar Buttons"),
        checkboxInput("title", "Title (General):", value = TRUE),
        checkboxInput("title1", "Title 1 (H1):", value = FALSE),
        checkboxInput("title2", "Title 2 (H2):", value = FALSE),
        checkboxInput("title3", "Title 3 (H3):", value = FALSE),
        checkboxInput("title4", "Title 4 (H4):", value = FALSE),
        checkboxInput("title5", "Title 5 (H5):", value = FALSE),
        checkboxInput("title6", "Title 6 (H6):", value = FALSE),
        checkboxInput("bold", "Bold:", value = TRUE),
        checkboxInput("italic", "Italic:", value = TRUE),
        checkboxInput("strikethrough", "Strikethrough:", value = FALSE),
        checkboxInput("hr", "Horizontal Rule:", value = TRUE),
        checkboxInput("quote", "Quote:", value = FALSE),
        checkboxInput("unorderedList", "Unordered List:", value = TRUE),
        checkboxInput("orderedList", "Ordered List:", value = TRUE),
        checkboxInput("checkedList", "Checked List:", value = FALSE),
        checkboxInput("code", "Inline Code:", value = FALSE),
        checkboxInput("codeBlock", "Code Block:", value = FALSE),
        checkboxInput("link", "Link:", value = FALSE),
        checkboxInput("image", "Image:", value = FALSE),
        checkboxInput("table", "Table:", value = FALSE),
        checkboxInput("fullscreen", "Fullscreen:", value = FALSE),
        checkboxInput("previewToggle", "Preview Toggle:", value = FALSE),
        
        hr(),
        
        # Editor Features
        h4("Editor Features"),
        checkboxInput("visible", "Visible:", value = TRUE),
        checkboxInput("spellCheck", "Spell Check:", value = FALSE),
        checkboxInput("disabled", "Disabled:", value = FALSE),
        checkboxInput("autoFocus", "Auto Focus:", value = FALSE),
        checkboxInput("autoSave", "Auto Save:", value = FALSE),
        checkboxInput("dragDrop", "Drag & Drop:", value = TRUE),
        checkboxInput("shortcuts", "Keyboard Shortcuts:", value = TRUE),
        checkboxInput("enableScroll", "Enable Scroll:", value = TRUE),
        checkboxInput("enableSearch", "Enable Search:", value = TRUE),
        checkboxInput("lineNumbers", "Line Numbers:", value = FALSE),
        checkboxInput("highlightEnable", "Syntax Highlighting:", value = TRUE),
        
        hr(),
        
        # Code Theme
        h4("Code Theme"),
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
        
        hr(),
        
        # Styling
        h4("Styling"),
        textInput("className", "CSS Class:", value = ""),
        textInput("border", "Border:", value = "1px solid #ccc"),
        textInput("borderRadius", "Border Radius:", value = "4px"),
        
        hr(),
        
        # Output Display
        h4("Output"),
        verbatimTextOutput("markdown_value"),
        verbatimTextOutput("config_value")
      )
    ),
    
    # Main content area
    column(
      width = 8,
      div(
        class = "main-container",
        
        # Markdown Editor
        uiOutput("mdeditor_ui"),
        
        hr(),
        
        # Configuration JSON
        h4("Current Configuration (JSON)"),
        verbatimTextOutput("config_json")
      )
    )
  )
)

server <- function(input, output, session) {
  output$mdeditor_ui <- renderUI({
    # Collect enabled toolbar commands
    toolbar_commands <- c(
      if (input$title) "title",
      if (input$title1) "title1",
      if (input$title2) "title2", 
      if (input$title3) "title3",
      if (input$title4) "title4",
      if (input$title5) "title5",
      if (input$title6) "title6",
      if (input$bold) "bold",
      if (input$italic) "italic",
      if (input$strikethrough) "strikethrough",
      if (input$hr) "hr",
      if (input$quote) "quote",
      if (input$unorderedList) "unorderedList",
      if (input$orderedList) "orderedList",
      if (input$checkedList) "checkedList",
      if (input$code) "code",
      if (input$codeBlock) "codeBlock",
      if (input$link) "link",
      if (input$image) "image",
      if (input$table) "table",
      if (input$fullscreen) "fullscreen",
      if (input$previewToggle) "preview"
    )
    
    mdeditorInput(
      id = "markdown1",
      label = input$label,
      markdown = input$initial_markdown,
      config = list(
        # Basic settings
        preview = input$preview,
        height = input$height,
        theme = input$theme,
        
        # Toolbar commands
        commands = toolbar_commands,
        
        # Editor features
        visible = input$visible,
        spellCheck = input$spellCheck,
        disabled = input$disabled,
        autoFocus = input$autoFocus,
        autoSave = input$autoSave,
        dragDrop = input$dragDrop,
        shortcuts = input$shortcuts,
        enableScroll = input$enableScroll,
        enableSearch = input$enableSearch,
        lineNumbers = input$lineNumbers,
        highlightEnable = input$highlightEnable,
        
        # Code theme
        codeTheme = input$codeTheme,
        
        # Styling
        className = input$className,
        style = list(
          fontSize = input$fontSize,
          border = input$border,
          borderRadius = input$borderRadius
        )
      )
    )
  })

  # Display current markdown value
  output$markdown_value <- renderPrint({
    cat("Current Markdown Value:\n")
    cat(input$markdown1)
  })
  
  # Display current configuration
  output$config_value <- renderPrint({
          cat("Current Configuration:\n")
      config <- list(
        preview = input$preview,
        height = input$height,
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
      lineNumbers = input$lineNumbers,
      highlightEnable = input$highlightEnable,
      codeTheme = input$codeTheme,
      className = input$className,
      style = list(
        fontSize = input$fontSize,
        border = input$border,
        borderRadius = input$borderRadius
      )
    )
    str(config)
  })
  
  # Display configuration as JSON
  output$config_json <- renderPrint({
    config <- list(
              preview = input$preview,
        height = input$height,
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
      lineNumbers = input$lineNumbers,
      highlightEnable = input$highlightEnable,
      codeTheme = input$codeTheme,
      className = input$className,
      style = list(
        fontSize = input$fontSize,
        border = input$border,
        borderRadius = input$borderRadius
      )
    )
    cat(jsonlite::toJSON(config, pretty = TRUE, auto_unbox = TRUE))
  })
}

shinyApp(ui, server) 