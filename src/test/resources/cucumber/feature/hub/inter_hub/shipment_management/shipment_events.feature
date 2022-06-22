@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentManagement @ShipmentEvents
Feature: Shipment Management - Shipment Events

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment @CloseNewWindows
  Scenario: Shipment Events -  Create Shipment
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    And Operator open the shipment detail for the shipment "{KEY_CREATED_SHIPMENT_ID}" on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source    | SHIPMENT_CREATED                    |
      | result    | Pending                             |
      | hub       | {hub-name}                          |
      | userId    | qa@ninjavan.co                      |
      | createdAt | ^{gradle-current-date-yyyy-MM-dd}.* |

  @DeleteShipment @CloseNewWindows
  Scenario: Shipment Events -  Close Shipment
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator put created parcel to shipment
    And API Operator closes the created shipment
    When Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    And Operator open the shipment detail for the shipment "{KEY_CREATED_SHIPMENT_ID}" on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source    | SHIPMENT_CREATED                    |
      | userId    | qa@ninjavan.co                      |
      | result    | Pending                             |
      | hub       | {hub-name}                          |
      | createdAt | ^{gradle-current-date-yyyy-MM-dd}.* |
    Then Operator verify shipment event on Shipment Details page using data below:
      | source    | SHIPMENT_CLOSED                     |
      | userId    | qa@ninjavan.co                      |
      | result    | Closed                              |
      | hub       | {hub-name}                          |
      | createdAt | ^{gradle-current-date-yyyy-MM-dd}.* |

  @DeleteShipment @CloseNewWindows
  Scenario: Shipment Events -  Re-open Shipment
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator put created parcel to shipment
    And API Operator closes the created shipment
    And API Operator opens "{KEY_CREATED_SHIPMENT_ID}" shipment
    When Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    And Operator open the shipment detail for the shipment "{KEY_CREATED_SHIPMENT_ID}" on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source    | SHIPMENT_CREATED                    |
      | userId    | qa@ninjavan.co                      |
      | result    | Pending                             |
      | hub       | {hub-name}                          |
      | createdAt | ^{gradle-current-date-yyyy-MM-dd}.* |
    Then Operator verify shipment event on Shipment Details page using data below:
      | source    | SHIPMENT_REOPENED                   |
      | userId    | qa@ninjavan.co                      |
      | result    | Pending                             |
      | hub       | {hub-name}                          |
      | createdAt | ^{gradle-current-date-yyyy-MM-dd}.* |

  @DeleteShipment @CloseNewWindows
  Scenario: Shipment Events -  Re-open Shipment
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And API Operator performs van inbound by updating shipment status using data below:
      | scanValue  | {KEY_CREATED_SHIPMENT_ID} |
      | hubCountry | SG                        |
      | hubId      | {hub-id}                  |
    When Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    And Operator open the shipment detail for the shipment "{KEY_CREATED_SHIPMENT_ID}" on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source    | SHIPMENT_CREATED                    |
      | userId    | qa@ninjavan.co                      |
      | result    | Pending                             |
      | hub       | {hub-name}                          |
      | createdAt | ^{gradle-current-date-yyyy-MM-dd}.* |
    Then Operator verify shipment event on Shipment Details page using data below:
      | source    | SHIPMENT_VAN_INBOUND(MMDA)          |
      | userId    | qa@ninjavan.co                      |
      | result    | Transit                             |
      | hub       | {hub-name}                          |
      | createdAt | ^{gradle-current-date-yyyy-MM-dd}.* |

  @DeleteShipment @CloseNewWindows
  Scenario: Shipment Events -  Hub Inbound Shipment
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And API Operator performs van inbound by updating shipment status using data below:
      | scanValue  | {KEY_CREATED_SHIPMENT_ID} |
      | hubCountry | SG                        |
      | hubId      | {hub-id}                  |
    And API Operator performs hub inbound by updating shipment status using data below:
      | scanValue  | {KEY_CREATED_SHIPMENT_ID} |
      | hubCountry | SG                        |
      | hubId      | {hub-id-2}                |
    When Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    And Operator open the shipment detail for the shipment "{KEY_CREATED_SHIPMENT_ID}" on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source    | SHIPMENT_CREATED                    |
      | userId    | qa@ninjavan.co                      |
      | result    | Pending                             |
      | hub       | {hub-name}                          |
      | createdAt | ^{gradle-current-date-yyyy-MM-dd}.* |
    Then Operator verify shipment event on Shipment Details page using data below:
      | source    | SHIPMENT_VAN_INBOUND(MMDA)          |
      | userId    | qa@ninjavan.co                      |
      | result    | Transit                             |
      | hub       | {hub-name}                          |
      | createdAt | ^{gradle-current-date-yyyy-MM-dd}.* |
    Then Operator verify shipment event on Shipment Details page using data below:
      | source    | SHIPMENT_HUB_INBOUND(MMDA)          |
      | userId    | qa@ninjavan.co                      |
      | result    | Completed                           |
      | hub       | {hub-name-2}                        |
      | createdAt | ^{gradle-current-date-yyyy-MM-dd}.* |

  @DeleteShipment @CloseNewWindows
  Scenario: Shipment Events -  Force Complete Shipment
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And API Operator change the status of the shipment into "Completed"
    When Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    And Operator open the shipment detail for the shipment "{KEY_CREATED_SHIPMENT_ID}" on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source    | SHIPMENT_CREATED                    |
      | userId    | qa@ninjavan.co                      |
      | result    | Pending                             |
      | hub       | {hub-name}                          |
      | createdAt | ^{gradle-current-date-yyyy-MM-dd}.* |
    Then Operator verify shipment event on Shipment Details page using data below:
      | source    | SHIPMENT_FORCE_COMPLETED            |
      | userId    | qa@ninjavan.co                      |
      | result    | Completed                           |
      | hub       | null                                |
      | createdAt | ^{gradle-current-date-yyyy-MM-dd}.* |

  @DeleteShipment @CloseNewWindows
  Scenario: Shipment Events -  Cancel Shipment
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And API Operator change the status of the shipment into "Cancelled"
    When Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    And Operator open the shipment detail for the shipment "{KEY_CREATED_SHIPMENT_ID}" on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source    | SHIPMENT_CREATED                    |
      | userId    | qa@ninjavan.co                      |
      | result    | Pending                             |
      | hub       | {hub-name}                          |
      | createdAt | ^{gradle-current-date-yyyy-MM-dd}.* |
    Then Operator verify shipment event on Shipment Details page using data below:
      | source    | SHIPMENT_CANCELLED                  |
      | userId    | qa@ninjavan.co                      |
      | result    | Cancelled                           |
      | hub       | null                                |
      | createdAt | ^{gradle-current-date-yyyy-MM-dd}.* |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op