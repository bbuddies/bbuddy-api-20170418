require 'rails_helper'

RSpec.describe LicensesController, type: :controller do

  it "should create licenses" do
    license = {
        month: "2017-01", amount: 500
    }
    post :create, license: license, format: :json

    actual = License.all.first
    expect(actual.month).to eq(license[:month])
    expect(actual.amount).to eq(license[:amount])

  end

end
