@OperatorV2 @Core @Route @NewFeatures @StationRoute @SearchTrackingIdsOnStationRoutePart7
Feature: Search Tracking IDs on Station Route

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Search Tracking IDs on Station Route - Shipment Filter - Start Date < End Date
    Given Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator select filters on Station Route page:
      | hub                        | {hub-name-13}                  |
      | shipmentType               | AIR_HAUL                       |
      | shipmentCompletionTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentCompletionTimeTo   | {gradle-next-1-day-yyyy-MM-dd} |
    Then Operator verify Assign drivers button is enabled on Station Route Page