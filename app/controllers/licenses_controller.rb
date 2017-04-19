class LicensesController < ApplicationController
  before_action :set_account, only: [:show, :update, :destroy]

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
    @license = License.new
    start_date = @license.get_date(license_params[:start_date])
    end_date = @license.get_date(license_params[:end_date])
    if start_date.nil? or end_date.nil?
      render json: {code: 400, message: "invalid date"}, status: :bad_request
      return
    end
    @licenses = License.where("month >= ? AND month <= ?", start_date[:date].strftime("%Y-%m"), end_date[:date].strftime("%Y-%m"))
    total_fee = @license.fee(@licenses, start_date, end_date)
    render json: {fee: format("%.2f",total_fee).to_f}, status: :created
  end
end