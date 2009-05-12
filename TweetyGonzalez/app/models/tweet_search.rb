class TweetSearch < OSX::NSObject
  SEARCH_URL = 'http://search.twitter.com/search.atom?q=%s'
  
  attr_accessor :delegate, :connection, :data
  
  def initWithDelegate(delegate)
    if init
      @delegate = delegate
      self
    end
  end
  
  def search(query)
    log.debug "Start search for `#{query}'"
    url = OSX::NSURL.URLWithString(SEARCH_URL % query)
    request = OSX::NSURLRequest.requestWithURL(url)
    @connection = OSX::NSURLConnection.connectionWithRequest_delegate(request, self)
    @data = OSX::NSMutableData.data
  end
  
  def connection_didReceiveData(connection, data)
    log.debug "Did receive tweet data."
    @data.appendData(data)
  end
  
  def connectionDidFinishLoading(connection)
    xml = OSX::NSString.alloc.initWithData_encoding(@data, OSX::NSUTF8StringEncoding).to_s
    tweets = Hash.from_xml(xml)['feed']['entry'].map { |attributes| Tweet.alloc.initWithHash(attributes) }
    log.debug "Finished search, found #{tweets.length} tweets."
    @delegate.tweetDidFinishSearch(tweets)
  end
end