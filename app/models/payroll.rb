class Payroll < ActiveRecord::Base
	audited
	belongs_to :labor_law
	belongs_to :entity
	
	validates :labor_law_id, presence: true
	
	# Scope Model
	scope :date, ->(year=Time.now.year, month=Time.now.month) { where(year: year, month: month) }
	scope :for_entity, ->(entity_id) { where(entity_id: entity_id) }

	def self.import(file, year, month, entity, country, payroll_type)
		spreadsheet = open_spreadsheet(file)
		header = allowed_columns #spreadsheet.row(1)
		(2..spreadsheet.last_row).each do |i|
			row = spreadsheet.row(i)
			begin
				staff = Staff.find_by(code: row[3]).id
			rescue Exception => e
				return "No se encontro el Codigo de Personal #{row[3]}"
			end
			begin
				code_labor_standard = row[4].present? ? row[4] : '00' 
				labor_standard = LaborStandard.find_by(code: code_labor_standard, geography_id: country).id
			rescue Exception => e
				return "No se encontro el Nivel Laboral #{row[4]}"
			end
			begin
				labor_law = LaborLaw.find_by(year: year, month: month, entity_id: entity, staff_id: staff, labor_standard_id: labor_standard, contract_type_id: row[7]).id
			rescue Exception => e
				return "No se se definio un estandar de personal con los datos de #{row[0]}-#{row[1]}"
			end
			
			if payroll_type == 'consolidated'
				payroll = find_by(labor_law_id: labor_law, year: year, month: month, entity_id: entity) || new
				max_dni = where(entity_id: entity, year: year, month: month).maximum('dni')
				payroll.dni = max_dni ? max_dni.to_i + 1 : 1
				payroll.name = ''
			else
				payroll = find_by(dni: row[0], year: year, month: month, entity_id: entity) || new
				payroll.dni = row[0]
				payroll.name = row[1]
			end
			payroll.year = year
			payroll.month = month
			payroll.entity_id = entity
			payroll.salary = row[2]
			payroll.labor_law_id = labor_law
			payroll.bonuses = row[5]
			payroll.benefits = row[6]
			begin
				payroll.save!
			rescue Exception => e  
				return "Error con el archivo, solo se importo hasta la linea #{i-1}, error: #{e}."
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
