# require 'google_calendar_api'
class AppointmentController < ApplicationController
  include Calendar
  def index
  end

  def redirect
    client = init_calendar({
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
      redirect_uri: callback_url
    })
    redirect_to client.authorization_uri.to_s
  end

  def callback
    client = init_calendar({
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      redirect_uri: callback_url,
      code: params[:code]
    })

    response = client.fetch_access_token!

    session[:authorization] = response

    redirect_to calendars_url
  end

  def calendars
    client = init_calendar({
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token'
    })

    client.update!(session[:authorization])

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    @calendar_list = service.list_calendar_lists
    @event_list = service.list_events(@calendar_list.items.first.id)

  end
  
end
