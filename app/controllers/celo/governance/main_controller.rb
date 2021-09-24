class Celo::Governance::MainController < Celo::BaseController
  def index
    @proposals = client.proposals

    page_title @chain.network_name, @chain.name, 'Governance Proposals & Results'
    meta_description "#{@chain.network_name} - #{@chain.name} Governance Proposals: ID, Stage, Started Date and Started Height"

    render template: 'celo/governance/index'
  end
end
