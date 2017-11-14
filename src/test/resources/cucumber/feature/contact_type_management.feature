@ContactTypeManagement @selenium
Feature: Contact Type Management

  @LaunchBrowser @ContactTypeManagement#01
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  @ContactTypeManagement#01
  Scenario: add contact type (uid:0eef79ec-1d12-4408-8971-5b122ed8c644)
    Given op click navigation Contact Type Management in Fleet
    When contact type management, add contact type button is clicked
    When contact type management, add new contact type of "QA"
    Then contact type management, verify new contact type "QA" existed

  @ContactTypeManagement#01
  Scenario: search contact type (uid:a09c1ac5-c72b-4ef8-9977-a436cc82d414)
    Given op click navigation Blocked Dates in Shipper Support
    Given op click navigation Contact Type Management in Fleet
    When contact type management, search for "QA" contact type
    Then contact type management, verify contact type "QA" existed

  @ContactTypeManagement#01
  Scenario: edit contact type (uid:69e23778-83fb-49ad-9537-e0d2c49c4dcb)
    Given op click navigation Blocked Dates in Shipper Support
    Given op click navigation Contact Type Management in Fleet
    When contact type management, search for "QA" contact type
    When contact type management, edit contact type of "QA"
    Then contact type management, verify contact type "QA [EDITED]" existed

  @ContactTypeManagement#01
  Scenario: delete contact type (uid:ca1f6e89-e5f7-4518-850e-06ad38afd602)
    Given op click navigation Blocked Dates in Shipper Support
    Given op click navigation Contact Type Management in Fleet
    When contact type management, search for "QA [EDITED]" contact type
    When contact type management, delete contact type
    Then contact type management, verify contact type "QA [EDITED]" not existed

  @KillBrowser @ContactTypeManagement#01
  Scenario: Kill Browser
