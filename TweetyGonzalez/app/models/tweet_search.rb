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
    @connection = OSX::NSURLConnection.connectionWithRequest_delegate(request(query), self)
    @data = OSX::NSMutableData.data
  end
  
  def connection_didReceiveData(connection, data)
    log.debug "Did receive tweet data."
    @data.appendData(data)
  end
  
  def connectionDidFinishLoading(connection)
    tweets = tweet_hashes.map { |attributes| Tweet.alloc.initWithHash(attributes) }
    log.debug "Finished search, found #{tweets.length} tweets."
    @delegate.tweetDidFinishSearch(tweets)
  end
  
  private
  
  def request(query)
    OSX::NSURLRequest.requestWithURL(OSX::NSURL.URLWithString(SEARCH_URL % query))
  end
  
  def tweet_hashes
    xml = OSX::NSString.alloc.initWithData_encoding(@data, OSX::NSUTF8StringEncoding).to_s
    [Hash.from_xml(xml)['feed']['entry'] || []].flatten
  end
end