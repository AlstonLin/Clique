Recaptcha.configure do |config|
  config.public_key  = ENV['CLIQUE_RECAPTCHA_KEY']
  config.private_key = ENV['CLIQUE_RECAPTCHA_SECRET']
end
