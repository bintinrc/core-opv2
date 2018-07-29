@OperatorV2Disabled @ShipmentScanning @ShouldAlwaysRun
Feature: Shipment Scanning

  @LaunchBrowser
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Scan order to shipment (uid:b776b582-a395-4a02-962a-9785f6945750)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment with Start Hub 30JKB, End hub DOJO and comment Created by feature @ShipmentScanning.
    Given Operator go to menu Inter-Hub -> Shipment Scanning
    When Operator scan the created order to shipment in hub 30JKB

  @KillBrowser
  Scenario: Kill Browser
    Given no-op
