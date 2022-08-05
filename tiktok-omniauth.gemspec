# -*- encoding: utf-8 -*-

require File.expand_path('../lib/tiktok_oauth_strategy/version', __FILE__)

Gem::Specification.new do |gem|
    gem.name          = 'tiktok-oauth-strategy'
    gem.version       = TiktokOAuthStrategy::VERSION
    gem.authors       = ['Fariha Hossain']
    gem.email         = ['fthossain220@gmail.com']
    gem.description   = 'OmniAuth strategy for TikTok.'
    gem.summary       = 'OmniAuth strategy for TikTok.'
    gem.homepage      = 'https://github.com/f-hossain/tiktok_oauth_strategy'

    gem.files         = `git ls-files`.split("\n")
    gem.require_paths = ['lib']
    
    gem.add_dependency 'omniauth', '~> 2.0'
    gem.add_dependency 'omniauth-oauth2', '~> 1.7'
end