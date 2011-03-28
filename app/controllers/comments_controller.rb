class CommentsController < ApplicationController
  before_filter :require_user
  
  def create
    comment = current_user.comments.new(params[:comment])
    if comment.save
      flash[:notice] = I18n.t("action.create_successfully")
      redirect_to :back
    else
      flash[:error] = I18n.t("action.create_fail")
      redirect_to :back
    end
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:notice] = I18n.t("action.destroy_successfully")
    redirect_to comments_url
  end
end
