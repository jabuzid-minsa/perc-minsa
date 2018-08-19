module IncomesHelper

  def acces_attribute_incomes(record, attribute='value')
    if record.present?
      record[:"#{attribute}"]
    end
  end

end
