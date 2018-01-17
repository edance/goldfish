import socket from './socket';
import $ from 'jquery';

let channel           = socket.channel(`room:${window.roomId}`, {});
let chatInput         = $('#chat-input');
let messagesContainer = $('#messages');

const scrollToBottom = ()=> {
  const $container = $('.messages-container');
  $container.scrollTop($container[0].scrollHeight);
};

const addMessage = (message) => {
  const className = message.bot ? 'bot' : '';
  const template = `
  <div class="message ${className}">
    <img class="avatar" src="/images/prof.jpg" />

    <div class="container">
      <div class="body">
        ${message.body}
      </div>
      <div class="time">
        ${message.inserted_at}
      </div>
    </div>
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

  $('.chat.container').click(() => {
    const $input = $('.messagebox .input');
    // Set focus for input
    if ($input[0]) {
      $input[0].focus();
    }
  });
});

channel.join();
