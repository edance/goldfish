import notifications from './notifications';
import $ from 'jquery';

let container = $('#message-nav');

notifications.on('new_msg', payload => {
  let messageItem = document.createElement('li');
  messageItem.innerText = payload.body;
  container.prepend(messageItem);
});
