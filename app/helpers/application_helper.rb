module ApplicationHelper
  include Pagy::Frontend

  def nav_link_current_classes(path)
    'nav-link--current' if path.include?(params[:controller])
  end
end
