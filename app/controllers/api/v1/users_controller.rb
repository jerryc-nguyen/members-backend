class Api::V1::UsersController < ApiController
  def  index
    users = User.all
    success(data: users)
  end

  private

  def user_params
    params.permit(
      :name, :job_title
    )
  end

end
