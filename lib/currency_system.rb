module CurrencySystem
  CURRENCIES = {
    'CHF'    => 'CHF',
    'EUR'    => '€',
    'USD'    => '$',
    'GBP'    => '£'
  }

  CURRENCY_NAMES = CURRENCIES.keys + CURRENCIES.keys.map(&:downcase)

  def currency_field(form, field, selected = nil)
    unless selected.blank?
      form.select(field, CURRENCIES.invert, :selected => selected)
    else
      form.select(field, CURRENCIES.invert)
    end
  end

  def currency_sign(key)
    CURRENCIES[key]
  end

  # available as ActionView helper methods.
  def self.included(base)
    base.send :helper_method, :currency_field, :currency_sign if base.respond_to? :helper_method
  end
end
