module ApplicationHelper
  include Pagy::Frontend

  def nav_link_to(text, path)
    link_to text, path, class: (path.include?(params[:controller]) ? 'active' : nil).to_s
  end

  def heroicon(name)
    Rails.root.join('app/assets/images/heroicons/', name.to_s).sub_ext('.svg').read
  end
end
