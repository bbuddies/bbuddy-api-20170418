class LicensesController < ApplicationController
  before_action :set_account, only: [:show, :update, :destroy]

  # POST /accounts
  def create
    license_params = params.require(:license).permit(:month, :amount)
    begin
      if (license_params[:amount].to_i <= 0)
        raise "amount must > 0"
      end
      if (/^\d{4}-\d{2}$/=~license_params[:month]).nil?
        raise "invalid date"
      end
      Date.strptime(license_params[:month], '%Y-%m')
    rescue Exception => e
      render json: {code: 400, message: e.message}, status: :bad_request
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