import socket from './socket';

if (window.userToken) {
  let notifications = socket.channel('notifications');
  notifications.join();
}
