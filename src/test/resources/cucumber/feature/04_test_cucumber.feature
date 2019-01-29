@04TestCucumber
Feature: Test Cucumber
  Dedicated feature files that contains scenario to test Cucumber API
  compatibility when we update the Cucumber version.

  Scenario: Test Cucumber API
    Given Test Map parameter:
      | id   | 1      |
      | name | Test 1 |
    Given Test DataTable parameter:
      | id   | 2      |
      | name | Test 2 |
    Given Test int parameter: 1234
    Given Test RegEx decimal to long: 5678
    Given Test combination parameters 1 -> name = "Cucumber", ID = 9012, other parameters:
      | id   | 3      |
      | name | Test 3 |
