SUMMARY
=======

Ecommerceapp is a open source ecommerce solution for Ruby on Rails.
It was developed by [satish](http://satishchauhan.com) at [vinsol](http://vinsol.com)

QUICK START
===========

Running from sources
---------------------------------------------------

1. Clone the git repo

        git clone git://github.com/Satish/test_ec.git

2. Create the necessary config/database.yml file

                defaults:      &defaults
                  adapter:     mysql
                  encoding:    utf8
                  username:    root
                  password :   root
                  host:        localhost

                development:
                  database:    ecommerceapp_development
                  <<:          *defaults

                test:
                  database:    ecommerceapp_test
                  <<:          *defaults

                production:
                  database:    ecommerceapp_production
                  <<:          *defaults
        
3. Bootstrap the database (run the migrations, create database)

        rake db:bootstrap

5. Start the server

        script/server

Browse Store
------------

http://localhost:xxxx/

Browse Admin Interface
----------------------

http://localhost:xxxx/admin