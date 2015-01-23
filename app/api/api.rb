require 'grape-swagger'

class API < Grape::API
  prefix 'api'
  format :json
  
  content_type :xml, 'application/xml;charset=utf-8'
  content_type :json, 'application/json;charset=utf-8'
  content_type :binary, 'application/octet-stream;charset=utf-8'
  content_type :txt, 'text/plain;charset=utf-8'

  default_format :json

  helpers do
    def current_user
      @current_user ||= User.authorize!(env)
    end

    def authenticate!
      error!('401 Unauthorized', 401) unless current_user
    end

    def logger
      API.logger
    end
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    Rack::Response.new({
      error_code: 404,
      error_message: e.message
      }.to_json, 404).finish
  end
 
  rescue_from :all do |e|
    Rack::Response.new({
      error_code: 500,
      error_message: e.message
      }.to_json, 500).finish
  end
        # # global handler for simple not found case
        # rescue_from ActiveRecord::RecordNotFound do |e|
        #   error_response(message: e.message, status: 404)
        # end

        # # global exception handler, used for error notifications
        # rescue_from :all do |e|
        #   if Rails.env.development?
        #     raise e
        #   else
        #     Raven.capture_exception(e)
        #     error_response(message: "Internal server error", status: 500)
        #   end
        # end

        # # HTTP header based authentication
        # before do
        #   error!('Unauthorized', 401) unless headers['Authorization'] == "some token"
        # end

  #mount WTK::OrgAPI
  mount WTK::Users
  mount WTK::Products
  mount WTK::Orders

  add_swagger_documentation mount_path: '/docs',
                            hide_documentation_path: true
                            # base_path: lambda { |request| "http://#{request.host}:#{request.port}" },
                            # markdown: GrapeSwagger::Markdown::KramdownAdapter unless Rails.env.production?
end