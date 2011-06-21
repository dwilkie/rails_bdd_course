require 'spec_helper'

describe "products/index.html.haml" do

  let(:parent_selector) { [] }
  let(:abc) { mock_model(Product, :name => "Abc", :price => 2.99, :cheap? => false).as_null_object }
  let(:angkor) { mock_model(Product, :name => "Angkor", :price => 0.99, :cheap? => true).as_null_object }

  before do
    assign(:products, [abc, angkor])
    render
  end

  def have_parent_selector(options = {})
    selector = parent_selector.join("/")
    selector = ".//" << selector
    have_selector :xpath, selector, options
  end

  context "h1" do

    before {parent_selector << "h1"}

    it "should be 'Products'" do
      rendered.should have_parent_selector :text => "Products"
    end
  end

  context "table" do
    before { parent_selector << "table[@id = 'products']" }

    it "should be displayed" do
      rendered.should have_parent_selector
    end

    context "table row" do
      before { parent_selector << "tr" }

      context "header row" do
        before { parent_selector << "th" }

        it "should display 'Name'" do
          rendered.should have_parent_selector :text => "Name"
        end

        it "should display 'Price'" do
          rendered.should have_parent_selector :text => "Price"
        end
      end
    end

    context "row for #product_1" do
      before { parent_selector << "tr[@id='product_1' and not(@class)]" }

      it "should be displayed" do
        rendered.should have_parent_selector
      end

      context "table data" do
        before { parent_selector << "td" }

        it "should contain 'Abc'" do
          rendered.should have_parent_selector :text => "Abc"
        end

        it "should contain '$2.99'" do
          rendered.should have_parent_selector :text => "$2.99"
        end

      end
    end

    context "row for #product_2" do
      before { parent_selector << "tr[@id='product_2' and @class='cheap']" }

      it "should be displayed" do
        rendered.should have_parent_selector
      end

    end

  end

end

