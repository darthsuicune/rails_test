module ApplicationHelper
  
  #Define the full title of the web page, appending an extra part when needed
  def full_title(page_title)
    base_title = "Test Page"
    if(page_title.empty?)
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
  
end
