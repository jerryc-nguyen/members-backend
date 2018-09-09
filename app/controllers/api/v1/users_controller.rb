class Api::V1::UsersController < ApiController
  skip_before_action :authenticate!, only: [:show, :index]

  def  index
    users = User.all.by_keyword(params[:keyword]).paginate(page: params[:page] || 1, per_page: params[:per_page] || 5)
    success(data: users)
  end

  def current_profile
    success(data: current_user.serialize(UserAuthSerializer))
  end

  def show
    user = User.find(params[:id])
    success(data: user.serialize(UserDetailSerializer))
  end

  private

  def user_params
    params.permit(
      :name, :job_title
    )
  end

end
