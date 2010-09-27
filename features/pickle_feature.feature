Feature: Example of the pickle steps, testing with different combinations of orm and factory

  Scenario Outline:
    Given an example <ORM>/<FACTORY> app
    And a pickle config:
      """
      Pickle.config.map_label_for 'user', :to => 'name'
      """
      
    Then the following steps should pass:
      """
      Given a user "Fred"
      And 2 users with name: "not labelled"
      And the following users:
        | user  | name      |
        | Betty | Elizabeth |
        | Liz   | Elizabeth |
  
      Then "Fred" should be the 1st user
      
      # note that single quoted string is used below, because "Fred" will cause pickle to return the user "Fred"
      And "Fred"'s name should be 'Fred'
  
      Then there should be at least 2 users with name: "not labelled"
      And the 2nd last user should be the 2nd user
      And the last user should be the 3rd user
      And last user's name should be the same as the 3rd user's name
  
      And "Betty" should be the 4th user
      And "Betty"'s name should be "Elizabeth"
      And "Liz" should be the 5th user
      And the user "Liz"'s name should be 'Elizabeth'
      And the user "Liz"'s name should be the user: "Betty"'s name
  
      But "Fred"'s name should not be the same as "Betty"'s name
      """
      
  Examples:
    | ORM           | FACTORY      |
    | active_record | machinist    |
    | active_record | factory_girl |
    | active_record | orm          |
    | data_mapper   | machinist    |
    | data_mapper   | factory_girl |
    | data_mapper   | orm          |
    | mongoid       | machinist    |
    | mongoid       | factory_girl |
    | mongoid       | orm          |