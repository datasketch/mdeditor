import { reactShinyInput } from 'reactR';
import MarkdownEditorInput from '../srcjs/MarkdownEditorInput.jsx';

// The first argument should match the `class` argument from reactR::createReactShinyInput()
// The second argument is the input binding name
// The third argument is the React component
reactShinyInput('.markdowneditor', 'markdowneditor', MarkdownEditorInput);