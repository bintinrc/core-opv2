@OperatorV2Disabled @ShipmentScanning @ShouldAlwaysRun
Feature: Shipment Scanning

  @LaunchBrowser
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Scan order to shipment (uid:b776b582-a395-4a02-962a-9785f6945750)
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"C2C", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":1 } |
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment with Start Hub 30JKB, End hub DOJO and comment Created by feature @ShipmentScanning.
    Given Operator go to menu Inter-Hub -> Shipment Scanning
    When Operator scan the created order to shipment in hub 30JKB

  @KillBrowser
  Scenario: Kill Browser
    Given no-op
