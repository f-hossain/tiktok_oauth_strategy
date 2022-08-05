# tiktok_oauth_strategy

An unofficial OmniAuth strategy for TikTok authentication with the [TikTok Login Kit](https://developers.tiktok.com/doc/login-kit-web/). 


## Usage

Install the gem 

```ruby
gem 'tiktok_oauth_strategy'
bundle install
```

Make a TikTok developer account and create an application. Retrieve the app's `TIKTOK_CLIENT_ID` and `TIKTOK_CLIENT_SECRET` once it is approved and add a middleware to your ruby project, typically in a config/initializers/omniauth.rb file :

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :tiktok, ENV['TIKTOK_CLIENT_ID'], ENV['TIKTOK_CLIENT_SECRET']
end
```

