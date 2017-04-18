class LicensesController < ApplicationController
    def create
        License.create(params.require("license").permit(:month, :amount))
        render :json => {:status => 'ok', :message => nil}
    end
end
