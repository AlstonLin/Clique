$('#comments-content').html("<%= j render :partial => 'modal' %>");
$('#comments-modal').modal();
setupClasses();
setupComments();
