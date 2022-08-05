# frozen_string_literal: true

class Tiktok < OmniAuth::Strategies::OAuth2
  option :name, "tiktok"
  option :response_type, "code"

  uid { raw_info["open_id"] }

  extra do
    {
      raw_info: raw_info
    }
  end

  info do
    {
      name: raw_info["display_name"],
      description: raw_info["description"],
      image: raw_info["avatar"],
      large_image: raw_info["avatar_larger"],
      secondary_social_id: raw_info["union_id"],
      refresh_token_expiry: access_token["refresh_expires_in"].seconds.from_now,
      access_token_expiry: Time.at(access_token.expires_at).utc.to_datetime
    }
  end

  def client
    # config/initializers/tiktok_oauth2.rb
    ::TiktokOAuth2Client.new(options.client_id, options.client_secret, deep_symbolize(options.client_options))
  end

  # overriding method to pass in client_key to authorization url
  def authorize_params
    super.tap do |params|
      params[:client_key] = options[:client_key]
      session["omniauth.state"] = params[:state] if params[:state]
    end
  end

  def raw_info
    uri = "https://open-api.tiktok.com/oauth/userinfo/"

    query_params = {
      open_id: access_token.params['open_id'],
      access_token: access_token.token
    }

    result = HTTParty.get(uri, query: query_params)
    @raw_info ||= result.parsed_response["data"]
  end
end
