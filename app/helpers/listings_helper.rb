module ListingsHelper
  
  def listings_title(type)
    if @product
      "#{@product.name.pluralize} Listed #{type}"
    elsif @product_category  
      "#{@product_category.name.pluralize} Listed #{type}"      
    else
      "All Items Listed #{type.titleize}"
    end
  end
  
  
  def product_category_title_with_icon(sell, title, product_category_name, product_category_name_id = nil)
    
    if product_category_name == "Agricultural Products"
      title_class = "agricultural"
    elsif product_category_name == "Fish Products"
      title_class = "fish"
    else
      title_class = "handicraft"
    end
    
    if sell == true
      content_tag(:h4, "<span class='red'>#{product_category_name}</span> > #{link_to "show all", sell_path(:product_category => product_category_name_id)}", :class => title_class)      
    else
      content_tag(:h4, "<span class='red'>#{product_category_name}</span> > #{link_to "show all", buy_path(:product_category => product_category_name_id)}", :class => title_class)
    end
    
  end
  
end

