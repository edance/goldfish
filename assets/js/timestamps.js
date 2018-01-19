import $ from 'jquery';
import moment from 'moment';

// Use moment to set for the current timezone
$('.time').each((idx, $el) => {
  const timestr = $el.dataset['time'];
  if (!timestr.trim()) {
    return;
  }
  const str = moment.utc(timestr).local().format('h:mm A');
  $el.innerHTML = str;
});
