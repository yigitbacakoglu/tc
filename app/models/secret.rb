class Secret < ActiveRecord::Base
  attr_accessible :active, :api_key, :api_secret, :environment, :permission, :provider


  def self.twitter_key
    where(:provider => 'twitter').first.api_key
  end

  def self.twitter_secret
    where(:provider => 'twitter').first.api_secret
  end

  def self.facebook_key
    where(:provider => 'facebook').first.api_key
  end

  def self.facebook_secret
    where(:provider => 'facebook').first.api_secret
  end

  def self.mail_secret
    where(:provider => 'yandex').first.api_secret
  end
end
