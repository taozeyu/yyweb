class PostPraiseController < ApplicationController

  def create
    
    if curr_user.nil?
      render :text => 'error'
      return
    end
    
    post = Post.find_by_id(params[:id].to_i)
    if post.nil?
      render :text => 'error'
      return
    end
    
    pp = PostPraise.create(
      :user_id => curr_user.id,
      :post_id => post.id,
      :create_at => Time.now
    )
    render :text => pp.id.to_s
  end
  
  def destroy
    
    if curr_user.nil?
      render :text => 'error'
      return
    end
    
    record = PostPraise.find_by_id(params[:id].to_i)
    if record.nil?
      return render :text => 'error'
    elsif record.user_id != curr_user.id
      return render :text => 'error'
    end
    
    record.destroy
    render :text => 'ok'
  end
  
end
