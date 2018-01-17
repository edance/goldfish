import $ from 'jquery';

$('.messagebox').ready(() => {
  const $input = $('.messagebox .input');
  // Set focus for input
  if ($input[0]) {
    $input[0].focus();
  }

  // Clear out div to show placeholder
  $input.empty();

  // Handle paste events
  $input.on('paste', event => {
    event.stopPropagation();
    event.preventDefault();

    // Get pasted data via clipboard API
    const data = event.originalEvent.clipboardData || window.clipboardData;
    const text = data.getData('Text');

    document.execCommand('insertText', false, text);
  });
});
