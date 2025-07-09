# mdeditor

An R package providing a Shiny input widget for markdown editing using [@uiw/react-md-editor](https://github.com/uiwjs/react-md-editor) and [reactR](https://react-r.github.io/reactR/).

## Installation

```r
# Install from GitHub (when available)
# devtools::install_github("yourusername/mdeditor")

# Or install locally
devtools::install_local(".")
```

## Basic Usage

```r
library(shiny)
library(mdeditor)

ui <- fluidPage(
  titlePanel("Markdown Editor Example"),
  sidebarLayout(
    sidebarPanel(
      mdeditorInput(
        id = "markdown_content",
        label = "Edit your markdown:",
        markdown = "# Hello World\n\nThis is **bold** text.",
        config = list(height = 300)
      )
    ),
    mainPanel(
      h3("Markdown Output"),
      verbatimTextOutput("output")
    )
  )
)

server <- function(input, output, session) {
  output$output <- renderPrint({
    input$markdown_content
  })
}

shinyApp(ui, server)
```

## Function Reference

### `mdeditorInput(id, label, markdown, config)`

Creates a markdown editor input widget.

**Parameters:**
- `id` (character): The input id for Shiny
- `label` (character): The label displayed above the editor
- `markdown` (character): Initial markdown content (default: "")
- `config` (list): Configuration options for the editor (default: list())

### `updateMdeditorInput(session, inputId, value, configuration)`

Updates a markdown editor input from the server side.

**Parameters:**
- `session`: The Shiny session object
- `inputId` (character): The input id to update
- `value` (character): The new markdown value
- `configuration` (list, optional): New configuration options

## Configuration Options

The `config` parameter accepts a list of options that are passed directly to the underlying `@uiw/react-md-editor` component:

### Editor Appearance

```r
config <- list(
  # Editor height in pixels
  height = 300,
  
  # Editor width (can be number or string like "100%")
  width = "100%",
  
  # Preview mode: "live", "edit", "preview"
  preview = "live",
  
  # Show/hide the toolbar
  visible = TRUE,
  
  # Editor theme: "light", "dark"
  theme = "light",
  
  # Enable/disable spell check
  spellCheck = FALSE
)
```

### Editor Behavior

```r
config <- list(
  # Enable/disable the editor
  disabled = FALSE,
  
  # Enable/disable auto focus
  autoFocus = FALSE,
  
  # Enable/disable auto save
  autoSave = TRUE,
  
  # Enable/disable drag and drop
  dragDrop = TRUE,
  
  # Enable/disable keyboard shortcuts
  shortcuts = TRUE,
  
  # Enable/disable textarea mode (simpler interface)
  textareaProps = list(
    placeholder = "Enter markdown here..."
  )
)
```

### Preview Options

```r
config <- list(
  # Preview mode
  preview = "live",  # "live", "edit", "preview"
  
  # Preview options
  previewOptions = list(
    # Enable/disable line numbers
    lineNumbers = FALSE,
    
    # Enable/disable code highlighting
    highlightEnable = TRUE,
    
    # Code theme for syntax highlighting
    codeTheme = "github"
  )
)
```

### Advanced Configuration

```r
config <- list(
  # Custom commands for the toolbar
  commands = list(
    # Add custom commands here
  ),
  
  # Custom preview renderer
  preview = "live",
  
  # Enable/disable specific features
  enableScroll = TRUE,
  enableSearch = TRUE,
  
  # Custom CSS classes
  className = "custom-editor",
  
  # Custom styles
  style = list(
    border = "1px solid #ccc",
    borderRadius = "4px"
  )
)
```

## Complete Example

```r
library(shiny)
library(mdeditor)

ui <- fluidPage(
  titlePanel("Advanced Markdown Editor"),
  
  fluidRow(
    column(6,
      mdeditorInput(
        id = "editor1",
        label = "Basic Editor",
        markdown = "# Welcome\n\nStart typing your markdown here...",
        config = list(
          height = 200,
          preview = "live",
          theme = "light"
        )
      )
    ),
    column(6,
      mdeditorInput(
        id = "editor2",
        label = "Advanced Editor",
        markdown = "## Advanced Features\n\n- **Bold text**\n- *Italic text*\n- `Code snippets`",
        config = list(
          height = 200,
          preview = "edit",
          theme = "dark",
          spellCheck = TRUE,
          autoSave = TRUE
        )
      )
    )
  ),
  
  fluidRow(
    column(12,
      h3("Editor 1 Output:"),
      verbatimTextOutput("output1"),
      h3("Editor 2 Output:"),
      verbatimTextOutput("output2")
    )
  ),
  
  fluidRow(
    column(12,
      actionButton("update1", "Update Editor 1"),
      actionButton("update2", "Update Editor 2")
    )
  )
)

server <- function(input, output, session) {
  output$output1 <- renderPrint({
    input$editor1
  })
  
  output$output2 <- renderPrint({
    input$editor2
  })
  
  observeEvent(input$update1, {
    updateMdeditorInput(
      session, 
      "editor1", 
      "# Updated Content\n\nThis content was updated from the server!",
      list(height = 250)
    )
  })
  
  observeEvent(input$update2, {
    updateMdeditorInput(
      session, 
      "editor2", 
      "## Server Update\n\n- Point 1\n- Point 2\n- Point 3"
    )
  })
}

shinyApp(ui, server)
```

## Development

To build the JavaScript bundle:

```bash
# Install dependencies
yarn install

# Build for development
yarn run webpack

# Watch for changes
yarn run watch
```

## Dependencies

- **R**: shiny, reactR, htmltools
- **JavaScript**: @uiw/react-md-editor, react, react-dom
- **Build tools**: webpack, babel-loader

## License

[Add your license here]

## Contributing

[Add contribution guidelines here] # mdeditor
