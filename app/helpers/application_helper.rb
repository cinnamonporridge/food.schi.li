module ApplicationHelper
  include Pagy::Frontend

  def nav_link_to(text, path)
    link_to text, path, class: (path.include?(params[:controller]) ? 'active' : nil).to_s
  end
end
