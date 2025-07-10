import React, { useState } from 'react';
import ReactDOM from 'react-dom/client';
import MarkdownEditorInput from './MarkdownEditorInput.jsx';
import MDEditor from '@uiw/react-md-editor';
import * as commands from '@uiw/react-md-editor/commands';
import '@uiw/react-md-editor/markdown-editor.css';

const defaultConfig = {
  preview: 'edit',
  height: 300,
  theme: 'light',
  visible: true,
  spellCheck: false,
  disabled: false,
  autoFocus: false,
  autoSave: false,
  dragDrop: true,
  shortcuts: true,
  enableScroll: true,
  enableSearch: true,
  lineNumbers: false,
  highlightEnable: true,
  codeTheme: 'github',
  className: '',
  style: {
    fontSize: '14px',
    border: '1px solid #ccc',
    borderRadius: '4px'
  }
};

const CODE_THEME_OPTIONS = [
  { label: 'GitHub', value: 'github' },
  { label: 'VS Code', value: 'vscode' },
  { label: 'Atom One Dark', value: 'atom-one-dark' },
  { label: 'Atom One Light', value: 'atom-one-light' },
  { label: 'Dracula', value: 'dracula' },
  { label: 'Monokai', value: 'monokai' },
  { label: 'Nord', value: 'nord' },
  { label: 'Solarized Dark', value: 'solarized-dark' },
  { label: 'Solarized Light', value: 'solarized-light' }
];

// Correct command mapping for @uiw/react-md-editor
const TOOLBAR_COMMANDS = [
  { key: 'title1', label: 'Title 1 (H1)', cmd: 'title1', default: false },
  { key: 'title2', label: 'Title 2 (H2)', cmd: 'title2', default: false },
  { key: 'title3', label: 'Title 3 (H3)', cmd: 'title3', default: false },
  { key: 'title4', label: 'Title 4 (H4)', cmd: 'title4', default: false },
  { key: 'title5', label: 'Title 5 (H5)', cmd: 'title5', default: false },
  { key: 'title6', label: 'Title 6 (H6)', cmd: 'title6', default: false },
  { key: 'bold', label: 'Bold', cmd: 'bold', default: true },
  { key: 'italic', label: 'Italic', cmd: 'italic', default: true },
  { key: 'strikethrough', label: 'Strikethrough', cmd: 'strikeThrough', default: false },
  { key: 'hr', label: 'Horizontal Rule', cmd: 'hr', default: true },
  { key: 'title', label: 'Title (General)', cmd: 'title', default: true },
  { key: 'quote', label: 'Quote', cmd: 'quote', default: false },
  { key: 'unorderedListCommand', label: 'Unordered List', cmd: 'unorderedListCommand', default: true },
  { key: 'orderedListCommand', label: 'Ordered List', cmd: 'orderedListCommand', default: true },
  { key: 'checkedList', label: 'Checked List', cmd: 'checkedListCommand', default: false },
  { key: 'code', label: 'Inline Code', cmd: 'code', default: false },
  { key: 'codeBlock', label: 'Code Block', cmd: 'codeBlock', default: false },
  { key: 'link', label: 'Link', cmd: 'link', default: false },
  { key: 'image', label: 'Image', cmd: 'image', default: false },
  { key: 'table', label: 'Table', cmd: 'table', default: false },
  { key: 'fullscreen', label: 'Fullscreen', cmd: 'fullscreen', default: false },
  { key: 'preview', label: 'Preview Toggle', cmd: 'preview', default: false },
  { key: 'help', label: 'Help', cmd: 'help', default: false }
];

