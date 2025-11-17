class BlogsController < ApplicationController
  after_action :kakuninn, only:[:index]
  before_action :authenticate_user!, only: [:new, :create, :index]
   
  def index
      @tweets = Tweet.all
    if params[:tag]
      Tag.create(name: params[:tag])
    end
  @blogs = Blog.all
  if params[:tag_ids]
      @blogs = []
      params[:tag_ids].each do |key, value|      
        @blogs += Tag.find_by(name: key).blogs if value == "1"
      end
      @blogs.uniq!
    end
  end

  def new
    @blog = Blog.new
  end

  def show
    @blog = Blog.find(params[:id])
  end

  def create
    blog = Blog.new(blog_params)

    blog.user_id = current_user.id  #追記

    if blog.save!
      redirect_to action: "index"
    else
      redirect_to action: "new"
    end
  end

  def destroy
    @blog = Blog.find(params[:id])
    @blog.destroy
    redirect_to blogs_path, notice:"削除しました"
  end

  def edit
    @blog = Blog.find(params[:id])
  end

  def update
    @blog = Blog.find(params[:id])
    if @blog.update(blog_params)
      redirect_to blogs_path, notice: "編集しました"
    else
      render 'edit'
    end
  end
    
    def kakuninn
        user = current_user
        time = Time.now
        jtime = Time.at(time, in: "+09:00")
        user = current_user
        if user.last_tweeted_date.nil?
          user.update!(last_tweeted_date: Date.today)
        end
        user.update!(remind_date: Date.today)
    end

private

  def blog_params
    params.require(:blog).permit(:title, :content, :start_time, :image, tag_ids: [])
  end
end

