// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
var Login={}

Login={

     loginWithOpenId:function()
      {
       $('user_name_login').hide()
       $('open_id_login').show()
       $('user_name_login_link').show()
       $('open_id_login_link').hide()
       
      },

     loginWithUserName:function()
      {
       $('user_name_login').show()
       $('open_id_login').hide()
       $('user_name_login_link').hide()
       $('open_id_login_link').show()
      }
    }

function showSpinner(id)
  {
    $(id).show()
  }
  
function hideSpinner(id)
  {
    $(id).hide()
  }


var PopupContainer = {
  initialize: function(container_id, options ) {
    
    
    default_options = { 
                autoOpen: false,
                bgiframe: true,
                width: 500,
                height: 200,
                modal: true,
                position: 'center',
                resizable: true,
                hide: 'slide',
//                buttons: {
//                  "Cancel": function(){
//                    $(this).dialog("close");
//                  }
//                },
                overlay:
                  {
                    background: '#000',
                    opacity: 0.5
                  }
                };
 
    $(container_id).dialog(jQuery.extend(default_options, options));
  },

  open: function(post_id, container_id) {
    $(container_id).dialog('open');
  },

  close: function(container_id) {
    $(container_id).dialog('close');
  }
};


var FlashMessage = {
  show: function(message) {
    $('#flash p').html(message);
    $('#flash').fadeIn(2000).fadeTo(6000, 1).fadeOut(2000);
  }
};

function onCheckCopyBillingToShipping(dom_element){
  ele = ['first_name', 'last_name', 'email', 'company', 'street1', 'street2', 'city', 'country', 'zipcode', 'phone', 'fax', 'state' ]
  if (dom_element.checked == true){
    for(i=0; i < ele.length; i++){
      $('#shipping_address_' + ele[i]).attr("value", $('#billing_address_' + ele[i]).attr("value"))
    }
  }
  else {
    
  }
}

function hide_card_info(dom_id) {
	if ($(dom_id).attr("value") == 'creditcard')
	$('#creditCardInfo').show()
	else
	$('#creditCardInfo').hide()
}

function toggle_disable_message(dom_element) {
  if ($('#store_status').attr('value') == 'false')
    $('#storeDisableMessage').show()
  else
  	$('#storeDisableMessage').hide()
}  


var Product
Product = {
 selectAll:function(dom_ele, name){
   coll = document.getElementsByName(name)
   for( i=0; i < coll.length; i = i+1){
       if (dom_ele.checked == true) {
         coll[i].checked = true;
       }
       else {
         coll[i].checked = false;
       }
     }
  }
}


function is_selected(dom_ids){
  for( i=0; i< dom_ids.length; i++ ){
    var attr_value = $(dom_ids[i]).attr('value')
    if ( attr_value == '') {
      alert('You must select required options to add product to your cart.');
      set_attribute_values(dom_ids)
      return false;
    }
  }
  set_attribute_values(dom_ids)
  return true;
}

function set_attribute_values(dom_ids){
  var attribute_values = []
  for(i=0; i< dom_ids.length; i++){
    var attr_value = $(dom_ids[i]).attr('value')
    if(attr_value != '')
    attribute_values[i] = attr_value
  }
  $('input#attribute_values').attr('value', attribute_values)
}

/*
document.observe("dom:loaded", function() {r
  // the element in which we will observe all clicks and capture
  // ones originating from pagination links
  var container = $(document.body)

  if (container) {
    var img = new Image
    img.src = '/images/spinner.gif'

    function createSpinner() {
      new Element('img', { src: img.src, 'class': 'spinner' })
    }

    container.observe('click', function(e) {
      var el = e.element()
      if (el.match('.pagination a')) {
        el.up('.pagination').insert(createSpinner())
        new Ajax.Request(el.href, { method: 'get' })
        e.stop()
      }
    })
  }
})
*/
