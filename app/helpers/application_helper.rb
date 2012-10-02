module ApplicationHelper

  def current_server
    return request.env["rmonitor.current_server"] unless request.env["rmonitor.current_server"].nil?
    false
  end

  # Fomat the given +text+ with the text formater selected in the settings
  def format_text(*args, &block)
    if block_given?
      options      = args.first || {}
      format_text(capture(&block), options)
    else
      text         = args[0]
      options      = args[1] || {}

      formated_text = text#.gsub(/\b(([\w-]+:\/\/?|www[.])[^\s()<>]+(?:\([\w\d]+\)|([^[:punct:]\s]|\/)))/i) { link_to($1, $1) }
      formated_text = method(Setting.text_formatting.to_sym).call(formated_text)
      ERB::Util.html_escape(formated_text).html_safe
    end
  end

  # Alias method of textilize
  def textile(text)
    textilize(text)
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    column = column.downcase
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    # link_to title, {:sort => column, :direction => direction}, {:class => css_class}
    link_to({:sort => column, :direction => direction}) do
      "#{title} ".html_safe + (sort_column == column ? content_tag("i", nil, :class => "icon-chevron-#{direction == "asc" ? "down" : "up"}") : '')
    end
  end
end
