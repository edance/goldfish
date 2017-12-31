import socket from './socket';

let notifications = socket.channel('notifications');

if (window.userToken) {
  let notifications = socket.channel('notifications');
  notifications.join();
}

export default notifications;
