import socket from './socket';
import $ from 'jquery';

let channel           = socket.channel(`room:${window.roomId}`, {});
let chatInput         = $('#chat-input');
let messagesContainer = $('#messages');

chatInput.on('paste', event => {
  event.stopPropagation();
  event.preventDefault();

  // Get pasted data via clipboard API
  const data = event.originalEvent.clipboardData || window.clipboardData;
  const text = data.getData('Text');

  document.execCommand('insertText', false, text);
});

const scrollToBottom = ()=> {
  const $container = $('.messages-container');
  $container.scrollTop($container[0].scrollHeight);
};

const addMessage = (message) => {
  const className = message.bot ? 'bot' : '';
  const template =
        `<div class='message ${className}'>
           <div class='body'>
             ${message.body}
           </div>
           <div class='time'>${message.inserted_at}</div>
         </div>`;

  let messageItem = document.createElement('div');
  messageItem.innerHTML = template;
  messagesContainer.append(messageItem);
  setSpacerHeight();
  scrollToBottom();
};

const sendWelcomeMessages = () => {
  const messages = ['Hi there!', 'I am Evan\'s Website Bot', 'Ask me anything (about him)?'];
  messages.map((body, idx) => {
    const message = {
      body,
      bot: true,
      inserted_at: new Date(),
    };
    setTimeout(() => addMessage(message), idx * 1500);
  });
};

const setSpacerHeight = () => {
  const containerHeight = $('.messages-container').height();
  const messageHeight = $('.messages').height();
  if (messageHeight > containerHeight) {
    return;
  }
  $('.spacer').height(containerHeight - messageHeight);
};

$('.messagebox').on('keyup', e => {
  const $box = $(e.currentTarget);
  const height = $box.outerHeight();
  $('.messages-container').outerHeight($box.parent().height() - height);
  setSpacerHeight();
  scrollToBottom();
});

chatInput.on('keypress', event => {
  if(event.keyCode === 13 && !event.shiftKey){
    event.preventDefault();
    channel.push('new_msg', {body: chatInput.text()});
    chatInput.empty();
  }
});

channel.on('new_msg', addMessage);

$('.chat.container').ready(() => {
  setSpacerHeight();
  scrollToBottom();

  if (!messagesContainer.html().trim()) {
    sendWelcomeMessages();
  }

});

channel.join();
