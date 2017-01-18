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
    @events = get_events(client, session[:authorization])
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
  end

end
