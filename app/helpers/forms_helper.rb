module FormsHelper
  def cancel_tag(url=nil)
    if url.nil?
      url = :back 
    else
      url = url_for(url)
    end

    link_to(t(:cancel), url, :data => {:confirm => "Are you sure?"}, :class => "btn")
  end
end
