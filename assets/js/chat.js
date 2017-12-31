import socket from './socket';
import $ from 'jquery';

let channel           = socket.channel(`room:${window.roomId}`, {});
let chatInput         = $('#chat-input');
let messagesContainer = document.querySelector('#messages');

chatInput.on('paste', event => {
  event.stopPropagation();
  event.preventDefault();

  // Get pasted data via clipboard API
  const data = event.originalEvent.clipboardData || window.clipboardData;
  const text = data.getData('Text');

  document.execCommand('insertText', false, text);
});

chatInput.on('keypress', event => {
  if(event.keyCode === 13 && !event.shiftKey){
    event.preventDefault();
    channel.push('new_msg', {body: chatInput.text()});
    chatInput.empty();
  }
});

channel.on('new_msg', payload => {
  const className = payload.bot ? 'bot' : '';
  const template =
        `<div class='clearing'>
           <div class='message ${className}'>
             ${payload.body}
             <div class='time'>${payload.inserted_at}</div>
           </div>
         </div>`;

  let messageItem = document.createElement('div');
  messageItem.innerHTML = template;
  messagesContainer.appendChild(messageItem);
});

channel.join();
