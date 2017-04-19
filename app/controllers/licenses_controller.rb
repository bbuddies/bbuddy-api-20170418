require "domain_model/domain_license"

class LicensesController < ApplicationController
    def create
        result = DomainLicense.save(license_params)
        if result
            render :json => {:status => 'ok', :message => nil, :data => nil}
        else
            render json: errors(result), status: 400
        end
    end

    def index
        @licenses = License.all.order('month asc')
        render :json => {:status => 'ok', :message => nil,  :data => @licenses}
    end

    def license_price
        @total = DomainLicense.caculate_license_price(params)
        render :json => {:status => 'ok', :message => nil, :data => @total}
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
