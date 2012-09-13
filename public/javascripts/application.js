$(document).ready(function(){		
	// Validated form
	$("#validatedForm").validationEngine({
		success :  false,
		failure : function() {}
	})
});

// Listing form product category -> products
$(function(){
  $("select#product_category_id").change(function(){
    $.getJSON("/json/get_products_for_product_category",{id: $(this).val(), ajax: 'true'}, function(j){
      var options = '';
      for (var i = 0; i < j.length; i++) {
        options += '<option value="' + j[i].id + '">' + j[i].name + '</option>';
      }
      $("select#listing_product_id").html(options);
    })
  })
})

// Listing form atoll -> islands
$(function(){	
  $("select#atoll_id").change(function(){
    $.getJSON("/json/get_islands_for_atoll",{id: $(this).val(), ajax: 'true'}, function(j){
      var options = '';
      for (var i = 0; i < j.length; i++) {
        options += '<option value="' + j[i].id + '">' + j[i].name + '</option>';
      }
      $("select#user_island_id").html(options);
    })
  })
})

// Measuring system tag
$(function(){
  $("select#listing_measuring_system_id").change(function(){
  	$("#measuring_system_tag").html($("select#listing_measuring_system_id option:selected").text());
  })
})