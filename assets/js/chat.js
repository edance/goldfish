import socket from './socket';
import $ from 'jquery';
import moment from 'moment';

let channel           = socket.channel(`room:${window.roomId}`, {});
let chatInput         = $('#chat-input');
let messagesContainer = $('#messages');

const scrollToBottom = ()=> {
  const $container = $('.messages-container');
  $container.scrollTop($container[0].scrollHeight);
};

const addMessage = (message) => {
  const className = message.bot ? 'bot' : '';
  const date = moment.utc(message.inserted_at).local().format('h:mm A');
  const template = `
  <div class="message ${className}">
    <div class="avatar"></div>

    <div class="container">
      <div class="body">
        ${message.body}
      </div>
      <div class="time">
        ${date}
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
  const messages = ['👋 Hi there!', `I'm Evan Dancer`, 'Ask me anything'];
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

if (messagesContainer.length) {
  setSpacerHeight();
  scrollToBottom();

  if (!messagesContainer.html().trim()) {
    sendWelcomeMessages();
  }
}

$('.chat.container').click(() => {
  const $input = $('.messagebox .input');
  // Set focus for input
  if ($input[0]) {
    $input[0].focus();
  }
});

channel.join();
