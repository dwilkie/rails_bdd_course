!SLIDE incremental

# Introduction to BDD in Rails
## David Wilkie
* ### [https://github.com/dwilkie/rails\_bdd\_course](https://github.com/dwilkie/rails_bdd_course)

!SLIDE center incremental

## Red, Green, Refactor

* ![Red, Green, Refactor](/images/red-green-refactor-diagram.gif)

!SLIDE center incremental

## Cucumber & RSpec

* ![BDD cycle in Rails](/images/bdd_rspec_cucumber.jpg)

!SLIDE center incremental

# Exercise
## Learn by doing!

* ![Mockup](/images/list_products.png)

!SLIDE commandline incremental

# Setup

    $ git clone git://github.com/dwilkie/rails_bdd_course.git
    $ cd rails_bdd_course/
    $ git checkout new_store
    $ cd store/

    Examining /home/dave/work/tmp/rails_bdd_course/store/.rvmrc complete.

    ================================================================
    = Trusting an .rvmrc file means that whenever you cd into the  =
    = directory RVM will execute this .rvmrc script in your shell  =
    =                                                              =
    = Now that you have examined the contents of the file, do you  =
    = wish to trust this .rvmrc from now on?                       =
    ================================================================

    (yes or no) > yes

!SLIDE commandline incremental

    $ bundle install --path vendor

    ...
    Your bundle is complete! It was installed into ./vendor

!SLIDE incremental

# Describing features with Cucumber
## Feature Definition

    # features/list_products.feature

    Feature: List Products
      In order to purchase the right product
      As a customer
      I want to browse products and see the price

!SLIDE incremental

## Scenario

    Scenario: List Products
      Given the following products exist
        | name   | price |
        | Abc    | 2.99  |
        | Angkor | 0.99  |
      When I go to the products page
      Then I should see "Products"
      And I should see "Name"
      And I should see "Price"
      And I should see "Abc" within "#product_1"
      And I should see "$2.99" within "#product_1"
      And I should see "Angkor" within "#product_2"
      And I should see "$0.99" within "#product_2"

!SLIDE commandline incremental

## Generate product model

    $ rails g model product
    invoke  active_record
    create    db/migrate/20110620051418_create_products.rb
    create    app/models/product.rb
    invoke    rspec
    create      spec/models/product_spec.rb

!SLIDE

## Add name and price to Migration

    # db/migration/*_create_products.rb

    def change
      create_table :products do |t|
        t.string  :name
        t.decimal :price

        t.timestamps
      end
    end

!SLIDE commandline incremental

## Migrate the db and clone structure to test db

    $ bundle exec rake db:migrate
    $ bundle exec rake db:test:clone

!SLIDE commandline incremental

## Start the Spork server and run the features

    $ bundle exec spork cuc
    $ bundle exec cucumber features/
    When I go to the products page
      Can't find mapping from "the products page" to a path.

!SLIDE

## Add the routes
    # config/routes.rb

    Store::Application.routes.draw do
      resources :products
      ...
    end

!SLIDE commandline incremental

## Run the features again

    $ bundle exec cucumber features/
    uninitialized constant ProductsController...

!SLIDE commandline incremental

## Generate the products controller

    $ rails g controller products

!SLIDE commandline incremental

## And again...

    $ bundle exec cucumber features/
    The action 'index' could not be found for ProductsController

!SLIDE

## Add the index action

    # app/controllers/products_controller.rb

    class ProductsController < ApplicationController
      def index
      end
    end

!SLIDE commandline incremental

## Run features

    $ bundle exec cucumber features/
    Missing template products/index

!SLIDE commandline incremental

## Add the missing template

    $ touch app/views/products/index.html.haml

!SLIDE commandline incremental

## Run features

    $ bundle exec cucumber features/
    When I go to the products page # passed!
    Then I should see "Products"
      expected there to be content "Products"

!SLIDE

## Enter RSpec

    Then I should see "Products"
      expected there to be content "Products"

* ![BDD Cycle in Rails](/images/bdd_rspec_cucumber.jpg)

!SLIDE

