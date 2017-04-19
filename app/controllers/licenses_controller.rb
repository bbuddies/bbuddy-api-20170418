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

  def index
    @license = License.all

    render json: @license
  end

  def get_fee
    license_params = params.permit(:start_date, :end_date)
    begin
      if (/^\d{4}-\d{2}-\d{2}$/=~license_params[:start_date]).nil? or (/^\d{4}-\d{2}-\d{2}$/=~license_params[:end_date]).nil?
        raise "invalid date"
      end
      start_date = Date.strptime(license_params[:start_date], '%Y-%m-%d')
      end_date = Date.strptime(license_params[:end_date], '%Y-%m-%d')
      if start_date.to_time.to_i > end_date.to_time.to_i
        raise "invalid date"
      end
      query_array = []
      for i in start_date.to_time.strftime("%Y").to_i .. end_date.to_time.strftime("%Y").to_i
        if start_date.to_time.strftime("%Y").to_i == end_date.to_time.strftime("%Y").to_i
          for j in start_date.to_time.strftime("%m").to_i..end_date.to_time.strftime("%m").to_i
            query_array.push("%d-%02d"%[i,j])
          end
        else
          if i == start_date.to_time.strftime("%Y").to_i
            for j in start_date.to_time.strftime("%m").to_i..12
              query_array.push("%d-%02d"%[i,j])
            end
          elsif i == end_date.to_time.strftime("%Y").to_i
            for j in 1..end_date.to_time.strftime("%m").to_i
              query_array.push("%d-%02d"%[i,j])
            end

          else
            for j in 1..12
              query_array.push("%d-%02d"%[i,j])
            end
          end
        end

      end
      @license = License.where(:month => query_array)

      total_fee = 0.0
      for result in @license
        if start_date.to_time.strftime("%Y-%m").to_s == result.month
          last_date = Date.civil(start_date.to_time.strftime("%Y").to_i,
                                 start_date.to_time.strftime("%m").to_i, -1)
                          .strftime("%d").to_f
          total_fee += result.amount * (last_date - start_date.to_time.strftime("%d").to_f + 1.0)/last_date
        elsif end_date.to_time.strftime("%Y-%m").to_s == result.month
          last_date = Date.civil(end_date.to_time.strftime("%Y").to_i,
                                 end_date.to_time.strftime("%m").to_i, -1)
                          .strftime("%d").to_f
          total_fee += result.amount * end_date.to_time.strftime("%d").to_f / last_date
        else
          total_fee += result.amount
        end
      end
      
      render json: {fee: format("%.2f",total_fee).to_f}, status: :created


    rescue Exception => e
      render json: {code: 400, message: e.message}, status: :bad_request
      return
    end

  end
end