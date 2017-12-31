import notifications from './notifications';
import $ from 'jquery';

let count = 0;

notifications.on('new_msg', ()=> {
  count += 1;
  $('#notification-counter').text(`${count} messages`);
});
