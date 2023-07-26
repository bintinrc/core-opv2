@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentWeightDimension @AddWeightAndDimension
Feature: Search Weight and Dimension

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
	Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @HappyPath @DeleteShipment
  Scenario: Submit Weight and Dimension without enter Weight and Dimension
	Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
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
	When Operator enter dimension values on Shipment Weight Dimension Weight input
	  | val | 0 |
	And Operator click Submit on Shipment Weight Dimension
	Then Operator verify Shipment Weight Dimension Add Dimension UI
	  | state        | invalid                        |
	  | field        | weight                         |
	  | errorMessage | Please enter Weight (required) |
	And Operator verify Shipment Weight Dimension Submit button is disabled

  @HappyPath @DeleteShipment
  Scenario: Submit Weight and Dimension without enter Weight
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
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
	When Operator enter dimension values on Shipment Weight Dimension Weight input
	  | length | 16.8 |
	  | width  | 19.0 |
	  | height | 9.7  |
	And Operator click Submit on Shipment Weight Dimension
	Then Operator verify Shipment Weight Dimension Add Dimension UI
	  | state        | invalid                        |
	  | field        | weight                         |
	  | errorMessage | Please enter Weight (required) |
	And Operator verify Shipment Weight Dimension Submit button is disabled

  @DeleteShipment
  Scenario: Submit Weight and Dimension with enter Weight and Empty Dimension
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
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
	When Operator enter dimension values on Shipment Weight Dimension Weight input
	  | weight | 3.1 |
	And Operator click Submit on Shipment Weight Dimension
	Then Operator verify notice message "Success! SID {KEY_CREATED_SHIPMENT_ID} record was updated." is shown in Shipment Weight Dimension Add UI
	Then DB Operator verify the updated shipment dimension is correct
	  | weight | 3.1 |
	And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_CREATED_SHIPMENT_ID} |
	And Operator open the shipment detail for the created shipment on Shipment Management Page
	Then Operator verify shipment event on Shipment Details page:
	  | source | SHIPMENT_DIMENSION_WEIGHT_UPDATED |
	  | result | Pending                           |
	  | hub    | {hub-name}                        |

  @DeleteShipment
  Scenario: Submit Weight and Dimension with enter Weight, Length and empty Width, Height
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
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
	When Operator enter dimension values on Shipment Weight Dimension Weight input
	  | weight | 3.1 |
	  | length | 16  |
	And Operator click Submit on Shipment Weight Dimension
	Then Operator verify notice message "Success! SID {KEY_CREATED_SHIPMENT_ID} record was updated." is shown in Shipment Weight Dimension Add UI
	Then DB Operator verify the updated shipment dimension is correct
	  | weight | 3.1 |
	  | length | 16  |
	And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_CREATED_SHIPMENT_ID} |
	And Operator open the shipment detail for the created shipment on Shipment Management Page
	Then Operator verify shipment event on Shipment Details page:
	  | source | SHIPMENT_DIMENSION_WEIGHT_UPDATED |
	  | result | Pending                           |
	  | hub    | {hub-name}                        |

  @DeleteShipment
  Scenario: Submit Weight and Dimension with enter Weight, Length, Width and empty Height
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
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
	When Operator enter dimension values on Shipment Weight Dimension Weight input
	  | weight | 3.1 |
	  | length | 16  |
	  | width  | 8.0 |
	And Operator click Submit on Shipment Weight Dimension
	Then Operator verify notice message "Success! SID {KEY_CREATED_SHIPMENT_ID} record was updated." is shown in Shipment Weight Dimension Add UI
	Then DB Operator verify the updated shipment dimension is correct
	  | weight | 3.1 |
	  | length | 16  |
	  | width  | 8.0 |
	And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_CREATED_SHIPMENT_ID} |
	And Operator open the shipment detail for the created shipment on Shipment Management Page
	Then Operator verify shipment event on Shipment Details page:
	  | source | SHIPMENT_DIMENSION_WEIGHT_UPDATED |
	  | result | Pending                           |
	  | hub    | {hub-name}                        |

  @HappyPath @DeleteShipment
  Scenario: Submit Weight and Dimension with enter Weight, Length, Width and Height
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
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
	When Operator enter dimension values on Shipment Weight Dimension Weight input
	  | weight | 3.1 |
	  | length | 16  |
	  | width  | 8.0 |
	  | height | 9.7 |
	And Operator click Submit on Shipment Weight Dimension
	Then Operator verify notice message "Success! SID {KEY_CREATED_SHIPMENT_ID} record was updated." is shown in Shipment Weight Dimension Add UI
	Then DB Operator verify the updated shipment dimension is correct
	  | weight | 3.1 |
	  | length | 16  |
	  | width  | 8.0 |
	  | height | 9.7 |
	When Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_CREATED_SHIPMENT_ID} |
	And Operator open the shipment detail for the created shipment on Shipment Management Page
	Then Operator verify shipment event on Shipment Details page:
	  | source | SHIPMENT_DIMENSION_WEIGHT_UPDATED |
	  | result | Pending                           |
	  | hub    | {hub-name}                        |

  @HappyPath @DeleteShipment
  Scenario: Submit Weight and Dimension with enter Weight > 100 kg
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
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
	When Operator enter dimension values on Shipment Weight Dimension Weight input
	  | weight | 101 |
	  | length | 16  |
	  | width  | 8.0 |
	  | height | 9.7 |
	And Operator click Submit on Shipment Weight Dimension
	Then Operator click "Confirm" on Over Weight Modal
	Then Operator verify notice message "Success! SID {KEY_CREATED_SHIPMENT_ID} record was updated." is shown in Shipment Weight Dimension Add UI
	Then DB Operator verify the updated shipment dimension is correct
	  | weight | 101 |
	  | length | 16  |
	  | width  | 8.0 |
	  | height | 9.7 |
	And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_CREATED_SHIPMENT_ID} |
	And Operator open the shipment detail for the created shipment on Shipment Management Page
	Then Operator verify shipment event on Shipment Details page:
	  | source | SHIPMENT_DIMENSION_WEIGHT_UPDATED |
	  | result | Pending                           |
	  | hub    | {hub-name}                        |

  @HappyPath @DeleteShipment
  Scenario: Submit Weight and Dimension with enter Weight > 100 kg and Re-enter weight <= 100 kg
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
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
	When Operator enter dimension values on Shipment Weight Dimension Weight input
	  | weight | 101 |
	  | length | 16  |
	  | width  | 8.0 |
	  | height | 9.7 |
	And Operator click Submit on Shipment Weight Dimension
	Then Operator click "Cancel" on Over Weight Modal
	Then Operator verify notice message "Failed, Shipment record was NOT updated." is shown in Shipment Weight Dimension Add UI
	Then Operator verify Shipment Weight Dimension Add Dimension UI
	  | state        | invalid         |
	  | field        | weight          |
	  | errorMessage | Re-enter weight |
	When Operator enter dimension values on Shipment Weight Dimension Weight input
	  | weight | 3 |
	And Operator click Submit on Shipment Weight Dimension
	Then Operator verify notice message "Success! SID {KEY_CREATED_SHIPMENT_ID} record was updated." is shown in Shipment Weight Dimension Add UI
	Then DB Operator verify the updated shipment dimension is correct
	  | weight | 3   |
	  | length | 16  |
	  | width  | 8.0 |
	  | height | 9.7 |
	And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_CREATED_SHIPMENT_ID} |
	And Operator open the shipment detail for the created shipment on Shipment Management Page
	Then Operator verify shipment event on Shipment Details page:
	  | source | SHIPMENT_DIMENSION_WEIGHT_UPDATED |
	  | result | Pending                           |
	  | hub    | {hub-name}                        |

  @DeleteShipment
  Scenario: Submit Weight and Dimension with enter Weight = 100 kg
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
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
	When Operator enter dimension values on Shipment Weight Dimension Weight input
	  | weight | 100 |
	  | length | 16  |
	  | width  | 8.0 |
	  | height | 9.7 |
	And Operator click Submit on Shipment Weight Dimension
	Then Operator verify notice message "Success! SID {KEY_CREATED_SHIPMENT_ID} record was updated." is shown in Shipment Weight Dimension Add UI
	Then DB Operator verify the updated shipment dimension is correct
	  | weight | 100 |
	  | length | 16  |
	  | width  | 8.0 |
	  | height | 9.7 |
	And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_CREATED_SHIPMENT_ID} |
	And Operator open the shipment detail for the created shipment on Shipment Management Page
	Then Operator verify shipment event on Shipment Details page:
	  | source | SHIPMENT_DIMENSION_WEIGHT_UPDATED |
	  | result | Pending                           |
	  | hub    | {hub-name}                        |

  @HappyPath @DeleteShipment
  Scenario: Submit Weight and Dimension with enter 0 Weight
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
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
	When Operator enter dimension values on Shipment Weight Dimension Weight input
	  | weight | 0   |
	  | length | 16  |
	  | width  | 8.0 |
	  | height | 9.7 |
	Then Operator verify Shipment Weight Dimension Add Dimension UI
	  | state        | invalid                |
	  | field        | weight                 |
	  | errorMessage | Must be greater than 0 |
	And Operator verify Shipment Weight Dimension Submit button is disabled

  Scenario: Submit Weight and Dimension for Invalid Shipment ID
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
	When Operator enter dimension values on Shipment Weight Dimension Weight input
	  | weight | 19  |
	  | length | 16  |
	  | width  | 8.0 |
	  | height | 9.7 |
	And Operator click Submit on Shipment Weight Dimension
	Then Operator verify notice message "Failed, Shipment record was NOT updated." is shown in Shipment Weight Dimension Add UI

  @KillBrowser
  Scenario: Kill Browser
	Given no-op