@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentWeightDimension @SearchWeightAndDimension @CWF
Feature: Search Weight and Dimension

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Search without input Shipment ID
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    When Operator click on Shipment Weight Dimension New Record button
    Then Operator verify Shipment Weight Dimension Add UI
    | state | initial |
    When Operator click Shipment Weight Dimension search button
    Then Operator verify Shipment Weight Dimension Add UI
    | state   | error                         |
    | message | Shipment ID must not be empty |


  @RT
  Scenario: Search with invalid input Shipment ID
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
    Then Operator verify Shipment Weight Dimension page UI
    When Operator click on Shipment Weight Dimension New Record button
    Then Operator verify Shipment Weight Dimension Add UI
      | state | initial |
    When Operator enter "Invalid" shipment ID on Shipment Weight Dimension
    And Operator click Shipment Weight Dimension search button
    Then Operator verify Shipment Weight Dimension Add UI
      | state   | error                     |
      | message | Shipment ID is not found  |
    Then Operator verify toast message "Request failed with status code 404" is shown in Shipment Weight Dimension Add UI





  @KillBrowser
  Scenario: Kill Browser
    Given no-op
