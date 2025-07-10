import React from "react";
import MDEditor from "@uiw/react-md-editor";
import "@uiw/react-md-editor/markdown-editor.css";

// Try to import commands, but handle if they're not available
let commands;
try {
  const commandsModule = require("@uiw/react-md-editor/commands");
  commands = commandsModule;
} catch (e) {
  // Fallback: try to get commands from MDEditor
  commands = null;
}

export default function MarkdownEditorInput(props) {
  // Handle both reactR pattern (configuration, value, setValue) and dev pattern (value, setValue, configuration)
  const isReactRPattern = props.configuration !== undefined && props.setValue !== undefined && typeof props.setValue === 'function';
  const isDevPattern = !isReactRPattern;
  
  let value, setValue, configuration;
  
  if (isReactRPattern) {
    // reactR pattern for Shiny
    ({ configuration = {}, value, setValue } = props);
  } else {
    // Dev pattern
    ({ value, setValue, configuration = {} } = props);
  }

  // Only pass supported props
  const {
    preview,
    height,
    theme,
    commands: commandsFromConfig,
    className,
    style
  } = configuration;

  const handleChange = (val) => {
    // MDEditor onChange passes the markdown string directly
    if (typeof val === 'string') {
      setValue(val);
    } else {
      // Fallback - convert to string if needed
      setValue(String(val || ''));
    }
  };

  const editorProps = {
    value: value || '',
    onChange: handleChange,
    preview: preview || 'edit',
    height,
    theme,
    className,
    style
  };

  // Handle toolbar commands - only use defaults for R package when truly not specified
  let commandsToUse = commandsFromConfig;
  if (isReactRPattern && (!commandsToUse || !Array.isArray(commandsToUse) || commandsToUse.length === 0)) {
    // Use the same defaults as R package - but only for R, not dev environment
    commandsToUse = ["title", "bold", "italic", "hr", "unorderedListCommand", "orderedListCommand"];
  }
  
  if (commandsToUse && Array.isArray(commandsToUse) && commandsToUse.length > 0) {
    // Import individual commands dynamically
    try {
      const commands = require('@uiw/react-md-editor');
      
      if (commands.commands) {
        const commandObjects = [];
        
        commandsToUse.forEach(name => {
          if (name === 'title') {
            // Create a grouped title command with all title options
            const titleGroup = commands.commands.group(
              [
                commands.commands.title1,
                commands.commands.title2,
                commands.commands.title3,
                commands.commands.title4,
                commands.commands.title5,
                commands.commands.title6
              ],
              {
                name: "title",
                groupName: "title",
                buttonProps: { "aria-label": "Insert title" }
              }
            );
            commandObjects.push(titleGroup);
          } else {
            // Regular command - try both possible names
            let cmd = commands.commands[name];
            if (!cmd && name === 'unorderedList') {
              cmd = commands.commands.unorderedListCommand;
            }
            if (!cmd && name === 'orderedList') {
              cmd = commands.commands.orderedListCommand;
            }
            if (cmd) {
              commandObjects.push(cmd);
            }
          }
        });
        
        editorProps.commands = commandObjects;
      } else {
        // Fallback to string array
        editorProps.commands = commandsToUse;
      }
    } catch (e) {
      // Fallback to string array
      editorProps.commands = commandsToUse;
    }
  }

  return <MDEditor {...editorProps} />;
} 