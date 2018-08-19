class ProductionCostCenter < ActiveRecord::Base
  audited
  belongs_to :cost_center
  belongs_to :entity

  # Scope Model
  scope :date, ->(year=Time.now.year, month=Time.now.month) { where(year: year, month: month) }
  scope :for_entity, ->(entity_id) { where(entity_id: entity_id) }

  def self.import(file, year, month, entity)
		spreadsheet = open_spreadsheet(file)
		header = allowed_columns #spreadsheet.row(1)
		(2..spreadsheet.last_row).each do |i|
			row = spreadsheet.row(i)
			production_cost_center = find_by(year: year, month: month, entity_id: entity, cost_center_id: row[0].split('__')[0], production_units: row[1].split('__')[0]) || new
			production_cost_center.year = year
			production_cost_center.month = month
			production_cost_center.entity_id = entity
			production_cost_center.cost_center_id = row[0].split('__')[0]
			production_cost_center.production_units = row[1].split('__')[0]
			production_cost_center.value = row[2]
			begin
				production_cost_center.save!
			rescue Exception => e  
				return "Error con el archivo, solo se importo hasta la linea #{i-1}."
			end
		end
		return "Archivo importado."
	end

	def self.open_spreadsheet(file)
		case File.extname(file.original_filename)
			when ".csv" then Roo::Csv.new(file.path)
			when ".xls" then Roo::Excel.new(file.path)
			when ".xlsx" then Roo::Excelx.new(file.path)
			else raise "Unknown file type: #{file.original_filename}"
		end
	end

	def self.allowed_columns
		[ 'cost_center_id', 'production_units', 'value' ]
	end

	def self.allowed_columns_for_human
		[
			self.human_attribute_name('cost_center_id'), self.human_attribute_name('production_units'), self.human_attribute_name('value')
		]
	end
end
