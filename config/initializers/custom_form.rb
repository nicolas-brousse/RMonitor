# Custom validation Initializer

# Uncomment the following block if you want each input field to have the validation messages attached.
# ActionView::Base.field_error_proc = Proc.new do |html_tag, instance_tag|
#   if html_tag =~ /<(input|textarea|select)[^>]+class=/
#     class_attribute = html_tag =~ /class=['"]/
#     html_tag.insert(class_attribute + 7, "error ")
#   elsif html_tag =~ /<(input|textarea|select)/
#     first_whitespace = html_tag =~ /\s/
#     html_tag[first_whitespace] = " class=\"error\" "
#   end

#   if html_tag =~ /^<label/
#     "#{html_tag}".html_safe
#   else
#     "#{html_tag}\n<span class=\"help-inline\">#{instance_tag.error_message.first}</span>".html_safe
#   end
# end