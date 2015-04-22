Rails.application.config.middleware.use OmniAuth::Builder do
  provider :wechat, 'wx93312b406088cd15', '0601b8947c0cac7d1680bb40b674a9c4'
end