
class LicensesController < ApplicationController
  before_action :set_account, only: [:show, :update, :destroy]

  # POST /accounts
  def create
    p params
    license_params = params.require(:license).permit(:month, :amount)
    p license_params
    @license = License.new(license_params)

    if @license.save
      render json: @license, status: :created, location: @license
    else
      render json: errors(@license.errors), status: :unprocessable_entity
    end
  end
end