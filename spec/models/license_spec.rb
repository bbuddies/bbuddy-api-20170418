require 'rails_helper'
# require 'flexmock/test_unit'

RSpec.describe License, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  it 'test now time' do
    # Time.stub!(:now).and_return(Time.mktime(1970,1,1))

    @time_now = Time.mktime(1970,1,1)
    allow(Time).to receive(:now).and_return(@time_now)

    t = License.new.getNowString

    expect(t).to eq('1970-01-01 00:00:00.000')

  end


end
