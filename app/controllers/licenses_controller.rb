class LicensesController < ApplicationController
  # before_action :set_account, only: [:show, :update, :destroy]
  # before_action :authenticate_user!

  # POST /licenses
  def create
    license = License.where(month: license_params[:month]).first

    if license_params[:amount].to_i <= 0
      render json: nil, status: :bad_request, data: nil
      return
    end
    
    if license.nil?
      license = License.create(license_params)
    else
      license.amount = license_params[:amount]
    end
    

    if license.save
      render json: license, status: :created, data: license
    end

    
  end

  private
    # Only allow a trusted parameter "white list" through.
    def license_params
      params.require(:license).permit(:month, :amount)
    end

end
