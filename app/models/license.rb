class License < ApplicationRecord
  def fee(licenses, start_date, end_date)
    total_fee = 0.0
    for result in licenses
      # same month
      if start_date[:date].strftime("%Y-%m") == end_date[:date].strftime("%Y-%m")
        last_date = start_date[:last_day].to_f
        total_fee = result.amount * (end_date[:day].to_f - start_date[:day].to_f + 1.0)/last_date
      else
        if start_date[:date].strftime("%Y-%m") == result.month
          last_date = start_date[:last_day].to_f
          total_fee = total_fee + (result.amount * ((last_date - start_date[:day].to_f + 1.0)/last_date))
        elsif end_date[:date].strftime("%Y-%m") == result.month
          last_date = end_date[:last_day].to_f
          total_fee = total_fee + (result.amount * (end_date[:day].to_f / last_date))
        else
          total_fee = total_fee + result.amount
        end
      end
    end
    total_fee
  end

  def get_date(date_string)
    if not (/^\d{4}-\d{2}-\d{2}$/=~date_string).nil?
      date = Date.strptime(date_string, '%Y-%m-%d')
      {
          year: date.strftime("%Y"),
          month: date.strftime("%m"),
          day: date.strftime("%d"),
          date: date,
          last_day:Date.civil(date.strftime("%Y").to_i,
                              date.strftime("%m").to_i,
                              -1).strftime("%d")
      }
    else
      nil
    end
  end
end
