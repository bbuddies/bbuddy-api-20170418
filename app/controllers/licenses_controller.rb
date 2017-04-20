class LicensesController < ApplicationController
  before_action :set_account, only: [:show, :update, :destroy]

  def initialize
    @licenses_service = LicensesService.new
  end
  # POST /accounts
  def create
    license_params = params.require(:license).permit(:month, :amount)
    if (license_params[:amount].to_i <= 0)
      render json: {code: 400, message: "amount must > 0"}, status: :bad_request
      return
    end
    if (/^\d{4}-\d{2}$/=~license_params[:month]).nil?
      render json: {code: 400, message: "invalid date"}, status: :bad_request
      return
    end
    begin
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

  def index
    @license = License.all

    render json: @license
  end

  def get_fee
    license_params = params.permit(:start_date, :end_date)
    render @licenses_service.get_fee(license_params)
  end
end