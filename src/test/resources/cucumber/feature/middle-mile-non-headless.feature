@ShipmentManagement @Shipment @ForceNotHeadless @MiddleMileNonHeadless
Feature: Shipment Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment
  Scenario: Print Master AWB (uid:6edf77ea-9bd7-49f5-a9e5-d520fd5d1a73)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment on Shipment Management page using data below:
      | origHubName | {hub-name}                                                          |
      | destHubName | {hub-name-2}                                                        |
      | comments    | Created by @ShipmentManagement at {gradle-current-date-yyyy-MM-dd}. |
    Given API Operator put created parcel to shipment
    When Operator click "Load All Selection" on Shipment Management page
    And Operator open the Master AWB of the created shipment on Shipment Management Page
    Then Operator verify the the master AWB is opened
    Given API Operator download the Shipment AWB PDF
    Then Operator verify that the data consist is correct

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
