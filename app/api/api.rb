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

  mount WTK::OrgAPI
  mount WTK::UserAPI
  mount WTK::ProductAPI

  add_swagger_documentation mount_path: '/docs' 
                            #,
                            # base_path: lambda { |request| "http://#{request.host}:#{request.port}" },
                            # markdown: GrapeSwagger::Markdown::KramdownAdapter unless Rails.env.production?
end