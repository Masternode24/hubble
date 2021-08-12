class Celo::Governance::MainController < Celo::BaseController
  def index
    @proposals = client.proposals
    render template: 'celo/governance/index'
  end
end
