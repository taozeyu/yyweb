class ParagraphController < ApplicationController

  def show
    find_paragraph
    @self_text_id = find_self_text_id(@paragraph.translated_texts)
    @can_post = can_post?
    @ban = ban?
  
    render :layout => false
  end
  
  def single
    find_paragraph
    @p = @paragraph
    render 'paragraph/_single-show', :layout => false
  end
  
  private
  
  def find_paragraph
    @paragraph = Paragraph.find_by_id(params[:id].to_i)
    raise ActionController::RoutingError.new('Paragraph Not Found') unless @paragraph
  end
  
  def find_self_text_id(texts)
    return -1 if curr_user.nil?
    texts.each do |t|
      return t.id if t.author.id==curr_user.id
    end
    return -1
  end
  
end
