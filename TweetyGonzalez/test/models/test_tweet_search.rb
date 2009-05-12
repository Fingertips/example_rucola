require File.expand_path('../../test_helper', __FILE__)

describe "TweetSearch" do
  before do
    @delegate = mock("Delegate")
    @tweet_search = TweetSearch.alloc.initWithDelegate(@delegate)
    @tweet_search.data = OSX::NSMutableData.data
    
    OSX::NSURLConnection.stubs(:connectionWithRequest_delegate)
  end
  
  it "should have assigned the delegate" do
    @tweet_search.delegate.should == @delegate
  end
  
  it "should start an HTTP request for the given query with itself as its delegate" do
    connection = mock("NSURLConnection")
    
    OSX::NSURLConnection.expects(:connectionWithRequest_delegate).with do |request, delegate|
      delegate == @tweet_search &&
        request.URL.absoluteString == TweetSearch::SEARCH_URL % 'rubyonosx'
    end.returns(connection)
    
    @tweet_search.search('rubyonosx')
    @tweet_search.connection.should == connection
  end
  
  it "should instantiate a new NSMutableData object to hold any received data" do
    data_before = @tweet_search.data = OSX::NSMutableData.data
    @tweet_search.search('rubyonosx')
    
    @tweet_search.data.should.be.kind_of OSX::NSMutableData
    @tweet_search.data.should.not.be data_before
  end
  
  it "should concatenate received data to @data" do
    parts = [
      "lrz: Hah, Tweety Gonzaléz-rolled ",
      "Ninh while he was preparing to Patrick Hernandez-roll me! ",
      "He’s so last week… ;-)"
    ]
    
    parts.each do |part|
      data = part.to_ns.dataUsingEncoding(OSX::NSUTF8StringEncoding)
      @tweet_search.connection_didReceiveData(nil, data)
    end
    
    result = OSX::NSString.alloc.initWithData_encoding(@tweet_search.data, OSX::NSUTF8StringEncoding)
    result.should == parts.join
  end
  
  it "should send an array of result Tweet instances to its delegate once all data has been received" do
    tweets = Hash.from_xml(File.read(fixture("tweety_sings.xml")))["feed"]["entry"].map do |attributes|
      Tweet.alloc.initWithHash(attributes)
    end
    
    @delegate.expects(:tweetDidFinishSearch).with(tweets)
    
    @tweet_search.data = OSX::NSData.dataWithContentsOfFile(fixture("tweety_sings.xml"))
    @tweet_search.connectionDidFinishLoading(nil)
  end
  
  it "should send an empty array to the delegate if no tweet were found" do
    @tweet_search.data = OSX::NSData.dataWithContentsOfFile(fixture("no_tweets.xml"))
    @delegate.expects(:tweetDidFinishSearch).with([])
    @tweet_search.connectionDidFinishLoading(nil)
  end
end