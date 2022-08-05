# frozen_string_literal: true

# Overriding a few methods for the OAuth2::Client (https://github.com/oauth-xx/oauth2/blob/422d3132343227cec84d5d34a7a8ce4825439bdb/lib/oauth2/client.rb)
#
# TikTok Returns it's access_token inside of a data attribute which is unexpected by OAuth2. Overriding methods to look inside of the data attribute for
# the access_token

class TiktokOAuth2Client < OAuth2::Client
  # Initializes an AccessToken by making a request to the token endpoint
  #
  # @param params [Hash] a Hash of params for the token endpoint
  # @param access_token_opts [Hash] access token options, to pass to the AccessToken object
  # @param access_token_class [Class] class of access token for easier subclassing OAuth2::AccessToken
  # @return [AccessToken] the initialized AccessToken
  def get_token(params, access_token_opts = {}, access_token_class = OAuth2::AccessToken) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    params = params.map do |key, value|
      if RESERVED_PARAM_KEYS.include?(key)
        [key.to_sym, value]
      else
        [key, value]
      end
    end

    params = authenticator.apply(params.to_h)
    opts = { raise_errors: options[:raise_errors], parse: params.delete(:parse) }
    headers = params.delete(:headers) || {}
    if options[:token_method] == :post
      opts[:body] = params
      opts[:headers] = { "Content-Type" => "application/x-www-form-urlencoded" }
    else
      opts[:params] = params
      opts[:headers] = {}
    end
    opts[:headers].merge!(headers)
    http_method = options[:token_method] == :post_with_query_string ? :post : options[:token_method]
    response = request(http_method, token_url, opts)
    response_contains_token = response.parsed.is_a?(Hash) &&
                              (response.parsed.dig("data", "access_token") || response.parsed.dig("data", "id_token"))

    raise OAuth2::Error, response if options[:raise_errors] && !response_contains_token

    return nil if !response_contains_token

    build_access_token(response, access_token_opts, access_token_class)
  end

  private

  # Returns the authenticator object
  #
  # @return [OAuth2::Authenticator] the initialized Authenticator
  def authenticator
    OAuth2::Authenticator.new(id, secret, options[:auth_scheme])
  end

  # Builds the access token from the response of the HTTP call
  #
  # @return [AccessToken] the initialized AccessToken
  def build_access_token(response, access_token_opts, access_token_class)
    access_token_class.from_hash(self, response.parsed["data"].merge(access_token_opts)).tap do |access_token|
      access_token.response = response if access_token.respond_to?(:response=)
    end
  end
end
