module Prime
  module ServiceClients
    extend ActiveSupport::Concern

    def anjin_client
      @anjin_client ||= Prime::Anjin::Client.new(
        Rails.application.secrets.figment_anjin[:endpoint],
        authorization: Rails.application.secrets.figment_anjin[:token]
      )
    end
  end
end
