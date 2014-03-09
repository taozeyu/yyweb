#!/bin/env ruby
# encoding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

Node.create(
  :id => 1,
  :name => '站务管理',
  :path_name => 'website-management',
  :introduction => ''
)
Node.create(
  :id => 2,
  :name => '英语新闻',
  :path_name => 'english-news',
  :introduction => ''
)
Node.create(
  :id => 3,
  :name => '吹水冒泡',
  :path_name => 'free-chat',
  :introduction => ''
)
