class Prime::Admin::NetworksController < Prime::Admin::BaseController
  def new
    @network = Prime::Network.new
  end

  def create
    @network = Prime::Network.new(name: network_params[:name])

    if @network.save
      redirect_to prime_admin_root_path, notice: 'Network created successfully.'
    else
      flash[:error] = @network.errors.full_messages.join(', ')
      render :new
    end
  end

  def edit
    @network = Prime::Network.find_by!(name: params[:id])
  end

  def update
    @network ||= Prime::Network.find_by!(name: params[:id])
    if @network.update(name: network_params[:name])
      redirect_to prime_admin_root_path, notice: 'Network updated successfully.'
    else
      flash[:error] = @network.errors.full_messages.join(', ')
      render :edit
    end
  end

  def destroy
    @network = Prime::Network.find_by!(name: params[:id])
    if @network.destroy
      redirect_to prime_admin_root_path, notice: 'Network has been deleted!'
    else
      redirect_to :back, notice: 'Unable to delete the network.'
    end
  end

  private

  def network_params
    params.require(:prime_network).permit(:name)
  end
end
