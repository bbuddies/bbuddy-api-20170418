require 'rails_helper'

RSpec.describe LicensesController, type: :controller do
    it "POST license into database" do
        license = {month: '2017-05', amount: 100}
        post :create, license: license, format: :json
        actual = License.all.first;
        expect(actual.month).to eq('2017-05')
        expect(actual.amount).to eq(100)
    end

    it "assign @license" do
        license = {month: '2017-01', amount: 400}
        post :create, license: license, format: :json
        license = {month: '2017-02', amount: 500}
        post :create, license: license, format: :json

        licenses = License.all.order('month asc')
        get :index

        expect(assigns(:licenses)).to eq(licenses)
    end

    it "UPDATE license into database" do 
        license = {month: '2017-05', amount: 100}
        post :create, license: license, format: :json
        license = {month: '2017-05', amount: 200}
        post :create, license: license, format: :json

        licenses = License.all
        expect(licenses.count).to eq(1)
        expect(licenses.first.amount).to eq(200)
    end
end
