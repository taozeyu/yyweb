class NodeManager < ActiveRecord::Base

  belongs_to :node, :foreign_key => :node_id
  belongs_to :user, :foreign_key => :user_id
  
end
