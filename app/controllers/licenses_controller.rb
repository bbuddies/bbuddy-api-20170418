class LicensesController < ApplicationController
  # before_action :set_account, only: [:show, :update, :destroy]
  # before_action :authenticate_user!

  # POST /licenses
  def create
    # p license_params.month
    License.create(license_params)
    # @license = License.new()

    # if @license.save
    #   render json: @license, status: :created, location: @license
    # end
  end


  private
    # Only allow a trusted parameter "white list" through.
    def license_params
      params.require(:license).permit(:month, :amount)
    end

end
