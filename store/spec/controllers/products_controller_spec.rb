require 'spec_helper'

describe ProductsController do
  describe "GET /products" do

    def do_index
      get :index
    end

    let(:products) { [] }
    before { Product.stub(:scoped).and_return(products) }

    it "should get the products" do
      Product.should_receive(:scoped)
      do_index
    end

    it "should assign @products" do
      do_index
      assigns[:products].should == products
    end
  end
end

