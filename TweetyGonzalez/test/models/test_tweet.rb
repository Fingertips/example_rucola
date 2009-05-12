require File.expand_path('../../test_helper', __FILE__)

describe 'Tweet' do
  it "should perform an HTTP request for the given query" do
    REST.expects(:get).with('http://search.twitter.com/search.atom?q=rubyonosx').
      returns(REST::Response.new(200, {}, File.read(fixture("tweety_sings.xml"))))
    
    tweets = Tweet.search('rubyonosx')
  end
end