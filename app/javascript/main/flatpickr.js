import flatpickr from "flatpickr";
import { Japanese } from "flatpickr/dist/l10n/ja.js";

document.addEventListener("turbolinks:load", () => {
  const datePicker = document.getElementById("recruit_date");
  const timePicker = document.getElementById("recruit_meeting_time");
  let initializedDate = false;
  let initializedTime = false;
  let date = "today";
  if(location.href.includes('/edit') || !location.href.includes('/new') || window.location.pathname == (/\/recruits\/\d+/)) {
    date = "<%= @recruit.date %>";
  };
  let fpDate = flatpickr(datePicker, {
    locale: Japanese,
    defaultDate: date,
    dateFormat: "Y/n/j",
  });

  let time = new Date();
  if(location.href.includes('/edit') || !location.href.includes('/new') || window.location.pathname == (/\/recruits\/\d+/)) {
    time = timePicker.value.split(' ')[1]
  };

  let fpTime = flatpickr(timePicker, {
                 enableTime  : true,
                 noCalendar  : true,
                 dateFormat  : "H:i",
                 time_24hr   : true,
                 defaultDate: time,
               });

  function dateTimeOpen(picker, type) {
    if(type == 'date') {
      if(!initializedDate) {
        initializedDate = true;
      } else {
        if(picker.isOpen) {
          picker.close();
          initializedDate = false;
          return;
        }
      }
      picker.open();
      if(initializedTime) {
        initializedTime = false;
      }
    }else {
      if(!initializedTime) {
        initializedTime = true;
      } else {
        if(picker.isOpen) {
          picker.close();
          initializedTime = false;
          return;
        }
      }
      picker.open();
      if(initializedDate) {
        initializedDate = false;
      }
    }
  }
               
  datePicker.addEventListener("click", () => {
    dateTimeOpen(fpDate, 'date');
  });
  timePicker.addEventListener("click", () => {
    dateTimeOpen(fpTime, 'time');
  });
});
