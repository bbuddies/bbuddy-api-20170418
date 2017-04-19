class LicensesController < ApplicationController
    def create
        @license = License.where(:month => license_params[:month]).first_or_create
        @license.amount = license_params[:amount]
        @license.save
        render :json => {:status => 'ok', :message => nil, :data => nil}
    end

    def index
        @licenses = License.all
        render :json => {:status => 'ok', :message => nil,  :data => @licenses}
    end

    def license_params
        params.require("license").permit(:month, :amount)
    end
end
