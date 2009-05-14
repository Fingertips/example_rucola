class ApplicationController < Rucola::RCController
  ApplicationController::ARIBA_PATH = Rucola::RCApp.path_for_asset('ariba.aif')
  
  kvc_accessor :tweets
  
  ib_outlet :mainWindow, :searchField
  
  def awakeFromNib
    self.tweets = []
    @tweet_search = TweetSearch.alloc.initWithDelegate(self)
    @found_tweets_sound = OSX::NSSound.alloc.initWithContentsOfFile_byReference(ARIBA_PATH, true)
  end
  
  def search(sender)
    @tweet_search.search(@searchField.stringValue)
  end
  
  def tweetDidFinishSearch(tweets)
    @found_tweets_sound.play unless tweets.empty?
    self.tweets = tweets
  end
end