class LicensesController < ApplicationController
  before_action :set_account, only: [:show, :update, :destroy]

  # POST /accounts
  def create
    license_params = params.require(:license).permit(:month, :amount)
    if (license_params[:amount].to_i <= 0)
      render json: nil, status: :bad_request
      return
    end

    @license = License.where(:month => license_params[:month]).first_or_create
    @license.amount = license_params[:amount]
    if @license.save
      render json: @license, status: :created, location: @license
    else
      render json: errors(@license.errors), status: :unprocessable_entity
    end
  end
end