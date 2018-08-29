module AnalysisNetworksHelper

  def analysis_networks_geographies(countries)    
    if countries.present?
      if countries.size == 1
        html = "<h3 class='text-center'>#{countries.first.description}</h3>".html_safe
      else
        html = select_tag 'countries', options_for_select(countries.collect{|u| [u.description, u.numerical_code] }),
                  class: 'form-control select2', id: 'countries_analysis_networks', include_blank: true
      end
    else
      html = '<h3 class="text-center">No hay un pais disponible</h3>'.html_safe
    end
  end

end