## Let's write a view spec...

    # spec/views/products/index.html.haml_spec.rb

    require 'spec_helper'
    describe "products/index.html.haml" do

      context "h1" do
        it "should be 'Products'" do
          render
          rendered.should have_selector(
            "h1", :text => "Products"
          )
        end
      end
    end

!SLIDE commandline incremental

## Boot Spork for RSpec

    $ bundle exec spork

!SLIDE commandline incremental

## Run the view spec

    $ bundle exec rspec --drb spec/views/
    expected css "h1" with text "Products" to return something

!SLIDE

## Write the code to make the spec pass

    # app/views/products/index.html.haml

    %h1
      Products

!SLIDE commandline incremental

## Run the view spec again

    $ bundle exec rspec --drb spec/views/
    1 example, 0 failures

!SLIDE commandline incremental

## Now run the features

    $ bundle exec cucumber features/
    When I go to the products page # passed!
    Then I should see "Products" # passed!
    And I should see "Name"
      expected there to be content "Name"

!SLIDE center

## We need a table with a 'Name' column

* ![Mockup](/images/list_products.png)

!SLIDE

## Back to RSpec

### Add an example for the table

    # spec/views/products/index.html.haml

    context "table" do
      it "should be displayed" do
        render
        rendered.should have_selector "table"
      end
    end

!SLIDE commandline incremental

## Run the spec

    $ bundle exec rspec --drb spec/views/
    expected css "table" to return something

!SLIDE

## Write the code to make the spec pass

    # app/views/products/index.html.haml

    %h1
      Products
    %table

!SLIDE commandline incremental

## Run the spec again

    $ bundle exec rspec --drb spec/views/
    2 examples, 0 failures

!SLIDE

## Add another example for the header row

    # spec/views/products/index.html.haml

    context "table" do
     ...
      context "table row" do
        context "header row" do
          it "should display 'Name'" do
            render
            rendered.should have_selector(
              "table tr th", :text => "Name"
            )
          end
        end
      end
    end

!SLIDE commandline incremental

## And run the spec again

    $ bundle exec rspec --drb spec/views/
    expected css "table tr th" with text "Name" to return something

!SLIDE

## And write the code to make it pass

    # app/views/products/index.html.haml

    %h1
      Products
    %table
      %tr
        %th
          Name

!SLIDE commandline incremental

## Run the spec again

    $ bundle exec rspec --drb spec/views/
    3 examples, 0 failures

!SLIDE commandline incremental

## Now run the features

    $ bundle exec cucumber features/
    When I go to the products page # passed!
    Then I should see "Products" # passed!
    And I should see "Name" # passed!
    And I should see "Price"
      expected there to be content "Price"

!SLIDE

## Add another example for the 'Price Column'

    # spec/views/products/index.html.haml

    context "header row" do
      it "should display 'Price'" do
        render
        rendered.should have_selector(
          "table tr th", :text => "Price"
        )
      end
    end

!SLIDE commandline incremental

## Run the spec

    $ bundle exec rspec --drb spec/views/
    expected css "table tr th" with text "Price" to return something

!SLIDE

## Write the code to make it pass

    # app/views/products/index.html.haml

    %h1
      Products
    %table
      %tr
        %th
          Name
        %th
          Price

!SLIDE commandline incremental

## Run the spec again

    $ bundle exec rspec --drb spec/views/
    4 examples, 0 failures

!SLIDE commandline incremental

## And run the features

    $ bundle exec cucumber features/
    When I go to the products page # passed!
    Then I should see "Products" # passed!
    And I should see "Name" # passed!
    And I should see "Price" # passed!
    And I should see "Abc" within "#product_1"
      Unable to find css "#product_1"

!SLIDE center

## Time to Refactor

* ![BDD cycle in Rails](/images/bdd_rspec_cucumber.jpg)

!SLIDE

## What is refactoring?

### "Refactoring is the process of changing a software system in such a way that it does not alter the external behavior of the code yet improves its internal structure." [Martin Fowler]

!SLIDE

## Keeping it DRY

    # spec/views/products/index.html.haml
    render
    rendered.should have_selector(
      "h1", :text => "Products"
    )

    render
    rendered.should have_selector "table"

    render
    rendered.should have_selector(
      "table tr th", :text => "Name"
    )

    render
    rendered.should have_selector(
      "table tr th", :text => "Price"
    )

