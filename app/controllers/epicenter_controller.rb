class EpicenterController < ApplicationController

	before_action :authenticate_user!


  helper :all
	 # include TweetsHelper
  #  include ApplicationHelper
  
  def feed
  	@following_tweets = []

    Tweet.all.each do |tweet|
      if current_user.following.include?(tweet.user_id) || current_user.id == tweet.user_id
        @following_tweets.push(tweet)
      end
    end
    @following_tweets.sort! { |x,y| y <=> x }
  end

  def show_user
  	@user = User.find(params[:id])
  end

  def now_following
  	current_user.following.push(params[:id].to_i)
  	current_user.save
    redirect_back(fallback_location: root_path)
    # redirect_to show_user_path(id: params[:id])
  end

  def unfollow
  	current_user.following.delete(params[:id].to_i)
  	current_user.save
    redirect_back(fallback_location: root_path)
  	# redirect_to show_user_path(id: params[:id]) 
  end


  def epi_tweet
    
    @tweet = Tweet.new

     #our parameters are received as an array of hashes, so we have to dig down into the layers #tweets_path to get our data. 
    @tweet.message = "#{params[:tweet][:message]}"
    @tweet.user_id = "#{params[:tweet][:user_id].to_i}"
 		@tweet.save
    #comes from the TweetsHelper
    @new_tweet = get_tagged(@tweet)


   	@tweet.update(message: @new_tweet.message)
    # @tweet = get_tagged(@tweet)
    redirect_to root_path


  end  




  def all_users
  	@users = User.all
  end	


  def tag_tweets
  	@tag = Tag.find(params[:id])
	end



  def following
    @user = User.find(params[:id])

    @users =[]

    User.all.each do |user|
      if @user.following.include?(user.id)
        @users.push(user)
      end
    end   

  end   


  def followers
    @user =  User.find(params[:id])
    @users = []

    User.all.each do |user|
      if user.following.include?(@user.id)
        @users.push(user)
      end
    end
    @total = @users.length
  end

end