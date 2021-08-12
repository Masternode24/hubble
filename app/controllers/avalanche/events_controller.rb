class Avalanche::EventsController < Avalanche::BaseController
  def index
    @current_page = params[:page].present? ? params[:page].to_i : 1

    raise ActiveRecord::RecordNotFound if @current_page < 1

    opts = params[:validator_id].present? ? { item_id: params[:validator_id], item_type: 'validator' } : {}

    @events = client.events(@current_page, opts)

    page_title 'Overview'
    meta_description 'Events'
  end

  def show
    @event = client.event(params[:id])

    page_title 'Event Details'
    meta_description 'Avalanche Event Details'
  end
end
