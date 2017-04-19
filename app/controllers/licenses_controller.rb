class LicensesController < ApplicationController
  before_action :set_account, only: [:show, :update, :destroy]

  # POST /accounts
  def create
    license_params = params.require(:license).permit(:month, :amount)

    if (license_params["amount"].to_i <= 0)
      render json: nil, status: :bad_request
      return
    end

    @license = License.find_by month: license_params["mounth"]
    if @license.nil?
      @license = License.new(license_params)
      if @license.save
        render json: @license, status: :created, location: @license
      else
        render json: errors(@license.errors), status: :unprocessable_entity
      end
    else
      if @license.update(license_params)
        render json: @license
      else
        render json: errors(@license.errors), status: :unprocessable_entity
      end
    end
  end
end