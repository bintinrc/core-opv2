@OperatorV2 @MiddleMile @Hub @InterHub @SearchByVehicleNumber
Feature: Search by Vehicle Number

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @HappyPath
  Scenario: Search Vehicle by Valid Single Vehicle Number
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to this URL "{operator-portal-base-url}/#/{country-code}/vehicle-masterlist"
    Then Operator verifies Vehicle Information page is loaded
    Then API MM - Operator gets list of 1 vehicles by truck type id "{default-truck-type-id}"
    Then Operator searches vehicles by vehicle number from "KEY_MM_LIST_OF_VEHICLES"
    Then Operator verifies vehicle table is loaded
    Then Operator verifies "KEY_MM_LIST_OF_VEHICLES" appear in vehicle result table

  @HappyPath
  Scenario: Search Vehicle by Valid Multiple Vehicle Number < 300
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to this URL "{operator-portal-base-url}/#/{country-code}/vehicle-masterlist"
    Then Operator verifies Vehicle Information page is loaded
    Then API MM - Operator gets list of 150 vehicles by truck type id "{default-truck-type-id}"
    Then Operator searches vehicles by vehicle number from "KEY_MM_LIST_OF_VEHICLES"
    Then Operator verifies vehicle table is loaded
    Then Operator verifies "KEY_MM_LIST_OF_VEHICLES" appear in vehicle result table

  Scenario: Search Vehicle by Valid Multiple Vehicle Number = 300
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to this URL "{operator-portal-base-url}/#/{country-code}/vehicle-masterlist"
    Then Operator verifies Vehicle Information page is loaded
    Then API MM - Operator gets list of 300 vehicles by truck type id "{default-truck-type-id}"
    Then Operator searches vehicles by vehicle number from "KEY_MM_LIST_OF_VEHICLES"
    Then Operator verifies vehicle table is loaded
    Then Operator verifies "KEY_MM_LIST_OF_VEHICLES" appear in vehicle result table

  @LowPriority
  Scenario: Search Vehicle by Valid Multiple Vehicle Number > 300
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to this URL "{operator-portal-base-url}/#/{country-code}/vehicle-masterlist"
    Then Operator verifies Vehicle Information page is loaded
    Then API MM - Operator gets list of 320 vehicles by truck type id "{default-truck-type-id}"
    Then Operator searches vehicles by vehicle number from "KEY_MM_LIST_OF_VEHICLES"
    Then Operator verifies maximum vehicle numbers input is exceeded

  @HappyPath
  Scenario: Search Vehicle by Valid Duplicate Multiple Vehicle Number < 300
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to this URL "{operator-portal-base-url}/#/{country-code}/vehicle-masterlist"
    Then Operator verifies Vehicle Information page is loaded
    Then API MM - Operator gets list of 150 vehicles by truck type id "{default-truck-type-id}"
    Then Operator input these vehicle numbers in Search by Vehicle Number textarea:
      | KEY_MM_LIST_OF_VEHICLES                    |
      | {KEY_MM_LIST_OF_VEHICLES[1].vehicleNumber} |
      | {KEY_MM_LIST_OF_VEHICLES[2].vehicleNumber} |
    Then Operator verifies vehicle number counter with duplicate is "152 entered (2 duplicate)"
    Then Operator clicks Search button when searching vehicles by vehicle number
    Then Operator verifies vehicle table is loaded
    Then Operator verifies "KEY_MM_LIST_OF_VEHICLES" appear in vehicle result table

  Scenario: Search Vehicle by Valid Duplicate Multiple Vehicle Number = 300
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to this URL "{operator-portal-base-url}/#/{country-code}/vehicle-masterlist"
    Then Operator verifies Vehicle Information page is loaded
    Then API MM - Operator gets list of 297 vehicles by truck type id "{default-truck-type-id}"
    Then Operator input these vehicle numbers in Search by Vehicle Number textarea:
      | KEY_MM_LIST_OF_VEHICLES                    |
      | {KEY_MM_LIST_OF_VEHICLES[1].vehicleNumber} |
      | {KEY_MM_LIST_OF_VEHICLES[2].vehicleNumber} |
      | {KEY_MM_LIST_OF_VEHICLES[3].vehicleNumber} |
    Then Operator verifies vehicle number counter with duplicate is "300 entered (3 duplicate)"
    Then Operator clicks Search button when searching vehicles by vehicle number
    Then Operator verifies vehicle table is loaded
    Then Operator verifies "KEY_MM_LIST_OF_VEHICLES" appear in vehicle result table

  @LowPriority
  Scenario: Search Vehicle by Valid Duplicate Multiple Vehicle Number > 300
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to this URL "{operator-portal-base-url}/#/{country-code}/vehicle-masterlist"
    Then Operator verifies Vehicle Information page is loaded
    Then API MM - Operator gets list of 310 vehicles by truck type id "{default-truck-type-id}"
    Then Operator input these vehicle numbers in Search by Vehicle Number textarea:
      | KEY_MM_LIST_OF_VEHICLES                    |
      | {KEY_MM_LIST_OF_VEHICLES[1].vehicleNumber} |
      | {KEY_MM_LIST_OF_VEHICLES[2].vehicleNumber} |
      | {KEY_MM_LIST_OF_VEHICLES[3].vehicleNumber} |
    Then Operator verifies vehicle number counter with duplicate is "313 entered (3 duplicate)"
    Then Operator clicks Search button when searching vehicles by vehicle number
    Then Operator verifies maximum vehicle numbers input is exceeded

  @HappyPath
  Scenario: Search Vehicle by Invalid Single Vehicle Number
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to this URL "{operator-portal-base-url}/#/{country-code}/vehicle-masterlist"
    Then Operator verifies Vehicle Information page is loaded
    Then Operator input these vehicle numbers in Search by Vehicle Number textarea:
      | 991219 LOREMIPSUM |
    Then Operator verifies vehicle number counter is 1
    Then Operator clicks Search button when searching vehicles by vehicle number
    Then Operator verifies invalid vehicle number dialog is displayed

  Scenario: Search Vehicle by Invalid Multiple Vehicle Number < 300
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to this URL "{operator-portal-base-url}/#/{country-code}/vehicle-masterlist"
    Then Operator verifies Vehicle Information page is loaded
    Then Operator input these vehicle numbers in Search by Vehicle Number textarea:
      | 991219 LOREMIPSUM    |
      | 991313 MARTABAKMANIS |
      | 891723 AYAMGEPREK    |
      | 786761 SODAGEMBIRA   |
    Then Operator verifies vehicle number counter is 4
    Then Operator clicks Search button when searching vehicles by vehicle number
    Then Operator verifies invalid vehicle number dialog is displayed

  Scenario: Search Vehicle by Invalid Multiple Vehicle Number = 300
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to this URL "{operator-portal-base-url}/#/{country-code}/vehicle-masterlist"
    Then Operator verifies Vehicle Information page is loaded
    Then API MM - Operator gets list of 300 vehicles by truck type id "{default-truck-type-id}"
    Then Operator searches vehicles by invalid vehicle number based on "KEY_MM_LIST_OF_VEHICLES"
    Then Operator verifies invalid vehicle number dialog is displayed

  @LowPriority
  Scenario: Search Vehicle by Invalid Multiple Vehicle Number > 300
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to this URL "{operator-portal-base-url}/#/{country-code}/vehicle-masterlist"
    Then Operator verifies Vehicle Information page is loaded
    Then API MM - Operator gets list of 310 vehicles by truck type id "{default-truck-type-id}"
    Then Operator searches vehicles by invalid vehicle number based on "KEY_MM_LIST_OF_VEHICLES"
    Then Operator verifies maximum vehicle numbers input is exceeded

  @HappyPath
  Scenario: Search Vehicle by Valid and Invalid Vehicle Number
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to this URL "{operator-portal-base-url}/#/{country-code}/vehicle-masterlist"
    Then Operator verifies Vehicle Information page is loaded
    Then API MM - Operator gets list of 2 vehicles by truck type id "{default-truck-type-id}"
    Then Operator input these vehicle numbers in Search by Vehicle Number textarea:
      | 991219 LOREMIPSUM                          |
      | 441313 TAHUCAMPUR                          |
      | {KEY_MM_LIST_OF_VEHICLES[1].vehicleNumber} |
      | {KEY_MM_LIST_OF_VEHICLES[2].vehicleNumber} |
    Then Operator verifies vehicle number counter is 4
    Then Operator clicks Search button when searching vehicles by vehicle number
    Then Operator verifies alert is showing 2 vehicle numbers cannot be found
    When Operator clicks View on not found vehicle numbers alert
    Then Operator verifies these vehicle numbers are displayed as not found vehicle numbers:
      | 991219 LOREMIPSUM |
      | 441313 TAHUCAMPUR |