require 'rails_helper'

RSpec.describe LicensesController, type: :controller do
  it 'add license' do
    license = {month: '2017-05', amount: 100}

    post :create, license: license, format: :json

    actual = License.all.first
    expect(actual.month).to eq('2017-05')


      # license = License.new
      # license.month = "2017.04"
      # license.amount = 500
      # license.add

      # result = License.first
      # expect(result.month).to eq "2017.04"
      # expect(result.amount).to eq 500

      #User.create!(email: 'joseph.yao.ruozhou@gmail.com', password: '123456', password_confirmation: '123456')

    #string_changer = StringChanger.new

    #reversed_string = string_changer.reverse_and_save('example string')

    #expect(reversed_string).to eq 'gnirts elpmaxe'
  end
end
