class HomeController < ApplicationController
  def show
    @search_form = SearchForm.new
  end
end
