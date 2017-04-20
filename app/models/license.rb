class License < ApplicationRecord

  def getNowString
    return Time.now.strftime('%Y-%m-%d %H:%M:%S.%L')
  end

  def getItemsByMonth(startDate, endDate)
    License.where(month: (startDate - 1.month)..endDate)
  end

  def getTotalAmount(startDate, endDate)
    step = startDate
    total = 0
    licenses = getItemsByMonth(startDate, endDate)

    while step <= endDate
      days = Time.days_in_month(step.month, step.year)
      license = licenses.where(month: step.year.to_s + "-" + step.strftime('%m').to_s).first
      amountThisMonth = 0

      if !license.nil?
        amountThisMonth = license.amount
      end

      total = total + amountThisMonth / days

      step = step + 1.day
    end

    total

  end

end
