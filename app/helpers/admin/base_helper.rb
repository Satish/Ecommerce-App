module Admin::BaseHelper

  def order_date(date)
    date.strftime("%d/%m/%Y")
  end

end
