class HomePagePost < ActiveRecord::Base

  def self.posts
    nodes = self.all
    home_page_ids = []
    nodes.each do |n|
      home_page_ids << n.post_id
    end
    Post.where(:id => home_page_ids, :is_delete => false).order('last_reply_at desc')
  end
  
end
