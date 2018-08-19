class CreateJoinTableLaborLawSalaryComponent < ActiveRecord::Migration
  def change
    create_join_table :labor_laws, :salary_components do |t|
      # t.index [:labor_law_id, :salary_component_id]
      # t.index [:salary_component_id, :labor_law_id]
    end
  end
end
