module FlashesHelper
  def format_flashes(types=[:alert, :notice, :info, :error])
    return nil unless types.kind_of?(Array)

    html_flashes = ""
    types.each do |t|
      html_flashes += format_flash(t) if flash[t]
    end
    return html_flashes.html_safe
  end

  def format_flash(type)
    flash_content  = link_to('&times;'.html_safe, "#", :class => "close", :data => {:dismiss => "alert"})
    flash_content += t(flash[type])
    content = content_tag(:div, flash_content, :class => "alert alert-block #{format_flash_class(type)} fade in", :data => {:alert => :alert})
    ERB::Util.html_escape(content).html_safe
  end

  def format_flash_class(type)
    {
      :error   => "alert-error",
      :info    => "alert-info",
      :alert   => "",
      :notice  => "alert-success",
    }[type]
  end
end
