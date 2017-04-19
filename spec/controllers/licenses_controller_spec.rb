require 'rails_helper'

RSpec.describe LicensesController, type: :controller do

  it "should create license" do
    license = {
        month: "2017-01", amount: 500
    }
    post :create, license: license, format: :json

    actual = License.all.first
    expect(actual.month).to eq(license[:month])
    expect(actual.amount).to eq(license[:amount])
  end

  it "should update license when license exists" do
    license = {
        month: "2017-01", amount: 200
    }
    @license = License.new(license)
    @license.save

    license = {
        month: "2017-01", amount: 400
    }
    post :create, license: license, format: :json
    actual = License.all.first
    expect(actual.month).to eq(license[:month])
    expect(actual.amount).to eq(license[:amount])
  end

  it "should check amount > 0" do
    license = {
        month: "2018-09", amount: 0
    }

    post :create, license: license, format: :json

    actual = License.all.first
    expect(response.code).to eq("400")
    expect(actual).to eq(nil)
  end

  it "should check month format" do
    license = {
        month: "2018-100", amount: 0
    }

    post :create, license: license, format: :json

    actual = License.all.first
    expect(response.code).to eq("400")
    expect(actual).to eq(nil)
  end

end
