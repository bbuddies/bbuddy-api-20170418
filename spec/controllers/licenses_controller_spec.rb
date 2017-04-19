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

  it "should get licenses" do
    license = {
        month: "2017-01", amount: 500
    }
    post :create, license: license, format: :json

    actual = License.all.first
    expect(actual.month).to eq(license[:month])
    expect(actual.amount).to eq(license[:amount])

    get :index
    data = JSON.parse(response.body)
    expect(data[0]["month"]).to eq(license[:month])
    expect(data[0]["amount"]).to eq(license[:amount])

  end

  it "should get fee" do
    add_license({month: "2017-01", amount: 500})
    add_license({month: "2017-03", amount: 310})

    get :get_fee, start_date:"2017-01-01", end_date:"2017-03-20"
    data = JSON.parse(response.body)
    expect(data["fee"]).to eq(700)

  end

  def add_license(data)
    post :create, license: data, format: :json
  end

end
