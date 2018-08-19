module MessagesConcern extend ActiveSupport::Concern

  def get_message_created(model)
    "#{model.model_name.human} #{t('messages.crud.created')}"
  end

  def get_message_destroyed(model)
    "#{model.model_name.human} #{t('messages.crud.destroyed')}"
  end

  def get_message_updated(model)
    "#{model.model_name.human} #{t('messages.crud.updated')}"
  end


end