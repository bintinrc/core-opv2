@OperatorV2Disabled @ShipmentInboundScanning
Feature: Shipment Inbound Scanning

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Shipment inbound to van (uid:eed4a9d2-45c9-4b77-9b71-f88ff1423f0f)
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment with Start Hub 30JKB, End hub DOJO and comment Created by feature @ShipmentInboundScanning.
    When Operator go to menu Inter-Hub -> Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub 30JKB on Shipment Inbound Scanning page
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator filter Shipment Status = Transit on Shipment Management page
    When Operator filter Last Inbound Hub = 30JKB on Shipment Management page
    When Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page
    When Operator click Scans button on Shipment Management page
    Then Operator scan Shipment with source VAN_INBOUND in hub 30JKB on Shipment Management page
    When Operator click Delete button on Shipment Management page
    Then Operator verify the Shipment is deleted successfully
    Then Operator click Edit filter on Shipment Management page
    Then Operator clear all filters on Shipment Management page

  Scenario: Shipment inbound to transit hub (uid:12758688-5e0d-4121-9b27-e11765138648)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment with Start Hub 30JKB, End hub DOJO and comment Created by feature @ShipmentInboundScanning.
    When Operator go to menu Inter-Hub -> Inbound Scanning
    When Operator inbound scanning Shipment Into Hub in hub EASTGW on Shipment Inbound Scanning page
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator filter Shipment Status = Transit on Shipment Management page
    When Operator filter Last Inbound Hub = EASTGW on Shipment Management page
    When Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page
    When Operator click Scans button on Shipment Management page
    Then Operator scan Shipment with source HUB_INBOUND in hub EASTGW on Shipment Management page
    When Operator click Delete button on Shipment Management page
    Then Operator verify the Shipment is deleted successfully
    Then Operator click Edit filter on Shipment Management page
    Then Operator clear all filters on Shipment Management page

  Scenario: Shipment inbound to destination hub (uid:595ea161-b4a0-4490-b4c2-e439f2bd6293)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment with Start Hub 30JKB, End hub DOJO and comment Created by feature @ShipmentInboundScanning.
    When Operator go to menu Inter-Hub -> Inbound Scanning
    When Operator inbound scanning Shipment Into Hub in hub DOJO on Shipment Inbound Scanning page
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator filter Shipment Status = Completed on Shipment Management page
    When Operator filter Last Inbound Hub = DOJO on Shipment Management page
    When Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page
    When Operator click Scans button on Shipment Management page
    Then Operator scan Shipment with source HUB_INBOUND in hub DOJO on Shipment Management page
    When Operator click Delete button on Shipment Management page
    Then Operator verify the Shipment is deleted successfully
    Then Operator click Edit filter on Shipment Management page
    Then Operator clear all filters on Shipment Management page

  Scenario: Change end date when inbound scanning (uid:6efa9d01-49d8-4515-b924-5805d34d587a)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator create Shipment with Start Hub 30JKB, End hub DOJO and comment Created by feature @ShipmentInboundScanning.
    When Operator go to menu Inter-Hub -> Shipment Scanning
    When Operator scan the created order to shipment in hub 30JKB
    When Operator go to menu Inter-Hub -> Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub 30JKB on Shipment Inbound Scanning page
    When Operator change End Date on Shipment Inbound Scanning page
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator filter Shipment Status = Transit on Shipment Management page
    When Operator filter Last Inbound Hub = 30JKB on Shipment Management page
    When Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page
    When Operator click Scans button on Shipment Management page
    Then Operator scan Shipment with source VAN_INBOUND in hub 30JKB on Shipment Management page
    When Operator click Delete button on Shipment Management page
    Then Operator verify the Shipment is deleted successfully
    Then Operator click Edit filter on Shipment Management page
    Then Operator clear all filters on Shipment Management page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
