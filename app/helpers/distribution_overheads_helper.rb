module DistributionOverheadsHelper

  def acces_attribute_distribution_overheads(record, attribute='value', first=false)
    if record.present?
      record[:"#{attribute}"]
    end
  end

end
