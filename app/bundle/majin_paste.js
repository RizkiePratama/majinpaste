import CodeMirror from 'codemirror';
import 'codemirror/lib/codemirror.css';
import 'codemirror/mode/clike/clike';
import 'codemirror/mode/css/css';
import 'codemirror/mode/javascript/javascript';
import 'codemirror/mode/ruby/ruby';
import 'codemirror/mode/xml/xml';
import 'codemirror/mode/python/python';
import 'codemirror/mode/php/php';
import 'codemirror/mode/go/go';
import 'codemirror/mode/shell/shell';
import 'codemirror/mode/sql/sql';
import 'codemirror/mode/markdown/markdown';
import 'codemirror/mode/nginx/nginx';
import 'codemirror/mode/perl/perl';
import 'codemirror/mode/rust/rust';
import 'codemirror/mode/swift/swift';
import 'codemirror/mode/yaml/yaml';
import 'codemirror/mode/dockerfile/dockerfile';
import 'codemirror/mode/powershell/powershell';
import 'codemirror/mode/haskell/haskell';
import 'codemirror/mode/lua/lua';
import 'codemirror/mode/r/r';
import 'codemirror/mode/dart/dart';
import 'codemirror/mode/elm/elm';
import 'codemirror/mode/erlang/erlang';
import 'codemirror/mode/fortran/fortran';
import 'codemirror/theme/dracula.css'; // Import Dracula theme

