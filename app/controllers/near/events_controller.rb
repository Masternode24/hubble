class Near::EventsController < Near::BaseController
  def index
    @current_events_page = params['events_page'].to_i || 1
    opts = {
      page: @current_events_page,
      limit: 50
    }

    if params[:id].present?
      opts = opts.merge(item_id: params[:id], item_type: 'validator')
    end

    @events = client.paginate(Near::Event, '/events', opts)
    page_title 'Events'
    meta_description 'Events'
  end

  def show
    @event = client.event(params[:id])
    page_title 'Event Details'
    meta_description 'Event Details'
  end
end
