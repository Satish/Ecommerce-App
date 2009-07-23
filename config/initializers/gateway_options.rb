GATEWAYS = [
            { :name => "Bogus Gateway", :description => "Simple ActiveMerchant compliant gateway that always approves credit card purchases.  Use credit card number: 4111111111111111, card type: visa, and card code: 123." },
            { :name => "Paypal - Website Payments Pro", :description => "Active Merchant's Paypal Website Payments Pro (US) Gateway." },
            { :name => "Authorize.net", :description => "Active Merchant's Authorize.Net Gateway." }
           ]

GATEWAY_OPTIONS = {"Bogus Gateway" => [
                                       { :name => "login",     :description => "Your Authorize.Net API Login ID" },
                                       { :name => "password",  :description => "Your Authorize.Net Transaction Key." }
                                      ],
                   "Authorize.net" => [ 
                                       { :name => "login",     :description => "Your Authorize.Net API Login ID" },
                                       { :name => "password",  :description => "Your Authorize.Net Transaction Key." },
                                       { :name => "test",      :description => "If true, perform transactions against the test server. Otherwise, perform transactions against the production server." }
                                      ],
                   "Paypal - Website Payments Pro" => [
                                       { :name => "login",     :description => "Your Authorize.Net API Login ID" },
                                       { :name => "password",  :description => "Your Authorize.Net Transaction Key." }
                                      ]
                 }