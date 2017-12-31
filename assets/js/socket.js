import {Socket} from 'phoenix';

let params = {};

if (window.userToken) {
  params['token'] = window.userToken;
}
let socket = new Socket('/socket', {params: params});
socket.connect();

export default socket;
