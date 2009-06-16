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
