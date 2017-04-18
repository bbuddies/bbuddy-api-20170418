class LicensesController < ApplicationController
    def create
        License.create(params.require("license").permit(:month, :amount))
    end
end
