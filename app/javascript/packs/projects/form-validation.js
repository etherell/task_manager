function setProjectFormValidation(buttonClass, inputClass) {
  let submBtn = $(buttonClass)
  let titleInput = $(inputClass)
  
  titleInput.keyup(function() {
    if (titleInput.val().length >= 3 && titleInput.val().length <= 75) {
      submBtn.prop('disabled', false);
      titleInput.removeClass('is-invalid').addClass('is-valid');
    } else {
      submBtn.prop('disabled', true);
      titleInput.removeClass('is-valid').addClass('is-invalid');
    }
  })
};

window.setProjectFormValidation = setProjectFormValidation
document.addEventListener('load', setProjectFormValidation('.add-project-button', '.add-project-title'));
