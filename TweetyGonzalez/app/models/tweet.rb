class Tweet < OSX::NSObject
  SEARCH_URL = 'http://search.twitter.com/search.atom?q=%s'
  
  class << self
    attr_accessor :delegate, :connection, :data
    
    def search(query)
      url = OSX::NSURL.URLWithString(SEARCH_URL % query)
      request = OSX::NSURLRequest.requestWithURL(url)
      @connection = OSX::NSURLConnection.connectionWithRequest_delegate(request, self)
      @data = OSX::NSMutableData.data
    end
    
    def connection_didReceiveData(connection, data)
      @data.appendData(data)
    end
    
    def connectionDidFinishLoading(connection)
      xml = OSX::NSString.alloc.initWithData_encoding(Tweet.data, OSX::NSUTF8StringEncoding).to_s
      tweets = Hash.from_xml(xml)['feed']['entry'].map { |attributes| alloc.initWithHash(attributes) }
      @delegate.tweetDidFinishSearch(tweets)
    end
  end
  
  attr_reader :author, :title
  
  def initWithHash(attributes)
    if init
      @author = attributes['author']['name']
      @title = attributes['title']
      self
    end
  end
  
  def ==(other)
    other.is_a?(Tweet) and other.author == @author and other.title == @title
  end
  
  def inspect
    "#<Tweet author=#{@author} title=#{@title}>"
  end
end