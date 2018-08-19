module ApplicationHelper
  ## Section current user data.
  # Get name for current User
  def name_current_user(user)
    user.full_name ? user.full_name : user.email
  end

  ## Section Path's custom for model (edit and destroy path's)
  # Path Edit
  def common_edit_path(id=0)
    prefix = params[:prefix].present? == true ? "/#{params[:prefix]}" : ''
    "#{prefix}/#{params[:controller]}/#{id}/edit"
  end

  # Path Destroy
  def common_destoy_path(id=0)
    prefix = params[:prefix].present? == true ? "/#{params[:prefix]}" : ''
    "#{prefix}/#{params[:controller]}/#{id}"
  end

  ## Section Tags html custom
  # Button load form add new model
  def button_add_model(path, class_css='btn btn-outline btn-primary dim', fa_icon='fa fa-plus')
    content_tag :a, :href => path do
      content_tag :button, :class => class_css do
        content_tag(:i, '',class: fa_icon)
      end
    end
  end

  # Input type checkbox for attribute state of models.
  def check_state(form, element=:state, class_css='js-switch')
    content_tag :div, :class => 'switch' do
      content_tag :div, :class => 'onoffswitch' do
        form.check_box element, class: class_css
      end
    end
  end

  ## Section Translations for elements
  # Translations for columns of datatables.
  def columns_model_translated(model, columns=[])
    array_tralate = []

    columns.each do |column|
      array_tralate << model.human_attribute_name(column)
    end

    return array_tralate
  end

  # Translation for state attribute
  def human_status_text(state)
    t("app.status.#{state == true ? 'activated' : 'deactivated' }")
  end

  ## Section URL's validation, for navigation menu.
  # Valid current action.
  def is_active_action(action_name)
    params[:action] == action_name ? "active" : nil
  end

  # Valid current controller.
  def is_active_controller(controller_name)
    params[:controller] == controller_name ? "active" : nil
  end

  # Valid prefix for current URL.
  def is_active_prefix(prefix_name)
    params[:prefix] == prefix_name ? "active" : nil
  end

  def get_date(record, date_part)
    if record.present? and record.year.present?
      record[:"#{date_part}"]
    else
      session[:"#{date_part}"]
    end
  end

end
