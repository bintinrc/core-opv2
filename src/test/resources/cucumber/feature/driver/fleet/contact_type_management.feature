@OperatorV2 @Fleet @OperatorV2Part1 @ContactTypeManagement @Saas
Feature: Contact Type Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteContactTypes
  Scenario: Create New Contact Type (uid:567ed49b-0506-407f-a2ee-d5b357c9a12f)
    Given Operator go to menu Fleet -> Contact Type Management
    When Operator create new Contact Type on page Contact Type Management using data below:
      | name | GENERATED |
    Then Operator verify a new Contact Type is created successfully on page Contact Type Management

  @DeleteContactTypes
  Scenario: Update Contact Type (uid:e9659eed-89b4-4677-902d-f9ca439df862)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Fleet -> Contact Type Management
    When Operator create new Contact Type on page Contact Type Management using data below:
      | name | GENERATED |
    Then Operator verify a new Contact Type is created successfully on page Contact Type Management
    And Operator update Contact Type on page Contact Type Management using data below:
      | searchContactTypesKeyword | {KEY_CONTACT_TYPE.name} |
      | name                      | GENERATED               |
    Then Operator verify Contact Type is updated successfully on page Contact Type Management

  @DeleteContactTypes
  Scenario: Delete Contact Type (uid:b608fbb0-b420-4c60-a398-01503d79b2cb)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Fleet -> Contact Type Management
    When Operator create new Contact Type on page Contact Type Management using data below:
      | name | GENERATED |
    Then Operator verify a new Contact Type is created successfully on page Contact Type Management
    When Operator delete Contact Type on page Contact Type Management using data below:
      | searchContactTypesKeyword | {KEY_CONTACT_TYPE.name} |
    Then Operator verify Contact Type is deleted successfully on page Contact Type Management

  @DeleteContactTypes
  Scenario: Search Contact Type (uid:e6e64225-fb24-49dd-b826-5f49b14da148)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Fleet -> Contact Type Management
    When Operator create new Contact Type on page Contact Type Management using data below:
      | name | GENERATED |
    Then Operator verify a new Contact Type is created successfully on page Contact Type Management
    When Operator search Contact Type on page Contact Type Management using data below:
      | searchContactTypesKeyword | {KEY_CONTACT_TYPE.name} |
    Then Operator verify Contact Type is found on page Contact Type Management and contains correct info

  @DeleteContactTypes
  Scenario: Download CSV File of Contact Type (uid:b968a978-534c-4714-b325-16b5437920ad)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Fleet -> Contact Type Management
    When Operator create new Contact Type on page Contact Type Management using data below:
      | name | GENERATED |
    When Operator download Contact Type CSV file on page Contact Type Management
    Then Operator verify Contact Type CSV file is downloaded successfully and contains correct info

  @KillBrowser
  Scenario: Kill Browser
    Given no-op