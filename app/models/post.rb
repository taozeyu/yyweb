#!/bin/env ruby
# encoding: utf-8

class Post < ActiveRecord::Base

  TopicType = 1
  TranslationType =2
  
  NormalState = 1
  DeleteState = 2
  
  ColumnsExceptContent = Post.column_names - ["content"]
  
  has_many :paragraphs, :order => 'paragraphs.idx'
  has_many :comments, :order => 'comments.create_at'
  
  belongs_to :author, :foreign_key => :author_id, :class_name => "User"
  belongs_to :node, :foreign_key => :node_id, :class_name => "Node"
  belongs_to :last_reply_user, :foreign_key => :last_reply_user_id, :class_name => "User"
  
  validates :title, :presence => true,
                   :length => {:minimum => 1, :maximum => 120}
  validates :content, :length => {:minimum => 0, :maximum => 2000}
  
  # 用 include 语句将所有paragraphs的translated_texts一次性载入。
  # 但是这样 rails 就不做缓存了，对于热贴的效率可能还不如用N条Selete语句载入快。（因为Rails会缓存。）
  def load_paragraphs
    ps = self.paragraphs
    text_ids = []
    ps.each do |p|
      text_ids << p.translated_text_id
    end
    TranslatedText.where("translated_texts.id in (#{text_ids.join(",")})").all.each do |tt|
      for i in 0..(self.paragraphs.length)
        break if self.paragraphs[i].translated_text_id == tt.id
      end
      self.paragraphs[i].choosed_text = tt
    end
    return ps
  end
  
  def can_reply?
    return true
  end
                   
  def can_delete_by? (user)
    self.node.can_manager_by?(user)
  end
  
  def can_edit_by? (user)
    if self.node.can_manager_by?(user)
      return true
    elsif (not user.nil?) and user.id == self.author.id
      return true
    else
      return false
    end
  end
  
  def has_delete?
    return false
  end
  
  def attention_id_by(user)
    return nil if user.nil?
    pa = PostAttention.where(:user_id => user.id, :post_id => self.id).first
    if pa.nil?
      return nil
    else
      return pa.id
    end
  end
  
  def praise_id_by(user)
    return nil if user.nil?
    pp = PostPraise.where(:user_id => user.id, :post_id => self.id).first
    if pp.nil?
      return nil
    else
      return pp.id
    end
  end
  
end
