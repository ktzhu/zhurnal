require File.dirname(__FILE__) + 'spec/helper'

describe 'App' do
  it 'has a root path' do
    get "/"
    last_response.status.should == 200
  end
end
