class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy, :edit]

  before_action :find_comment, only: [:show, :edit, :update, :destroy]

  def create
    @idea = Idea.find params[:idea_id]
    @comment = @idea.comments.new(comment_attributes)
    @comment.user = current_user #connect a user to the comment
    
    if @comment.save
      redirect_to @idea, notice: "Your thrilling comment was added"
    else
      @comments = @idea.comments
      render "/ideas/show"
    end

  end

  def destroy
    if @comment.destroy
      redirect_to @idea, notice: "Comment destroyed"
    else
      redirect_to @idea, notice: "There was a problem deleting your comment"
    end
    
  end


  private
  def find_comment
    @comment = Comment.find(params[:comment_id] || params[:id])
    @idea = @comment.idea
  end

  def comment_attributes
    params.require(:comment).permit(:comment)
  end


end
