Rails.application.config.middleware.use OmniAuth::Builder do
  provider :wechat, 'wxcc4c37da7948edc4', '0601b8947c0cac7d1680bb40b674a9c4'
end