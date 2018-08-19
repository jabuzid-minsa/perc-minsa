module DistributionAreasHelper

  def acces_attribute_distribution_area(record, attribute='meters')
    if record.present?
      record[:"#{attribute}"]
    end
  end

end
