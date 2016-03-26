$("#comments<%= @post.id %>").html('<%= j render :partial => "posts/comments", :locals => { post: @post } %>');
