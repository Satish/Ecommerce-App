module Admin::GatewayOptionsHelper

  def get_gateway_option_value(gateway_option)
    gateway_option.gateway_option_value ? gateway_option.gateway_option_value.value : nil
  end

end
