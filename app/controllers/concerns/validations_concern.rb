module ValidationsConcern extend ActiveSupport::Concern

  def next_code_simple_model(model)
    max_code = model.maximum(:code)
    if not max_code.present?
      max_code = 0
    end
    max_code.to_i + 1
  end

  def next_code_model(model, reference_field, value_reference)
    max_code = model.where("#{reference_field}": value_reference ).maximum(:code)
    if not max_code.present?
      max_code = model.maximum(:code)
      if not max_code.present?
        max_code = 1
      else
        max_code.to_i + 1
      end
    else
      max_code.to_i + 1
    end
  end

end