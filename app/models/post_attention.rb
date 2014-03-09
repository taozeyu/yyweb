class PostAttention < ActiveRecord::Base

  belongs_to :post, :counter_cache => :attentions_count
  
end
