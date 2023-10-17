@OperatorV2 @Core @Routing @RoutingJob4 @CreateRouteGroups @ShipmentFiltersPart1 @CRG5
Feature: Create Route Groups - Shipment Filters

  https://studio.cucumber.io/projects/208144/test-plan/folders/2096344

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment
  Scenario Outline: Operator Filter Shipment Type on Create Route Group - Shipment Filters - Shipment Type = <name>
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2096344/scenarios/6907884
    And API Operator create new shipment with type "<shipmentType>" from hub id = {hub-id} to hub id = {hub-id-2}
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                           |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                       |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator adds order to shipment:
      | shipmentId | {KEY_CREATED_SHIPMENT_ID}                                                                                               |
      | request    | {"order_country":"sg","tracking_id":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","hub_id":{hub-id},"action_type":"ADD"} |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    When Operator set General Filters on Create Route Groups page:
      | creationTime | today                 |
      | shipper      | {filter-shipper-name} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    And Operator set Shipment Filters on Create Route Groups page:
      | shipmentDateFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentDateTo   | {gradle-next-1-day-yyyy-MM-dd} |
      | shipmentType     | <shipmentType>                 |
      | shipmentStatus   | Pending                        |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction records on Create Route Groups page using data below:
      | trackingId                                 | type                 | shipper                                  | address                                                     | status         |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortToAddressString}   | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortFromAddressString} | Pending Pickup |
    Examples:
      | name         | shipmentType |
      | Air Haul     | AIR_HAUL     |
      | Land Haul    | LAND_HAUL    |
      | Sea Haul     | SEA_HAUL     |
      | Cross Border | CROSS_BORDER |
      | Others       | OTHERS       |

  @DeleteCreatedShipments
  Scenario: Operator Filter Shipment Last Inbound Hub on Create Route Group - Shipment Filters
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2096344/scenarios/6907937
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
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    When Operator set General Filters on Create Route Groups page:
      | creationTime | today                 |
      | shipper      | {filter-shipper-name} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    And Operator set Shipment Filters on Create Route Groups page:
      | shipmentDateFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentDateTo   | {gradle-next-1-day-yyyy-MM-dd} |
      | shipmentType     | AIR_HAUL                       |
      | shipmentStatus   | Transit                        |
      | lastInboundHub   | {hub-name}                     |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction records on Create Route Groups page using data below:
      | trackingId                                 | type                 | shipper                                  | address                                                     | status                 |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortToAddressString}   | Arrived at Sorting Hub |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortFromAddressString} | Arrived at Sorting Hub |

  @DeleteCreatedShipments
  Scenario: Operator Filter Shipment MAWB on Create Route Group - Shipment Filters
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2096344/scenarios/6907940
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
    And API Operator assign mawb "mawb_{KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id}" to following shipmentIds
      | {KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    When Operator set General Filters on Create Route Groups page:
      | creationTime | today                 |
      | shipper      | {filter-shipper-name} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    And Operator set Shipment Filters on Create Route Groups page:
      | shipmentDateFrom | {gradle-next-0-day-yyyy-MM-dd}                |
      | shipmentDateTo   | {gradle-next-1-day-yyyy-MM-dd}                |
      | shipmentType     | AIR_HAUL                                      |
      | shipmentStatus   | Pending                                       |
      | mawb             | mawb_{KEY_MM_LIST_OF_CREATED_SHIPMENTS[1].id} |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction records on Create Route Groups page using data below:
      | trackingId                                 | type                 | shipper                                  | address                                                     | status         |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortToAddressString}   | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortFromAddressString} | Pending Pickup |

  @DeleteCreatedShipments
  Scenario: Operator Filter Shipment Start Hub on Create Route Group - Shipment Filters
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2096344/scenarios/6907938
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
      | shipmentType     | AIR_HAUL                       |
      | shipmentStatus   | Pending                        |
      | startHub         | {hub-name}                     |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction records on Create Route Groups page using data below:
      | trackingId                                 | type                 | shipper                                  | address                                                     | status         |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortToAddressString}   | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortFromAddressString} | Pending Pickup |

  @DeleteCreatedShipments
  Scenario: Operator Filter Shipment ETA (Date Time) on Create Route Group - Shipment Filters
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2096344/scenarios/6907853
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
      | shipmentDateFrom | {gradle-next-0-day-yyyy-MM-dd}     |
      | shipmentDateTo   | {gradle-next-1-day-yyyy-MM-dd}     |
      | shipmentType     | AIR_HAUL                           |
      | shipmentStatus   | Closed                             |
      | etaDateTimeFrom  | {gradle-previous-1-day-yyyy-MM-dd} |
      | etaDateTimeTo    | {gradle-next-1-day-yyyy-MM-dd}     |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction records on Create Route Groups page using data below:
      | trackingId                                 | type                 | shipper                                  | address                                                     | status         |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortToAddressString}   | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortFromAddressString} | Pending Pickup |

  @DeleteCreatedShipments
  Scenario: Operator Filter Shipment End Hub on Create Route Group - Shipment Filters
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2096344/scenarios/6907939
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
      | shipmentType     | AIR_HAUL                       |
      | shipmentStatus   | Pending                        |
      | endHub           | {hub-name-2}                   |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction records on Create Route Groups page using data below:
      | trackingId                                 | type                 | shipper                                  | address                                                     | status         |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortToAddressString}   | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortFromAddressString} | Pending Pickup |

  @DeleteCreatedShipments
  Scenario: Operator Filter Shipment Transit Date Time on Create Route Group - Shipment Filters
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2096344/scenarios/6907888
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
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    When Operator set General Filters on Create Route Groups page:
      | creationTime | today                 |
      | shipper      | {filter-shipper-name} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    And Operator set Shipment Filters on Create Route Groups page:
      | shipmentDateFrom    | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentDateTo      | {gradle-next-1-day-yyyy-MM-dd} |
      | shipmentType        | AIR_HAUL                       |
      | shipmentStatus      | Transit                        |
      | transitDateTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | transitDateTimeTo   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction records on Create Route Groups page using data below:
      | trackingId                                 | type                 | shipper                                  | address                                                     | status                 |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortToAddressString}   | Arrived at Sorting Hub |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortFromAddressString} | Arrived at Sorting Hub |

  @DeleteCreatedShipments
  Scenario: Operator Filter Shipment Completion Date on Create Route Group - Shipment Filters
    # https://studio.cucumber.io/projects/208144/test-plan/folders/2096344/scenarios/6907943
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
      | shipmentDateFrom               | {gradle-next-0-day-yyyy-MM-dd}     |
      | shipmentDateTo                 | {gradle-next-1-day-yyyy-MM-dd}     |
      | shipmentType                   | AIR_HAUL                           |
      | shipmentStatus                 | Completed                          |
      | shipmentCompletionDateTimeFrom | {gradle-previous-1-day-yyyy-MM-dd} |
      | shipmentCompletionDateTimeTo   | {gradle-next-1-day-yyyy-MM-dd}     |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction records on Create Route Groups page using data below:
      | trackingId                                 | type                 | shipper                                  | address                                                     | status                 |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortToAddressString}   | Arrived at Sorting Hub |
      | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDERS[1].fromName} | {KEY_LIST_OF_CREATED_ORDERS[1].buildShortFromAddressString} | Arrived at Sorting Hub |
