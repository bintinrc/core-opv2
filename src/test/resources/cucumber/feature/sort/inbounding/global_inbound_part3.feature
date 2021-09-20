@Sort @Inbounding @GlobalInbound @GlobalInboundPart3 @Saas @Inbound
Feature: Global Inbound

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CloseNewWindows
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
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | ON HOLD - SHIPPER ISSUE |
      | rackInfo       | sync_problem RECOVERY   |
      | color          | #e86161                 |
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
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    When Operator switch to edit order page using direct URL
    And Operator verify Delivery details on Edit order page using data below:
      | status  | PENDING                                |
      | endDate | {gradle-next-3-working-day-yyyy-MM-dd} |

  @CloseNewWindows
  Scenario: Inbound Parcel with change in order SLA - Express Service (uid:45b363f0-1fb9-4155-8a7a-c9bd3d46da73)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Express", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-2-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    Then Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                    |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    When Operator switch to edit order page using direct URL
    And Operator verify Delivery details on Edit order page using data below:
      | status  | PENDING                                |
      | endDate | {gradle-next-2-working-day-yyyy-MM-dd} |

  @CloseNewWindows
  Scenario: Inbound Parcel with change in order SLA - Next Day Service (uid:69d8cd89-bfd3-4e1a-ad04-ece038974e99)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Nextday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-2-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    Then Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                    |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    When Operator switch to edit order page using direct URL
    And Operator verify Delivery details on Edit order page using data below:
      | status  | PENDING                                |
      | endDate | {gradle-next-1-working-day-yyyy-MM-dd} |

  @CloseNewWindows
  Scenario: Inbound Parcel with change in order SLA - Same Day (uid:79a946bb-aa72-4e5e-a063-9656f8826a7b)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                 |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Sameday", "parcel_job":{ "is_pickup_required":false, "delivery_start_date":"{{next-2-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    Then Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                    |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    When Operator switch to edit order page using direct URL
    And Operator verify Delivery details on Edit order page using data below:
      | status  | PENDING                                |
      | endDate | {gradle-next-2-working-day-yyyy-MM-dd} |

  @CloseNewWindows
  Scenario: Inbound parcel that is intended to be picked up on future date - Standard (uid:d929ec0a-629b-4ab3-beae-47ef1fafc329)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-2-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    Then Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                    |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
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
      | startDate          | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate            | {gradle-next-1-day-yyyy-MM-dd} |
      | lastServiceEndDate | {gradle-next-0-day-yyyy-MM-dd} |
    And Operator verify Delivery details on Edit order page using data below:
      | status    | PENDING                                |
      | startDate | {gradle-next-1-day-yyyy-MM-dd}         |
      | endDate   | {gradle-next-3-working-day-yyyy-MM-dd} |
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
      | startDate          | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate            | {gradle-next-1-day-yyyy-MM-dd} |
      | lastServiceEndDate | {gradle-next-0-day-yyyy-MM-dd} |
    And Operator verify Delivery details on Edit order page using data below:
      | status    | PENDING                                |
      | startDate | {gradle-next-1-day-yyyy-MM-dd}         |
      | endDate   | {gradle-next-2-working-day-yyyy-MM-dd} |
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
      | startDate          | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate            | {gradle-next-1-day-yyyy-MM-dd} |
      | lastServiceEndDate | {gradle-next-0-day-yyyy-MM-dd} |
    And Operator verify Delivery details on Edit order page using data below:
      | status    | PENDING                                |
      | startDate | {gradle-next-1-day-yyyy-MM-dd}         |
      | endDate   | {gradle-next-1-working-day-yyyy-MM-dd} |
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
      | startDate          | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate            | {gradle-next-1-day-yyyy-MM-dd} |
      | lastServiceEndDate | {gradle-next-0-day-yyyy-MM-dd} |
    And Operator verify Delivery details on Edit order page using data below:
      | status    | PENDING                        |
      | startDate | {gradle-next-1-day-yyyy-MM-dd} |
      | endDate   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator verify order event on Edit order page using data below:
      | name    | HUB INBOUND SCAN |
      | hubName | {hub-name-3}     |

  @CloseNewWindows
  Scenario: Inbound showing max weight limit alert - inbound weight is higher than max weight limit (uid:d56315b8-24df-49ad-8d1f-f02e0cfeb658)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":1.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu System Settings -> Global Settings
    And Operator set Weight Tolerance value to "0" on Global Settings page
    And Operator save Inbound settings on Global Settings page
    And Operator set Weight Limit value to "25" on Global Settings page
    And Operator save Weight Limit settings on Global Settings page
    And Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName        | {hub-name-3}                               |
      | trackingId     | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | overrideWeight | 25                                         |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    And DB Operator verify the order_events record exists for the created order with type:
      | 26 |

  @CloseNewWindows
  Scenario: Inbound showing max weight limit alert - inbound weight is equal to max weight limit (uid:fbcb6c61-f744-4bb7-9697-561d32714f9a)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":1.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu System Settings -> Global Settings
    And Operator set Weight Tolerance value to "100" on Global Settings page
    And Operator save Inbound settings on Global Settings page
    And Operator set Weight Limit value to "25" on Global Settings page
    And Operator save Weight Limit settings on Global Settings page
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below and check alert:
      | hubName        | {hub-name-3}                               |
      | trackingId     | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | overrideWeight | 26                                         |
      | weightWarning  | Weight is exceeding inbound weight limit   |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #e86161                            |
    And DB Operator verify order_events record for the created order:
      | type | 26 |

  @CloseNewWindows
  Scenario: Inbound showing max weight limit alert - inbound weight is lower than max weight limit (uid:533e3e4d-5dd0-4582-a204-2e163620654c)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":1.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu System Settings -> Global Settings
    And Operator set Weight Tolerance value to "100" on Global Settings page
    And Operator save Inbound settings on Global Settings page
    And Operator set Weight Limit value to "25" on Global Settings page
    And Operator save Weight Limit settings on Global Settings page
    And Operator refresh page
    And Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName        | {hub-name-3}                               |
      | trackingId     | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | overrideWeight | 24                                         |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    And DB Operator verify order_events record for the created order:
      | type | 26 |

  @CloseNewWindows
  Scenario: Inbound an International order - portation export (uid:a0364582-4f4a-4f8c-90e6-ded25c878348)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                |
      | v4OrderRequest    | { "service_type":"International", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}, "international":{"portation":"export"}} |
      | addressType       | global                                                                                                                                                                                                                                                                |
    And Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                               |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | INTERNATIONAL                  |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector} |
      | color          | #ffa400                        |
    And DB Operator verify order_events record for the created order:
      | type | 26 |

  @CloseNewWindows
  Scenario: Inbound an International order - portation import (uid:581b7d82-f823-4d56-b6a4-bfffc2b65d8f)
    When Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                |
      | v4OrderRequest    | { "service_type":"International", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}, "international":{"portation":"import"}} |
      | addressType       | global                                                                                                                                                                                                                                                                |
    And Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                               |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    And DB Operator verify order_events record for the created order:
      | type | 26 |

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Inbound Arrived at Distribution Point Order (uid:6213841e-2cb4-434b-bd6b-020aea8833ba)
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-working-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-2-working-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Distribution Points -> DP Tagging
    When Operator tags single order to DP with DPMS ID = "{dpms-id}"
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id-3} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id-3}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator pulled out parcel "DELIVERY" from route
    And API Operator new add parcel to the route using data below:
      | addParcelToRouteRequest | DELIVERY |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver deliver the created parcel successfully
    When API Operator refresh created order data
    And Operator go to menu Inbounding -> Global Inbound
    And Operator refresh page
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                               |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    And Operator verifies DP tag is displayed
    And DB Operator verify order_events record for the created order:
      | type | 26 |

  @CloseNewWindows
  Scenario: Inbound With Device ID (uid:a4df911d-8bf7-43ae-aef0-e791b6e9a664)
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-working-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-2-working-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                               |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | deviceId   | 12345                                      |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    When Operator switch to edit order page using direct URL
    Then Operator verify Delivery "HUB INBOUND SCAN" order event description on Edit order page

  @CloseNewWindows
  Scenario: Order Tagging with Global Inbound - Total tags is less/equal 4 (uid:0e043740-9f44-45ae-94a3-94f6987c45ad)
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-working-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-2-working-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                               |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | tags       | OPV2AUTO1,OPV2AUTO2,OPV2AUTO3              |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify the tags shown on Edit Order page
      | OPV2AUTO1 |
      | OPV2AUTO2 |
      | OPV2AUTO3 |
    And DB Operator verify order_events record for the created order:
      | type | 48 |
    And DB Operator verify order_events record for the created order:
      | type | 26 |

  @CloseNewWindows
  Scenario: Order Tagging with Global Inbound - Total tags is more than 4 (uid:aecc250f-25a7-49ec-8d19-8634ff2a1d79)
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-working-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-2-working-days-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 5570 |
    And Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                               |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | tags       | OPV2AUTO1,OPV2AUTO2,OPV2AUTO3,SORTAUTO02   |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    And Operator verify failed tagging error toast is shown
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify the tags shown on Edit Order page
      | PRIOR |
    And DB Operator verify order_events record for the created order:
      | type | 48 |
    And DB Operator verify order_events record for the created order:
      | type | 26 |

  @CloseNewWindows
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
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    When Operator switch to edit order page using direct URL
    And Operator verifies prior tag is displayed
    And DB Operator verify order_events record for the created order:
      | type | 26 |

  @CloseNewWindows
  Scenario: Inbound parcel with changes in dimensions (0 Values) (uid:d2232263-f912-4561-8154-d56327e54ca0)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "length":"40", "width":"41", "height":"12", "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName           | {hub-name-3}                               |
      | trackingId        | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | overrideDimHeight | 0                                          |
      | overrideDimWidth  | 0                                          |
      | overrideDimLength | 0                                          |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    Then API Operator verify order info after Global Inbound
    When Operator switch to edit order page using direct URL
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    Then Operator verify "HUB INBOUND SCAN" order event description on Edit order page

  @CloseNewWindows
  Scenario: Inbound parcel with changes in dimensions (NULL Values) (uid:83644b40-cd17-4b3a-b6ba-927a8170a4f3)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "length":"40", "width":"41", "height":"12", "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                               |
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_CREATED_ORDER.destinationHub} |
      | rackInfo       | {KEY_CREATED_ORDER.rackSector}     |
      | color          | #ffa400                            |
    Then API Operator verify order info after Global Inbound
    When Operator switch to edit order page using direct URL
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    Then Operator verify "HUB INBOUND SCAN" order event description on Edit order page

  @CloseNewWindows
  Scenario: Inbound parcel with changes in dimensions (with volumetric weight)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName           | {KEY_CREATED_ORDER.destinationHub}         |
      | trackingId        | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | overrideDimHeight | {dimension-height}                         |
      | overrideDimWidth  | {dimension-width}                          |
      | overrideDimLength | {dimension-length}                         |
    Then Operator verify info on Global Inbound page using data below:
      | rackInfo | {KEY_CREATED_ORDER.rackSector} |
      | color    | #55a1e8                        |
    Then API Operator verify order info after Global Inbound
    When API Operator get order details by saved Order ID
    And Operator switch to edit order page using direct URL
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And Operator verify "HUB INBOUND SCAN" order event description on Edit order page
    And Operator verifies order weight is overridden based on the volumetric weight

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op