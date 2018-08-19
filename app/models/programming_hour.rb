class ProgrammingHour < ActiveRecord::Base
  audited
  belongs_to :entity
  belongs_to :cost_center
  belongs_to :payroll
  belongs_to :salary_component

  # Scope Model
  scope :date, ->(year=Time.now.year, month=Time.now.month) { where(year: year, month: month) }
  scope :for_entity, ->(entity_id) { where(entity_id: entity_id) }

  def self.import(file, year, month, entity)
    spreadsheet = open_spreadsheet(file)
    (2..spreadsheet.last_row).each do |i|
      row = spreadsheet.row(i)
      payroll = row[0].split('__')[0]
      for column in 4..(row.length-1)
        if row[column].present? and row[column] > 0
          programing_hour = find_by(year: year, month: month, entity_id: entity, payroll_id: payroll, salary_component_id: row[3].split('-')[0], cost_center_id: spreadsheet.row(1)[column].split('-')[0]) || new
          programing_hour.year = year
          programing_hour.month = month
          programing_hour.entity_id = entity
          programing_hour.payroll_id = payroll
          programing_hour.total = row[1]
          programing_hour.paid = row[2]
          programing_hour.salary_component_id = row[3].split('-')[0]
          programing_hour.cost_center_id = spreadsheet.row(1)[column].split('-')[0]
          programing_hour.hours = row[column]
          programing_hour.save!
        end
      end
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
      when ".csv" then Roo::Csv.new(file.path)
      when ".xls" then Roo::Excel.new(file.path)
      when ".xlsx" then Roo::Excelx.new(file.path)
      else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def self.allowed_columns_for_human
    [
        self.human_attribute_name('payroll_id'), self.human_attribute_name('total'), self.human_attribute_name('paid'),
        self.human_attribute_name('salary_component_id')
    ]
  end
end
