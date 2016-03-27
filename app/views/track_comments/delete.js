var comments = $("#track-comments<%= @track.id %>");
if (comments.length > 0){
  comments.html('<%= j render :partial => "tracks/comments", :locals => { track: @track } %>');
} else {
  $("#track-comments<%= @track.id %>-numbered").html('<%= j render :partial => "tracks/comments_with_number" %>');
}
