@MileZero @B2B @target
Feature: B2B Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: View list of master shipper (uid:921e8a50-6f50-4f25-a4fe-544f0b38661e)
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    When Operator go to menu Shipper -> B2B Management
    And API Operator get b2b master shippers
    Then QA verify b2b management page is displayed
    And QA verify correct master shippers are displayed on b2b management page

  Scenario Outline: Search master shipper by name (uid:45f8d624-d652-4c1d-ad54-70e849f6ec08)
    Given QA verify b2b management page is displayed
    Given Operator clear search fields on b2b management page
    When Operator fill name search field with "<searchValue>" on b2b management page
    Then QA verify master shippers with name contains "<searchValue>" is displayed on b2b management page

    Examples:
      | searchValue                        | hiptest-uid                              |
      | {operator-b2b-master-shipper-name} | uid:d32e9751-c5ed-41c6-a2c0-d8f3ad74bf85 |

  Scenario Outline: Search master shipper by email (uid:58a96bac-9a11-4a9a-a473-9d40f82958b2)
    Given QA verify b2b management page is displayed
    Given Operator clear search fields on b2b management page
    When Operator fill email search field with "<searchValue>" on b2b management page
    Then QA verify master shippers with email contains "<searchValue>" is displayed on b2b management page

    Examples:
      | searchValue                         | hiptest-uid                              |
      | {operator-b2b-master-shipper-email} | uid:9b7f113a-6f3a-473e-9e28-00c1046ec60a |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op