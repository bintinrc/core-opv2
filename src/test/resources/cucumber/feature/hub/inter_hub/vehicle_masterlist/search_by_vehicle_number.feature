@OperatorV2 @MiddleMile @Hub @InterHub @SearchByVehicleNumber
Feature: Add To Shipment

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Search Vehicle by Valid Single Vehicle Number
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to this URL "{operator-portal-base-url}/#/{country-code}/vehicle-masterlist"
    Then Operator verifies Vehicle Information page is loaded
    Then API MM - Operator gets list of 1 vehicles by truck type id "{default-truck-type-id}"
    Then Operator searches vehicle by vehicle number from "KEY_MM_LIST_OF_VEHICLES"