class ProductsController < ApplicationController
  def index
    @products = Product.scoped
  end
end

