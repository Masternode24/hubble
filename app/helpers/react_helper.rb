module ReactHelper
  def react_app_wrapper(element_id, html_options: {}, props: {})
    tag(:div, html_options.merge(id: element_id, data: props.to_json))
  end
end
