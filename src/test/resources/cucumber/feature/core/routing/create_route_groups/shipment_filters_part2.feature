@OperatorV2 @Core @Routing @RoutingJob4 @CreateRouteGroups @ShipmentFiltersPart2 @CRG5
Feature: Create Route Groups - Shipment Filters

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment
  Scenario: Operator Filter Shipment Status on Create Route Group - Pending - Shipment Filters
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator adds order to shipment:
      | shipmentId | {KEY_CREATED_SHIPMENT_ID}                                                                                   |
      | request    | {"order_country":"sg","tracking_id":"{KEY_CREATED_ORDER.trackingId}","hub_id":{hub-id},"action_type":"ADD"} |
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
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction records on Create Route Groups page using data below:
      | trackingId                     | type                 | shipper                      | address                                         | status         |
      | {KEY_CREATED_ORDER.trackingId} | DELIVERY Transaction | {KEY_CREATED_ORDER.fromName} | {KEY_CREATED_ORDER.buildShortToAddressString}   | Pending Pickup |
      | {KEY_CREATED_ORDER.trackingId} | PICKUP Transaction   | {KEY_CREATED_ORDER.fromName} | {KEY_CREATED_ORDER.buildShortFromAddressString} | Pending Pickup |

  @DeleteShipment
  Scenario: Operator Filter Shipment Status on Create Route Group - At Transit Hub - Shipment Filters
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator adds order to shipment:
      | shipmentId | {KEY_CREATED_SHIPMENT_ID}                                                                                   |
      | request    | {"order_country":"sg","tracking_id":"{KEY_CREATED_ORDER.trackingId}","hub_id":{hub-id},"action_type":"ADD"} |
    Given API Operator does the "hub-inbound" scan for the shipment at transit hub = {hub-id}
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
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction records on Create Route Groups page using data below:
      | trackingId                     | type                 | shipper                      | address                                         | status         |
      | {KEY_CREATED_ORDER.trackingId} | DELIVERY Transaction | {KEY_CREATED_ORDER.fromName} | {KEY_CREATED_ORDER.buildShortToAddressString}   | Pending Pickup |
      | {KEY_CREATED_ORDER.trackingId} | PICKUP Transaction   | {KEY_CREATED_ORDER.fromName} | {KEY_CREATED_ORDER.buildShortFromAddressString} | Pending Pickup |

  @DeleteShipment
  Scenario: Operator Filter Shipment Status on Create Route Group - Transit - Shipment Filters
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator adds order to shipment:
      | shipmentId | {KEY_CREATED_SHIPMENT_ID}                                                                                   |
      | request    | {"order_country":"sg","tracking_id":"{KEY_CREATED_ORDER.trackingId}","hub_id":{hub-id},"action_type":"ADD"} |
    And API Operator closes the created shipment
    And API Operator performs van inbound by updating shipment status using data below:
      | scanValue  | {KEY_CREATED_SHIPMENT_ID} |
      | hubCountry | SG                        |
      | hubId      | {hub-id}                  |
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
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction records on Create Route Groups page using data below:
      | trackingId                     | type                 | shipper                      | address                                         | status         |
      | {KEY_CREATED_ORDER.trackingId} | DELIVERY Transaction | {KEY_CREATED_ORDER.fromName} | {KEY_CREATED_ORDER.buildShortToAddressString}   | Pending Pickup |
      | {KEY_CREATED_ORDER.trackingId} | PICKUP Transaction   | {KEY_CREATED_ORDER.fromName} | {KEY_CREATED_ORDER.buildShortFromAddressString} | Pending Pickup |

  @DeleteShipment
  Scenario: Operator Filter Shipment Status on Create Route Group - Completed - Shipment Filters
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator adds order to shipment:
      | shipmentId | {KEY_CREATED_SHIPMENT_ID}                                                                                   |
      | request    | {"order_country":"sg","tracking_id":"{KEY_CREATED_ORDER.trackingId}","hub_id":{hub-id},"action_type":"ADD"} |
    And API Operator closes the created shipment
    And API Operator performs van inbound by updating shipment status using data below:
      | scanValue  | {KEY_CREATED_SHIPMENT_ID} |
      | hubCountry | SG                        |
      | hubId      | {hub-id}                  |
    Given API Operator does the "hub-inbound" scan for the shipment at transit hub = {hub-id-2}
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
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction records on Create Route Groups page using data below:
      | trackingId                     | type                 | shipper                      | address                                         | status         |
      | {KEY_CREATED_ORDER.trackingId} | DELIVERY Transaction | {KEY_CREATED_ORDER.fromName} | {KEY_CREATED_ORDER.buildShortToAddressString}   | Pending Pickup |
      | {KEY_CREATED_ORDER.trackingId} | PICKUP Transaction   | {KEY_CREATED_ORDER.fromName} | {KEY_CREATED_ORDER.buildShortFromAddressString} | Pending Pickup |

  @DeleteShipment
  Scenario: Operator Filter Shipment Status on Create Route Group - Cancelled - Shipment Filters
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator adds order to shipment:
      | shipmentId | {KEY_CREATED_SHIPMENT_ID}                                                                                   |
      | request    | {"order_country":"sg","tracking_id":"{KEY_CREATED_ORDER.trackingId}","hub_id":{hub-id},"action_type":"ADD"} |
    And API Operator cancel shipment "{KEY_CREATED_SHIPMENT_ID}"
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
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction records on Create Route Groups page using data below:
      | trackingId                     | type                 | shipper                      | address                                         | status         |
      | {KEY_CREATED_ORDER.trackingId} | DELIVERY Transaction | {KEY_CREATED_ORDER.fromName} | {KEY_CREATED_ORDER.buildShortToAddressString}   | Pending Pickup |
      | {KEY_CREATED_ORDER.trackingId} | PICKUP Transaction   | {KEY_CREATED_ORDER.fromName} | {KEY_CREATED_ORDER.buildShortFromAddressString} | Pending Pickup |

  @DeleteShipment
  Scenario: Operator Filter Shipment Status on Create Route Group - Closed - Shipment Filters
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator adds order to shipment:
      | shipmentId | {KEY_CREATED_SHIPMENT_ID}                                                                                   |
      | request    | {"order_country":"sg","tracking_id":"{KEY_CREATED_ORDER.trackingId}","hub_id":{hub-id},"action_type":"ADD"} |
    And API Operator closes the created shipment
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
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction records on Create Route Groups page using data below:
      | trackingId                     | type                 | shipper                      | address                                         | status         |
      | {KEY_CREATED_ORDER.trackingId} | DELIVERY Transaction | {KEY_CREATED_ORDER.fromName} | {KEY_CREATED_ORDER.buildShortToAddressString}   | Pending Pickup |
      | {KEY_CREATED_ORDER.trackingId} | PICKUP Transaction   | {KEY_CREATED_ORDER.fromName} | {KEY_CREATED_ORDER.buildShortFromAddressString} | Pending Pickup |
