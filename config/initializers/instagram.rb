require "instagram"

Instagram.configure do |config|
  config.client_id = "c4a99320aa8a4bb7bc73858bc0934213"
  config.client_secret = "77adcbe6513746c69defd2f73d662957"
end

CALLBACK_URL = "http://localhost:3000/session/callback"
