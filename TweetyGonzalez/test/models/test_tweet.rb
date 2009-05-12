require File.expand_path('../../test_helper', __FILE__)

describe "Tweet the class" do
  before do
    OSX::NSURLConnection.stubs(:connectionWithRequest_delegate)
  end
  
  it "should accept a delegate" do
    delegate = mock("Delegate")
    Tweet.delegate = delegate
    Tweet.delegate.should == delegate
  end
  
  it "should start an HTTP request for the given query with itself as its delegate" do
    connection = mock("NSURLConnection")
    
    OSX::NSURLConnection.expects(:connectionWithRequest_delegate).with do |request, delegate|
      delegate == Tweet &&
        request.URL.absoluteString == Tweet::SEARCH_URL % 'rubyonosx'
    end.returns(connection)
    
    Tweet.search('rubyonosx')
    Tweet.connection.should == connection
  end
  
  it "should instantiate a new NSMutableData object to hold any received data" do
    data_before = Tweet.data = OSX::NSMutableData.data
    Tweet.search('rubyonosx')
    
    Tweet.data.should.be.kind_of OSX::NSMutableData
    Tweet.data.should.not.be data_before
  end
  
  it "should concatenate received data to Tweet.data" do
    parts = [
      "lrz: Hah, Tweety Gonzaléz-rolled ",
      "Ninh while he was preparing to Patrick Hernandez-roll me! He’s so last week… ;-)"
    ]
    
    parts.each do |part|
      data = part.to_ns.dataUsingEncoding(OSX::NSUTF8StringEncoding)
      Tweet.connection_didReceiveData(nil, data)
    end
    
    result = OSX::NSString.alloc.initWithData_encoding(Tweet.data, OSX::NSUTF8StringEncoding)
    result.should == parts.join
  end
  
  it "should send an array of result Tweet instances to its delegate once all data has been received" do
    tweets = Hash.from_xml(File.read(fixture("tweety_sings.xml")))["feed"]["entry"].map do |attributes|
      Tweet.alloc.initWithHash(attributes)
    end
    
    delegate = mock("Delegate")
    delegate.expects(:tweetDidFinishSearch).with(tweets)
    Tweet.delegate = delegate
    
    Tweet.data = OSX::NSData.dataWithContentsOfFile(fixture("tweety_sings.xml"))
    Tweet.connectionDidFinishLoading(nil)
  end
end

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