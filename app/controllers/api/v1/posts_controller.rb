class Api::V1::PostsController < ApiController
  skip_before_action :authenticate!

  def  index
    posts = Post.includes(:user).paginate(page: params[:page] || 1, per_page: params[:per_page] || 5)
    success(data: posts)
  end

  private

  def post_params
    params.permit(
      :title, :content
    )
  end

end