!SLIDE

## RSpec Before Block

    before do
      # do something here...
    end

    before { render }

!SLIDE

## Helper Methods

    let(:parent_selector) { [] }

    def have_parent_selector(options = {})
      selector = parent_selector.join("/")
      selector = ".//" << selector
      have_selector :xpath, selector, options
    end

    context "h1" do
      before {parent_selector << "h1"}

      it "should be 'Products'" do
        rendered.should have_parent_selector(
          :text => "Products"
        )
      end
    end

!SLIDE

## Refactored Spec

    require 'spec_helper'

    describe "products/index.html.haml" do

      let(:parent_selector) { [] }

      def have_parent_selector(options = {})
        selector = parent_selector.join("/")
        selector = ".//" << selector
        have_selector :xpath, selector, options
      end

      before { render }

!SLIDE code

      context "h1" do
        before {parent_selector << "h1"}

        it "should be 'Products'" do
          rendered.should have_parent_selector(
            :text => "Products"
          )
        end
      end

      context "table" do
        before { parent_selector << "table" }

        it "should be displayed" do
          rendered.should have_parent_selector
        end

!SLIDE code

        context "table row" do
          before { parent_selector << "tr" }

          context "header row" do
            before { parent_selector << "th" }

            it "should display 'Name'" do
              rendered.should have_parent_selector(
                :text => "Name"
              )
            end

!SLIDE code

            it "should display 'Price'" do
              rendered.should have_parent_selector(
                :text => "Price"
              )
            end
          end
        end
      end
    end

!SLIDE commandline incremental

## Run the spec and features again to make sure we didn't break anything

    $ bundle exec rspec --drb spec/views/
    4 examples, 0 failure

    $ bundle exec cucumber features/
    When I go to the products page # passed!
    Then I should see "Products" # passed!
    And I should see "Name" # passed!
    And I should see "Price" # passed!
    And I should see "Abc" within "#product_1"
      Unable to find css "#product_1"

!SLIDE

## Add another example to view spec

    # spec/views/products/index.html.haml

    context "table" do
      # ...

      context "row for #product_1" do
        before do
          parent_selector << "tr[@id='product_1']"
        end

        it "should be displayed" do
          rendered.should have_parent_selector
        end
      end
    end

!SLIDE commandline incremental

## Run the spec

    $ bundle exec rspec --drb spec/views/
    expected xpath ".//table/tr[@id='product_1']" to return something

!SLIDE

## Add code to render the products

    # app/views/products/index.html.haml
    %h1
      Products
    %table
      %tr
        %th
          Name
        %th
          Price
      = render @products

!SLIDE commandline incremental

## Add the \_product partial

    $ touch app/views/products/_product.html.haml

!SLIDE

## And add the id to to the table row

    # app/views/products/_product.html.haml

    %tr{:id => "product_#{product_counter + 1}"}

!SLIDE commandline incremental

## Run the spec

    $ bundle exec rspec --drb spec/views/
    undefined method `model_name' for NilClass:Class
    # ./app/views/products/index.html.haml:9
    5 examples, 5 failures

!SLIDE

## What happened!? We broke all our tests!

### The failure occurred on line 9 because `@products` returns nil

### We need `@products` to return an enumerable of `Product` instances

### But we want to remain focussed on the view layer

!SLIDE

## RSpec Mocks

### Allow you to define a 'fake' model which will behave how you want

### Mocks allow you to keep your view specs isolated from changes in the model an controller layers

### `mock_model` is an rspec_rails function to create mocks for Rails models

!SLIDE

## RSpec `assigns`

### Sets up instance variables to use in your view specs

### E.g. `assigns(:products, [])` sets `@products` as an empty array

!SLIDE

## Add mocks and assign `@products` in view spec

    # spec/views/products/index.html.haml

    let(:abc) {
      mock_model(Product).as_null_object
    }

    let(:angkor) {
      mock_model(Product).as_null_object
    }

    before do
      assign(:products, [abc, angkor])
      render
    end

!SLIDE commandline incremental

## Run the spec

    $ bundle exec rspec --drb spec/views/
    5 examples, 0 failures

!SLIDE commandline incremental

## Run the features

    $ bundle exec cucumber features/
    When I go to the products page
      undefined method `model_name' for NilClass:Class

