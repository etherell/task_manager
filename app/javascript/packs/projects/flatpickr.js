function setFlatpickr() {
  flatpickr(".datepicker", {
    altInput: true,
    enableTime: true,
    minDate: "today"
  })
}

document.addEventListener("turbolinks:load", setFlatpickr);

document.querySelector('.add-new-project').onclick = function() {
  setTimeout(setFlatpickr, 200);
};
