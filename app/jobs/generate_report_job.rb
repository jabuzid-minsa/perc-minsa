class GenerateReportJob < ActiveJob::Base
  queue_as :default

  # Types jobs
  # => 1: Human Resource -> depend of payrolls and programming hours
  def perform(type, year, month, entity)    
    if type == 1
      generate_payrolls(year, month, entity)
    elsif type == 2
      generate_overheads(year, month, entity)
    elsif type == 3
      generate_supplies(year, month, entity)
    elsif type == 4
      generate_distribution_costs(year, month, entity)
    elsif type == 5
      if DistributionCost.where(year: year, month: month, entity_id: entity).limit(1).size == 1
        generate_production_unit(year, month, entity)
      end
    elsif type == 6
      generate_payrolls(year, month, entity)
      generate_overheads(year, month, entity)
      generate_supplies(year, month, entity)
      generate_distribution_costs(year, month, entity)
      generate_production_unit(year, month, entity)
    end

    if validate_state_info(year, month, entity)
      generate_indirect_cost(year, month, entity)
    end
  end

  def generate_payrolls(year, month, entity)
    ActiveRecord::Base.connection.execute("CALL greport_human_resource(#{year},#{month}, #{entity})")
    ActiveRecord::Base.clear_active_connections!
  end

  def generate_overheads(year, month, entity)
    ActiveRecord::Base.connection.execute("CALL greport_overheads(#{year},#{month}, #{entity})")
    ActiveRecord::Base.clear_active_connections!
  end

  def generate_supplies(year, month, entity)
    ActiveRecord::Base.connection.execute("CALL greport_supplies(#{year},#{month}, #{entity})")
    ActiveRecord::Base.clear_active_connections!
  end

  def generate_distribution_costs(year, month, entity)
    ActiveRecord::Base.connection.execute("CALL greport_distribution_costs(#{year},#{month}, #{entity})")
    ActiveRecord::Base.clear_active_connections!
  end

  def generate_production_unit(year, month, entity)
    ActiveRecord::Base.connection.execute("CALL greport_production_unit(#{year},#{month}, #{entity})")
    ActiveRecord::Base.clear_active_connections!
  end

  def generate_indirect_cost(year, month, entity)
    ActiveRecord::Base.connection.execute("CALL greport_indirect_cost(#{year},#{month}, #{entity})")
    ActiveRecord::Base.clear_active_connections!
  end

  def validate_state_info(year, month, entity)
    cont = 0

    cont += ProgrammingHour.where(year: year, month: month, entity_id: entity).limit(1).size
    cont += DistributionOverhead.where(year: year, month: month, entity_id: entity).limit(1).size
    cont += DistributionSupply.where(year: year, month: month, entity_id: entity).limit(1).size
    cont += DistributionCost.where(year: year, month: month, entity_id: entity).limit(1).size
    cont += ProductionCostCenter.where(year: year, month: month, entity_id: entity).limit(1).size

    return cont == 5 ? true : false
  end
end
