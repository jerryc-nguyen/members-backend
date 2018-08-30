class ApiController < ActionController::Base
  # before_action :maintainance_mode

  before_action :set_current_user
  # before_action :authenticate!

  unless Rails.application.config.consider_all_requests_local

    rescue_from StandardError do |ex|
      log_exception(ex)
      error(status: 403, message: ex.message.to_s, backtrace: ex.backtrace)
    end

    rescue_from ActiveRecord::RecordInvalid do |ex|
      log_exception(ex)
      error(status: 403, message: ex.message.to_s, backtrace: ex.backtrace)
    end

    rescue_from ActionController::ParameterMissing do |ex|
      log_exception(ex)
      error(status: 403, message: ex.message.to_s, backtrace: ex.backtrace)
    end

    rescue_from ActionController::RoutingError, with: :routing_error

    rescue_from ActiveRecord::RecordNotFound do |ex|
      log_exception(ex)
      error(status: 404, message: ex.message.to_s, backtrace: ex.backtrace)
    end
  end

  rescue_from CustomError do |ex|
    error(status: 400, message: ex.message.to_s, backtrace: ex.backtrace)
  end

  def maintainance_mode
    return error(
      status: 403,
      message: "Sorry, the app is maintaining."
    ) if !request.xhr? && !Rails.env.development?
  end

  def index
    success(data: {"message": "API server is working!"})
  end

  def success(data: nil, serializer: nil, serialize_options: {}, message: nil,
    extra_info: nil, return_data: false)

    response = {
      status: 200,
      data: data
    }

    serialize_options = serialize_options.merge(
      current_user: current_user,
      req_params: params
    )

    lat = current_user.try(:latitude) || cookies["user_lat_local"]
    lng = current_user.try(:longitude) || cookies["user_lon_local"]

    if lat.to_f != 0 && lng.to_f != 0
      serialize_options = serialize_options.merge({
        coors: { lat: lat, lng: lng }
      })
    end

    if data.is_a?(Hash)
      response[:data] = data
    elsif data.present?
      serializer = Api::SuccessResponse.new(
                    object: data,
                    serializer: serializer,
                    serialize_options: serialize_options
                  )
      response = serializer.response
    end

    response[:message] = message if message.present?
    response = response.merge(extra_info) if extra_info.is_a?(Hash)
    response = response["data"] if return_data == true
    render json: response
  end

  def error(status: 403, message: nil, backtrace: nil)
    # backtrace =  nil if Rails.env.production?
    render json: { status: status, message: message, backtrace: backtrace }
  end


  def set_current_user
    @current_user ||= begin
      User.first
    end
  end

  def current_user
    @current_user ||= set_current_user
  end

  def authenticate!
    if current_user.blank?
      message = request.headers['X-Api-Token'].present? ? "Token not valid." : "You must login to continue."
      return error(status: 403, message: message)
    end
  end

  def show_exception(ex)
    message = "ERROR: #{ex.message}"
    params[:file] = nil
    params[:image_data] = nil
    puts "\n#{'='*message.length}\n"
    puts ">>>  ERROR: #{ex.message}  \n#{params.to_json}"
    puts ex.backtrace.select{|i| i.include?("/app/")}

    if ex.message.include?("PG::")
      log_exception(ex)
    end
  end

  def log_exception(ex)
    show_exception(ex)
    # CustomError.error(ex, params, current_user)
  end

  private

  def routing_error
    error(status: 404, message: "No route matches.")
  end

end
