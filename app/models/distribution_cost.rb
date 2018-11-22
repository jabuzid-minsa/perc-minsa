class DistributionCost < ActiveRecord::Base
	audited
	belongs_to :cost_center
	belongs_to :supported_cost_center, :class_name => 'CostCenter'
	belongs_to :entity

	# Scope Model
	scope :date, ->(year=Time.now.year, month=Time.now.month) { where(year: year, month: month) }
	scope :for_entity, ->(entity_id) { where(entity_id: entity_id) }

	def self.import(file, year, month, entity)
		spreadsheet = open_spreadsheet(file)
		(2..spreadsheet.last_row).each do |i|
			row = spreadsheet.row(i)
			cost_center = row[0].split('-')[0].split('_')[0]
			unit_production = row[0].split('-')[0].split('_')[1]
			for column in 1..(row.length-1)
				if row[column].present? and row[column] > 0
					support_cost_center = spreadsheet.row(1)[column].split('-')[0]
					distribution_cost = find_by(year: year, month: month, entity_id: entity, cost_center_id: cost_center, supported_cost_center_id: support_cost_center, production_units: unit_production) || new
					distribution_cost.year = year
					distribution_cost.month = month
					distribution_cost.entity_id = entity
					distribution_cost.cost_center_id = cost_center
					distribution_cost.supported_cost_center_id = support_cost_center
					distribution_cost.production_units = unit_production
					distribution_cost.value = row[column]
					begin
						distribution_cost.save!
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
end
