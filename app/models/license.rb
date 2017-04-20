class License < ApplicationRecord

  def getNowString
    return Time.now.strftime('%Y-%m-%d %H:%M:%S.%L')
  end

end
