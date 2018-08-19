module DistributionSuppliesHelper

  def acces_attribute_distribution_supplies(record, attribute='value')
    if record.present?
      record[:"#{attribute}"]
    end
  end

end
