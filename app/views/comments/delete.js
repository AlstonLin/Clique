$("##{comment_form_id @commentable}").html('<%= j render :partial => "comments/comments", :locals => { commentable: @commentable } %>');
