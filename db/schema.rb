# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180819153610) do

  create_table "audits", force: :cascade do |t|
    t.integer  "auditable_id",    limit: 4
    t.string   "auditable_type",  limit: 255
    t.integer  "associated_id",   limit: 4
    t.string   "associated_type", limit: 255
    t.integer  "user_id",         limit: 4
    t.string   "user_type",       limit: 255
    t.string   "username",        limit: 255
    t.string   "action",          limit: 255
    t.text     "audited_changes", limit: 65535
    t.integer  "version",         limit: 4,     default: 0
    t.string   "comment",         limit: 255
    t.string   "remote_address",  limit: 255
    t.string   "request_uuid",    limit: 255
    t.datetime "created_at"
  end

  add_index "audits", ["associated_type", "associated_id"], name: "associated_index", using: :btree
  add_index "audits", ["auditable_type", "auditable_id"], name: "auditable_index", using: :btree
  add_index "audits", ["created_at"], name: "index_audits_on_created_at", using: :btree
  add_index "audits", ["request_uuid"], name: "index_audits_on_request_uuid", using: :btree
  add_index "audits", ["user_id", "user_type"], name: "user_index", using: :btree

  create_table "care_levels", force: :cascade do |t|
    t.string   "code",         limit: 255,   default: ""
    t.string   "description",  limit: 255,   default: ""
    t.text     "definition",   limit: 65535
    t.integer  "geography_id", limit: 4
    t.integer  "language_id",  limit: 4
    t.boolean  "state",                      default: true
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  add_index "care_levels", ["code", "geography_id"], name: "index_care_levels_on_code_and_geography_id", unique: true, using: :btree
  add_index "care_levels", ["geography_id"], name: "index_care_levels_on_geography_id", using: :btree
  add_index "care_levels", ["language_id"], name: "index_care_levels_on_language_id", using: :btree

  create_table "contract_types", force: :cascade do |t|
    t.string   "code",         limit: 255, default: ""
    t.string   "description",  limit: 255, default: ""
    t.integer  "geography_id", limit: 4
    t.boolean  "state",                    default: true
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "contract_types", ["geography_id"], name: "index_contract_types_on_geography_id", using: :btree

  create_table "cost_centers", force: :cascade do |t|
    t.string   "code",                             limit: 255,                             default: ""
    t.string   "description",                      limit: 255,                             default: ""
    t.text     "definition",                       limit: 65535
    t.integer  "function",                         limit: 4,                               default: 0
    t.integer  "cost_center_id",                   limit: 4
    t.integer  "geography_id",                     limit: 4
    t.integer  "language_id",                      limit: 4
    t.integer  "staff_id",                         limit: 4
    t.integer  "supply_id",                        limit: 4
    t.integer  "cost_distribution_id",             limit: 4
    t.integer  "primary_production_unit_id",       limit: 4
    t.integer  "secondary_production_unit_id",     limit: 4
    t.integer  "tertiary_production_unit_id",      limit: 4
    t.integer  "quaternary_production_unit_id",    limit: 4
    t.integer  "quinary_production_unit_id",       limit: 4
    t.boolean  "state",                                                                    default: true
    t.datetime "created_at",                                                                               null: false
    t.datetime "updated_at",                                                                               null: false
    t.boolean  "comprehensive",                                                            default: false
    t.decimal  "secondary_equivalent_to_primary",                precision: 42, scale: 10, default: 0.0
    t.decimal  "tertiary_equivalent_to_primary",                 precision: 42, scale: 10, default: 0.0
    t.decimal  "quaternary_equivalent_to_primary",               precision: 42, scale: 10, default: 0.0
    t.decimal  "quinary_equivalent_to_primary",                  precision: 42, scale: 10, default: 0.0
  end

  add_index "cost_centers", ["code", "geography_id"], name: "index_cost_centers_on_code_and_geography_id", unique: true, using: :btree
  add_index "cost_centers", ["cost_center_id"], name: "index_cost_centers_on_cost_center_id", using: :btree
  add_index "cost_centers", ["cost_distribution_id"], name: "index_cost_centers_on_cost_distribution_id", using: :btree
  add_index "cost_centers", ["geography_id"], name: "index_cost_centers_on_geography_id", using: :btree
  add_index "cost_centers", ["language_id"], name: "index_cost_centers_on_language_id", using: :btree
  add_index "cost_centers", ["staff_id"], name: "index_cost_centers_on_staff_id", using: :btree
  add_index "cost_centers", ["supply_id"], name: "index_cost_centers_on_supply_id", using: :btree

  create_table "cost_distributions", force: :cascade do |t|
    t.string   "code",         limit: 255,   default: ""
    t.string   "description",  limit: 255,   default: ""
    t.text     "definition",   limit: 65535
    t.integer  "geography_id", limit: 4
    t.integer  "language_id",  limit: 4
    t.boolean  "state",                      default: true
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  add_index "cost_distributions", ["code", "geography_id"], name: "index_cost_distributions_on_code_and_geography_id", unique: true, using: :btree
  add_index "cost_distributions", ["geography_id"], name: "index_cost_distributions_on_geography_id", using: :btree
  add_index "cost_distributions", ["language_id"], name: "index_cost_distributions_on_language_id", using: :btree

  create_table "distribution_areas", force: :cascade do |t|
    t.integer  "year",           limit: 2
    t.integer  "month",          limit: 1
    t.decimal  "meters",                   precision: 42, scale: 10, default: 0.0
    t.integer  "entity_id",      limit: 4
    t.integer  "cost_center_id", limit: 4
    t.datetime "created_at",                                                       null: false
    t.datetime "updated_at",                                                       null: false
  end

  add_index "distribution_areas", ["cost_center_id"], name: "index_distribution_areas_on_cost_center_id", using: :btree
  add_index "distribution_areas", ["entity_id"], name: "index_distribution_areas_on_entity_id", using: :btree
  add_index "distribution_areas", ["year", "month", "entity_id", "cost_center_id"], name: "uk_distribution_areas", unique: true, using: :btree

  create_table "distribution_costs", force: :cascade do |t|
    t.integer  "year",                     limit: 2
    t.integer  "month",                    limit: 1
    t.decimal  "value",                              precision: 42, scale: 10, default: 0.0
    t.integer  "cost_center_id",           limit: 4
    t.integer  "supported_cost_center_id", limit: 4
    t.integer  "entity_id",                limit: 4
    t.datetime "created_at",                                                                 null: false
    t.datetime "updated_at",                                                                 null: false
    t.integer  "production_units",         limit: 4
  end

  add_index "distribution_costs", ["cost_center_id"], name: "index_distribution_costs_on_cost_center_id", using: :btree
  add_index "distribution_costs", ["entity_id"], name: "index_distribution_costs_on_entity_id", using: :btree
  add_index "distribution_costs", ["year", "month", "entity_id", "supported_cost_center_id", "cost_center_id", "production_units"], name: "uk_distribution_costs", unique: true, using: :btree

  create_table "distribution_overheads", force: :cascade do |t|
    t.integer  "year",                 limit: 2
    t.integer  "month",                limit: 1
    t.decimal  "general_value",                  precision: 42, scale: 10, default: 0.0
    t.decimal  "value",                          precision: 42, scale: 10, default: 0.0
    t.integer  "type_distribution_id", limit: 4
    t.integer  "cost_center_id",       limit: 4
    t.integer  "supply_id",            limit: 4
    t.integer  "entity_id",            limit: 4
    t.datetime "created_at",                                                             null: false
    t.datetime "updated_at",                                                             null: false
  end

  add_index "distribution_overheads", ["cost_center_id"], name: "index_distribution_overheads_on_cost_center_id", using: :btree
  add_index "distribution_overheads", ["entity_id"], name: "index_distribution_overheads_on_entity_id", using: :btree
  add_index "distribution_overheads", ["supply_id"], name: "index_distribution_overheads_on_supply_id", using: :btree
  add_index "distribution_overheads", ["type_distribution_id"], name: "index_distribution_overheads_on_type_distribution_id", using: :btree
  add_index "distribution_overheads", ["year", "month", "entity_id", "supply_id", "cost_center_id"], name: "uk_distribution_overheads", unique: true, using: :btree

  create_table "distribution_supplies", force: :cascade do |t|
    t.integer  "year",           limit: 2
    t.integer  "month",          limit: 1
    t.decimal  "value",                    precision: 42, scale: 10, default: 0.0
    t.integer  "supply_id",      limit: 4
    t.integer  "cost_center_id", limit: 4
    t.integer  "entity_id",      limit: 4
    t.datetime "created_at",                                                       null: false
    t.datetime "updated_at",                                                       null: false
  end

  add_index "distribution_supplies", ["cost_center_id"], name: "index_distribution_supplies_on_cost_center_id", using: :btree
  add_index "distribution_supplies", ["entity_id"], name: "index_distribution_supplies_on_entity_id", using: :btree
  add_index "distribution_supplies", ["supply_id"], name: "index_distribution_supplies_on_supply_id", using: :btree
  add_index "distribution_supplies", ["year", "month", "entity_id", "supply_id", "cost_center_id"], name: "uk_distribution_supplies", unique: true, using: :btree

  create_table "entities", force: :cascade do |t|
    t.string   "code",          limit: 255, default: ""
    t.string   "abbreviation",  limit: 255, default: ""
    t.string   "description",   limit: 255, default: ""
    t.integer  "payroll_type",  limit: 4,   default: 0
    t.integer  "care_level_id", limit: 4
    t.integer  "geography_id",  limit: 4
    t.boolean  "state",                     default: true
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "entities", ["care_level_id"], name: "index_entities_on_care_level_id", using: :btree
  add_index "entities", ["code", "geography_id"], name: "index_entities_on_code_and_geography_id", unique: true, using: :btree
  add_index "entities", ["geography_id"], name: "index_entities_on_geography_id", using: :btree

  create_table "entities_networks", id: false, force: :cascade do |t|
    t.integer "network_id", limit: 4, null: false
    t.integer "entity_id",  limit: 4, null: false
  end

  create_table "entities_staffs", id: false, force: :cascade do |t|
    t.integer "entity_id", limit: 4, null: false
    t.integer "staff_id",  limit: 4, null: false
  end

  create_table "entities_supplies", id: false, force: :cascade do |t|
    t.integer "entity_id", limit: 4, null: false
    t.integer "supply_id", limit: 4, null: false
  end

  create_table "entities_users", id: false, force: :cascade do |t|
    t.integer "entity_id", limit: 4, null: false
    t.integer "user_id",   limit: 4, null: false
  end

  create_table "entity_cost_centers", id: false, force: :cascade do |t|
    t.integer  "entity_id",      limit: 4
    t.integer  "cost_center_id", limit: 4
    t.integer  "function",       limit: 4, default: 0
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "entity_cost_centers", ["cost_center_id"], name: "index_entity_cost_centers_on_cost_center_id", using: :btree
  add_index "entity_cost_centers", ["entity_id"], name: "index_entity_cost_centers_on_entity_id", using: :btree

  create_table "geographies", force: :cascade do |t|
    t.integer  "numerical_code", limit: 4,   default: 0
    t.string   "first_level",    limit: 3,   default: ""
    t.integer  "second_level",   limit: 2,   default: 0
    t.integer  "third_level",    limit: 2,   default: 0
    t.integer  "fourth_level",   limit: 2,   default: 0
    t.integer  "fifth_level",    limit: 2,   default: 0
    t.string   "description",    limit: 255, default: ""
    t.integer  "depth_detail",   limit: 1
    t.boolean  "state",                      default: true
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.integer  "user_id",        limit: 4
  end

  add_index "geographies", ["numerical_code", "second_level", "third_level", "fourth_level", "fifth_level"], name: "uk_geography_levels", unique: true, using: :btree
  add_index "geographies", ["user_id"], name: "fk_rails_240dcf050a", using: :btree

  create_table "hml_cost_centers", id: false, force: :cascade do |t|
    t.string "old_code", limit: 10
    t.string "new_code", limit: 10
  end

  create_table "hml_overheads", id: false, force: :cascade do |t|
    t.string "old_code", limit: 10
    t.string "new_code", limit: 10, null: false
  end

  create_table "hml_staffs", id: false, force: :cascade do |t|
    t.string "old_code", limit: 10
    t.string "new_code", limit: 10, null: false
  end

  create_table "hml_supplies", id: false, force: :cascade do |t|
    t.string "old_code", limit: 10
    t.string "new_code", limit: 10, null: false
  end

  create_table "income_definitions", force: :cascade do |t|
    t.boolean  "invoice",                  default: true
    t.integer  "cost_center_id", limit: 4
    t.integer  "entity_id",      limit: 4
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "income_definitions", ["cost_center_id", "entity_id"], name: "index_income_definitions_on_cost_center_id_and_entity_id", unique: true, using: :btree
  add_index "income_definitions", ["cost_center_id"], name: "index_income_definitions_on_cost_center_id", using: :btree
  add_index "income_definitions", ["entity_id"], name: "index_income_definitions_on_entity_id", using: :btree

  create_table "incomes", force: :cascade do |t|
    t.integer  "year",           limit: 2
    t.integer  "month",          limit: 1
    t.decimal  "value",                    precision: 42, scale: 10, default: 0.0
    t.integer  "entity_id",      limit: 4
    t.integer  "cost_center_id", limit: 4
    t.datetime "created_at",                                                       null: false
    t.datetime "updated_at",                                                       null: false
  end

  add_index "incomes", ["cost_center_id"], name: "index_incomes_on_cost_center_id", using: :btree
  add_index "incomes", ["entity_id"], name: "index_incomes_on_entity_id", using: :btree
  add_index "incomes", ["year", "month", "entity_id", "cost_center_id"], name: "uk_incomes", unique: true, using: :btree

  create_table "labor_laws", force: :cascade do |t|
    t.integer  "year",              limit: 2
    t.integer  "month",             limit: 1
    t.decimal  "min_wage",                    precision: 42, scale: 10, default: 0.0
    t.integer  "staff_id",          limit: 4
    t.integer  "labor_standard_id", limit: 4
    t.integer  "contract_type_id",  limit: 4
    t.integer  "entity_id",         limit: 4
    t.boolean  "state",                                                 default: true
    t.datetime "created_at",                                                           null: false
    t.datetime "updated_at",                                                           null: false
  end

  add_index "labor_laws", ["contract_type_id"], name: "index_labor_laws_on_contract_type_id", using: :btree
  add_index "labor_laws", ["entity_id"], name: "index_labor_laws_on_entity_id", using: :btree
  add_index "labor_laws", ["labor_standard_id"], name: "index_labor_laws_on_labor_standard_id", using: :btree
  add_index "labor_laws", ["staff_id"], name: "index_labor_laws_on_staff_id", using: :btree
  add_index "labor_laws", ["year", "month", "staff_id", "labor_standard_id", "contract_type_id", "entity_id"], name: "uk_labor_laws", unique: true, using: :btree

  create_table "labor_laws_salary_components", id: false, force: :cascade do |t|
    t.integer "labor_law_id",        limit: 4, null: false
    t.integer "salary_component_id", limit: 4, null: false
  end

  create_table "labor_standards", force: :cascade do |t|
    t.string   "code",         limit: 255, default: ""
    t.string   "description",  limit: 255, default: ""
    t.integer  "geography_id", limit: 4
    t.boolean  "state",                    default: true
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "labor_standards", ["geography_id"], name: "index_labor_standards_on_geography_id", using: :btree

  create_table "languages", force: :cascade do |t|
    t.string   "abbreviation", limit: 255, default: ""
    t.string   "name",         limit: 255, default: ""
    t.boolean  "state",                    default: true
    t.integer  "user_id",      limit: 4
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "languages", ["abbreviation"], name: "index_languages_on_abbreviation", unique: true, using: :btree
  add_index "languages", ["user_id"], name: "index_languages_on_user_id", using: :btree

  create_table "migrations_perc", id: false, force: :cascade do |t|
    t.string  "user",       limit: 50,                  null: false
    t.integer "year",       limit: 4,                   null: false
    t.integer "month",      limit: 4,                   null: false
    t.integer "entity",     limit: 4,                   null: false
    t.string  "status",     limit: 1,     default: "N", null: false
    t.text    "mess_error", limit: 65535,               null: false
  end

  create_table "networks", force: :cascade do |t|
    t.string   "code",         limit: 255, default: ""
    t.string   "description",  limit: 255, default: ""
    t.integer  "geography_id", limit: 4
    t.boolean  "state",                    default: true
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "networks", ["code", "geography_id"], name: "index_networks_on_code_and_geography_id", unique: true, using: :btree
  add_index "networks", ["geography_id"], name: "index_networks_on_geography_id", using: :btree

  create_table "networks_users", id: false, force: :cascade do |t|
    t.integer "network_id", limit: 4, null: false
    t.integer "user_id",    limit: 4, null: false
  end

  create_table "payrolls", force: :cascade do |t|
    t.string   "dni",          limit: 255,                           default: ""
    t.string   "name",         limit: 255,                           default: ""
    t.decimal  "salary",                   precision: 42, scale: 10, default: 0.0
    t.integer  "labor_law_id", limit: 4
    t.integer  "entity_id",    limit: 4
    t.datetime "created_at",                                                       null: false
    t.datetime "updated_at",                                                       null: false
    t.integer  "year",         limit: 2
    t.integer  "month",        limit: 1
    t.decimal  "bonuses",                  precision: 42, scale: 10, default: 0.0
    t.decimal  "benefits",                 precision: 42, scale: 10, default: 0.0
  end

  add_index "payrolls", ["entity_id"], name: "index_payrolls_on_entity_id", using: :btree
  add_index "payrolls", ["labor_law_id"], name: "index_payrolls_on_labor_law_id", using: :btree

  create_table "production_cost_centers", force: :cascade do |t|
    t.integer  "year",             limit: 2
    t.integer  "month",            limit: 1
    t.decimal  "value",                      precision: 42, scale: 10, default: 0.0
    t.integer  "production_units", limit: 1
    t.integer  "cost_center_id",   limit: 4
    t.integer  "entity_id",        limit: 4
    t.datetime "created_at",                                                         null: false
    t.datetime "updated_at",                                                         null: false
  end

  add_index "production_cost_centers", ["cost_center_id"], name: "index_production_cost_centers_on_cost_center_id", using: :btree
  add_index "production_cost_centers", ["entity_id"], name: "index_production_cost_centers_on_entity_id", using: :btree

  create_table "production_units", force: :cascade do |t|
    t.string   "code",         limit: 255,   default: ""
    t.string   "abbreviation", limit: 255,   default: ""
    t.string   "description",  limit: 255,   default: ""
    t.text     "definition",   limit: 65535
    t.integer  "geography_id", limit: 4
    t.integer  "language_id",  limit: 4
    t.boolean  "state",                      default: true
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  add_index "production_units", ["abbreviation", "geography_id"], name: "index_production_units_on_abbreviation_and_geography_id", unique: true, using: :btree
  add_index "production_units", ["code", "geography_id"], name: "index_production_units_on_code_and_geography_id", unique: true, using: :btree
  add_index "production_units", ["geography_id"], name: "index_production_units_on_geography_id", using: :btree
  add_index "production_units", ["language_id"], name: "index_production_units_on_language_id", using: :btree

  create_table "programming_hours", force: :cascade do |t|
    t.integer  "year",                limit: 2
    t.integer  "month",               limit: 1
    t.integer  "total",               limit: 4,                           default: 0
    t.decimal  "paid",                          precision: 42, scale: 10, default: 0.0
    t.decimal  "hours",                         precision: 42, scale: 10, default: 0.0
    t.integer  "entity_id",           limit: 4
    t.integer  "cost_center_id",      limit: 4
    t.integer  "payroll_id",          limit: 4
    t.integer  "salary_component_id", limit: 4
    t.datetime "created_at",                                                            null: false
    t.datetime "updated_at",                                                            null: false
  end

  add_index "programming_hours", ["cost_center_id"], name: "index_programming_hours_on_cost_center_id", using: :btree
  add_index "programming_hours", ["entity_id"], name: "index_programming_hours_on_entity_id", using: :btree
  add_index "programming_hours", ["payroll_id"], name: "index_programming_hours_on_payroll_id", using: :btree
  add_index "programming_hours", ["salary_component_id"], name: "index_programming_hours_on_salary_component_id", using: :btree
  add_index "programming_hours", ["year", "month", "entity_id", "cost_center_id", "payroll_id", "salary_component_id"], name: "uk_programming_hours", unique: true, using: :btree

  create_table "salary_components", force: :cascade do |t|
    t.string   "code",         limit: 255,                           default: ""
    t.string   "abbreviation", limit: 255,                           default: ""
    t.string   "description",  limit: 255,                           default: ""
    t.decimal  "max_value",                precision: 42, scale: 10, default: 0.0
    t.decimal  "rate",                     precision: 42, scale: 10, default: 0.0
    t.integer  "geography_id", limit: 4
    t.boolean  "state",                                              default: true
    t.datetime "created_at",                                                        null: false
    t.datetime "updated_at",                                                        null: false
  end

  add_index "salary_components", ["code", "geography_id"], name: "index_salary_components_on_code_and_geography_id", unique: true, using: :btree
  add_index "salary_components", ["geography_id"], name: "index_salary_components_on_geography_id", using: :btree

  create_table "staffs", force: :cascade do |t|
    t.string   "code",         limit: 255,   default: ""
    t.string   "description",  limit: 255,   default: ""
    t.text     "definition",   limit: 65535
    t.integer  "staff_id",     limit: 4
    t.integer  "geography_id", limit: 4
    t.integer  "language_id",  limit: 4
    t.boolean  "state",                      default: true
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  add_index "staffs", ["code", "geography_id"], name: "index_staffs_on_code_and_geography_id", unique: true, using: :btree
  add_index "staffs", ["geography_id"], name: "index_staffs_on_geography_id", using: :btree
  add_index "staffs", ["language_id"], name: "index_staffs_on_language_id", using: :btree
  add_index "staffs", ["staff_id"], name: "index_staffs_on_staff_id", using: :btree

  create_table "supplies", force: :cascade do |t|
    t.string   "code",                 limit: 255,   default: ""
    t.string   "description",          limit: 255,   default: ""
    t.text     "definition",           limit: 65535
    t.integer  "supply_id",            limit: 4
    t.integer  "geography_id",         limit: 4
    t.integer  "language_id",          limit: 4
    t.boolean  "state",                              default: true
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.integer  "supplies_category_id", limit: 4
  end

  add_index "supplies", ["code", "geography_id"], name: "index_supplies_on_code_and_geography_id", unique: true, using: :btree
  add_index "supplies", ["geography_id"], name: "index_supplies_on_geography_id", using: :btree
  add_index "supplies", ["language_id"], name: "index_supplies_on_language_id", using: :btree
  add_index "supplies", ["supplies_category_id"], name: "index_supplies_on_supplies_category_id", using: :btree
  add_index "supplies", ["supply_id"], name: "index_supplies_on_supply_id", using: :btree

  create_table "supplies_categories", force: :cascade do |t|
    t.string   "code",         limit: 255,   default: ""
    t.string   "description",  limit: 255,   default: ""
    t.text     "definition",   limit: 65535
    t.integer  "geography_id", limit: 4
    t.integer  "language_id",  limit: 4
    t.boolean  "state",                      default: true
    t.integer  "user_id",      limit: 4
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  add_index "supplies_categories", ["code", "geography_id"], name: "index_supplies_categories_on_code_and_geography_id", unique: true, using: :btree
  add_index "supplies_categories", ["geography_id"], name: "index_supplies_categories_on_geography_id", using: :btree
  add_index "supplies_categories", ["language_id"], name: "index_supplies_categories_on_language_id", using: :btree
  add_index "supplies_categories", ["user_id"], name: "index_supplies_categories_on_user_id", using: :btree

  create_table "type_distributions", force: :cascade do |t|
    t.string   "code",         limit: 255, default: ""
    t.string   "description",  limit: 255, default: ""
    t.integer  "geography_id", limit: 4
    t.integer  "language_id",  limit: 4
    t.boolean  "state",                    default: true
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "type_distributions", ["code", "geography_id"], name: "index_type_distributions_on_code_and_geography_id", unique: true, using: :btree
  add_index "type_distributions", ["code", "language_id"], name: "index_type_distributions_on_code_and_language_id", unique: true, using: :btree
  add_index "type_distributions", ["geography_id"], name: "index_type_distributions_on_geography_id", using: :btree
  add_index "type_distributions", ["language_id"], name: "index_type_distributions_on_language_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",   null: false
    t.string   "encrypted_password",     limit: 255, default: "",   null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "full_name",              limit: 255, default: ""
    t.integer  "role",                   limit: 4
    t.integer  "geography_id",           limit: 4,   default: 1
    t.boolean  "state",                              default: true
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "avatar_file_name",       limit: 255
    t.string   "avatar_content_type",    limit: 255
    t.integer  "avatar_file_size",       limit: 4
    t.datetime "avatar_updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["geography_id"], name: "index_users_on_geography_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "care_levels", "geographies"
  add_foreign_key "care_levels", "languages"
  add_foreign_key "contract_types", "geographies"
  add_foreign_key "cost_centers", "cost_centers"
  add_foreign_key "cost_centers", "cost_distributions"
  add_foreign_key "cost_centers", "geographies"
  add_foreign_key "cost_centers", "languages"
  add_foreign_key "cost_centers", "staffs"
  add_foreign_key "cost_centers", "supplies"
  add_foreign_key "cost_distributions", "geographies"
  add_foreign_key "cost_distributions", "languages"
  add_foreign_key "distribution_areas", "cost_centers"
  add_foreign_key "distribution_areas", "entities"
  add_foreign_key "distribution_costs", "cost_centers"
  add_foreign_key "distribution_costs", "entities"
  add_foreign_key "distribution_overheads", "cost_centers"
  add_foreign_key "distribution_overheads", "entities"
  add_foreign_key "distribution_overheads", "supplies"
  add_foreign_key "distribution_overheads", "type_distributions"
  add_foreign_key "distribution_supplies", "cost_centers"
  add_foreign_key "distribution_supplies", "entities"
  add_foreign_key "distribution_supplies", "supplies"
  add_foreign_key "entities", "care_levels"
  add_foreign_key "entities", "geographies"
  add_foreign_key "entity_cost_centers", "cost_centers"
  add_foreign_key "entity_cost_centers", "entities"
  add_foreign_key "geographies", "users"
  add_foreign_key "income_definitions", "cost_centers"
  add_foreign_key "income_definitions", "entities"
  add_foreign_key "incomes", "cost_centers"
  add_foreign_key "incomes", "entities"
  add_foreign_key "labor_laws", "contract_types"
  add_foreign_key "labor_laws", "entities"
  add_foreign_key "labor_laws", "labor_standards"
  add_foreign_key "labor_laws", "staffs"
  add_foreign_key "labor_standards", "geographies"
  add_foreign_key "languages", "users"
  add_foreign_key "networks", "geographies"
  add_foreign_key "payrolls", "entities"
  add_foreign_key "payrolls", "labor_laws"
  add_foreign_key "production_cost_centers", "cost_centers"
  add_foreign_key "production_cost_centers", "entities"
  add_foreign_key "production_units", "geographies"
  add_foreign_key "production_units", "languages"
  add_foreign_key "programming_hours", "cost_centers"
  add_foreign_key "programming_hours", "entities"
  add_foreign_key "programming_hours", "payrolls"
  add_foreign_key "programming_hours", "salary_components"
  add_foreign_key "salary_components", "geographies"
  add_foreign_key "staffs", "geographies"
  add_foreign_key "staffs", "languages"
  add_foreign_key "staffs", "staffs"
  add_foreign_key "supplies", "geographies"
  add_foreign_key "supplies", "languages"
  add_foreign_key "supplies", "supplies"
  add_foreign_key "supplies", "supplies_categories"
  add_foreign_key "supplies_categories", "geographies"
  add_foreign_key "supplies_categories", "languages"
  add_foreign_key "supplies_categories", "users"
  add_foreign_key "type_distributions", "geographies"
  add_foreign_key "type_distributions", "languages"
  add_foreign_key "users", "geographies"
end
