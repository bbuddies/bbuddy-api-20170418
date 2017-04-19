require 'date'

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

    def self.caculate_license_price(params)
        total = 0

        start_date_time = DateTime.parse(params[:start_date])
        end_date_time = DateTime.parse(params[:end_date])

        start_year = start_date_time.strftime('%Y')
        start_month = start_date_time.strftime('%m')
        start_date = start_date_time.strftime('%d')
        end_year = end_date_time.strftime('%Y')
        end_month = end_date_time.strftime('%m')
        end_date = end_date_time.strftime('%d')

        @licenses = License.where(month: (start_date_time.strftime('%Y-%m') .. end_date_time.strftime('%Y-%m')))
        @licenses.each do |license|
            if (license.month == start_date_time.strftime('%Y-%m') && start_date_time.strftime('%Y-%m') == end_date_time.strftime('%Y-%m'))
                days_in_month = Date.new(start_year.to_i, start_month.to_i, -1).day
                total = total + license.amount * (end_date.to_i - start_date.to_i + 1) / days_in_month 
            elsif license.month == start_date_time.strftime('%Y-%m')
                days_in_month = Date.new(start_year.to_i, start_month.to_i, -1).day
                total = total + license.amount * (days_in_month - start_date.to_i + 1) / days_in_month
            elsif license.month == end_date_time.strftime('%Y-%m')
                days_in_month = Date.new(end_year.to_i, end_month.to_i, -1).day
                total = total + (license.amount * end_date.to_i / days_in_month)
            else
            total = total + license.amount
            end
        end

        return total
    end
end
