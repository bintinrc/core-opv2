@OperatorV2 @Core @Routing @RoutingJob4 @CreateRouteGroups
Feature: Create Route Groups - Shipment Filters

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment
  Scenario Outline: Operator Filter Shipment Type on Create Route Group - Shipment Filters - Shipment Type = <name>
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipment with type "<shipmentType>" from hub id = {hub-id} to hub id = {hub-id-2}
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator put created parcel to shipment
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
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction records on Create Route Groups page using data below:
      | trackingId                     | type                 | shipper                      | address                                         | status         |
      | {KEY_CREATED_ORDER.trackingId} | DELIVERY Transaction | {KEY_CREATED_ORDER.fromName} | {KEY_CREATED_ORDER.buildShortToAddressString}   | Pending Pickup |
      | {KEY_CREATED_ORDER.trackingId} | PICKUP Transaction   | {KEY_CREATED_ORDER.fromName} | {KEY_CREATED_ORDER.buildShortFromAddressString} | Pending Pickup |
    Examples:
      | name         | shipmentType |
      | Air Haul     | AIR_HAUL     |
      | Land Haul    | LAND_HAUL    |
      | Sea Haul     | SEA_HAUL     |
      | Cross Border | CROSS_BORDER |
      | Others       | OTHERS       |

  @DeleteShipment
  Scenario: Operator Filter Shipment Last Inbound Hub on Create Route Group - Shipment Filters
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
      | shipmentType     | AIR_HAUL                       |
      | shipmentStatus   | At Transit Hub                 |
      | lastInboundHub   | {hub-name}                     |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction records on Create Route Groups page using data below:
      | trackingId                     | type                 | shipper                      | address                                         | status         |
      | {KEY_CREATED_ORDER.trackingId} | DELIVERY Transaction | {KEY_CREATED_ORDER.fromName} | {KEY_CREATED_ORDER.buildShortToAddressString}   | Pending Pickup |
      | {KEY_CREATED_ORDER.trackingId} | PICKUP Transaction   | {KEY_CREATED_ORDER.fromName} | {KEY_CREATED_ORDER.buildShortFromAddressString} | Pending Pickup |

  @DeleteShipment
  Scenario: Operator Filter Shipment MAWB on Create Route Group - Shipment Filters
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator adds order to shipment:
      | shipmentId | {KEY_CREATED_SHIPMENT_ID}                                                                                   |
      | request    | {"order_country":"sg","tracking_id":"{KEY_CREATED_ORDER.trackingId}","hub_id":{hub-id},"action_type":"ADD"} |
    And API Operator assign mawb "mawb_{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]}" to following shipmentIds
      | {KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    When Operator set General Filters on Create Route Groups page:
      | creationTime | today                 |
      | shipper      | {filter-shipper-name} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    And Operator set Shipment Filters on Create Route Groups page:
      | shipmentDateFrom | {gradle-next-0-day-yyyy-MM-dd}             |
      | shipmentDateTo   | {gradle-next-1-day-yyyy-MM-dd}             |
      | shipmentType     | AIR_HAUL                                   |
      | mawb             | mawb_{KEY_LIST_OF_CREATED_SHIPMENT_IDS[1]} |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction records on Create Route Groups page using data below:
      | trackingId                     | type                 | shipper                      | address                                         | status         |
      | {KEY_CREATED_ORDER.trackingId} | DELIVERY Transaction | {KEY_CREATED_ORDER.fromName} | {KEY_CREATED_ORDER.buildShortToAddressString}   | Pending Pickup |
      | {KEY_CREATED_ORDER.trackingId} | PICKUP Transaction   | {KEY_CREATED_ORDER.fromName} | {KEY_CREATED_ORDER.buildShortFromAddressString} | Pending Pickup |

  @DeleteShipment
  Scenario: Operator Filter Shipment Start Hub on Create Route Group - Shipment Filters
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
      | shipmentType     | AIR_HAUL                       |
      | startHub         | {hub-name}                     |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction records on Create Route Groups page using data below:
      | trackingId                     | type                 | shipper                      | address                                         | status         |
      | {KEY_CREATED_ORDER.trackingId} | DELIVERY Transaction | {KEY_CREATED_ORDER.fromName} | {KEY_CREATED_ORDER.buildShortToAddressString}   | Pending Pickup |
      | {KEY_CREATED_ORDER.trackingId} | PICKUP Transaction   | {KEY_CREATED_ORDER.fromName} | {KEY_CREATED_ORDER.buildShortFromAddressString} | Pending Pickup |

  @DeleteShipment
  Scenario: Operator Filter Shipment ETA (Date Time) on Create Route Group - Shipment Filters
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
      | shipmentDateFrom | {gradle-next-0-day-yyyy-MM-dd}     |
      | shipmentDateTo   | {gradle-next-1-day-yyyy-MM-dd}     |
      | shipmentType     | AIR_HAUL                           |
      | etaDateTimeFrom  | {gradle-previous-1-day-yyyy-MM-dd} |
      | etaDateTimeTo    | {gradle-next-1-day-yyyy-MM-dd}     |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction records on Create Route Groups page using data below:
      | trackingId                     | type                 | shipper                      | address                                         | status         |
      | {KEY_CREATED_ORDER.trackingId} | DELIVERY Transaction | {KEY_CREATED_ORDER.fromName} | {KEY_CREATED_ORDER.buildShortToAddressString}   | Pending Pickup |
      | {KEY_CREATED_ORDER.trackingId} | PICKUP Transaction   | {KEY_CREATED_ORDER.fromName} | {KEY_CREATED_ORDER.buildShortFromAddressString} | Pending Pickup |

  @DeleteShipment
  Scenario: Operator Filter Shipment End Hub on Create Route Group - Shipment Filters
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
      | shipmentType     | AIR_HAUL                       |
      | endHub           | {hub-name-2}                   |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction records on Create Route Groups page using data below:
      | trackingId                     | type                 | shipper                      | address                                         | status         |
      | {KEY_CREATED_ORDER.trackingId} | DELIVERY Transaction | {KEY_CREATED_ORDER.fromName} | {KEY_CREATED_ORDER.buildShortToAddressString}   | Pending Pickup |
      | {KEY_CREATED_ORDER.trackingId} | PICKUP Transaction   | {KEY_CREATED_ORDER.fromName} | {KEY_CREATED_ORDER.buildShortFromAddressString} | Pending Pickup |

  @DeleteShipment
  Scenario: Operator Filter Shipment Transit Date Time on Create Route Group - Shipment Filters
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
      | shipmentDateFrom    | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentDateTo      | {gradle-next-1-day-yyyy-MM-dd} |
      | shipmentType        | AIR_HAUL                       |
      | transitDateTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | transitDateTimeTo   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction records on Create Route Groups page using data below:
      | trackingId                     | type                 | shipper                      | address                                         | status         |
      | {KEY_CREATED_ORDER.trackingId} | DELIVERY Transaction | {KEY_CREATED_ORDER.fromName} | {KEY_CREATED_ORDER.buildShortToAddressString}   | Pending Pickup |
      | {KEY_CREATED_ORDER.trackingId} | PICKUP Transaction   | {KEY_CREATED_ORDER.fromName} | {KEY_CREATED_ORDER.buildShortFromAddressString} | Pending Pickup |

  @DeleteShipment
  Scenario: Operator Filter Shipment Completion Date on Create Route Group - Shipment Filters
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator adds order to shipment:
      | shipmentId | {KEY_CREATED_SHIPMENT_ID}                                                                                   |
      | request    | {"order_country":"sg","tracking_id":"{KEY_CREATED_ORDER.trackingId}","hub_id":{hub-id},"action_type":"ADD"} |
    Given API Operator does the "hub-inbound" scan for the shipment at transit hub = {hub-id}
    Given API Operator does the "hub-inbound" scan for the shipment at transit hub = {hub-id-2}
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    When Operator set General Filters on Create Route Groups page:
      | creationTime | today                 |
      | shipper      | {filter-shipper-name} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    And Operator set Shipment Filters on Create Route Groups page:
      | shipmentDateFrom               | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentDateTo                 | {gradle-next-1-day-yyyy-MM-dd} |
      | shipmentType                   | AIR_HAUL                       |
      | shipmentCompletionDateTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentCompletionDateTimeTo   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction records on Create Route Groups page using data below:
      | trackingId                     | type                 | shipper                      | address                                         | status         |
      | {KEY_CREATED_ORDER.trackingId} | DELIVERY Transaction | {KEY_CREATED_ORDER.fromName} | {KEY_CREATED_ORDER.buildShortToAddressString}   | Pending Pickup |
      | {KEY_CREATED_ORDER.trackingId} | PICKUP Transaction   | {KEY_CREATED_ORDER.fromName} | {KEY_CREATED_ORDER.buildShortFromAddressString} | Pending Pickup |

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

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op