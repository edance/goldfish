import notifications from './notifications';
import $ from 'jquery';

let container = $('#message-nav');

notifications.on('new_msg', message => {
  const name = message.bot ? 'Bot' : message.ip_address;
  const template = `
  <a href="/admin/rooms/${message.room_id}">
    <div class="message-link">
      <div class="from">${name}</div>
      <div class="body">${message.body}</div>
    </div>
  </a>`;

  let messageItem = document.createElement('div');
  messageItem.innerHTML = template;
  container.prepend(messageItem);
});
