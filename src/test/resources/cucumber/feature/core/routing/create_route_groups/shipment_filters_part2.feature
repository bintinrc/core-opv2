@OperatorV2 @Core @Routing  @CreateRouteGroups @ShipmentFiltersPart2
Feature: Create Route Groups - Shipment Filters

  https://studio.cucumber.io/projects/208144/test-plan/folders/2096344

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteCreatedShipments @HighPriority
  Scenario: Operator Filter Shipment Status on Create Route Group - Pending - Shipment Filters
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2096344/scenarios/8129456
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{date: 1 days next, yyyy-MM-dd}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Hub Automation Customer","email":"hub.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"-","postcode":"960304","city":"-","country":"SG"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    And API Sort - Operator adds order to shipment:
      | shipmentId | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}                                                                           |
      | request    | {"order_country":"sg","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","hub_id":{hub-id},"action_type":"ADD"} |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    When Operator set General Filters on Create Route Groups page:
      | creationTime | today                 |
      | shipper      | {filter-shipper-name} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    And Operator set Shipment Filters on Create Route Groups page:
      | shipmentDateFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentDateTo   | {gradle-next-1-day-yyyy-MM-dd} |
      | shipmentStatus   | Pending                        |
      | shipmentType     | AIR_HAUL                       |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction records on Create Route Groups page using data below:
      | trackingId                                 | type                 | shipper                                  | address                                                     | status         |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortToAddressString}   | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortFromAddressString} | Pending Pickup |

  @DeleteCreatedShipments @HighPriority
  Scenario: Operator Filter Shipment Status on Create Route Group - At Transit Hub - Shipment Filters
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2096344/scenarios/6907935
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{date: 1 days next, yyyy-MM-dd}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Hub Automation Customer","email":"hub.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"-","postcode":"960304","city":"-","country":"SG"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    And API Sort - Operator adds order to shipment:
      | shipmentId | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}                                                                           |
      | request    | {"order_country":"sg","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","hub_id":{hub-id},"action_type":"ADD"} |
    And API MM - Operator scan inbound single shipment without trip:
      | scanValue | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | scanType  | shipment_hub_inbound                     |
      | hubId     | {hub-id}                                 |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    When Operator set General Filters on Create Route Groups page:
      | creationTime | today                 |
      | shipper      | {filter-shipper-name} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    And Operator set Shipment Filters on Create Route Groups page:
      | shipmentDateFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentDateTo   | {gradle-next-1-day-yyyy-MM-dd} |
      | shipmentStatus   | At Transit Hub                 |
      | shipmentType     | AIR_HAUL                       |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction records on Create Route Groups page using data below:
      | trackingId                                 | type                 | shipper                                  | address                                                     | status         |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortFromAddressString} | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortToAddressString}   | Pending Pickup |

  @DeleteCreatedShipments @HighPriority
  Scenario: Operator Filter Shipment Status on Create Route Group - Transit - Shipment Filters
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2096344/scenarios/8129457
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{date: 1 days next, yyyy-MM-dd}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Hub Automation Customer","email":"hub.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"-","postcode":"960304","city":"-","country":"SG"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    And API Sort - Operator adds order to shipment:
      | shipmentId | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}                                                                           |
      | request    | {"order_country":"sg","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","hub_id":{hub-id},"action_type":"ADD"} |
    When API MM - Operator closes shipments "KEY_MM_LIST_OF_CREATED_SHIPMENTS"
    And API MM - Operator scan inbound single shipment without trip:
      | scanValue | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | scanType  | SHIPMENT_VAN_INBOUND                     |
      | hubId     | {hub-id}                                 |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    When Operator set General Filters on Create Route Groups page:
      | creationTime | today                 |
      | shipper      | {filter-shipper-name} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    And Operator set Shipment Filters on Create Route Groups page:
      | shipmentDateFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentDateTo   | {gradle-next-1-day-yyyy-MM-dd} |
      | shipmentStatus   | Transit                        |
      | shipmentType     | AIR_HAUL                       |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction records on Create Route Groups page using data below:
      | trackingId                                 | type                 | shipper                                  | address                                                     | status         |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortToAddressString}   | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortFromAddressString} | Pending Pickup |

  @DeleteCreatedShipments @HighPriority
  Scenario: Operator Filter Shipment Status on Create Route Group - Completed - Shipment Filters
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2096344/scenarios/8129455
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{date: 1 days next, yyyy-MM-dd}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Hub Automation Customer","email":"hub.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"-","postcode":"960304","city":"-","country":"SG"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","dimensions":null,"to_reschedule":false,"to_show_shipper_info":false,"tags":[]} |
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                                                                         |
      | hubId                | {hub-id}                                                                                                      |
    And API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    And API Sort - Operator adds order to shipment:
      | shipmentId | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}                                                                           |
      | request    | {"order_country":"sg","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","hub_id":{hub-id},"action_type":"ADD"} |
    When API MM - Operator closes shipments "KEY_MM_LIST_OF_CREATED_SHIPMENTS"
    And API MM - Operator scan inbound single shipment without trip:
      | scanValue | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | scanType  | SHIPMENT_VAN_INBOUND                     |
      | hubId     | {hub-id}                                 |
    And API MM - Operator scan inbound single shipment without trip:
      | scanValue | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
      | scanType  | shipment_hub_inbound                     |
      | hubId     | {hub-id-2}                               |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    When Operator set General Filters on Create Route Groups page:
      | creationTime | today                 |
      | shipper      | {filter-shipper-name} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    And Operator set Shipment Filters on Create Route Groups page:
      | shipmentDateFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentDateTo   | {gradle-next-1-day-yyyy-MM-dd} |
      | shipmentStatus   | Completed                      |
      | shipmentType     | AIR_HAUL                       |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction records on Create Route Groups page using data below:
      | trackingId                                 | type                 | shipper                                  | address                                                     | status                 |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortToAddressString}   | Arrived at Sorting Hub |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortFromAddressString} | Arrived at Sorting Hub |

  @DeleteCreatedShipments @HighPriority
  Scenario: Operator Filter Shipment Status on Create Route Group - Cancelled - Shipment Filters
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2096344/scenarios/8129453
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{date: 1 days next, yyyy-MM-dd}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Hub Automation Customer","email":"hub.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"-","postcode":"960304","city":"-","country":"SG"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    And API Sort - Operator adds order to shipment:
      | shipmentId | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}                                                                           |
      | request    | {"order_country":"sg","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","hub_id":{hub-id},"action_type":"ADD"} |
    When API MM - Operator updates shipment "KEY_MM_LIST_OF_CREATED_SHIPMENTS[1]" status to "Cancelled"
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    When Operator set General Filters on Create Route Groups page:
      | creationTime | today                 |
      | shipper      | {filter-shipper-name} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    And Operator set Shipment Filters on Create Route Groups page:
      | shipmentDateFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentDateTo   | {gradle-next-1-day-yyyy-MM-dd} |
      | shipmentStatus   | Cancelled                      |
      | shipmentType     | AIR_HAUL                       |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction records on Create Route Groups page using data below:
      | trackingId                                 | type                 | shipper                                  | address                                                     | status         |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortToAddressString}   | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortFromAddressString} | Pending Pickup |

  @DeleteCreatedShipments @HighPriority
  Scenario: Operator Filter Shipment Status on Create Route Group - Closed - Shipment Filters
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2096344/scenarios/8129454
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{date: 1 days next, yyyy-MM-dd}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{date: 1 days next, yyyy-MM-dd}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Hub Automation Customer","email":"hub.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"30A ST. THOMAS WALK 102600 SG","address2":"-","postcode":"960304","city":"-","country":"SG"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API MM - Operator creates multiple 1 new shipments with type "AIR_HAUL" from hub id "{hub-id}" to "{hub-id-2}"
    And API Sort - Operator adds order to shipment:
      | shipmentId | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}                                                                           |
      | request    | {"order_country":"sg","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","hub_id":{hub-id},"action_type":"ADD"} |
    When API MM - Operator closes shipments "KEY_MM_LIST_OF_CREATED_SHIPMENTS"
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    When Operator set General Filters on Create Route Groups page:
      | creationTime | today                 |
      | shipper      | {filter-shipper-name} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    And Operator set Shipment Filters on Create Route Groups page:
      | shipmentDateFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentDateTo   | {gradle-next-1-day-yyyy-MM-dd} |
      | shipmentStatus   | Closed                         |
      | shipmentType     | AIR_HAUL                       |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction records on Create Route Groups page using data below:
      | trackingId                                 | type                 | shipper                                  | address                                                     | status         |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortToAddressString}   | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortFromAddressString} | Pending Pickup |