module DistributionCostsHelper

  def acces_attribute_distribution_cost(record, attribute='meters')
    if record.present?
      record[:"#{attribute}"]
    end
  end

end
