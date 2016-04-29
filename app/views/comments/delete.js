$("#flash-container").html('<%= escape_javascript(render :partial => "shared/flash_box") %>');
var $track_comments = $('<%= "##{comment_form_id @commentable}-show" %>');
if ($track_comments.size() > 0){
  $track_comments.html('<%= j render :partial => "tracks/show_comments", :locals => { track: @commentable } %>')
} else{
  $('<%= "##{comment_form_id @commentable}" %>').html('<%= j render :partial => "comments/comments_list", :locals => { commentable: @commentable } %>');
}
