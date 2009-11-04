module Admin::StoresHelper
  
   def options_for_status
    { :Disable => false, :Enable => true }
  end

  def options_for_product_selection_option
    { 'Radio Button' => true, 'Drop Down List' => false }
  end

end
