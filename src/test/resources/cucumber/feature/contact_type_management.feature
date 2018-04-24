@OperatorV2 @ContactTypeManagement
Feature: Contact Type Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator should be able to create a new Contact Type on page Contact Type Management (uid:0eef79ec-1d12-4408-8971-5b122ed8c644)
    Given Operator go to menu Fleet -> Contact Type Management
    When Operator create new Contact Type on page Contact Type Management using data below:
      | name | GENERATED |
    Then Operator verify a new Contact Type is created successfully on page Contact Type Management
    When Operator delete Contact Type on page Contact Type Management using data below:
      | searchContactTypesKeyword | GET_FROM_CREATED_CONTACT_TYPE_NAME |
    Then Operator verify Contact Type is deleted successfully on page Contact Type Management

  Scenario: Operator should be able to update Contact Type on page Contact Type Management (uid:69e23778-83fb-49ad-9537-e0d2c49c4dcb)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Fleet -> Contact Type Management
    When Operator create new Contact Type on page Contact Type Management using data below:
      | name | GENERATED |
    Then Operator verify a new Contact Type is created successfully on page Contact Type Management
    When Operator update Contact Type on page Contact Type Management using data below:
      | searchContactTypesKeyword | GET_FROM_CREATED_CONTACT_TYPE_NAME |
      | name                      | GENERATED                          |
    Then Operator verify Contact Type is updated successfully on page Contact Type Management
    When Operator delete Contact Type on page Contact Type Management using data below:
      | searchContactTypesKeyword | GET_FROM_CREATED_CONTACT_TYPE_NAME |
    Then Operator verify Contact Type is deleted successfully on page Contact Type Management

  Scenario: Operator should be able to delete Contact Type on page Contact Type Management (uid:ca1f6e89-e5f7-4518-850e-06ad38afd602)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Fleet -> Contact Type Management
    When Operator create new Contact Type on page Contact Type Management using data below:
      | name | GENERATED |
    Then Operator verify a new Contact Type is created successfully on page Contact Type Management
    When Operator delete Contact Type on page Contact Type Management using data below:
      | searchContactTypesKeyword | GET_FROM_CREATED_CONTACT_TYPE_NAME |
    Then Operator verify Contact Type is deleted successfully on page Contact Type Management

  Scenario: Operator should be able to search Contact Type on page Contact Type Management (uid:a09c1ac5-c72b-4ef8-9977-a436cc82d414)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Fleet -> Contact Type Management
    When Operator create new Contact Type on page Contact Type Management using data below:
      | name | GENERATED |
    Then Operator verify a new Contact Type is created successfully on page Contact Type Management
    When Operator search Contact Type on page Contact Type Management using data below:
      | searchContactTypesKeyword | GET_FROM_CREATED_CONTACT_TYPE_NAME |
    Then Operator verify Contact Type is found on page Contact Type Management and contains correct info

  Scenario: Operator should be able to download Contact Type CSV file and verify the contents is correct on page Contact Type Management (uid:dba3191a-9cb1-4723-9eb8-d9bb58498b14)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Fleet -> Contact Type Management
    When Operator create new Contact Type on page Contact Type Management using data below:
      | name | GENERATED |
    When Operator download Contact Type CSV file on page Contact Type Management
    Then Operator verify Contact Type CSV file is downloaded successfully and contains correct info

  @KillBrowser
  Scenario: Kill Browser
    Given no-op
