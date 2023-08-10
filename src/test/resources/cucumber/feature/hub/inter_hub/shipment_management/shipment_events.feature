@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentManagement @ShipmentEvents
Feature: Shipment Management - Shipment Events

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
	Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCreatedShipments @CloseNewWindows
  Scenario: Shipment Events - Create Shipment
	When Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
	And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_CREATED_SHIPMENT_ID} |
	And Operator open the shipment detail for the shipment "{KEY_CREATED_SHIPMENT_ID}" on Shipment Management Page
	Then Operator verify shipment event on Shipment Details page:
	  | source    | SHIPMENT_CREATED                    |
	  | result    | Pending                             |
	  | hub       | {hub-name}                          |
	  | userId    | qa@ninjavan.co                      |
	  | createdAt | ^{gradle-current-date-yyyy-MM-dd}.* |

  @DeleteCreatedShipments @CloseNewWindows
  Scenario: Shipment Events - Close Shipment
	Given Operator go to menu Utilities -> QRCode Printing
	When Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
	And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	And API Shipper create V4 order using data below:
	  | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
	  | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
	And API Operator put created parcel to shipment
	And API Operator closes the created shipment
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_CREATED_SHIPMENT_ID} |
	And Operator open the shipment detail for the shipment "{KEY_CREATED_SHIPMENT_ID}" on Shipment Management Page
	Then Operator verify shipment event on Shipment Details page:
	  | source    | SHIPMENT_CREATED                    |
	  | userId    | qa@ninjavan.co                      |
	  | result    | Pending                             |
	  | hub       | {hub-name}                          |
	  | createdAt | ^{gradle-current-date-yyyy-MM-dd}.* |
	Then Operator verify shipment event on Shipment Details page:
	  | source    | SHIPMENT_CLOSED                     |
	  | userId    | qa@ninjavan.co                      |
	  | result    | Closed                              |
	  | hub       | {hub-name}                          |
	  | createdAt | ^{gradle-current-date-yyyy-MM-dd}.* |

  @DeleteCreatedShipments @CloseNewWindows
  Scenario: Shipment Events - Re-open Shipment
	Given Operator go to menu Utilities -> QRCode Printing
	When Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
	And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	And API Shipper create V4 order using data below:
	  | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
	  | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
	And API Operator put created parcel to shipment
	And API Operator closes the created shipment
	And API Operator opens "{KEY_CREATED_SHIPMENT_ID}" shipment
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_CREATED_SHIPMENT_ID} |
	And Operator open the shipment detail for the shipment "{KEY_CREATED_SHIPMENT_ID}" on Shipment Management Page
	Then Operator verify shipment event on Shipment Details page:
	  | source    | SHIPMENT_CREATED                    |
	  | userId    | qa@ninjavan.co                      |
	  | result    | Pending                             |
	  | hub       | {hub-name}                          |
	  | createdAt | ^{gradle-current-date-yyyy-MM-dd}.* |
	Then Operator verify shipment event on Shipment Details page:
	  | source    | SHIPMENT_REOPENED                   |
	  | userId    | qa@ninjavan.co                      |
	  | result    | Pending                             |
	  | hub       | {hub-name}                          |
	  | createdAt | ^{gradle-current-date-yyyy-MM-dd}.* |

  @DeleteCreatedShipments @CloseNewWindows
  Scenario: Shipment Events - Van Inbound Shipment
	Given Operator go to menu Utilities -> QRCode Printing
	When Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
	When API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	And API Operator closes the created shipment
	And API Operator performs van inbound by updating shipment status using data below:
	  | scanValue  | {KEY_CREATED_SHIPMENT_ID} |
	  | hubCountry | SG                        |
	  | hubId      | {hub-id}                  |
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_CREATED_SHIPMENT_ID} |
	And Operator open the shipment detail for the shipment "{KEY_CREATED_SHIPMENT_ID}" on Shipment Management Page
	Then Operator verify shipment event on Shipment Details page:
	  | source    | SHIPMENT_CREATED                    |
	  | userId    | qa@ninjavan.co                      |
	  | result    | Pending                             |
	  | hub       | {hub-name}                          |
	  | createdAt | ^{gradle-current-date-yyyy-MM-dd}.* |
	Then Operator verify shipment event on Shipment Details page:
	  | source    | SHIPMENT_VAN_INBOUND(MMDA)          |
	  | userId    | qa@ninjavan.co                      |
	  | result    | Transit                             |
	  | hub       | {hub-name}                          |
	  | createdAt | ^{gradle-current-date-yyyy-MM-dd}.* |

  @DeleteCreatedShipments @CloseNewWindows
  Scenario: Shipment Events - Hub Inbound Shipment
	Given Operator go to menu Utilities -> QRCode Printing
	When Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
	When API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
	And API Operator closes the created shipment
	And API Operator performs van inbound by updating shipment status using data below:
	  | scanValue  | {KEY_CREATED_SHIPMENT_ID} |
	  | hubCountry | SG                        |
	  | hubId      | {hub-id}                  |
	And API Operator performs hub inbound by updating shipment status using data below:
	  | scanValue  | {KEY_CREATED_SHIPMENT_ID} |
	  | hubCountry | SG                        |
	  | hubId      | {hub-id-2}                |
	And Operator search shipments by given Ids on Shipment Management page:
	  | {KEY_CREATED_SHIPMENT_ID} |
	And Operator open the shipment detail for the shipment "{KEY_CREATED_SHIPMENT_ID}" on Shipment Management Page
	Then Operator verify shipment event on Shipment Details page:
	  | source    | SHIPMENT_CREATED                    |
	  | userId    | qa@ninjavan.co                      |
	  | result    | Pending                             |
	  | hub       | {hub-name}                          |
	  | createdAt | ^{gradle-current-date-yyyy-MM-dd}.* |
	Then Operator verify shipment event on Shipment Details page:
	  | source    | SHIPMENT_VAN_INBOUND(MMDA)          |
	  | userId    | qa@ninjavan.co                      |
	  | result    | Transit                             |
	  | hub       | {hub-name}                          |
	  | createdAt | ^{gradle-current-date-yyyy-MM-dd}.* |
	Then Operator verify shipment event on Shipment Details page:
	  | source    | SHIPMENT_HUB_INBOUND(MMDA)          |
	  | userId    | qa@ninjavan.co                      |
	  | result    | Completed                           |
	  | hub       | {hub-name-2}                        |
	  | createdAt | ^{gradle-current-date-yyyy-MM-dd}.* |

  @DeleteCreatedShipments
  Scenario: Shipment Events - Cancel Shipment
	Given Operator go to menu Shipper Support -> Blocked Dates
	When Operator go to menu Inter-Hub -> Shipment Management
	Given API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
	When API MM - Operator updates shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" status to "Cancelled"
	And Operator searches shipments by given Ids on Shipment Management page:
	  | KEY_MM_LIST_OF_CREATED_SHIPMENTS[1] |
	And Operator open the shipment detail for the shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" on Shipment Management Page
	When API MM - Operator verifies shipment with id "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" has events below:
	  | EVENT_NAME | SHIPMENT_CREATED |
	  | Status     | Pending          |
	When API MM - Operator verifies shipment with id "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" has events below:
	  | EVENT_NAME | SHIPMENT_CANCELLED |
	  | Status     | Cancelled          |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
	Given no-op