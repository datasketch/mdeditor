import { reactShinyInput } from 'reactR';
import MDEditor from '@uiw/react-md-editor';

const MarkdownEditorInput = ({ configuration, value, setValue }) => {
  return (
    <MDEditor
      value={value || ''}
      onChange={(val) => setValue(val || '')}
      preview="edit"
      {...configuration}
    />
  );
};

reactShinyInput('.markdowneditor', 'markdowneditor', MarkdownEditorInput);