function DevApp() {
  const [value, setValue] = useState('## Hello Markdown!\n\nThis is a **comprehensive** example with all configuration options.\n\n- List item 1\n- List item 2\n\n```javascript\nconsole.log("Code block");\n```');
  const [config, setConfig] = useState(defaultConfig);
  const [enabledCommands, setEnabledCommands] = useState(() => {
    // Initialize with R package defaults for comparison
    const rDefaults = ["title", "bold", "italic", "hr", "unorderedListCommand", "orderedListCommand"];
    const initialState = {};
    TOOLBAR_COMMANDS.forEach(cmd => {
      initialState[cmd.key] = rDefaults.includes(cmd.key);
    });
    return initialState;
  });

  // Update individual config values
  const updateConfig = (key, value) => {
    const newConfig = { ...config };
    if (key.includes('.')) {
      const [parent, child] = key.split('.');
      newConfig[parent] = { ...newConfig[parent], [child]: value };
    } else {
      newConfig[key] = value;
    }
    setConfig(newConfig);
  };

  // Update toolbar commands
  const updateCommand = (commandKey, enabled) => {
    setEnabledCommands(prev => ({
      ...prev,
      [commandKey]: enabled
    }));
  };

  // Get enabled command objects for MDEditor  
  const getEnabledCommandObjects = () => {
    const enabledCommandNames = TOOLBAR_COMMANDS
      .filter(cmd => enabledCommands[cmd.key])
      .map(cmd => cmd.key); // Use the key (which matches R command names)
    
    return enabledCommandNames;
  };

  // Render form group
  const FormGroup = ({ label, children }) => (
    <div className="form-group">
      <label>{label}</label>
      {children}
    </div>
  );

  // Render checkbox group
  const CheckboxGroup = ({ label, checked, onChange }) => (
    <div className="checkbox-group">
      <input
        type="checkbox"
        checked={checked}
        onChange={(e) => onChange(e.target.checked)}
      />
      <label>{label}</label>
    </div>
  );

  return (
    <div className="main-container">
      {/* Sidebar */}
      <div className="sidebar">
        {/* Basic Settings */}
        <div className="config-section">
          <h4>Basic Settings</h4>
          <FormGroup label="Initial Markdown">
            <textarea
              value={value}
              onChange={(e) => setValue(e.target.value)}
              rows={4}
            />
          </FormGroup>
        </div>

        {/* Toolbar Customization */}
        <div className="config-section">
          <h4>Toolbar Buttons</h4>
          <div style={{ marginBottom: '10px' }}>
            <button 
              onClick={() => {
                const newCommands = {};
                TOOLBAR_COMMANDS.forEach(cmd => {
                  newCommands[cmd.key] = cmd.key === 'title';
                });
                setEnabledCommands(newCommands);
              }}
              style={{ marginRight: '10px', padding: '5px 10px' }}
            >
              Show Only Title
            </button>
            <button 
              onClick={() => {
                const newCommands = {};
                TOOLBAR_COMMANDS.forEach(cmd => {
                  newCommands[cmd.key] = true;
                });
                setEnabledCommands(newCommands);
              }}
              style={{ marginRight: '10px', padding: '5px 10px' }}
            >
              Show All
            </button>
            <button 
              onClick={() => {
                const newCommands = {};
                TOOLBAR_COMMANDS.forEach(cmd => {
                  newCommands[cmd.key] = false;
                });
                setEnabledCommands(newCommands);
              }}
              style={{ padding: '5px 10px' }}
            >
              Hide All
            </button>
          </div>
          {TOOLBAR_COMMANDS.map(cmd => (
            <CheckboxGroup
              key={cmd.key}
              label={cmd.label}
              checked={enabledCommands[cmd.key]}
              onChange={(enabled) => updateCommand(cmd.key, enabled)}
            />
          ))}
        </div>

        {/* Editor Behavior */}
        <div className="config-section">
          <h4>Editor Behavior</h4>
          <FormGroup label="Preview Mode">
            <select
              value={config.preview}
              onChange={(e) => updateConfig('preview', e.target.value)}
            >
              <option value="edit">Edit</option>
              <option value="live">Live</option>
              <option value="preview">Preview</option>
            </select>
          </FormGroup>
          <FormGroup label="Height (px)">
            <input
              type="number"
              value={config.height}
              onChange={(e) => updateConfig('height', parseInt(e.target.value))}
              min="100"
              max="800"
            />
          </FormGroup>
          <FormGroup label="Theme">
            <select
              value={config.theme}
              onChange={(e) => updateConfig('theme', e.target.value)}
            >
              <option value="light">Light</option>
              <option value="dark">Dark</option>
            </select>
          </FormGroup>
        </div>

        {/* Font Settings */}
        <div className="config-section">
          <h4>Font Settings</h4>
          <FormGroup label="Font Size">
            <input
              type="text"
              value={config.style.fontSize}
              onChange={(e) => updateConfig('style.fontSize', e.target.value)}
              placeholder="14px"
            />
          </FormGroup>
        </div>

        {/* Code Theme */}
        <div className="config-section">
          <h4>Code Theme</h4>
          <FormGroup label="Code Theme">
            <select
              value={config.codeTheme}
              onChange={(e) => updateConfig('codeTheme', e.target.value)}
            >
              {CODE_THEME_OPTIONS.map(opt => (
                <option key={opt.value} value={opt.value}>{opt.label}</option>
              ))}
            </select>
          </FormGroup>
        </div>

        {/* Styling */}
        <div className="config-section">
          <h4>Styling</h4>
          <FormGroup label="CSS Class">
            <input
              type="text"
              value={config.className}
              onChange={(e) => updateConfig('className', e.target.value)}
            />
          </FormGroup>
          <FormGroup label="Border">
            <input
              type="text"
              value={config.style.border}
              onChange={(e) => updateConfig('style.border', e.target.value)}
            />
          </FormGroup>
          <FormGroup label="Border Radius">
            <input
              type="text"
              value={config.style.borderRadius}
              onChange={(e) => updateConfig('style.borderRadius', e.target.value)}
            />
          </FormGroup>
        </div>

        {/* Output */}
        <div className="output-section">
          <h4>Current Value</h4>
          <pre>{value}</pre>
          
          <h4>Configuration (JSON)</h4>
          <pre>{JSON.stringify({
            ...config,
            commands: TOOLBAR_COMMANDS.filter(cmd => enabledCommands[cmd.key]).map(cmd => cmd.key)
          }, null, 2)}</pre>
        </div>
      </div>

      {/* Content */}
      <div className="content">
        <div style={{ marginBottom: '20px', padding: '10px', backgroundColor: '#f8f9fa', border: '1px solid #dee2e6', borderRadius: '4px' }}>
          <h4>Debug Info</h4>
          <p><strong>Preview Mode:</strong> {config.preview}</p>
          <p><strong>Theme:</strong> {config.theme}</p>
          <p><strong>Enabled Commands:</strong> {TOOLBAR_COMMANDS.filter(cmd => enabledCommands[cmd.key]).map(cmd => cmd.key).join(', ')}</p>
        </div>
        
        <div style={{ marginBottom: '20px' }}>
          <h4>Configured MDEditor</h4>
          {(() => {
            const enabledCommands = getEnabledCommandObjects();
            const filteredConfig = {
              preview: config.preview,
              height: config.height,
              theme: config.theme,
              className: config.className,
              style: config.style,
              commands: enabledCommands
            };
            return (
              <MarkdownEditorInput
                value={value}
                setValue={setValue}
                configuration={filteredConfig}
                onConfigChange={setConfig}
              />
            );
          })()}
        </div>
      </div>
    </div>
  );
}

// Render the app
const root = ReactDOM.createRoot(document.getElementById('app'));
root.render(<DevApp />); 