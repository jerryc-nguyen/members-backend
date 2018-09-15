class Api::V1::EventsController < ApiController
  skip_before_action :authenticate!

  def  index
    events = Event.paginate(page: params[:page] || 1, per_page: params[:per_page] || 5)
    success(data: events)
  end

  private

  def post_params
    params.permit(
      :title, :content
    )
  end

end
