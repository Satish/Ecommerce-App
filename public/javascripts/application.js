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
