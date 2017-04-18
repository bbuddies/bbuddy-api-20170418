require 'rails_helper'

RSpec.describe LicensesController, type: :controller do
    it "POST license into database" do
        license = {month: '2017-05', amount: 100}
        post :create, license: license, format: :json
        actual = License.all.first;
        expect(actual.month).to eq('2017-05')
        expect(actual.amount).to eq(100)
    end
end
