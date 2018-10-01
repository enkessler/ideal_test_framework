Feature: Feature 3


  Scenario: Failing test 1
    * fail

  Scenario Outline: An outline
    * pass
    Examples: missing id column
      | param |
      | foo   |
    Examples: missing id value
      | param | test_case_id |
      | bar   |              |
