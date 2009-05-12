class Tweet < OSX::NSObject
  kvc_accessor :author, :title
  
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