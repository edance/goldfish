import $ from 'jquery';

$('.messagebox').on('keyup', e => {
  const $box = $(e.currentTarget);
  const height = $box.outerHeight();
  $('.messages').outerHeight($box.parent().height() - height);
});
