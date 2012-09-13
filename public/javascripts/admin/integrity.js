$(document).ready(function(){
	
	// Accordion menu active link CSS, default automatic highlighting first.
	var full_path = location.pathname;
	var href = location.href;
	controller = full_path.match(/admin\/\w+/g);
	path = full_path.replace(/\/$/, "");
		
	// Inner links default highliting method
  // $("a[href='" + href + "']").addClass("current");
	// alert(href);

	// All menu headers have hardcoded highlighting
	// Selecting a menu name
	var path_text = path;
	var menu_name = null;
	
	if (path_text.match(/admin\/users/)) {
		$("#users-top").addClass("current");		
	}
	else if (path_text.match(/admin\/reports|admin\/measuring|admin\/system|admin\/listing_types|admin\/settings/)) {
		menu_name = 'System Settings';
	}
	else if (path_text.match(/admin\/product/)) {
		$("#products-top").addClass("current");		
	}	
	else if (path_text.match(/admin\/listings/)) {
		menu_name = 'Listings'
	}
	else if (path_text.match(/admin\/article/)) {
		menu_name = 'Articles'
	}	
	else if (path_text.match(/admin\/messages/)){
		$("#messages-top").addClass("current");		
	}
	else {
		menu_name = 'Dashboard';
	}
	
	$(".nav-top-item").each (
		function () {
			if (this.innerHTML.match(menu_name)) {
				this.className="nav-top-item current";
			}
		}
	);
	
	// Inner links highlighted according to controller names
	$("#main-nav a:not(.nav-top-item)").each (
		function () {
			// Gotcha highliting for listing categories
			if (controller == 'admin/listings'){
				if (this.href == href) {
					this.className="current";					
				}				
			}
			// Gotcha highliting for messages.
			else if (controller == 'admin/messages'){
				if (this.href == href) {
					this.className="current"
				}
			}
			// All gotchas above could be combined.
			// Anyway, else
			else {
				if (this.href.match(controller)) {
					if (this.href.match(/[^#]$/)) {
						this.className="current";					
					}					
				}
			}			
		}		
	);
	
	// Sortable table with zebra styles
	$(".sortable_table").tablesorter({sortList:[[0,0],[1,2]], widgets: ['zebra']});
	
	// Simple CSS for will_paginate
	$(".pagination span").addClass("number");
	$(".pagination a").addClass("number");
	var current_page = path.match(/page=(\n)$/);
	$(".pagination a[href$='" + current_page + "']").addClass("current");
	
	
	// Validated form
	$("#validatedForm").validationEngine({
		success :  false,
		failure : function() {}
	})

});

// Remove keyword
$(function(){
  $("a.keyword_remove_link").live("click", function(){
		$(this).parent().remove();
  })
})

// Existing Remove keyword
$(function(){
  $("a.existing_keyword_remove_link").live("click", function(){
		$(this).parent().find(".should_destroy").val("1");
		$(this).parent().hide();
  })
})

// Add keyword
$(function(){
  $("#add_keyword_link").click(function(){
		$("#keywords").append("<p><input class='validate[custom[onlyLetter]] text-input small-input' id='product_keyword_attributes__name' name='product[keyword_attributes][][name]' size='30' type='text' /> <a href='#' class='keyword_remove_link'>remove</a></p>")
  })
})

// Listing form product category -> products
$(function(){
  $("select#product_category_id").change(function(){
    $.getJSON("/json/get_products_for_product_category",{id: $(this).val(), ajax: 'true'}, function(j){
      var options = '<option value="">All</option>';
      for (var i = 0; i < j.length; i++) {
        options += '<option value="' + j[i].id + '">' + j[i].name + '</option>';
      }
      $("select#product_id").html(options);
    })
  })
})

