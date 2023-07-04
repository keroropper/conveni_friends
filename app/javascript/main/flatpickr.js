import flatpickr from "flatpickr";
import { Japanese } from "flatpickr/dist/l10n/ja.js";

document.addEventListener("turbolinks:load", () => {
  const datePicker = document.getElementById("recruit_date");
  const timePicker = document.getElementById("recruit_meeting_time");
  let initializedDate = false;
  let initializedTime = false;
  let fpDate = flatpickr(datePicker, {
    dateFormat: "Y/m/d",
    locale: Japanese,
    defaultDate: "today"
  });
  let fpTime = flatpickr(timePicker, {
                 enableTime  : true,
                 noCalendar  : true,
                 dateFormat  : "H:i",
                 time_24hr   : true,
                 defaultDate: new Date()
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