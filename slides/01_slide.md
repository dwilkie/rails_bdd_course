!SLIDE incremental

# Introduction to BDD in Rails
## David Wilkie
* ### [https://github.com/dwilkie/rails\_bdd\_course](https://github.com/dwilkie/rails_bdd_course)

!SLIDE center incremental

# Exercise
## Learn by doing!

* ![Mockup](/mockups/images/list_products.png)

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

    $ rails g model product

