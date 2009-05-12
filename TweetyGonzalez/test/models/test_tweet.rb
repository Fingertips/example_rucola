require File.expand_path('../../test_helper', __FILE__)

describe "A Tweet" do
  before do
    @attributes = {
      "author" => { "name" => "Tweety Gonzaléz" },
      "title" => "I own Patrick Hernandez!"
    }
    @tweet = Tweet.alloc.initWithHash(@attributes)
  end
  
  it "should initialize with a hash of attributes" do
    @tweet.author.should == "Tweety Gonzaléz"
    @tweet.title.should == "I own Patrick Hernandez!"
  end
  
  it "should be equal to another Tweet if the author and title match" do
    @tweet.should == Tweet.alloc.initWithHash(@attributes)
    @tweet.should.not == Tweet.alloc.initWithHash(@attributes.merge("title" => "Clearly a different tweet"))
  end
end