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

      formated_text = method(Setting.text_formatting.to_sym).call(text)
      ERB::Util.html_escape(formated_text).html_safe
    end
  end

  # Alias method of textilize
  def textile(text)
    textilize(text)
  end
end
