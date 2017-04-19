class DomainLicense
    def self.save(license_params)
        @license = License.where(:month => license_params[:month]).first_or_create
        @license.amount = license_params[:amount]
        if @license.save
            return true
        else
            return @license.errors
        end
    end
end
