class CommentsController < ApplicationController

  def create
    comment = Comment.new (params.require :comment).permit :content,:recipe_id
    comment.user_id = current_user.id
    puts params[:comment]

    comment.save if comment.valid?

    puts params

    redirect_to "/recipes/#{params[:comment][:recipe_id]}"
end

end
