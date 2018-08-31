# Sinatra DSL
module Sinatra
  # Category Helper
  module CategoryHelper
    def find_categories
      param :limit, Integer, min: 1, max: 1000, default: 100
      param :offset, Integer, min: 0, max: 1000, default: 0
      categories = Category.limit(params[:limit]).offset(params[:offset]).order(name: :desc)
      [200, { status: 'success', data: { categories: categories } }.to_json]
    end
  end

  helpers CategoryHelper
end
