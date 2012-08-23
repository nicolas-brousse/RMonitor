module NavigationHelper
  def nav_link_to(*args, &block)
    # args[:class] += "active" if controller_name
    html_class = "active"

    if block_given?
      args.second[:class] = html_class
      link_to(capture(&block), *args)
    else
      link_to(*args)
    end
  end

  # TODO
  # nav_class :controller => controller, :aciton => action
  # nav_class [{:controller => controller, :aciton => action}, {:controller => controller, :aciton => action}] <==== recursive
  def nav_class controller, action=nil
    if controller.kind_of?(Array)
      controllers = controller.collect {|v| v.to_s }
      controller  = controllers.include?(controller_name) ? controller_name : false
    end

    if action.kind_of?(Array)
      actions = action.collect {|v| v.to_s }
      action  = actions.include?(action_name) ? action_name : false
    end

    " class=\"active\"".html_safe if controller_name == controller.to_s && (action_name == action.to_s || action.nil?)
  end
end
