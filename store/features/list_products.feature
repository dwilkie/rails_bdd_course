Feature: List Products
  In order to purchase the right product
  As a customer
  I want to browse products and see detailed information

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

