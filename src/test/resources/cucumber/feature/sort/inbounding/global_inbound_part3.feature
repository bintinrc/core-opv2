@Sort @Inbounding @GlobalInbound @GlobalInboundPart3 @Saas @Inbound
Feature: Global Inbound

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CloseNewWindows @happy-path
  Scenario: Inbound On Hold Order - DO NOT Resolve NON-MISSING ticket type (uid:e1211ee8-24c0-42f2-bb00-4940d65950da)
    When Operator go to menu Shipper Support -> Blocked Dates
    When API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Operator create recovery ticket using data below:
      | ticketType              | 5                                |
      | subTicketType           | 9                                |
      | entrySource             | 1                                |
      | investigatingParty      | 448                              |
      | investigatingHubId      | 1                                |
      | outcomeName             | ORDER OUTCOME (DUPLICATE PARCEL) |
      | outComeValue            | REPACKED/RELABELLED TO SEND      |
      | comments                | Automation Testing.              |
      | shipperZendeskId        | 1                                |
      | ticketNotes             | Automation Testing.              |
      | issueDescription        | Automation Testing.              |
      | creatorUserId           | 106307852128204474889            |
      | creatorUserName         | Niko Susanto                     |
      | creatorUserEmail        | niko.susanto@ninjavan.co         |
      | TicketCreationSource    | TICKET_MANAGEMENT                |
      | ticketTypeId            | 17                               |
      | subTicketTypeId         | 17                               |
      | entrySourceId           | 13                               |
      | trackingIdFieldId       | 2                                |
      | investigatingPartyId    | 15                               |
      | investigatingHubFieldId | 67                               |
      | outcomeNameId           | 64                               |
      | commentsId              | 26                               |
      | shipperZendeskFieldId   | 36                               |
      | ticketNotesId           | 32                               |
      | issueDescriptionId      | 45                               |
      | creatorUserFieldId      | 30                               |
      | creatorUserNameId       | 39                               |
      | creatorUserEmailId      | 66                               |
    And Operator go to menu Inbounding -> Global Inbound
    Then Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                               |
      | parcelType | Bulky                                      |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | ON HOLD - SHIPPER ISSUE |
      | rackInfo       | RECOVERY                |
      | color          | #fa002c                 |
    And DB Operator verify the last inbound_scans record for the created order:
      | hubId      | {hub-id-3}             |
      | trackingId | GET_FROM_CREATED_ORDER |
      | type       | 2                      |
    And DB Operator verify order_events record for the created order:
      | type | 26 |
    Given Operator go to menu Recovery -> Recovery Tickets
    When Operator removes all ticket status filters
    And Operator enters the Tracking Id
    Then Operator chooses the ticket status as "PENDING"
    And Operator enters the tracking id and verifies that is exists

  @CloseNewWindows
  Scenario: Inbound Parcel with change in order SLA - Standard Service (uid:c43a34d0-b8ba-4e6f-9304-51320543b9ee)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-2-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    Then Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                    |
      | parcelType | Bulky                           |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #f06c00                            |
    When Operator switch to edit order page using direct URL
    And Operator verify Delivery details on Edit order page using data below:
      | status  | PENDING                                              |
      | endDate | {date: 3 days next,yyyy-MM-dd,excludedDays:[Sunday]} |

  @CloseNewWindows
  Scenario: Inbound Parcel with change in order SLA - Express Service (uid:45b363f0-1fb9-4155-8a7a-c9bd3d46da73)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Express", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-2-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    Then Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                    |
      | parcelType | Bulky                           |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #f06c00                            |
    When Operator switch to edit order page using direct URL
    And Operator verify Delivery details on Edit order page using data below:
      | status  | PENDING                                               |
      | endDate | {date: 2 days next,yyyy-MM-dd ,excludedDays:[Sunday]} |

  @CloseNewWindows
  Scenario: Inbound Parcel with change in order SLA - Next Day Service (uid:69d8cd89-bfd3-4e1a-ad04-ece038974e99)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Nextday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-2-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    Then Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                    |
      | parcelType | Bulky                           |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #f06c00                            |
    When Operator switch to edit order page using direct URL
    And Operator verify Delivery details on Edit order page using data below:
      | status  | PENDING                                              |
      | endDate | {date: 1 days next,yyyy-MM-dd,excludedDays:[Sunday]} |

  @CloseNewWindows
  Scenario: Inbound Parcel with change in order SLA - Same Day (uid:79a946bb-aa72-4e5e-a063-9656f8826a7b)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                 |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Sameday", "parcel_job":{ "is_pickup_required":false, "delivery_start_date":"{{next-2-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    Then Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                    |
      | parcelType | Bulky                           |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #f06c00                            |
    When Operator switch to edit order page using direct URL
    And Operator verify Delivery details on Edit order page using data below:
      | status  | PENDING                                              |
      | endDate | {date: 2 days next,yyyy-MM-dd,excludedDays:[Sunday]} |

  @CloseNewWindows
  Scenario: Inbound parcel that is intended to be picked up on future date - Standard (uid:d929ec0a-629b-4ab3-beae-47ef1fafc329)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-2-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    Then Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                    |
      | parcelType | Bulky                           |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #f06c00                            |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
    And DB Operator verify the last inbound_scans record for the created order:
      | hubId      | {hub-id-3}             |
      | trackingId | GET_FROM_CREATED_ORDER |
      | type       | 2                      |
    And DB Operator verify order_events record for the created order:
      | type | 26 |
    When Operator switch to edit order page using direct URL
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status             | SUCCESS                         |
      | startDate          | {date: 1 days next,yyyy-MM-dd}  |
      | endDate            | {date: 1 days next,yyyy-MM-dd}  |
      | lastServiceEndDate | {date: 0 days next, yyyy-MM-dd} |
    And Operator verify Delivery details on Edit order page using data below:
      | status    | PENDING                                              |
      | startDate | {date: 1 days next,yyyy-MM-dd}                       |
      | endDate   | {date: 3 days next,yyyy-MM-dd,excludedDays:[Sunday]} |
    And Operator verify order event on Edit order page using data below:
      | name    | HUB INBOUND SCAN |
      | hubName | {hub-name-3}     |

  @CloseNewWindows
  Scenario: Inbound parcel that is intended to be picked up on future date - Express (uid:56abc408-a381-4c0d-b431-ed75a0f289d7)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Express", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-2-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    Then Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                    |
      | parcelType | Bulky                           |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
    And DB Operator verify the last inbound_scans record for the created order:
      | hubId      | {hub-id-3}             |
      | trackingId | GET_FROM_CREATED_ORDER |
      | type       | 2                      |
    And DB Operator verify order_events record for the created order:
      | type | 26 |
    When Operator switch to edit order page using direct URL
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status             | SUCCESS                        |
      | startDate          | {date: 1 days next,yyyy-MM-dd} |
      | endDate            | {date: 1 days next,yyyy-MM-dd} |
      | lastServiceEndDate | {date: 0 days next,yyyy-MM-dd} |
    And Operator verify Delivery details on Edit order page using data below:
      | status    | PENDING                                              |
      | startDate | {date: 1 days next,yyyy-MM-dd}                       |
      | endDate   | {date: 2 days next,yyyy-MM-dd,excludedDays:[Sunday]} |
    And Operator verify order event on Edit order page using data below:
      | name    | HUB INBOUND SCAN |
      | hubName | {hub-name-3}     |

  @CloseNewWindows
  Scenario: Inbound parcel that is intended to be picked up on future date - Nextday (uid:49cbc076-7249-431d-abbb-43771b2ec41a)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Nextday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-2-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    Then Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                    |
      | parcelType | Bulky                           |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
    And DB Operator verify the last inbound_scans record for the created order:
      | hubId      | {hub-id-3}             |
      | trackingId | GET_FROM_CREATED_ORDER |
      | type       | 2                      |
    When Operator switch to edit order page using direct URL
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status             | SUCCESS                        |
      | startDate          | {date: 1 days next,yyyy-MM-dd} |
      | endDate            | {date: 1 days next,yyyy-MM-dd} |
      | lastServiceEndDate | {date: 0 days next,yyyy-MM-dd} |
    And Operator verify Delivery details on Edit order page using data below:
      | status    | PENDING                        |
      | startDate | {date: 1 days next,yyyy-MM-dd} |
      | endDate   | {date: 1 days next,yyyy-MM-dd} |
    And Operator verify order event on Edit order page using data below:
      | name    | HUB INBOUND SCAN |
      | hubName | {hub-name-3}     |

  @CloseNewWindows
  Scenario: Inbound parcel that is intended to be picked up on future date - Sameday (uid:964cd5ae-50f2-4ea0-87b4-e36fcfe1b49a)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Sameday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    Then Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                    |
      | parcelType | Bulky                           |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
    And DB Operator verify the last inbound_scans record for the created order:
      | hubId      | {hub-id-3}             |
      | trackingId | GET_FROM_CREATED_ORDER |
      | type       | 2                      |
    And DB Operator verify order_events record for the created order:
      | type | 26 |
    When Operator switch to edit order page using direct URL
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Pickup details on Edit order page using data below:
      | status             | SUCCESS                        |
      | startDate          | {date: 1 days next,yyyy-MM-dd} |
      | endDate            | {date: 1 days next,yyyy-MM-dd} |
      | lastServiceEndDate | {date: 0 days next,yyyy-MM-dd} |
    And Operator verify Delivery details on Edit order page using data below:
      | status    | PENDING                        |
      | startDate | {date: 1 days next,yyyy-MM-dd} |
      | endDate   | {date: 1 days next,yyyy-MM-dd} |
    And Operator verify order event on Edit order page using data below:
      | name    | HUB INBOUND SCAN |
      | hubName | {hub-name-3}     |

  @CloseNewWindows @happy-path
  Scenario: Order Tagging with Global Inbound - Total tags is less/equal 4 (uid:0e043740-9f44-45ae-94a3-94f6987c45ad)
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-working-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-2-working-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                               |
      | parcelType | Bulky                                      |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | tags       | OPV2AUTO1,OPV2AUTO2,OPV2AUTO3              |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #f06c00                            |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify the tags shown on Edit Order page
      | OPV2AUTO1 |
      | OPV2AUTO2 |
      | OPV2AUTO3 |
    And DB Operator verify order_events record for the created order:
      | type | 48 |
    And DB Operator verify order_events record for the created order:
      | type | 26 |

  @CloseNewWindows @happy-path
  Scenario: Inbound Parcel With Prior Tag (uid:ac8ca197-533b-4e1a-bf13-b429d44bd93c)
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-working-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-2-working-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 5570 |
    And Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                               |
      | parcelType | Bulky                                      |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #f06c00                            |
    And Operator verifies prior tag is displayed
    When Operator switch to edit order page using direct URL
    And DB Operator verify order_events record for the created order:
      | type | 26 |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op