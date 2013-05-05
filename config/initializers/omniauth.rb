Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, Secret.twitter_key, Secret.twitter_secret
  provider :facebook, Secret.facebook_key, Secret.facebook_secret, :scope => "email, publish_stream, read_stream"
end

