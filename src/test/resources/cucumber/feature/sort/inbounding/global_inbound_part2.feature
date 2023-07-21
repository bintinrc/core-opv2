@Sort @Inbounding @GlobalInbound @GlobalInboundPart2 @Saas @Inbound
Feature: Global Inbound

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CloseNewWindows @happy-path
  Scenario: Inbound showing weight discrepancy alert - weight tolerance is not set, lower weight (uid:272f52ce-9443-4510-a7fd-10ff40c28c4c)
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Order - Shipper create multiple V4 orders using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu System Settings -> Global Settings
    And Operator set Weight Tolerance value to "" on Global Settings page
    And Operator save Inbound settings on Global Settings page
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                          |
      | parcelType | {parcel-type-bulky}                   |
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_LIST_OF_CREATED_ORDERS[1].destinationHub} |
      | rackInfo       | {KEY_LIST_OF_CREATED_ORDERS[1].rackSector}     |
      | color          | #f06c00                                        |
    Then API Core - Operator verify that event is published with correct details:
      | orderId   | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                                                                                 |
      | eventType | UPDATE_STATUS                                                                                                                                                                      |
      | eventData | {"granular_status": {"old_value": "Pending Pickup","new_value": "Arrived at Sorting Hub"},"order_status": {"old_value": "Pending","new_value": "Transit","reason": "HUB_INBOUND"}} |


  @CloseNewWindows @happy-path
  Scenario: Inbound showing weight discrepancy alert - weight tolerance is set, higher weight (uid:6fd8c798-b6b4-4920-bbc8-891bd6355eae)
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Order - Shipper create multiple V4 orders using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu System Settings -> Global Settings
    And Operator set Weight Tolerance value to "2" on Global Settings page
    And Operator save Inbound settings on Global Settings page
    And Operator refresh page
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below and check alert:
      | hubName        | {hub-name-3}                             |
      | parcelType     | {parcel-type-bulky}                      |
      | trackingId     | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}    |
      | overrideWeight | 10                                       |
      | weightWarning  | Weight is higher than original by 6.0 kg |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_LIST_OF_CREATED_ORDERS[1].destinationHub} |
      | rackInfo       | {KEY_LIST_OF_CREATED_ORDERS[1].rackSector}     |
      | color          | #f06c00                                        |
    Then API Core - Operator verify that event is published with correct details:
      | orderId   | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                                                                                 |
      | eventType | UPDATE_STATUS                                                                                                                                                                      |
      | eventData | {"granular_status": {"old_value": "Pending Pickup","new_value": "Arrived at Sorting Hub"},"order_status": {"old_value": "Pending","new_value": "Transit","reason": "HUB_INBOUND"}} |


  @CloseNewWindows @happy-path
  Scenario: Inbound showing Weight Discrepancy Alert - weight tolerance is set, lower weight (uid:ccae0c7e-cee9-45e4-adfe-024b8334e6a6)
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Order - Shipper create multiple V4 orders using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":1.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu System Settings -> Global Settings
    And Operator set Weight Tolerance value to "2" on Global Settings page
    And Operator save Inbound settings on Global Settings page
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And API Core - update order dimensions:
      | orderId    | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | dimensions | {"weight":10,"pricingWeight":10}   |
    And Operator refresh page
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below and check alert:
      | hubName        | {hub-name-3}                            |
      | parcelType     | {parcel-type-bulky}                     |
      | trackingId     | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}   |
      | overrideWeight | 2                                       |
      | weightWarning  | Weight is lower than original by 8.0 kg |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_LIST_OF_CREATED_ORDERS[1].destinationHub} |
      | rackInfo       | {KEY_LIST_OF_CREATED_ORDERS[1].rackSector}     |
      | color          | #f06c00                                        |
    Then API Core - Operator verify that event is published with correct details:
      | orderId   | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                                                                                 |
      | eventType | UPDATE_STATUS                                                                                                                                                                      |
      | eventData | {"granular_status": {"old_value": "Pending Pickup","new_value": "Arrived at Sorting Hub"},"order_status": {"old_value": "Pending","new_value": "Transit","reason": "HUB_INBOUND"}} |


  @CloseNewWindows
  Scenario: Inbound Fully Integrated DP Order (uid:8a855ffd-2b50-4aea-a358-53cff150ad98)
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Order - Shipper create multiple V4 orders using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest | {"service_type":"Parcel","service_level":"standard","reference":{"merchant_order_number":"ship-123"},"to":{"name":"Latika Jamnal","phone_number":"+6588923644","email":"ninjavan.qa3@gmail.com","address":{"country":"SG","address1":"30 Jalan Kilang Barat","address2":"NVQA V4 HQ","postcode":"628586"}, "collection_point": "{dp-short-name}"},"parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Singapore"},"pickup_address_slot_id":1,"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Singapore"},"dimensions":{"weight":2},"allow_self_collection":true}} |
    And Operator go to menu Inbounding -> Global Inbound
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Then Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                          |
      | parcelType | {parcel-type-bulky}                   |
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_LIST_OF_CREATED_ORDERS[1].destinationHub} |
      | rackInfo       | {KEY_LIST_OF_CREATED_ORDERS[1].rackSector}     |
      | color          | #f06c00                                        |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And Operator verifies DP tag is displayed
    And DB Events - verify order_events record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | type    | 26                                 |
    And DB Core - Operator verifies inbound_scans record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | hubId   | {hub-id-3}                         |
      | type    | 2                                  |
    When API DP - Operator get the DP Details by DP ID = "{dp-id}"
    When DB DP - get DP Reservation using barcode "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And Ninja Collect Operator verifies that all the details for Confirmed Status via "Fully Integrated" are right
      | barcode     | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}       |
      | id          | {dp-id}                                     |
      | dpBarcode   | {KEY_DP_LIST_OF_DP_RESERVATIONS[1].barcode} |
      | dpDetailsId | {KEY_DP_LIST_OF_DP_DETAILS[1].id}           |
      | dpStatus    | {KEY_DP_LIST_OF_DP_RESERVATIONS[1].status}  |
      | dpSource    | {KEY_DP_LIST_OF_DP_RESERVATIONS[1].source}  |

  @CloseNewWindows
  Scenario: Inbound Semi Integrated DP Order (uid:d846ee76-cf66-4b14-8e91-88f3f8f3999f)
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-semi-integrated-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {shipper-semi-integrated-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"standard","reference":{"merchant_order_number":"ship-123"},"to":{"name":"Latika Jamnal","phone_number":"+6596548707","email":"ninjavan.qa3@gmail.com","address":{"country":"SG","address2":"SIANG LIM SIAN LI BUDDHIST TEMPLE","address1":"184E JALAN TOA PAYOH #1-1","postcode":"319941"}},"parcel_job":{"allow_doorstep_dropoff": true,"enforce_delivery_verification": false,"delivery_verification_mode": "SIGNATURE","is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","cash_on_delivery":null,"pickup_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Singapore"},"pickup_address_slot_id":1,"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Singapore"},"dimensions":{"weight":1},"allow_self_collection":true}} |
    And Operator go to menu Inbounding -> Global Inbound
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                          |
      | parcelType | {parcel-type-bulky}                   |
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_LIST_OF_CREATED_ORDERS[1].destinationHub} |
      | rackInfo       | {KEY_LIST_OF_CREATED_ORDERS[1].rackSector}     |
      | color          | #f06c00                                        |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Then API Core - Operator verify that event is published with correct details:
      | orderId   | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                                                                                 |
      | eventType | UPDATE_STATUS                                                                                                                                                                      |
      | eventData | {"granular_status": {"old_value": "Pending Pickup","new_value": "Arrived at Sorting Hub"},"order_status": {"old_value": "Pending","new_value": "Transit","reason": "HUB_INBOUND"}} |
    And DB Events - verify order_events record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | type    | 26                                 |
    And DB Core - Operator verifies inbound_scans record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | hubId   | {hub-id-3}                         |
      | type    | 2                                  |
    When API DP - Operator get the DP Details by DP ID = "{dp-id}"
    When DB DP - get DP Reservation using barcode "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And Ninja Collect Operator verifies that all the details for Confirmed Status via "Semi Integrated" are right
      | barcode     | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}       |
      | id          | {dp-id}                                     |
      | dpBarcode   | {KEY_DP_LIST_OF_DP_RESERVATIONS[1].barcode} |
      | dpDetailsId | {KEY_DP_LIST_OF_DP_DETAILS[1].id}           |
      | dpStatus    | {KEY_DP_LIST_OF_DP_RESERVATIONS[1].status}  |
      | dpSource    | {KEY_DP_LIST_OF_DP_RESERVATIONS[1].source}  |
