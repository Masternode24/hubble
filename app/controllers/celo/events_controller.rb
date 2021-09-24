class Celo::EventsController < Celo::BaseController
  def index
    @page = (params[:page] || Celo::Client::DEFAULT_EVENTS_PAGE).to_i
    @events = client.paginated_events(@chain, @page)
    @pagy = Pagy.new(count: @events.count, page: @page, items: Celo::Client::DEFAULT_EVENTS_LIMIT)
    page_title @chain.network_name, @chain.name, 'Events'
    meta_description "Validator events for #{@chain.network_name} - #{@chain.name}"
  end
end
