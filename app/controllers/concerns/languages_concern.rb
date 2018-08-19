module LanguagesConcern extend ActiveSupport::Concern

def get_current_idiom
  I18n.locale.to_s.split('_')[0]
end

end