@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentWeightDimension @SearchByBillingNumber2
Feature: Search by Billing Number 2

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
	Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCreatedShipments
  Scenario: Search Shipment by Invalid MAWB
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verifies Shipment Weight Dimension page UI
	When Operator clicks "Search by Billing Number" button on Shipment Weight Dimension page
	Then Operator verifies "Search by Billing Number" popup is shown on Shipment Weight Dimension page
	When Operator input "MAWB" billing number with value "INVALID MAWB" on Shipment Weight Dimension page
	When Operator clicks "Search Shipments" button on Shipment Weight Dimension page
	Then Operator verifies error message "Request failed with status code 404" is shown on Shipment Weight Dimension page

  @DeleteCreatedShipments
  Scenario: Search Shipment by Invalid SWB
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verifies Shipment Weight Dimension page UI
	When Operator clicks "Search by Billing Number" button on Shipment Weight Dimension page
	Then Operator verifies "Search by Billing Number" popup is shown on Shipment Weight Dimension page
	When Operator input "SWB" billing number with value "INVALID SWB" on Shipment Weight Dimension page
	When Operator clicks "Search Shipments" button on Shipment Weight Dimension page
	Then Operator verifies error message "Request failed with status code 404" is shown on Shipment Weight Dimension page

  @DeleteCreatedShipments
  Scenario: Cancel Search Shipment by Invalid MAWB
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verifies Shipment Weight Dimension page UI
	When Operator clicks "Search by Billing Number" button on Shipment Weight Dimension page
	Then Operator verifies "Search by Billing Number" popup is shown on Shipment Weight Dimension page
	When Operator input "MAWB" billing number with value "INVALID MAWB" on Shipment Weight Dimension page
	When Operator clicks "Close Search by Billing Number" button on Shipment Weight Dimension page
	Then Operator verifies the popup is closed on Shipment Weight Dimension page

  @DeleteCreatedShipments
  Scenario: Cancel Search Shipment by Invalid SWB
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verifies Shipment Weight Dimension page UI
	When Operator clicks "Search by Billing Number" button on Shipment Weight Dimension page
	Then Operator verifies "Search by Billing Number" popup is shown on Shipment Weight Dimension page
	When Operator input "SWB" billing number with value "INVALID SWB" on Shipment Weight Dimension page
	When Operator clicks "Close Search by Billing Number" button on Shipment Weight Dimension page
	Then Operator verifies the popup is closed on Shipment Weight Dimension page

  @HappyPath @DeleteCreatedShipments
  Scenario: Search Shipment by Valid MAWB but No Shipment Found
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verifies Shipment Weight Dimension page UI
	When Operator clicks "Search by Billing Number" button on Shipment Weight Dimension page
	Then Operator verifies "Search by Billing Number" popup is shown on Shipment Weight Dimension page
	When Operator input "MAWB" billing number with value "RANDOM" on Shipment Weight Dimension page
	When Operator clicks "Search Shipments" button on Shipment Weight Dimension page
	Then Operator verifies error message "Request failed with status code 404" is shown on Shipment Weight Dimension page

  @HappyPath @DeleteCreatedShipments
  Scenario: Search Shipment by Valid SWB but No Shipment Found
	Given Operator go to menu Shipper Support -> Blocked Dates
	When Operator change the country to "Malaysia"
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verifies Shipment Weight Dimension page UI
	When Operator clicks "Search by Billing Number" button on Shipment Weight Dimension page
	Then Operator verifies "Search by Billing Number" popup is shown on Shipment Weight Dimension page
	When Operator input "SWB" billing number with value "RANDOM-R11B" on Shipment Weight Dimension page
	When Operator clicks "Search Shipments" button on Shipment Weight Dimension page
	Then Operator verifies error message "Request failed with status code 404" is shown on Shipment Weight Dimension page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
	Given no-op