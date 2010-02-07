module GoogleReader

  # the main api
  class Api
    
    
    require "api_helper"
    require "json"
    
    include GoogleReader::ApiHelper
    
    attr_accessor :email,:password
    
    def initialize(email,password)
      @email, @password = email, password
    end
    
    # get the number of unread items for a feed_url
    # feed_url can be a regular string (it will try to match it)
    # better will be to use the feed url, since this will match only one
    # this will only return the first one found. 
    def unread_count(feed_url=nil)
      # this url appears to be used by google to give the total count
      feed_url = "/state/com.google/reading-list" if ! feed_url
      
      feed = fetch_unread['unreadcounts'].find {|e| e['id'] =~ Regexp.new(feed_url)}
      feed ? feed['count'] : 0
    end

    # this will return the user info as a hash
    # example:
    # "userId":"01723985652832499840",
    # "userName":"username",
    # "userProfileId":"123456789123456789123",
    # "userEmail":"username@gmail.com",
    # "isBloggerUser":true,
    # "signupTimeSec":1234515320
    def user_info
      @user_info ||= fetch_user_info
    end
    
    # will return the an array of all the subscriptions
    # which are for now just hashes
    def subscriptions
      get_link "api/0/subscription/list" , :output => :json
    end
    
    private
    
    # will return the json object for the unread_request
    def fetch_unread
      get_link "api/0/unread-count" , :allcomments => true,:output => :json
    end
    
    def fetch_user_info
      get_link "api/0/user-info" , :output => :json
    end
    
   
    
  end

end