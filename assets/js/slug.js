import $ from 'jquery';

const $title = $('input.title');

$title.on('keyup', () => {
  const str = $title.val();
  const slug = str.toLowerCase().split(' ').join('-');
  $('input.slug').val(slug);
});
