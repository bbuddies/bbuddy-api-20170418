require 'rails_helper'

RSpec.describe LicensesController, type: :controller do
  it 'add new license' do
    license = {month: '2017-05', amount: 100}

    post :create, license: license, format: :json

    actual = License.where(month: license[:month]).first
    expect(actual).to be_truthy
    expect(actual.month).to eq(license[:month])
    expect(actual.amount).to eq(100)

  end

  it 'add exist license depend on case 1' do
    license = {month: '2017-05', amount: 100}

    post :create, license: license, format: :json

    license[:amount] = 200

    post :create, license: license, format: :json

    actual = License.where(month: license[:month]).first
    
    expect(actual).to be_truthy
    expect(actual.month).to eq(license[:month])
    expect(actual.amount).to eq(200)
  end

  it 'add new license with amount <= 0' do
    license = {month: '2017-05', amount: 0}

    post :create, license: license, format: :json

    actual = License.where(month: license[:month]).first
    
    expect(actual).to be_nil
  end
  
end
