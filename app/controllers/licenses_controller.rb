class LicensesController < ApplicationController
    def create
        License.create(params.require("license").permit(:month, :amount))
        render :json => {:status => 'ok', :message => nil, :data => nil}
    end

    def index
        @licenses = License.all
        render :json => {:status => 'ok', :message => nil,  :data => @licenses}
    end
end
