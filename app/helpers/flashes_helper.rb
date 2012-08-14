module FlashesHelper
  def format_flashes types=[:alert, :notice, :info, :error]
    return nil unless types.kind_of?(Array)

    html = ""
    types.each do |t|
      html += format_flash(t) if flash[t]
    end
    return raw(html)
  end

  def format_flash type
    flash_content = link_to('&times;'.html_safe, "#", :class => "close", :data => {:dismiss => "alert"}) + t(flash[type])
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
