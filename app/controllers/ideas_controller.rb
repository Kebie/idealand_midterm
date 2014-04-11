class IdeasController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  before_action :find_idea, only: [:edit, :destroy, :update]

  def index
    @ideas = Idea.all
  end

  def show
    @idea = Idea.find(params[:id]) #have to get the idea not from a user can any can view
    @comments = @idea.comments
    @comment = Comment.new
  end

  def create
    @idea = current_user.ideas.new(idea_attributes)
    if @idea.save
      redirect_to ideas_path, notice: "Your terrible idea was added."
    else
      render :new
    end
  end


  def update
    if @idea.update_attributes(idea_attributes)
      redirect_to @idea, notice: "Your idea was updated"
    else
      render :edit
    end
  end

  def destroy
    if @idea.destroy
      redirect_to ideas_path, notice: "Idea deleted."
    else
      redirect_to ideas_path, error: "We had a problem deleting your idea"
    end    
  end

  def new
    @idea = Idea.new
  end

  private

  def idea_attributes
    params.require(:idea).permit(:title, :description)
  end

  def find_idea
    @idea = current_user.ideas.find(params[:id]) #maybe later if we have to lock down ideas change to
                                  # current_user.ideas.find(params[:id])
  end

end
