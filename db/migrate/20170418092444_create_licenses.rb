class CreateLicenses < ActiveRecord::Migration[5.0]
  def change
    create_table :licenses do |t|
      t.string :month
      t.integer :amount

      t.timestamps
    end
  end
end
