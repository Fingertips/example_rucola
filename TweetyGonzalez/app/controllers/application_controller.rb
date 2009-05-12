class ApplicationController < Rucola::RCController
  kvc_accessor :tweets
  
  ib_outlet :main_window, :searchField
  
  def awakeFromNib
    Tweet.delegate = self
    @tweets = [].to_ns
  end
  
  def search(sender)
    log.debug "Start search for `#{@searchField.stringValue}'"
    Tweet.search(@searchField.stringValue)
  end
  
  def tweetDidFinishSearch(tweets)
    @tweets.removeAllObjects
    @tweets.addObjectsFromArray(tweets)
  end
end