document.addEventListener('DOMContentLoaded', () => {
  const pasteEditorDiv = document.getElementById('paste-editor');
  const pasteContentHidden = document.getElementById('paste-content-hidden');
  const newPasteForm = document.getElementById('new-paste');
  const langSelect = document.getElementById('lang');

  const showSnackbar = (message) => {
    const container = document.getElementById('snackbar-container') || (() => {
      const newContainer = document.createElement('div');
      newContainer.id = 'snackbar-container';
      document.body.appendChild(newContainer);
      return newContainer;
    })();
    const snackbar = document.createElement('p');
    snackbar.className = 'form-snackbar';
    snackbar.setAttribute('role', 'alert');
    snackbar.textContent = message;
    container.appendChild(snackbar);
    window.setTimeout(() => {
      snackbar.classList.add('is-leaving');
      window.setTimeout(() => snackbar.remove(), 220);
    }, 5000);
  };

  const codeMirrorModes = [
    { label: 'Plain Text', value: 'text/plain' },
    { label: 'C/C++/C#', value: 'text/x-csharp' },
    { label: 'CSS', value: 'text/css' },
    { label: 'JavaScript', value: 'text/javascript' },
    { label: 'Ruby', value: 'text/x-ruby' },
    { label: 'XML/HTML', value: 'application/xml' },
    { label: 'Python', value: 'text/x-python' },
    { label: 'PHP', value: 'application/x-httpd-php' },
    { label: 'Go', value: 'text/x-go' },
    { label: 'Shell', value: 'text/x-sh' },
    { label: 'SQL', value: 'text/x-sql' },
    { label: 'Markdown', value: 'text/x-markdown' },
    { label: 'Nginx', value: 'text/x-nginx-conf' },
    { label: 'Perl', value: 'text/x-perl' },
    { label: 'Rust', value: 'text/x-rustsrc' },
    { label: 'Swift', value: 'text/x-swift' },
    { label: 'YAML', value: 'text/x-yaml' },
    { label: 'Dockerfile', value: 'text/x-dockerfile' },
    { label: 'PowerShell', value: 'application/x-powershell' },
    { label: 'Haskell', value: 'text/x-haskell' },
    { label: 'Lua', value: 'text/x-lua' },
    { label: 'R', value: 'text/x-rsrc' },
    { label: 'Dart', value: 'application/dart' },
    { label: 'Elm', value: 'text/x-elm' },
    { label: 'Erlang', value: 'text/x-erlang' },
    { label: 'Fortran', value: 'text/x-fortran' },
  ];

  let editor; // For the new paste editor
  let displayEditor; // For the paste view display

  if (langSelect) {
    // Populate the dropdown with CodeMirror modes
    codeMirrorModes.forEach(mode => {
      const option = document.createElement('option');
      option.value = mode.value;
      option.textContent = mode.label;
      langSelect.appendChild(option);
    });
  }

  // Initialize CodeMirror for the new paste editor (if present)
  if (pasteEditorDiv) {
    console.log('Initializing CodeMirror on #paste-editor div');
    const initialMode = langSelect ? langSelect.value : 'text/plain';
    editor = CodeMirror(pasteEditorDiv, {
      lineNumbers: true,
      mode: initialMode,
      theme: 'dracula',
      lineWrapping: true,
    });
    console.log('CodeMirror editor instance created:', editor);

    if (pasteContentHidden && pasteContentHidden.value) {
      editor.setValue(pasteContentHidden.value);
      console.log('Set initial CodeMirror content from hidden textarea.');
    }

    if (newPasteForm) {
      newPasteForm.addEventListener('submit', (event) => {
        if (pasteContentHidden) {
          pasteContentHidden.value = editor.getValue();
          console.log('Updated hidden textarea with CodeMirror content before submission.');
        }
        if (editor.getValue().trim() === '') {
          event.preventDefault();
          showSnackbar('Paste content cannot be empty');
        }
      });
    }

    if (langSelect) {
      langSelect.addEventListener('change', (event) => {
        const selectedMode = event.target.value;
        editor.setOption('mode', selectedMode);
        console.log('CodeMirror mode changed to:', selectedMode);
      });
    }

    editor.refresh();
    editor.focus();
    console.log('CodeMirror editor refreshed and focused.');
  } else {
    console.log('Could not find #paste-editor div for CodeMirror initialization (this is expected on view page).');
  }

  // Initialize CodeMirror for the paste display (if present)
  const pasteDisplayEditorDiv = document.getElementById('paste-display-editor');
  const pasteDisplayContentHidden = document.getElementById('paste-content-hidden');
  const pasteDisplayLangHidden = document.getElementById('paste-lang-hidden');

  if (pasteDisplayEditorDiv && pasteDisplayContentHidden && pasteDisplayLangHidden) {
    console.log('Initializing CodeMirror for paste display on #paste-display-editor div');
    const displayMode = pasteDisplayLangHidden.value || 'text/plain';
    displayEditor = CodeMirror(pasteDisplayEditorDiv, {
      lineNumbers: true,
      mode: displayMode,
      theme: 'dracula',
      readOnly: true, // Make it read-only for display
      lineWrapping: true,
    });
    displayEditor.setValue(pasteDisplayContentHidden.value);
    displayEditor.refresh();
    console.log('CodeMirror display editor instance created and content set.');
  } else {
    console.log('Could not find #paste-display-editor div or hidden content/lang for CodeMirror display initialization (this is expected on new paste page).');
  }

  const menuToggle = document.getElementById('menu-toggle');
  const panelBlock = document.getElementById('panel-block');

  const copyLinkButton = document.getElementById('copy-link');
  const pasteLink = document.getElementById('paste-link');
  const copyLinkStatus = document.getElementById('copy-link-status');
  const copyContentButton = document.getElementById('copy-content');
  const copyContentStatus = document.getElementById('copy-content-status');

  const copyText = async (text) => {
    try {
      await navigator.clipboard.writeText(text);
    } catch (error) {
      const fallback = document.createElement('textarea');
      fallback.value = text;
      fallback.style.position = 'fixed';
      fallback.style.opacity = '0';
      document.body.appendChild(fallback);
      fallback.select();
      document.execCommand('copy');
      fallback.remove();
    }
  };

  if (copyLinkButton && pasteLink && copyLinkStatus) {
    copyLinkButton.addEventListener('click', async () => {
      await copyText(pasteLink.value);
      copyLinkStatus.textContent = 'Link copied';
    });
  }

  if (copyContentButton && pasteDisplayContentHidden && copyContentStatus) {
    copyContentButton.addEventListener('click', async () => {
      await copyText(pasteDisplayContentHidden.value);
      copyContentStatus.textContent = 'Content copied';
    });
  }

  if (menuToggle && panelBlock) {
    menuToggle.addEventListener('click', () => {
      panelBlock.classList.toggle('panel-expanded');
      document.body.classList.toggle('panel-open'); // Toggle class on body for overlay
    });
  }
});
