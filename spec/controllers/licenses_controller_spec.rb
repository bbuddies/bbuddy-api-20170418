require 'rails_helper'

RSpec.describe LicensesController, type: :controller do

  def addLicensesOfYear
    license = {month: '2017-01', amount: 31}
    post :create, license: license, format: :json
    license = {month: '2017-02', amount: 28}
    post :create, license: license, format: :json
    license = {month: '2017-03', amount: 0}
    post :create, license: license, format: :json
    license = {month: '2017-04', amount: 30}
    post :create, license: license, format: :json
    license = {month: '2017-05', amount: 31}
    post :create, license: license, format: :json
    license = {month: '2017-07', amount: 31}
    post :create, license: license, format: :json
    license = {month: '2017-08', amount: 31}
    post :create, license: license, format: :json
  end
  
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

  it 'search licenses from 02-10 to 02-14' do
    addLicensesOfYear()

    period = {start: '2017-02-10', end: '2017-02-14'}

    get :search, params: period, format: :json

    expect(response.body.to_i).to eq(5)
  end

  it 'search licenses from 04-14 to 05-31' do
    addLicensesOfYear()

    period = {start: '2017-04-14', end: '2017-05-31'}

    get :search, params: period, format: :json

    expect(response.body.to_i).to eq(48)
  end

  it 'search licenses from 02-16 to 04-30' do
    addLicensesOfYear()

    period = {start: '2017-02-16', end: '2017-04-30'}

    get :search, params: period, format: :json

    expect(response.body.to_i).to eq(43)
  end

  it 'search licenses from 04-30 to 02-15' do
    addLicensesOfYear()

    period = {start: '2017-04-30', end: '2017-02-15'}

    get :search, params: period, format: :json

    expect(response.body.to_i).to eq(-1)
  end
  
end
