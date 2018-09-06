class Api::V1::UsersController < ApiController
  def  index
    users = User.all.paginate(page: params[:page] || 1, per_page: params[:per_page] || 5)
    success(data: users)
  end

  private

  def user_params
    params.permit(
      :name, :job_title
    )
  end

end
