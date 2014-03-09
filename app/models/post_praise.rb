class PostPraise < ActiveRecord::Base

  belongs_to :post, :counter_cache => :praises_count
  
end
