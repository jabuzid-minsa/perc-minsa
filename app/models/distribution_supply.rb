class DistributionSupply < ActiveRecord::Base
  audited
  belongs_to :supply
  belongs_to :cost_center
  belongs_to :entity

  # Scope Model
  scope :date, ->(year=Time.now.year, month=Time.now.month) { where(year: year, month: month) }
  scope :for_entity, ->(entity_id) { where(entity_id: entity_id) }

  def self.import(file, year, month, entity)
    spreadsheet = open_spreadsheet(file)
    (2..spreadsheet.last_row).each do |i|
      row = spreadsheet.row(i)
      cost_center = row[0].split('-')[0]
      for column in 1..(row.length-1) 
        if row[column].present? and row[column] > 0
        	supply = spreadsheet.row(1)[column].split('-')[0]
          distribution_supply = find_by(year: year, month: month, entity_id: entity, cost_center_id: cost_center, supply_id: supply) || new
          distribution_supply.year = year
          distribution_supply.month = month
          distribution_supply.entity_id = entity
          distribution_supply.supply_id = supply
          distribution_supply.cost_center_id = cost_center
          distribution_supply.value = row[column]
          begin
            distribution_supply.save!
          rescue Exception => e  
            return "Error con el archivo, solo se importo hasta la linea #{i-1}, error: #{e}."
          end
        end        
      end
    end
    return "Archivo Importado."
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
      when ".csv" then Roo::Csv.new(file.path)
      when ".xls" then Roo::Excel.new(file.path)
      when ".xlsx" then Roo::Excelx.new(file.path)
      else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def self.to_csv(options = {}, include_data)
    CSV.generate({col_sep: ';', encoding: 'ISO-8859-1'}) do |csv|
      csv << allowed_columns_for_human
      if include_data
        all.each do |record|
          csv << record.attributes.values_at(*allowed_columns)
        end
      end
    end
  end

  def self.allowed_columns
    [ 'dni', 'name', 'salary', 'labor_law_id', 'entity_id', 'bonuses', 'benefits' ]
  end

  def self.allowed_columns_for_human
    [
        self.human_attribute_name('dni'), self.human_attribute_name('name'), self.human_attribute_name('salary'),
        self.human_attribute_name('labor_law_id'), self.human_attribute_name('entity_id'), self.human_attribute_name('bonuses'),
        self.human_attribute_name('benefits')
    ]
  end
end
