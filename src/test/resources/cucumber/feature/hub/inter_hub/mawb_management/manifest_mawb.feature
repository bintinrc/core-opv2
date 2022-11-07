@OperatorV2 @MiddleMile @Hub @InterHub @mawbManagement @ManifestMAWB @CWF
Feature: MAWB Management - Manifest MAWB

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipments @DeleteCreatedMAWBs @RT
  Scenario: Record Offload Manifest MAWB
    Given API Operator create multiple 1 new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Operator update multiple shipments dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
    And API Operator link mawb for following shipment ids
      | mawb                 | RANDOM         |
      | destinationAirportId | {airport-id-1} |
      | originAirportId      | {airport-id-2} |
      | vendorId             | {vendor-id}    |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> MAWB Management
    Then Operator verifies "Search by MAWB Number" UI on MAWB Management Page
    Given Operator add shipment IDs below to search by MAWB on MAWB Management page:
      | {KEY_LIST_OF_CREATED_MAWB} |
    And Operator clicks on "Search MAWB" button on MAWB Management Page
    Then Operator verifies Search MAWB Management Page
    Given Operator performs manifest MAWB "{KEY_LIST_OF_CREATED_MAWB[1]}"
#    When Operator performs record offload MAWB following data below:
#      | mawb                 | {KEY_LIST_OF_CREATED_MAWB[1]}       |
#      | totalOffloadedPcs    | 1                                   |
#      | totalOffloadedWeight | 1                                   |
#      | nextFlight           | 12345                               |
#      | departerTime         | {gradle-next-1-day-yyyy-MM-dd-HH-mm}|
#      | arrivalTime          | {gradle-next-1-day-yyyy-MM-dd-HH-mm}|
#      | offload_reason       | RANDOM                              |
#      | comments             | Automation update                   |
#    And Operator clicks offload update button on Record Offload MAWB Page
#    Then Operator verifies record offload successful message
  
  @KillBrowser
  Scenario: Kill Browser
    Given no-op

