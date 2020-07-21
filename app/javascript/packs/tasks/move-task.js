let drake = dragula();
$(document).ready(function () {
  // Dragula setup
  let allContainers = $('.tasks-drag').toArray();
  drake = dragula(allContainers);
  // Sends information to tasks#moves controller on drop
  drake.on('drop', function (el, target, source) {
    let taskId = $(el).data("task-id");
    let projectId = $(el).closest(".project").data("project-id");
    let targetTasksIds = new Array();
    let targetTasks = $(target).find(".task");
    let sourceTasksIds = new Array();
    let sourceTasks = $(source).find(".task");

    createTasksIdsArray(targetTasks, targetTasksIds);
    if(target != source){
      createTasksIdsArray(sourceTasks, sourceTasksIds);
    };

    $.ajax({
      url: `/projects/${projectId}/tasks/${taskId}/move/`,
      method: 'PATCH',
      headers: {
        'X-CSRF-Token': document.getElementsByName('csrf-token')[0].content
      },
      data : { target_tasks_ids: JSON.stringify(targetTasksIds),
               source_tasks_ids: JSON.stringify(sourceTasksIds) }
    });
  });
});

// Function to create array with tasks ids
function createTasksIdsArray(tasks, emptyArray) {
  tasks.each(function(){
    emptyArray.push($(this).data('task-id'));
  });
}

// Resets dragula containers
setInterval(function() {
  let currentDragConteiners = $('.tasks-drag')
  if(drake.containers.length != currentDragConteiners.length){
    drake.containers = currentDragConteiners.toArray();
  }
}, 1000);

