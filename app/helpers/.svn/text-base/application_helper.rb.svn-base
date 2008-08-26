# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def user_comment_link(comment)
    if !comment.website.blank? && comment.website.to_s != "http://"
      link_to(comment.name, comment.website)
    else
      comment.name
    end
  end
  
  def print_formated(type,text)
    case type
    when "HTML"
      text
    when "Plain Text"
      h text
    when "HAML"
      Haml::Engine.new(text).render
    when "Syntaxy"
      Syntaxi.line_number_method = 'none'
      Syntaxi.new(text).process
    when "Textile"
      RedCloth.new(text).to_html
    end
  end
  
  
  # returns a yes/no image small size
  def boolean_to_image_small(bol)
    if bol 
      return image_tag("/images/yes_small.png", :class => "align-center")
    else
      return image_tag("/images/no_small.png", :class => "align-center")
    end
  end
  
  # returns a proper image bigger
  def boolean_to_image_big(bol)
    if bol 
      return image_tag("/images/yes.png", :class => "align-center")
    else
      return image_tag("/images/no.png", :class => "align-center")
    end
  end

  # returns a proper image 
  def boolean_to_word(bol)
    if bol 
      return "Yes"
    else
      return "No"
    end
  end
  
end
