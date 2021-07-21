class Skale::EventsController < Skale::BaseController
  def index
    @current_page = params[:page].present? ? params[:page].to_i : 1

    raise ActiveRecord::RecordNotFound if @current_page < 1

    opts = params[:id].present? ? { validator_id: params[:id] } : {}

    @events = client.events(@current_page, opts)
    @validators = client.validators

    page_title 'Events'
    meta_description 'Skale Events'
  end

  def show
    @event = client.event(id: params[:id])[0]
    @validators = client.validators
    @validator = validator_lookup

    page_title 'Event Details'
    meta_description 'Skale Event Details'
  end

  private

  def validator_lookup
    id = @event.sender_id.zero? ? @event.recipient_id : @event.sender_id
    @validators.find { |v| v.id == id }
  end
end
