class Cosmos::ChainsController < Cosmoslike::ChainsController
  def broadcast
    render json: { ok: true, txhash: 'TESTHASH' } and return if Rails.env.development?

    tx = { tx: params[:payload] }

    if @chain.sdk_gte?('0.34.0')
      tx[:mode] = 'sync'
    else
      tx[:return] = 'sync'
    end

    r = @chain.syncer(5000).broadcast_tx(tx)
    ok = !r.has_key?('code') && !r.has_key?('error')
    Rails.logger.info("\n\nBROADCAST RESULT: #{r.inspect}\n\n")
    render json: { ok: ok }.merge(r)
  end
end
