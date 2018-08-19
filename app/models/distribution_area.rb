class DistributionArea < ActiveRecord::Base
	audited
  belongs_to :entity
  belongs_to :cost_center

  # Scope Model
  scope :date, ->(year=Time.now.year, month=Time.now.month) { where(year: year, month: month) }
  scope :for_entity, ->(entity_id) { where(entity_id: entity_id) }

  def self.import(file, year, month, entity)
		spreadsheet = open_spreadsheet(file)
		header = allowed_columns #spreadsheet.row(1)
		(2..spreadsheet.last_row).each do |i|
			row = spreadsheet.row(i)			
			distribution_area = find_by(year: year, month: month, entity_id: entity, cost_center_id: row[0]) || new
			distribution_area.year = year
			distribution_area.month = month
			distribution_area.entity_id = entity
			distribution_area.cost_center_id = row[0]
			distribution_area.meters = row[1]
			begin
				distribution_area.save!
			rescue Exception => e  
				return "Error con el archivo, solo se importo hasta la linea #{i-1}."
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
					csv << ["#{record.cost_center.id}-#{record.cost_center.description}", record.meters]
				end
			end
		end
	end

	def self.allowed_columns
		[ 'cost_center_id', 'meters' ]
	end

	def self.allowed_columns_for_human
		[
			self.human_attribute_name('cost_center_id'), self.human_attribute_name('meters')
		]
	end
end
