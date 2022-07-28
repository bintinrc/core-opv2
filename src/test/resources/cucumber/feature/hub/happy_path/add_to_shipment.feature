@OperatorV2 @Hub @HappyPath @AddToShipment
Feature: Add to Shipment

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment @ForceSuccessOrder
  Scenario: Add Parcel to Shipment (uid:ec01c5c8-9088-4da5-ae29-436e75637568)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And DB Operator gets Hub ID by Hub Name of created parcel
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {KEY_DESTINATION_HUB_ID}
    Given Operator go to menu Inter-Hub -> Add To Shipment
    Then Operator scan the created order to shipment in hub {hub-name} to hub id = {KEY_DESTINATION_HUB_ID}
    And Operator verifies that the row of the added order is blue highlighted
    And Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/new-shipment-management"
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id     | {KEY_CREATED_SHIPMENT_ID} |
      | status | Pending                   |
    When Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify the Shipment Details Page opened is for the created shipment
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name | ADDED TO SHIPMENT |

  @DeleteShipment @ForceSuccessOrder
  Scenario: Add Multiple Parcels to Shipment (uid:44bfcc1b-35e8-460b-ac98-f43af0cff49c)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 3                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given DB Operator gets Hub ID by Hub Name of created parcel
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {KEY_DESTINATION_HUB_ID}
    Given Operator go to menu Inter-Hub -> Add To Shipment
    When Operator scan multiple created order to shipment in hub {hub-name} to hub id = {KEY_DESTINATION_HUB_ID}

  @DeleteShipment @ForceSuccessOrder
  Scenario: Add Parcel with Tag to Shipment (uid:0a2f74ee-4810-493d-bd72-fc951a709943)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Order -> Order Tag Management
    When Operator selects filter and clicks Load Selection on Add Tags to Order page using data below:
      | shipperName     | {shipper-v4-legacy-id}-{shipper-v4-name} |
      | status          | Pending                                  |
      | granular status | Pending Pickup                           |
    And Operator searches and selects orders created first row on Add Tags to Order page
    And Operator tags order with:
      | OPV2AUTO1 |
      | OPV2AUTO2 |
      | OPV2AUTO3 |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify the tags shown on Edit Order page
      | OPV2AUTO1 |
      | OPV2AUTO2 |
      | OPV2AUTO3 |
    And DB Operator verify order_events record for the created order:
      | type | 48 |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given DB Operator gets Hub ID by Hub Name of created parcel
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {KEY_DESTINATION_HUB_ID}
    Given Operator go to menu Inter-Hub -> Add To Shipment
    Then Operator scan the created order to shipment in hub {hub-name} to hub id = {KEY_DESTINATION_HUB_ID}

  @DeleteShipment @ForceSuccessOrder
  Scenario: Add On Hold with Missing Type to Shipment (uid:81fd47a8-9dd1-4851-861e-4ce58a141ff4)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator create new ticket on page Recovery Tickets using data below:
      | entrySource             | CUSTOMER COMPLAINT |
      | investigatingDepartment | Recovery           |
      | investigatingHub        | {hub-name}         |
      | ticketType              | MISSING            |
      | orderOutcomeMissing     | LOST - DECLARED    |
      | parcelDescription       | GENERATED          |
      | custZendeskId           | 1                  |
      | shipperZendeskId        | 1                  |
      | ticketNotes             | GENERATED          |
    And API Operator refresh created order data
    And Operator refresh page
    Given Operator go to menu Order -> Order Tag Management
    When Operator selects filter and clicks Load Selection on Add Tags to Order page using data below:
      | status          | On Hold |
      | granular status | On Hold |
    And Operator searches and selects orders created first row on Add Tags to Order page
    And Operator tags order with:
      | OPV2AUTO1 |
      | OPV2AUTO2 |
      | OPV2AUTO3 |
    And DB Operator gets Hub ID by Hub Name of created parcel
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {KEY_DESTINATION_HUB_ID}
    Given Operator go to menu Inter-Hub -> Add To Shipment
    Then Operator scan the created order to shipment in hub {hub-name} to hub id = {KEY_DESTINATION_HUB}
    And Operator verifies that the row of the added order is blue highlighted
    And Operator close the shipment which has been created
    And Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/new-shipment-management"
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | status      | Closed |
      | ordersCount | 1      |
    When Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify the Shipment Details Page opened is for the created shipment
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name | ADDED TO SHIPMENT |

  @DeleteShipment @ForceSuccessOrder
  Scenario: Remove Parcel In Shipment from Action Toggle (uid:10201e78-b282-4eee-a1fb-f32e6c31f9e5)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 3                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-2} } |
    Given DB Operator gets Hub ID by Hub Name of created parcel
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id-2} to hub id = {KEY_DESTINATION_HUB_ID}
    Given Operator go to menu Inter-Hub -> Add To Shipment
    When Operator scan multiple created order to shipment in hub {hub-name-2} to hub id = {KEY_DESTINATION_HUB_ID}
    And Operator removes all the parcel from the shipment
    Then Operator verifies that the parcel shown is zero

  @DeleteShipment @ForceSuccessOrder
  Scenario: Remove Parcel In Shipment from Remove Field (uid:bcea2152-bbb9-4963-b418-8949ea22f2a4)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And DB Operator gets Hub ID by Hub Name of created parcel
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {KEY_DESTINATION_HUB_ID}
    Given Operator go to menu Inter-Hub -> Add To Shipment
    Then Operator scan the created order to shipment in hub {hub-name} to hub id = {KEY_DESTINATION_HUB}
    And Operator verifies that the row of the added order is blue highlighted
    And Operator removes the parcel from the shipment
    And Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/new-shipment-management"
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | status      | Pending |
      | ordersCount | 0       |
    When Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify the Shipment Details Page opened is for the created shipment
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name | REMOVED FROM SHIPMENT |

  @DeleteShipment @ForceSuccessOrder
  Scenario: Close Shipment (uid:c543c8e9-cd7d-434f-9670-49f2e2462c57)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given Operator go to menu Inter-Hub -> Add To Shipment
    When Operator scan the created order to shipment in hub {hub-name} to hub id = {hub-name-2}
    And Operator close the shipment which has been created
    And Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/new-shipment-management"
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | shipmentType | AIR_HAUL                  |
      | id           | {KEY_CREATED_SHIPMENT_ID} |
      | status       | Closed                    |
      | userId       | {operator-portal-uid}     |
      | origHubName  | {hub-name}                |
      | currHubName  | {hub-name}                |
      | destHubName  | {hub-name-2}              |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op