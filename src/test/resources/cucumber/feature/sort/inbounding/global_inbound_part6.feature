@Sort @Inbounding @GlobalInbound @GlobalInboundPart6 @Saas @Inbound
Feature: Global Inbound

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CloseNewWindows
  Scenario: Inbound showing max weight limit alert - inbound weight is higher than max weight limit (uid:d56315b8-24df-49ad-8d1f-f02e0cfeb658)
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Order - Shipper create multiple V4 orders using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":1.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu System Settings -> Global Settings
    And Operator set Weight Tolerance value to "0" on Global Settings page
    And Operator save Inbound settings on Global Settings page
    And Operator set Weight Limit value to "25" on Global Settings page
    And Operator save Weight Limit settings on Global Settings page
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName        | {hub-name-3}                               |
      | trackingId     | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | overrideWeight | 25                                         |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_LIST_OF_CREATED_ORDERS[1].destinationHub} |
      | rackInfo       |{KEY_LIST_OF_CREATED_ORDERS[1].rackSector}     |
      | color          | #f06c00                            |
    And DB Events - verify order_events record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | type    | 26                                 |

  @CloseNewWindows
  Scenario: Inbound showing max weight limit alert - inbound weight is equal to max weight limit (uid:fbcb6c61-f744-4bb7-9697-561d32714f9a)
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Order - Shipper create multiple V4 orders using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":1.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu System Settings -> Global Settings
    And Operator set Weight Tolerance value to "100" on Global Settings page
    And Operator save Inbound settings on Global Settings page
    And Operator set Weight Limit value to "25" on Global Settings page
    And Operator save Weight Limit settings on Global Settings page
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below and check alert:
      | hubName        | {hub-name-3}                               |
      | trackingId     | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | overrideWeight | 26                                         |
      | weightWarning  | Weight is exceeding inbound weight limit   |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_LIST_OF_CREATED_ORDERS[1].destinationHub} |
      | rackInfo       |{KEY_LIST_OF_CREATED_ORDERS[1].rackSector}     |
      | color          | #fa002c                           |
    And DB Events - verify order_events record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | type    | 26                                 |

  @CloseNewWindows
  Scenario: Inbound showing max weight limit alert - inbound weight is lower than max weight limit (uid:533e3e4d-5dd0-4582-a204-2e163620654c)
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Order - Shipper create multiple V4 orders using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":1.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu System Settings -> Global Settings
    And Operator set Weight Tolerance value to "100" on Global Settings page
    And Operator save Inbound settings on Global Settings page
    And Operator set Weight Limit value to "25" on Global Settings page
    And Operator save Weight Limit settings on Global Settings page
    And Operator refresh page
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName        | {hub-name-3}                               |
      | trackingId     | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | overrideWeight | 24                                         |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_LIST_OF_CREATED_ORDERS[1].destinationHub} |
      | rackInfo       |{KEY_LIST_OF_CREATED_ORDERS[1].rackSector}     |
      | color          | #f06c00                            |
    And DB Events - verify order_events record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | type    | 26                                 |

  @CloseNewWindows
  Scenario: Inbound an International order - portation export (uid:a0364582-4f4a-4f8c-90e6-ded25c878348)
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Order - Shipper create multiple V4 orders using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest    | { "service_type":"International", "service_level":"Standard", "to":{"address": {"postcode": "319941"}},"parcel_job":{ "is_pickup_required":false, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}, "international":{"portation":"export"}} |
      | addressType       | global                                                                                                                                                                                                                                                                                                         |
    And Operator go to menu Inbounding -> Global Inbound
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                               |
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | INTERNATIONAL                  |
      | rackInfo       |{KEY_LIST_OF_CREATED_ORDERS[1].rackSector} |
      | color          | #f06c00                        |
    And DB Events - verify order_events record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | type    | 26                                 |

  @CloseNewWindows
  Scenario: Inbound an International order - portation import (uid:581b7d82-f823-4d56-b6a4-bfffc2b65d8f)
    When Operator go to menu Shipper Support -> Blocked Dates
    Given API Order - Shipper create multiple V4 orders using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                |
      | v4OrderRequest    | { "service_type":"International", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}, "international":{"portation":"import"}} |
      | addressType       | global                                                                                                                                                                                                                                                                |
    Then API Core - Operator get order details for tracking order "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}"
    And Operator go to menu Inbounding -> Global Inbound
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name-3}                               |
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    Then Operator verify info on Global Inbound page using data below:
      | destinationHub | {KEY_LIST_OF_CREATED_ORDERS[1].destinationHub} |
      | rackInfo       |{KEY_LIST_OF_CREATED_ORDERS[1].rackSector}     |
      | color          | #f06c00                            |
    And DB Events - verify order_events record:
      | orderId | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | type    | 26                                 |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op