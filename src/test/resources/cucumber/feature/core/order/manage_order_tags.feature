@OperatorV2 @Core @Order @ManageOrderTags
Feature: Manage Order Tags

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrderTags
  Scenario: Operator Create Order Tag (uid:311e1903-de57-4661-b73f-c720700b6865)
    Given Operator go to menu Order -> Manage Order Tags
    When Operator create new route tag on Manage Order Tags page:
      | name        | AAA                                                                               |
      | description | This tag is created by Automation Test for testing purpose only. Ignore this tag. |
    Then Operator verify the new tag is created successfully on Manage Order Tags page

  @DeleteOrderTags
  Scenario: Operator Delete Order Tag (uid:5b49c448-d472-4eef-a1a2-2a84b6f8e608)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new order tag:
      | name        | AAA                                                                               |
      | description | This tag is created by Automation Test for testing purpose only. Ignore this tag. |
    When Operator go to menu Order -> Manage Order Tags
    And Operator deletes created tag on Manage Order Tags page
    Then Operator verifies that success toast displayed:
      | top | 1 Order Tag Deleted |
    And Operator verifies that created tag has been deleted on Manage Order Tags page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op