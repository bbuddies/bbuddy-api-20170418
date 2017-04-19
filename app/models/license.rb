class License < ApplicationRecord
    validates :amount, numericality: true
end
