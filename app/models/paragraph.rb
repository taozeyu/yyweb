class Paragraph < ActiveRecord::Base
  
  TypeContent = 1 # can commit translated text.
  TypeTitle = 2
  TypeLine = 3
  
  belongs_to :post
  belongs_to :choosed_text, :foreign_key => :translated_text_id, :class_name => "TranslatedText"
  has_many :translated_texts, :order => 'vote_count desc, create_at'
  
  validates :source_text, :presence => true,
                          :length => {:minimum => 0, :maximum => 1000}
  
  # reorder all the translated texts belongs to it, then choose the top of them, and save to the column.
  def refresh_choosed
    self.choosed_text = self.translated_texts.first
    self.save
  end
  
end
