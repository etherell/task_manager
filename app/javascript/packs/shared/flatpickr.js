function setFlatpickr(formClass) {
  flatpickr(formClass, {
    altInput: true,
    enableTime: true,
    minDate: 'today',
    time_24hr: true,
    defaultDate: setDefaultDate(formClass)
  })
}

function setDefaultDate(formClass) {
  let deadlineString = $(formClass).val()
  let today = new Date();
  let deadlineTime = new Date(deadlineString)

  if (deadlineString != '' && deadlineTime > today) {
    return deadlineString;
  } else {
    today.setHours(today.getHours() + 1)
    return today;
  }
}

window.setFlatpickr = setFlatpickr
document.addEventListener('load', setFlatpickr('.datepicker'));
