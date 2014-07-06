class PostController < ApplicationController

  def show
    @post = Post.find_by_id(params[:id].to_i)
    raise ActionController::RoutingError.new('Post Not Found') unless @post
    
    if @post.is_delete
      raise ActionController::RoutingError.new('Post Deleted')
    end
    @page_title = @post.title
    @author = @post.author
    @content = @post.content.split(/\n/)
    
    @attention_id = @post.attention_id_by(curr_user)
    @praise_id = @post.praise_id_by(curr_user)
    @can_reply = can_reply?(@post)
    
    @paragraphs = @post.paragraphs
    
    page = params[:page].to_i
    page = page == 0 ? 1 : page
    @comments = @post.comments.page(page).per_page(Comment::PerPage)
    @comment_page = page
  end
  
  def new
    @edit = false
    @node = Node.find_by_id(params[:node].to_i)
    @type = params[:type].to_i
    check_node_and_type(@node, @type)
    render :'post/editor'
  end
  
  def edit
    post = Post.find_by_id(params[:id].to_i)
    raise ActionController::RoutingError.new('Post Not Found') if post.nil?
    
    @title = post.title
    @content = post.content
    
    @node = post.node
    @edit = true
    @post_id = post.id
    @type = post.post_type
    check_node_and_type(@node, @type)
    render :'post/editor'
  end
  
  def create
    node = Node.find_by_id(params[:node].to_i)
    type = params[:type].to_i
    check_node_and_type(node, type)
    raise ActionController::RoutingError.new('Can Not Post.') unless node.can_post_by?(curr_user)
    
    if type == Post::TranslationType
      paragraphs = params[:paragraphs]
      if paragraphs.length == 0
        return render :text => "error"
      end
    end
    
    users = []
    content = handle_user_input(params[:content]) do |name, user|
      users << user
    end
    
    post = Post.new
    post.author = curr_user
    post.node = node
    post.create_at = Time.now
    post.update_at = Time.now
    post.post_type = type
    post.state = Post::NormalState
    post.is_elite = false
    post.title = params[:title]
    post.content = content
    post.last_reply_user = curr_user
    post.last_reply_at = Time.now
    
    if type == Post::TranslationType
      idx = 0
      paragraphs.each do |p|
        p = p.strip
        if /^>>>>>+[^><]*<<<<<+$/.match(p).nil?
          paragraph = Paragraph.new(:paragraph_type => Paragraph::TypeContent)
        else
          cut = /[^><]+/.match(p)
          p = (cut.nil?) ? "" : cut[0].strip
          if p.empty?
            paragraph = Paragraph.new(:paragraph_type => Paragraph::TypeLine)
            p = "#line"
          else
            paragraph = Paragraph.new(:paragraph_type => Paragraph::TypeTitle)
          end
        end
        paragraph.source_text = p
        paragraph.idx = idx
        post.paragraphs << paragraph
        idx += 1
      end
    end
    
    if not post.save
      return render :text => "error"
    end
    
    users.each do |user|
      NotificationMessage.notify(user, curr_user, post, NotificationMessage::TypePostAt)
    end
    
    PostAttention.create(
      :user_id => curr_user.id,
      :post_id => post.id,
      :create_at => Time.now,
      :last_watch_time => Time.now
    )
    
    render :text => post.id.to_s
  end
  
  def update
    post = Post.find_by_id(params[:id].to_i)
    if post.nil?
      render :text => "error"
      return
    end
    if not post.can_edit_by?(curr_user)
      render :text => "error"
      return
    end
    post.title = params[:title]
    post.content = params[:content]
    post.last_reply_user = curr_user
    post.last_reply_at Time.now
    post.save
    
    render :text => "ok"
  end
  
  def destroy
    post = Post.find_by_id(params[:id].to_i)
    if post.nil?
      render :text => "error"
      return
    end
    
    if not post.can_delete_by?(curr_user)
      render :text => "error"
      return
    end
    
    post.is_delete = true
    post.save
    
    render :text => "ok"
  end
  
  def set_top
    post = Post.find_by_id(params[:id].to_i)
    
    if post.nil?
      render :text => "error"
      return
    end
    
    if not post.can_top_by?(curr_user)
      render :text => "error"
      return
    end
    
    post.set_top = true    
    post.save
    render :text => "ok"
    
  end
  
  def cancel_top
    post = Post.find_by_id(params[:id].to_i)
    
    if post.nil?
      render :text => "error"
      return
    end
    
    if not post.can_top_by?(curr_user)
      render :text => "error"
      return
    end
    
    post.set_top = false
    post.save
    render :text => "ok"
    
  end
  
  def set_sticky
    post = Post.find_by_id(params[:id].to_i)
    
    if post.nil?
      render :text => "error"
      return
    end
    
    if not post.can_sticky_by?(curr_user)
      render :text => "error"
      return
    end
    
    post.set_sticky = true
    post.save
    render :text => "ok"
    
  end
  
  def cancel_sticky
    post = Post.find_by_id(params[:id].to_i)
    
    if post.nil?
      render :text => "error"
      return
    end
    
    if not post.can_sticky_by?(curr_user)
      render :text => "error"
      return
    end
    
    post.set_sticky = false
    post.save
    render :text => "ok"
    
  end
  
  private 
  
  def check_node_and_type(node, type)
    if node.nil?
      raise ActionController::RoutingError.new('Node Not Found')
    elsif type != Post::TopicType and type != Post::TranslationType
      raise ActionController::RoutingError.new('Error Type')
    end
  end
  
end
