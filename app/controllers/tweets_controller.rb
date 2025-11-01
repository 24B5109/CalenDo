class TweetsController < ApplicationController
    def index
        @tweets = Tweet.all
    end

    def new
    @tweet = Tweet.new
    end

    def create
        tweet = Tweet.new(tweet_params)
        if tweet.save!
        redirect_to :action => "index"
        else
        redirect_to :action => "new"
        end
    end

  def edit
    @tweet = Tweet.find(params[:id])
  end

   def update
    tweet = Tweet.find(params[:id])
    if tweet.update(tweet_params)
      redirect_to :action => "index"
    else
      redirect_to :action => "new"
    end
  end

  def destroy
    tweet = Tweet.find(params[:id])
    tweet.destroy
    redirect_to action: :index
  end

  private
  def tweet_params
    params.require(:tweet).permit(:goal)
  end

end
