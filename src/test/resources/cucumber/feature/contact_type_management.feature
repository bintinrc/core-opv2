@ContactTypeManagement @selenium @ShouldAlwaysRun
Feature: Contact Type Management

  @LaunchBrowser
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  Scenario: add contact type (uid:0eef79ec-1d12-4408-8971-5b122ed8c644)
    Given Operator go to menu Fleet -> Contact Type Management
    When contact type management, add contact type button is clicked
    When contact type management, add new contact type of "QA"
    Then contact type management, verify new contact type "QA" existed

  Scenario: search contact type (uid:a09c1ac5-c72b-4ef8-9977-a436cc82d414)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Fleet -> Contact Type Management
    When contact type management, search for "QA" contact type
    Then contact type management, verify contact type "QA" existed

  Scenario: edit contact type (uid:69e23778-83fb-49ad-9537-e0d2c49c4dcb)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Fleet -> Contact Type Management
    When contact type management, search for "QA" contact type
    When contact type management, edit contact type of "QA"
    Then contact type management, verify contact type "QA [EDITED]" existed

  Scenario: delete contact type (uid:ca1f6e89-e5f7-4518-850e-06ad38afd602)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Fleet -> Contact Type Management
    When contact type management, search for "QA [EDITED]" contact type
    When contact type management, delete contact type
    Then contact type management, verify contact type "QA [EDITED]" not existed

  @KillBrowser
  Scenario: Kill Browser
