class TaskFormValidator {

  constructor(submBtnClass, descInputClass, deadlineInputClass) {
    this.submBtn = $(submBtnClass);
    this.descInput = $(descInputClass);
    this.deadlineInput = $(deadlineInputClass);
  }

  // Sets validation for descriptio input
  setForDescription() {
    this.descInput.keyup(() => {
      if (this.descInput.val().length >= 3 && this.descInput.val().length <= 255) {
        this.descInput.removeClass('is-invalid').addClass('is-valid');
        this.unblockButton()
      } else {
        this.submBtn.prop('disabled', true);
        this.descInput.removeClass('is-valid').addClass('is-invalid');
      }
    })
    return this
  }

  // Sets validation for deadline input
  setForDeadline() {
    let deadlineString, today, deadlineTime;

    this.deadlineInput.on('change', () => {
      deadlineString = this.deadlineInput.val();
      today = new Date();
      deadlineTime = new Date(deadlineString)
  
      if (deadlineString == '' || deadlineTime < today) {
        this.deadlineInput.removeClass('is-valid').addClass('is-invalid');
        this.submBtn.prop('disabled', true);
      } else {
        this.deadlineInput.removeClass('is-invalid').addClass('is-valid');
        this.unblockButton()
      }
    })
  }

  // Unblocks button if both inputs valid
  unblockButton() {
    if (this.descInput.hasClass("is-valid") && this.deadlineInput.hasClass("is-valid")) {
      this.submBtn.prop('disabled', false);
    }
  }
}

window.TaskFormValidator = TaskFormValidator
