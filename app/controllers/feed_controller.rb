class FeedController < ApplicationController
  def index

  end

  def pull
    redirect_to :controller => 'sessions', :action => 'connect' if !session[:access_token] 

    client = Instagram.client(:access_token => session[:access_token])
    @user = client.user
    @recent_media_items = client.user_recent_media({count:30, max_id:19999999999999999999})
    page_2_max_id = @recent_media_items[@recent_media_items.length-1].id

    shouldStop = @recent_media_items.length < 30
    while (!shouldStop && @recent_media_items.length <= 60)
    	recent_media_items2 = client.user_recent_media({count:30, max_id:page_2_max_id})
		@recent_media_items = (@recent_media_items + recent_media_items2)
		page_2_max_id = recent_media_items2[recent_media_items2.length-1].id
		
		shouldStop = recent_media_items2.length < 30
		Rails.logger.debug(page_2_max_id)
	end	
  end
end
