@MileZero @B2B
Feature: Corporate Shipper

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2 go to menu all shipper
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCorporateSubShipper
  Scenario: View master shipper settings (uid:86b71c08-dc9a-45e8-8d25-8acc9b3c4de5)
    Given API Operator get b2b sub shippers for master shipper id "{operator-b2b-master-shipper-id}"
    And API Operator delete corporate sub shippers
    When Operator edits shipper "{operator-b2b-master-shipper-legacy-id}"
    Then Operator verifies shipper type is "Corporate HQ" on Edit Shipper page
    When Operator go to "More Settings" tab on Edit Shipper page
    When Operator go to "Integrations" tab on Edit Shipper page
    When Operator go to "Sub shippers Default Setting" tab on Edit Shipper page
    When Operator go to "Marketplace Sellers (Sub Shippers)" tab on Edit Shipper page
    Then hint "Page disabled for normal and marketplace seller shipper types." is displayed on Edit Shipper page
    When Operator go to "Corporate sub shippers" tab on Edit Shipper page
    And Operator create corporate sub shipper with data below:
      | branchId | generated |
      | name     | generated |
      | email    | generated |
    Then Operator verifies corporate sub shipper is created

  @CloseNewWindows
  Scenario: View sub shippers settings (uid:c4bfb504-6eef-4809-8d47-c2d819264e6f)
    Given API Operator get b2b sub shippers for master shipper id "{operator-b2b-master-shipper-id}"
    And API Operator delete corporate sub shippers
    When Operator edits shipper "{operator-b2b-master-shipper-legacy-id}"
    When Operator go to "Corporate sub shippers" tab on Edit Shipper page
    And Operator create corporate sub shipper with data below:
      | branchId | generated |
      | name     | generated |
      | email    | generated |
    Then Operator verifies corporate sub shipper is created
    When Operator click edit action button for first corporate sub shipper
    Then Operator verifies corporate sub shipper details page is displayed
    And Operator verifies shipper type is "Corporate Branch" on Edit Shipper page
    When Operator go to "Sub shippers Default Setting" tab on Edit Shipper page
    Then hint "No Settings required for normal and Corporate Branch shipper types." is displayed on Edit Shipper page
    When Operator go to "Marketplace Sellers (Sub Shippers)" tab on Edit Shipper page
    Then hint "Page disabled for normal and marketplace seller shipper types." is displayed on Edit Shipper page
    When Operator go to "Corporate sub shippers" tab on Edit Shipper page
    Then hint "Page available for Corporate HQ shipper only." is displayed on Edit Shipper page

  Scenario: Create more than 1 sub shipper on shipper settings (uid:fa95a3b5-88e9-4d80-b87f-f25b7739f362)
    Given API Operator get b2b sub shippers for master shipper id "{operator-b2b-master-shipper-id}"
    And API Operator delete corporate sub shippers
    When Operator edits shipper "{operator-b2b-master-shipper-legacy-id}"
    When Operator go to "Corporate sub shippers" tab on Edit Shipper page
    And Operator create corporate sub shippers with data below:
      | branchId  | name      | email     |
      | generated | generated | generated |
      | generated | generated | generated |
    Then Operator verifies corporate sub shippers are created

  Scenario: Create more than 1 sub shipper with the same branch ID on shipper settings (uid:fc5fe78f-520d-4ddd-ab78-dcdf0e9375d2)
    Given API Operator get b2b sub shippers for master shipper id "{operator-b2b-master-shipper-id}"
    And API Operator delete corporate sub shippers
    When Operator edits shipper "{operator-b2b-master-shipper-legacy-id}"
    When Operator go to "Corporate sub shippers" tab on Edit Shipper page
    And Operator create corporate sub shippers with data below:
      | branchId | name      | email     |
      | 12345    | generated | generated |
      | 12345    | generated | generated |
    Then Operator verifies error message "Branch ID already exists." is displayed on b2b management page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
