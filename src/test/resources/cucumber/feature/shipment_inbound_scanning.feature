@OperatorV2 @OperatorV2Part2 @ShipmentInboundScanning @Shipment @MiddleMile
Feature: Shipment Inbound Scanning

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment
  Scenario: Shipment inbound to van (uid:eed4a9d2-45c9-4b77-9b71-f88ff1423f0f)
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {hub-name} on Shipment Inbound Scanning page
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator filter Shipment Status = Transit on Shipment Management page
    When Operator filter Last Inbound Hub = {hub-name} on Shipment Management page
    When Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page

  @DeleteShipment
  Scenario: Shipment inbound to transit hub (uid:12758688-5e0d-4121-9b27-e11765138648)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given Operator go to menu Inter-Hub -> Shipment Scanning
    When Operator scan the created order to shipment in hub {hub-name}
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {hub-name} on Shipment Inbound Scanning page
    Given Operator go to menu Shipper Support -> Blocked Dates
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Hub in hub {hub-name} on Shipment Inbound Scanning page
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator filter Shipment Status = Transit on Shipment Management page
    When Operator filter Last Inbound Hub = {hub-name} on Shipment Management page
    When Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page

  @DeleteShipment
  Scenario: Shipment inbound to destination hub (uid:595ea161-b4a0-4490-b4c2-e439f2bd6293)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Hub in hub {hub-name-2} on Shipment Inbound Scanning page
    When Operator go to menu Inter-Hub -> Shipment Management
    When Operator filter Shipment Status = Completed on Shipment Management page
    When Operator filter Last Inbound Hub = {hub-name-2} on Shipment Management page
    When Operator click "Load All Selection" on Shipment Management page
    Then Operator verify inbounded Shipment exist on Shipment Management page

#  Scenario: Change end date when inbound scanning (uid:6efa9d01-49d8-4515-b924-5805d34d587a)
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    When API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
#    When Operator go to menu Inter-Hub -> Shipment Scanning
#    When Operator scan the created order to shipment in hub {hub-name}
#    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
#    When Operator inbound scanning Shipment Into Van in hub {hub-name} on Shipment Inbound Scanning page
#    When Operator change End Date on Shipment Inbound Scanning page
#    When Operator go to menu Inter-Hub -> Shipment Management
#    When Operator filter Shipment Status = Transit on Shipment Management page
#    When Operator filter Last Inbound Hub = {hub-name} on Shipment Management page
#    When Operator click "Load All Selection" on Shipment Management page
#    Then Operator verify inbounded Shipment exist on Shipment Management page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
