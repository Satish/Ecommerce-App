PAGE_NOT_FOUND_ERROR_MESSAGE = "Sorry, The page you were looking cannot be found..."
BAD_REQUEST_ERROR_MESSAGE = "Sorry, We are unable to process your request..."
FEEDS_DESCRIPTION_OPTIONS = ["Full", 'Short']
ORDER_BY_OPTIONS = {"Arrange by A-Z" => "name ASC", "Arrange by Z-A" => "name DESC", "Price (Low-High)" => "price ASC", "Price (High-Low)" => "price DESC" }
PER_PAGE_OPTIONS = [16, 40, 80, 120, 500]
STATE_FOR_STATE_SELECT = ['United States', 'India', 'Australia', 'Spain', 'Uganda', 'France', 'German', 'Canada', 'Scotland', 'Ireland', 'Wales', 'United Kingdom' ]
MAIL_AUTH = ['none', 'plain', 'login', 'cram_md5']
SECURE_CONNECTION_TYPES = ['None','SSL','TLS']
ACTIVE_INACTIVE_SELECT_OPTIONS = { "Active" => true, "Inactive" => false}
CARD_TYPES = {'Visa'=> 'visa', 'MasterCard'=> 'master', 'American Express'=> 'american_express', 'Discover'=> 'discover'}
PAYMENT_TYPES = ['creditcard']#, 'paypal', 'google checkout']
VALID_EXPIRY_YEARS = (Time.zone.now.year..Time.zone.now.year + 20).to_a
VALID_MONTHS = (1..12).to_a.collect{|n| [Date::MONTHNAMES[n], n] }
PER_PAGE = 20