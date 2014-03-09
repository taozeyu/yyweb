#!/bin/env ruby
# encoding: utf-8

require 'digest'

class User < ActiveRecord::Base
  
  has_many :post, :foreign_key => :author_id
  
  PasswordLengthMin = 6
  PasswordLengthMax = 15
  
  RexEmail = /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  
  Unchecked = 1 # 未验证邮箱(schedule)
  Checked = 2 # 验证了邮箱(schedule)
  CompletedInfo = 3 # 验证并完善了个人资料(schedule)
  
  Ban = 1 # 完全封禁的用户
  BanPublish = 2 # 禁言的用户（可以赞，可以投票，可以关注）
  Normal = 10 # 普通用户(group)
  Moderator = 11 # 版主(group)
  Manager = 12 # 管理员(group)
  SuperManager = 13 # 超级管理员(group)
  God = 14 # 神MOsky(group)
  
  UnknownSex = 0
  MaleSex = 1
  FemaleSex = 2
  
  validates :name, :presence => {:message => "不能为空"},
                   :length => {:minimum => 3, :maximum => 10, :message => "用户名字数必须为3～10个" },
                   :uniqueness => {:case_sensitive => false, :message => "用户名已注册"}
  validates :email, :presence => {:message => "不能为空"},
                    :length => {:minimum => 1, :maximum => 100, :message => "邮箱太长"},
                    :uniqueness => {:case_sensitive => false, :message => "邮箱已注册"},
                    :format => {:with => RexEmail, :message => "格式错误"}
  # TODO 其他东西以后再加
  
  def self.any? (name, email)
    where(:name => name, :email => email).any?
  end
  
  def icon_url
    file_name = self.icon
    if file_name.nil?
      return "/images/default-icon.jpg"
    else
      return "/images/user_icon/#{file_name}"
    end
  end
  
  def moderator?
    return self.group == Moderator
  end
  
  # has more power than moderator.
  def belongs_to_managers?
    return self.group >= Manager
  end
  
  def can_post?
    return self.group >= Normal;
  end
  
  def ban?
    return self.group == Ban
  end
  
  def password= (_value)
    self.salt = create_salt
    self.password_store = encrypt(_value, self.salt)
  end
  
  def password_equals? (checked_password)
    puts "input #{encrypt(checked_password, salt)} sotre #{password_store}"
    encrypt(checked_password, salt) == self.password_store
  end
  
  private 
  
  def create_salt
    rand(0xffffffff).to_s(16) #生成一个8位（16进制）随机数
  end
  
  def link_password_and_salt (password, salt)
    "#{password}-#{salt}"
  end
  
  def encrypt (password, salt)
    pas = link_password_and_salt( password, salt)
    Digest::SHA2.hexdigest(pas) #生成长度为64的字符串
  end
  
end
