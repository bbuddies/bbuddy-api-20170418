class LicensesController < ApplicationController
    def create
        @license = License.where(:month => license_params[:month]).first_or_create
        @license.amount = license_params[:amount]
        if @license.save
            render :json => {:status => 'ok', :message => nil, :data => nil}
        else
            render json: errors(@license.errors), status: 400
        end
    end

    def index
        @licenses = License.all.order('month asc')
        render :json => {:status => 'ok', :message => nil,  :data => @licenses}
    end

    def license_params
        params.require("license").permit(:month, :amount)
    end

    def errors(validationErrors)
        errors = []
        validationErrors.each do |key, keyErrors|
            errors << "#{key} #{keyErrors}"
        end
        {:status => 'error', :message => errors, :data => nil}
    end
end
