require 'rails_helper'

RSpec.describe LicensesController, type: :controller do

  it "should create licenses" do
    post :create, licenses: { month: "2017-01", amount: 500 }

  end

end
