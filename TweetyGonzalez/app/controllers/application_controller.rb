class ApplicationController < Rucola::RCController
  kvc_accessor :tweets
  
  ib_outlet :mainWindow, :searchField
  
  def awakeFromNib
    self.tweets = []
    @tweet_search = TweetSearch.alloc.initWithDelegate(self)
  end
  
  def search(sender)
    @tweet_search.search(@searchField.stringValue)
  end
  
  def tweetDidFinishSearch(tweets)
    self.tweets = tweets
  end
end