!SLIDE center

## Down the RSpec Stack

### We have a failing Cucumber scenario but a passing view spec
### We need to go down to the controller layer

* ![BDD cycle in Rails](/images/bdd_rspec_cucumber.jpg)

!SLIDE

## RSpec Controller Specs, Stubs & Message Expectations

### Controllers should know what to do but _not_ how to do it
### They are naturally interaction-based
### Specs make use of RSpec's stubs and message expectations which mock responses and assert that an objects receive messages

!SLIDE

## Our Example

### The controller should fetch all the products and assign them to `@products`

* ### Fake the response from `Product` to return an empty array
* ### Note: `scoped` is Rails 3 for `Product.all`

        Product.stub(:scoped).and_return([])

* ### Assert that the controller fetches all the products

        Product.should_receive(:scoped)

* ### Assert that the controller assigns them to `@products`

        assigns[:products].should == []

!SLIDE

## Add a controller spec

    # spec/controllers/products_controller_spec.rb
    require 'spec_helper'

    describe ProductsController do
      describe "GET /index" do

        let(:products) { [] }
        before do
          Product.stub(:scoped).and_return(
            products
          )
        end

!SLIDE code

        it "should fetch all the products" do
          Product.should_receive(:scoped)
          get :index
        end

        it "should assign @products" do
          get :index
          assigns[:products].should == products
        end
      end
    end

!SLIDE commandline incremental

## Run the controller spec

    $ bundle exec rspec --drb spec/controllers/
    2 examples, 2 failures

!SLIDE

## Write the code to make the spec pass

    # app/controllers/products_controller.rb

    def index
      @products = Product.scoped
    end

!SLIDE commandline incremental

## Run the spec

    $ bundle exec rspec --drb spec/controllers/
    2 examples, 0 failures

!SLIDE commandline incremental

## Run the features

    $ bundle exec cucumber features/
    When I go to the products page # passed!
    Then I should see "Products" # passed!
    And I should see "Name" # passed!
    And I should see "Price" # passed!
    And I should see "Abc" within "#product_1"
      expected there to be content "Abc" in ""

!SLIDE

## Back to the view spec

    # spec/views/products/index.html.haml_spec.rb

    context "row for #product_1" do
      # ...

      context "table data" do
        before { parent_selector << "td" }

        it "should contain 'Abc'" do
          rendered.should have_parent_selector(
            :text => "Abc"
          )
        end
      end
    end

!SLIDE commandline incremental

## Run the view spec

    $ bundle exec rspec --drb spec/views/
    expected xpath ".//table/tr[@id='product_1']/td" with text "Abc" to return something

!SLIDE

## Add the code to make the spec pass

    # app/views/products/_product.html.haml

    %tr{:id => "product_#{product_counter + 1}"}
      %td
        = product.name

!SLIDE commandline incremental

## Run the view spec

    $ bundle exec rspec --drb spec/views/
    expected xpath ".//table/tr[@id='product_1']/td" with text "Abc" to return something

!SLIDE

## Debugging

### We're stuck. Our new code didn't make the spec pass.
### Let's debug

!SLIDE

## Edit the view spec

    # spec/views/products/index.html.haml_spec.rb

    it "should contain 'Abc'" do
      p rendered
      rendered.should have_parent_selector(
        :text => "Abc"
      )
    end

!SLIDE commandline incremental

## Run the view spec again

    $ bundle exec rspec --drb spec/views/
    <tr id='product_1'>\n<td>\nProduct_#&lt;RSpec...</td>\n</tr>
    expected xpath ".//table/tr[@id='product_1']/td" with text "Abc" to return something

!SLIDE

## Mocks Revisited

### In our view spec we mock out our `Product` object using `mock_model(Product)`
### But what is `.as_null_object`?
### `.as_null_object` tells the mock to ignore messages that it's not expecting and just return something
### In our case the `Product` mock is not expecting `.name` so it returns 'Product_#&lt;RSpec...' which is what we saw from our output
### `mock_model` also accepts a hash of method/return values which we can use to return the product's name

    mock_model(Product, :name => "Abc")

!SLIDE

## Stub

