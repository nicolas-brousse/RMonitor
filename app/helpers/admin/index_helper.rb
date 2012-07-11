module Admin::IndexHelper

  def format_flash_class(type)
    {
      :success => "alert-success",
      :error   => "alert-error",
      :info    => "alert-info",
      :alert   => "",
      :notice  => "alert-info",
    }[type]
  end

end
