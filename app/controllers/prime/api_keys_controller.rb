class Prime::ApiKeysController < Prime::ApplicationController
  # Create a new API key for Prime
  # POST /prime/api_keys
  def create
    if current_user.api_keys.create(scope: 'prime')
      flash[:success] = 'New API key has been created'
    end

    redirect_to prime_eth2_staking_path
  end

  # Deactivate instead of destroying the key
  # DELETE /prime/api_keys/:id
  def destroy
    if current_user.api_keys.find(params[:id]).deactivate
      flash[:success] = 'API key has been deactivated'
    else
      flash[:error] = "API key can't be deactivated"
    end

    redirect_to prime_eth2_staking_path
  end
end
