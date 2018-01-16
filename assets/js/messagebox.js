import $ from 'jquery';

$('.messagebox').on('keyup', e => {
  const $box = $(e.currentTarget);
  const height = $box.outerHeight();
  $('.messages').outerHeight($box.parent().height() - height);
});

$('.messagebox').ready(() => {
  const $input = $('.messagebox .input');
  if ($input[0]) {
    $input[0].focus();
  }
  $input.empty();
});
