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