#    When API DP get the DP Details by DP ID = "{dp-id}"
#    And DB Operator gets all details for ninja collect confirmed status
#    And Ninja Collect Operator verifies that all the details for Confirmed Status via "Semi Integrated" are right

  @CloseNewWindows @happy-path
  Scenario: Inbound Parcel with Order Tags (uid:3f95f6e9-4e6a-4599-b438-7b1b74330c33)
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Order - Shipper create multiple V4 orders using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-working-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-2-working-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Order -> Order Tag Management
    When Operator selects filter and clicks Load Selection on Add Tags to Order page using data below:
      | shipperName     | {shipper-v4-name} |
      | status          | Pending           |
      | granular status | Pending Pickup    |
    And Operator searches and selects orders created first row on Add Tags to Order page
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator tags order with:
      | OPV2AUTO1 |
      | OPV2AUTO2 |
      | OPV2AUTO3 |
    And Operator go to menu Inbounding -> Global Inbound
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Then Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                          |
      | parcelType | {parcel-type-bulky}                   |
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_LIST_OF_CREATED_ORDERS[1].destinationHub} |
      | rackInfo       | {KEY_LIST_OF_CREATED_ORDERS[1].rackSector}     |
      | color          | #f06c00                                        |
    Then Operator verifies tags on Global Inbound page
      | OPV2AUTO1 |
      | OPV2AUTO2 |
      | OPV2AUTO3 |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Then API Core - Operator verify that event is published with correct details:
      | orderId   | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                                                                                                                                 |
      | eventType | UPDATE_STATUS                                                                                                                                                                      |
      | eventData | {"granular_status": {"old_value": "Pending Pickup","new_value": "Arrived at Sorting Hub"},"order_status": {"old_value": "Pending","new_value": "Transit","reason": "HUB_INBOUND"}} |
    And DB Events - verify order_events record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | type    | 26                                 |
    And DB Core - Operator verifies inbound_scans record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | hubId   | {hub-id-3}                         |
      | type    | 2                                  |

  @CloseNewWindows @happy-path
  Scenario: Inbound On Hold Order - Resolve PENDING MISSING ticket type (uid:e1211ee8-24c0-42f2-bb00-4940d65950da)
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Order - Shipper create multiple V4 orders using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Recovery - Operator create recovery ticket:
      | trackingId         | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | entrySource        | CUSTOMER COMPLAINT                    |
      | investigatingParty | 448                                   |
      | investigatingHubId | {hub-id}                              |
      | ticketType         | MISSING                               |
      | orderOutcomeName   | ORDER OUTCOME (MISSING)               |
      | creatorUserId      | 106307852128204474889                 |
      | creatorUserName    | Niko Susanto                          |
      | creatorUserEmail   | niko.susanto@ninjavan.co              |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And Operator go to menu Inbounding -> Global Inbound
    Then Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                          |
      | parcelType | {parcel-type-bulky}                   |
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_LIST_OF_CREATED_ORDERS[1].destinationHub} |
      | rackInfo       | {KEY_LIST_OF_CREATED_ORDERS[1].rackSector}     |
      | color          | #f06c00                                        |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    Then API Core - Operator verify that "TICKET_RESOLVED" event is published for order id "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And DB Events - verify order_events record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | type    | 26                                 |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op