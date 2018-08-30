class Api::V1::PostsController < ApiController
  def  index
    psots = Post.all
    success(data: psots)
  end

  private

  def post_params
    params.permit(
      :title, :content
    )
  end

end
