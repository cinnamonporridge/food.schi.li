# Permitted locales available for the application
I18n.available_locales = [:en, :de]

# Set default locale to something other than :en
I18n.default_locale = :en

module I18n
  def self.available_locales_options
    I18n.available_locales.map do |locale|
      [I18n.t("shared.available_locales", locale:)[locale], locale.to_s]
    end.sort_by(&:first)
  end
end
