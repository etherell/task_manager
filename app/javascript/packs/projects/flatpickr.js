function setFlatpickr() {
  flatpickr(".datepicker", {
    altInput: true,
    enableTime: true,
    minDate: "today"
  })
}

window.setFlatpickr = setFlatpickr

document.addEventListener("turbolinks:load", setFlatpickr);

