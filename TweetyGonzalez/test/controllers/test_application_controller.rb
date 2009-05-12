require File.expand_path('../../test_helper', __FILE__)

describe 'ApplicationController, when awoken from nib,' do
  tests ApplicationController
  
  before do
    # Setting searchField here doesn't currently work, because the outlet is
    # being set again from Rucola::TestCase::setup, which should happen
    ib_outlets :searchField => OSX::NSSearchField.alloc.init,
               :searchButton => OSX::NSButton.alloc.init
    
    searchButton.target = controller
    searchButton.action = "search:"
    
    controller.awakeFromNib
  end
  
  after do
    Tweet.delegate = nil
  end
  
  it "should have an empty KVC accessible #tweets array" do
    controller.valueForKey("tweets").should == [].to_ns
  end
  
  it "should have assigned itself as the Tweet delegate" do
    Tweet.delegate.should.be controller
  end
  
  it "should start a search, with the specified query, when the search button is pushed" do
    ib_outlet :searchField, OSX::NSSearchField.alloc.init
    searchField.stringValue = "Tweety Gonzaléz"
    
    Tweet.expects(:search).with("Tweety Gonzaléz")
    push_button(searchButton)
  end
  
  it "should _replace_ the contents of the existing @tweets array with the new ones" do
    tweets = [mock("Tweet 1"), mock("Tweet 2")]
    controller.tweets.expects(:removeAllObjects)
    controller.tweetDidFinishSearch(tweets)
    controller.tweets.should == tweets
  end
  
  private
  
  def push_button(button)
    button.target.send(button.action, button)
  end
end