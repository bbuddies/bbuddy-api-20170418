class AddMonthAndAmountToLicense < ActiveRecord::Migration[5.0]
  def change
    add_column :licenses, :month, :string
    add_column :licenses, :amount, :integer
  end
end
