class TranslatedTextVote < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :translated_text, :counter_cache => :vote_count
  
end
