class Income < ActiveRecord::Base
  audited
  belongs_to :cost_center
  belongs_to :entity

  # Scope Model
  scope :date, ->(year=Time.now.year, month=Time.now.month) { where(year: year, month: month) }
  scope :for_entity, ->(entity_id) { where(entity_id: entity_id) }

  def self.total_charged(year, month, entity)
    incomes = self.where(year: year, month: month, entity_id: entity)
    total_revenue = incomes.first.total_revenue || 0

    if total_revenue > 0
      return total_revenue
    else
      return incomes.map(&:value).inject(0, :+)
    end
  rescue
    0
  end

  def self.import(file, year, month, entity)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)

    (2..spreadsheet.last_row).each do |i|
      row = spreadsheet.row(i)

      for column in 2..(row.length-1) 
        if row[column].present? and row[column] > 0
          cost_center = header[column].split('-')[0]

          income = Income.where(year: year, month: month, entity_id: entity, cost_center_id: cost_center).first_or_initialize do |income|
            income.value = row[column]
          end

          unless income.save
            raise "Error con el archivo, revisar que los datos sean correctos."
          end
        end        
      end
    end
    
    if spreadsheet.row(2).length > 2
      if spreadsheet.row(2)[1].to_f > 0
        Income.where(year: year, month: month, entity_id: entity).update_all(total_revenue: spreadsheet.row(2)[1].to_f)
      else
        incomes = Income.where(year: year, month: month, entity_id: entity)
        incomes.update_all(total_revenue: incomes.sum(:value).to_f)
      end
    elsif spreadsheet.row(2)[1].to_f > 0
      cost_center = header[2].split('-')[0]
      income = Income.where(year: year, month: month, entity_id: entity, cost_center_id: cost_center).first_or_initialize do |income|
        income.value = 0
        income.total_revenue = spreadsheet.row(2)[1].to_f
      end

      unless income.save
        raise "Error con el archivo, revisar que los datos sean correctos."
      end
    end

    return "Archivo Importado."
  rescue Exception => e
    return e.message
  end
  
  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
      when ".csv" then Roo::Csv.new(file.path)
      when ".xls" then Roo::Excel.new(file.path)
      when ".xlsx" then Roo::Excelx.new(file.path)
      else raise "Archivo con formato no permitido solo se permite 'libro de excel (.xlsx)'"
    end
  end
end
