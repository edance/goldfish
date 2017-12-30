import socket from './socket';

let notifications = socket.channel('notifications');
notifications.join();
