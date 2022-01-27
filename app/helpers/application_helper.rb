module ApplicationHelper
  include Pagy::Frontend

  def nav_link_current_classes(path)
    return 'nav-link--current' if path.include?(params[:controller])
  end

  def fontawesome(name)
    Rails.root.join('app/assets/images/fontawesome/', name.to_s).sub_ext('.svg').read
  end
end
