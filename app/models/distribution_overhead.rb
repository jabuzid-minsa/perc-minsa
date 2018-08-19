class DistributionOverhead < ActiveRecord::Base
	audited
	belongs_to :type_distribution
	belongs_to :cost_center
	belongs_to :supply
	belongs_to :entity

	# Scope Model
	scope :date, ->(year=Time.now.year, month=Time.now.month) { where(year: year, month: month) }
	scope :for_entity, ->(entity_id) { where(entity_id: entity_id) }

	#
	def self.sum_values_group_by_cost_center_and_supply
		sql_raw = "SELECT a.id, a.description, b.id, b.description, c.id, c.description, d.id, d.description, e.id, e.description
			FROM geographies a
				LEFT JOIN geographies b ON (a.first_level = b.first_level
					AND b.second_level != '0' AND b.third_level = '0')
				LEFT JOIN geographies c ON (a.first_level = c.first_level AND b.second_level = c.second_level
					AND c.second_level != '0' AND c.third_level != '0' AND c.fourth_level = '0')
				LEFT JOIN geographies d ON (a.first_level = d.first_level AND b.second_level = d.second_level AND c.third_level = d.third_level
					AND d.second_level != '0' AND d.third_level != '0' AND d.fourth_level != '0' AND d.fifth_level = '0')
				LEFT JOIN geographies e ON (a.first_level = e.first_level AND b.second_level = e.second_level AND c.third_level = e.third_level
					AND d.fourth_level = e.fourth_level AND e.second_level != '0' AND e.third_level != '0' AND e.fourth_level != '0'
					AND e.fifth_level != '0')
			WHERE a.second_level = '0' AND a.first_level = '#{country_code}'"
		return ActiveRecord::Base.connection.execute(sql_raw)
	end

	def self.import(file, year, month, entity)
		spreadsheet = open_spreadsheet(file)

		(4..spreadsheet.last_row).each do |i|
			row = spreadsheet.row(i)
			begin
				cost_center = row[0].split('-')[0]
			rescue Exception => e
				return "Error en el CP #{row[0]}, posible fila en blanco."
			end
			for column in 1..(row.length-1)
				if row[column].present? and row[column] > 0
					type_distribution = spreadsheet.row(2)[column]
					general_value = spreadsheet.row(3)[column]
					begin
						supply = spreadsheet.row(1)[column].split('-')[0]
					rescue Exception => e
						return "Error en el insumo #{spreadsheet.row(1)[column]}, posible columna en blanco."
					end
					distribution_overhead = find_by(year: year, month: month, entity_id: entity, cost_center_id: cost_center, supply_id: supply) || new
					distribution_overhead.year = year
					distribution_overhead.month = month
					distribution_overhead.entity_id = entity
					distribution_overhead.supply_id = supply
					distribution_overhead.cost_center_id = cost_center
					distribution_overhead.type_distribution_id = type_distribution
					distribution_overhead.general_value = general_value
					distribution_overhead.value = row[column]
					begin
						distribution_overhead.save!
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
