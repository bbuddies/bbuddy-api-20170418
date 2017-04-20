class LicensesController < ApplicationController
  # before_action :set_account, only: [:show, :update, :destroy]
  # before_action :authenticate_user!

  # GET /license
  def index
    @licenses = License.all

    render json: @licenses
  end

  # GET /licenses/1
  def show
    @license = License.find(params[:id])
    render json: @license
  end

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


  # GET /search
  def search
    startDate = Date.parse(license_dates[:start])
    endDate = Date.parse(license_dates[:end])

    if startDate > endDate
      render json: -1, status: :bad_request, data: nil
      return
    end

    total = License.new.getTotalAmount(startDate, endDate)

    render json: total, status: :ok, data: nil
    
  end

  private
    # Only allow a trusted parameter "white list" through.
    def license_params
      params.require(:license).permit(:month, :amount)
    end

    def license_dates
      params.permit(:start, :end)
    end

end
