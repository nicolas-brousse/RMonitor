module FormsHelper
  def cancel_tag
    link_to(t(:cancel), :back, :data => {:confirm => "Are you sure?"}, :class => "btn")
  end
end
