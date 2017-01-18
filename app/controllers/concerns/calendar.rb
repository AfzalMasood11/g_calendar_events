module Calendar
  extend ActiveSupport::Concern

  def init_calendar(options={})
    options[:client_id] = Rails.application.secrets.google_client_id
    options[:client_secret] = Rails.application.secrets.google_client_secret
    Signet::OAuth2::Client.new(options)
  end

  def get_events(client, authorization)
    client.update!(authorization)
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    calendar_list = service.list_calendar_lists
    event_list = service.list_events(calendar_list.items.first.id)

    events = {}
    event_list.items.map do |event|
      if events[event.created.try(:strftime, '%Y-%m-%d')]
        events[event.created.try(:strftime, '%Y-%m-%d')] << event.summary
      else
        events[event.created.try(:strftime, '%Y-%m-%d')] = [event.summary]
      end
    end
    return events
  end

end