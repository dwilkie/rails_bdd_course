class Product < ActiveRecord::Base
  def cheap?
    price < 1.00
  end
end

