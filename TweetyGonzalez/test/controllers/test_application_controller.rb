require File.expand_path('../../test_helper', __FILE__)

describe 'ApplicationController, when awoken from nib,' do
  tests ApplicationController
  
  before do
    # Setting searchField here doesn't currently work, because the outlet is
    # being set again from Rucola::TestCase::setup, which should happen
    ib_outlets :searchField => OSX::NSSearchField.alloc.init
    
    @tweets = [mock("Tweet 1"), mock("Tweet 2")]
    controller.awakeFromNib
  end
  
  it "should have an empty KVC accessible #tweets array" do
    controller.valueForKey("tweets").should == [].to_ns
  end
  
  it "should have a TweetSearch instance and assigned itself as the Tweet delegate" do
    assigns(:tweet_search).should.be.instance_of TweetSearch
    assigns(:tweet_search).delegate.should.be controller
  end
  
  it "should have instantiated an NSSound object with the `ariba' sample" do
    sound = OSX::NSSound.alloc.initWithContentsOfFile_byReference(ApplicationController::ARIBA_PATH, true)
    assigns(:found_tweets_sound).duration.should == sound.duration
  end
  
  it "should start a search with the query specified on the searchField" do
    ib_outlet :searchField, OSX::NSSearchField.alloc.init
    searchField.stringValue = "Tweety Gonzaléz"
    
    assigns(:tweet_search).expects(:search).with("Tweety Gonzaléz")
    controller.search(nil)
  end
  
  it "should replace the tweets in the @tweets array with the new ones" do
    assigns(:found_tweets_sound).stubs(:play)
    controller.tweetDidFinishSearch(@tweets)
    controller.valueForKey("tweets").should == @tweets
  end
  
  it "should play the `found_tweets_sound' when a search query finished and tweets were found" do
    assigns(:found_tweets_sound).expects(:play)
    controller.tweetDidFinishSearch(@tweets)
  end
  
  it "should not play the `found_tweets_sound' if no tweets were found" do
    assigns(:found_tweets_sound).expects(:play).never
    controller.tweetDidFinishSearch([])
  end
end