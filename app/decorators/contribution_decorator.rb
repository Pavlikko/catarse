class ContributionDecorator < Draper::Decorator
  decorates :contribution
  include Draper::LazyHelpers

  def display_description
    render({
      partial: "projects/contributions/#{source.anonymous? ? 'anonymous_' : ''}description",
      locals: {contribution: source}
    })
  end

  def display_value
    number_to_currency source.value
  end

  def display_confirmed_at
    I18n.l(source.confirmed_at.to_date) if source.confirmed_at
  end
end

