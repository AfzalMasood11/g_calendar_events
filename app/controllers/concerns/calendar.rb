module Calendar
  # require 'google/api_client'
  extend ActiveSupport::Concern

  def init_calendar(options={})
    options[:client_id] = Rails.application.secrets.google_client_id
    options[:client_secret] = Rails.application.secrets.google_client_secret
    Signet::OAuth2::Client.new(options)
  end

end