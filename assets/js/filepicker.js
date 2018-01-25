import $ from 'jquery';
import filestack from 'filestack-js';

function fileToMarkdown(file) {
  return `![${file.filename}](${file.url})`;
}

function initFilePicker() {
  const client = filestack.init('Aj7z7GQJ7TunhKUAtIwcdz');
  const $textarea = $('textarea.filepicker');

  $('.open-picker').click(() => {
    client.pick({
      fromSources: ['local_file_system','imagesearch','facebook','instagram','dropbox'],
    }).then(function(response) {
      // declare this function to handle response
      const position = $textarea.prop('selectionStart');
      const text = response.filesUploaded.map(fileToMarkdown).join('');
      const original = $textarea.val();
      const newText = `${original.substring(0, position)}${text}${original.substring(position, original.length)}`;
      $textarea.val(newText);
    });
  });
}

if ($('textarea.filepicker')[0]) {
  initFilePicker();
}
