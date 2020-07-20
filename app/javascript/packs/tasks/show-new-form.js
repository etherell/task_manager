$(document).ready(function(){

  $("body").find(".add-task-btn").click(function() {
    const projectId = $(this).closest('.project').data('project-id')
    showNewForm(projectId)
    });
  });

 function showNewForm(projectId) {
  $.ajax({
    url: `/projects/${projectId}/tasks/new`,
    method: 'GET',
    headers: {
      'X-CSRF-Token': document.getElementsByName('csrf-token')[0].content
    },
  });
}
