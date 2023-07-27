@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentWeightDimension @SearchWeightAndDimension
Feature: Search Weight and Dimension

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
	Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @HappyPath
  Scenario: Search without input Shipment ID
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verify Shipment Weight Dimension page UI
	When Operator click on Shipment Weight Dimension New Record button
	Then Operator verify Shipment Weight Dimension Add UI
	  | state | initial |
	When Operator click Shipment Weight Dimension search button
	Then Operator verify Shipment Weight Dimension Add UI
	  | state   | error                         |
	  | message | Shipment ID must not be empty |

  @HappyPath
  Scenario: Search with input Invalid Shipment ID
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verify Shipment Weight Dimension page UI
	When Operator click on Shipment Weight Dimension New Record button
	Then Operator verify Shipment Weight Dimension Add UI
	  | state | initial |
	When Operator enter "Invalid" shipment ID on Shipment Weight Dimension
	And Operator click Shipment Weight Dimension search button
	Then Operator verify Shipment Weight Dimension Add UI
	  | state   | error                    |
	  | message | Shipment ID is not found |
	Then Operator verify toast message "Request failed with status code 404" is shown in Shipment Weight Dimension Add UI

  @HappyPath @DeleteShipment
  Scenario: Search with input Valid Pending Shipment ID
	Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verify Shipment Weight Dimension page UI
	When Operator click on Shipment Weight Dimension New Record button
	Then Operator verify Shipment Weight Dimension Add UI
	  | state | initial |
	When Operator enter "{KEY_CREATED_SHIPMENT_ID}" shipment ID on Shipment Weight Dimension
	And Operator click Shipment Weight Dimension search button
	Then Operator verify Shipment Weight Dimension Add UI
	  | state           | valid   |
	  | shipment status | Pending |

  @DeleteShipment
  Scenario: Search with input Valid Closed Shipment ID
	Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given API Operator closes the created shipment
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verify Shipment Weight Dimension page UI
	When Operator click on Shipment Weight Dimension New Record button
	Then Operator verify Shipment Weight Dimension Add UI
	  | state | initial |
	When Operator enter "{KEY_CREATED_SHIPMENT_ID}" shipment ID on Shipment Weight Dimension
	And Operator click Shipment Weight Dimension search button
	Then Operator verify Shipment Weight Dimension Add UI
	  | state           | valid  |
	  | shipment status | Closed |


  @DeleteShipment
  Scenario: Search with input Valid Transit Shipment ID
	Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given API Operator closes the created shipment
	Given API Operator does the "van-inbound" scan for the shipment at transit hub = {hub-id}
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verify Shipment Weight Dimension page UI
	When Operator click on Shipment Weight Dimension New Record button
	Then Operator verify Shipment Weight Dimension Add UI
	  | state | initial |
	When Operator enter "{KEY_CREATED_SHIPMENT_ID}" shipment ID on Shipment Weight Dimension
	And Operator click Shipment Weight Dimension search button
	Then Operator verify Shipment Weight Dimension Add UI
	  | state           | valid   |
	  | shipment status | Transit |

  @DeleteShipment
  Scenario: Search with input Valid At Transit Hub Shipment ID
	Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given API Operator closes the created shipment
	Given API Operator does the "hub-inbound" scan for the shipment at transit hub = {hub-relation-origin-hub-id}
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verify Shipment Weight Dimension page UI
	When Operator click on Shipment Weight Dimension New Record button
	Then Operator verify Shipment Weight Dimension Add UI
	  | state | initial |
	When Operator enter "{KEY_CREATED_SHIPMENT_ID}" shipment ID on Shipment Weight Dimension
	And Operator click Shipment Weight Dimension search button
	Then Operator verify Shipment Weight Dimension Add UI
	  | state           | valid          |
	  | shipment status | At Transit Hub |


  @HappyPath @DeleteShipment
  Scenario: Search with input Valid Completed Shipment ID
	Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given API Operator closes the created shipment
	Given API Operator does the "hub-inbound" scan for the shipment at transit hub = {hub-id-2}
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verify Shipment Weight Dimension page UI
	When Operator click on Shipment Weight Dimension New Record button
	Then Operator verify Shipment Weight Dimension Add UI
	  | state | initial |
	When Operator enter "{KEY_CREATED_SHIPMENT_ID}" shipment ID on Shipment Weight Dimension
	And Operator click Shipment Weight Dimension search button
	Then Operator verify Shipment Weight Dimension Add UI
	  | state           | valid     |
	  | shipment status | Completed |

  @DeleteShipment
  Scenario: Search with input Valid Cancelled Shipment ID
	Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given API Operator closes the created shipment
	Given API Operator change the status of the shipment into "Cancelled"
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verify Shipment Weight Dimension page UI
	When Operator click on Shipment Weight Dimension New Record button
	Then Operator verify Shipment Weight Dimension Add UI
	  | state | initial |
	When Operator enter "{KEY_CREATED_SHIPMENT_ID}" shipment ID on Shipment Weight Dimension
	And Operator click Shipment Weight Dimension search button
	Then Operator verify Shipment Weight Dimension Add UI
	  | state           | valid     |
	  | shipment status | Cancelled |


  @DeleteShipment
  Scenario: Search with input JSON Shipment ID
	Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verify Shipment Weight Dimension page UI
	When Operator click on Shipment Weight Dimension New Record button
	Then Operator verify Shipment Weight Dimension Add UI
	  | state | initial |
	When Operator enter "JSON" shipment ID on Shipment Weight Dimension
	And Operator click Shipment Weight Dimension search button
	Then Operator verify Shipment Weight Dimension Add UI
	  | state           | valid   |
	  | shipment status | Pending |

  @HappyPath @DeleteShipment
  Scenario: Search with input Valid Shipment ID that has Shipment Weight and Dimension
	Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	Given API Operator closes the created shipment
	Given API Operator update shipment dimension with weight: 16.0 and length: 8.0 and width: 1.9 and height: 9.7
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Shipment Weight Dimension
	Then Operator verify Shipment Weight Dimension page UI
	When Operator click on Shipment Weight Dimension New Record button
	Then Operator verify Shipment Weight Dimension Add UI
	  | state | initial |
	When Operator enter "{KEY_CREATED_SHIPMENT_ID}" shipment ID on Shipment Weight Dimension
	And Operator click Shipment Weight Dimension search button
	Then Operator verify Shipment Weight Dimension Add UI
	  | state           | has dimension |
	  | weight          | 16.0          |
	  | length          | 8.0           |
	  | width           | 1.9           |
	  | height          | 9.7           |
	  | shipment status | Closed        |

  @KillBrowser
  Scenario: Kill Browser
	Given no-op
