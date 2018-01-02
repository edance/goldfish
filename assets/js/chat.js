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
  messagesContainer.scrollTop(messagesContainer[0].scrollHeight);
};

const addMessage = (message) => {
  const className = message.bot ? 'bot' : '';
  const template =
        `<div class='clearing'>
           <div class='message ${className}'>
             ${message.body}
             <div class='time'>${message.inserted_at}</div>
           </div>
         </div>`;

  let messageItem = document.createElement('div');
  messageItem.innerHTML = template;
  messagesContainer.append(messageItem);
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

chatInput.on('keypress', event => {
  if(event.keyCode === 13 && !event.shiftKey){
    event.preventDefault();
    channel.push('new_msg', {body: chatInput.text()});
    chatInput.empty();
  }
});

channel.on('new_msg', addMessage);

scrollToBottom();

if (!messagesContainer.html().trim()) {
  sendWelcomeMessages();
}

channel.join();
