module LanguagesHelper

  #
  def get_current_idiom
    Language.where(abbreviation: I18n.locale.to_s.split('_')[0]).first.id
  end

end
