class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :create, :read, :update, :destroy, to: :crud

    user ||= User.new
    if user.is_global_administrator?
      can :manage, :all
    elsif user.is_basic_administrator?
      can :change_date, User
      can :change_entity, Entity
      can :change_network, Network
      can :select_date, User
      can :access_local_parametrization, User
      can :read, Entity
      can :associations, Entity
      can :create_associations, Entity
      can :destroy_associations, Entity
      can :access_cost_tool, User
      can :read, DistributionArea
      can :read, Payroll
      can :validate_dates_for_entity, Payroll
      can :read, ProgrammingHour
      can :read, DistributionSupply
      can :read, DistributionOverhead
      can :read, ProductionCostCenter
      can :read, DistributionCost
      can :read, Income
      can :access_analysis_and_graphs, User
      can :view_management_number_one, User
      can :view_management_number_two, User
      can :view_comparative_graphs, User
      can :access_multiple_analysis, User
    elsif user.is_level_two_local_administrator?
      can :get_third_level, Geography
      can :get_fourth_level, Geography
      can :get_fifth_level, Geography
      can :change_date, User
      can :change_entity, Entity
      can :change_network, Network
      can :select_date, User
      can :access_local_parametrization, User
      can :manage, SalaryComponent
      can :manage, Entity
      can :manage, Network
      can :manage, IncomeDefinition
      can :manage, LaborLaw
      can :access_cost_tool, User
      can :manage, DistributionArea
      can :manage, Payroll
      can :validate_dates_for_entity, Payroll
      can :manage, ProgrammingHour
      can :manage, DistributionSupply
      can :manage, DistributionOverhead
      can :manage, ProductionCostCenter
      can :manage, DistributionCost
      can :manage, Income
      can :access_analysis_and_graphs, User
      can :view_management_number_one, User
      can :view_management_number_two, User
      can :view_comparative_graphs, User
      can :access_multiple_analysis, User
    elsif user.is_level_one_local_administrator?
      can :get_third_level, Geography
      can :get_fourth_level, Geography
      can :get_fifth_level, Geography
      can :change_date, User
      can :change_entity, Entity
      can :change_network, Network
      can :select_date, User
      can :access_local_parametrization, User
      can :manage, SalaryComponent
      can :manage, Entity
      can :manage, Network
      can :manage, IncomeDefinition
      can :manage, LaborLaw
      can :access_cost_tool, User
      can :read, DistributionArea
      can :read, Payroll
      can :validate_dates_for_entity, Payroll
      can :read, ProgrammingHour
      can :read, DistributionSupply
      can :read, DistributionOverhead
      can :read, ProductionCostCenter
      can :read, DistributionCost
      can :read, Income
      can :access_analysis_and_graphs, User
      can :view_management_number_one, User
      can :view_management_number_two, User
      can :view_comparative_graphs, User
      can :access_multiple_analysis, User
    elsif user.is_level_three_manager?
      can :change_date, User
      can :change_entity, Entity
      can :change_network, Network
      can :select_date, User
      can :access_cost_tool, User
      can :manage, DistributionArea
      can :manage, Payroll
      can :validate_dates_for_entity, Payroll
      can :manage, ProgrammingHour
      can :manage, DistributionSupply
      can :manage, DistributionOverhead
      can :manage, ProductionCostCenter
      can :manage, DistributionCost
      can :manage, Income
      can :access_analysis_and_graphs, User
      can :view_management_number_one, User
      can :view_management_number_two, User
      can :view_comparative_graphs, User
      can :access_multiple_analysis, User
    elsif user.is_level_two_manager?
      can :change_network, Network
      can :change_entity, Entity
      can :select_date, User
      can :access_cost_tool, User
      can :access_analysis_and_graphs, User
      can :change_date, User
      can :manage, DistributionArea
      can :manage, Payroll
      can :validate_dates_for_entity, Payroll
      can :manage, ProgrammingHour
      can :manage, DistributionSupply
      can :manage, DistributionOverhead
      can :manage, ProductionCostCenter
      can :manage, DistributionCost
      can :manage, Income
      can :access_analysis_and_graphs, User
      can :view_management_number_one, User
      can :view_management_number_two, User
      can :view_comparative_graphs, User
      can :access_multiple_analysis, User
    elsif user.is_level_one_manager?
      can :change_date, User
      can :change_entity, Entity
      can :change_network, Network
      can :select_date, User
      can :access_analysis_and_graphs, User
      can :view_management_number_one, User
      can :view_management_number_two, User
      can :view_comparative_graphs, User
      can :access_multiple_analysis, User
      can :validate_dates_for_entity, Payroll
    elsif user.is_level_two_operator?
      can :change_network, Network
      can :change_entity, Entity
      can :select_date, User
      can :access_cost_tool, User
      can :access_analysis_and_graphs, User
      can :change_date, User
      can :manage, DistributionArea
      can :manage, Payroll
      can :validate_dates_for_entity, Payroll
      can :manage, ProgrammingHour
      can :manage, DistributionSupply
      can :manage, DistributionOverhead
      can :manage, ProductionCostCenter
      can :manage, DistributionCost
      can :manage, Income
      can :view_management_number_one, User
      can :view_management_number_two, User
      can :view_comparative_graphs, User
      can :access_multiple_analysis, User
    elsif user.is_level_one_operator?
      can :change_network, Network
      can :change_entity, Entity
      can :select_date, User
      can :change_date, User
      can :access_cost_tool, User
      can :manage, DistributionArea
      can :manage, Payroll
      can :validate_dates_for_entity, Payroll
      can :manage, ProgrammingHour
      can :manage, DistributionSupply
      can :manage, DistributionOverhead
      can :manage, ProductionCostCenter
      can :manage, DistributionCost
      can :manage, Income
      can :access_analysis_and_graphs, User
      can :view_management_number_one, User
      can :view_management_number_two, User
      can :view_comparative_graphs, User
      can :access_multiple_analysis, User
    else
      can :read, Geography
    end
  end

end