import $ from 'jquery';

$('.messagebox').ready(() => {
  const $input = $('.messagebox .input');
  if ($input[0]) {
    $input[0].focus();
  }
  $input.empty();
});
