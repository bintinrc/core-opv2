@Sort @Routing @ParcelSweeperLive @ParcelSweeperLiveUserAccessPart2
Feature: Parcel Sweeper Live User Access

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given no-op

  @CloseNewWindows
  Scenario: NOT ROLE_HUB_ADMIN - Assigned To Multiple Hub - Single Sort Task
    Given Operator login with client id = "{sort-role-hub-staff-assigned-user-client-id}" and client secret = "{sort-role-hub-staff-assigned-user-client-secret}"
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Then DB Sort - verify "{sort-role-hub-staff-assigned-user-client-id}" is a hub user with role "ROLE_HUB_STAFF"
    Given Operator go to menu Routing -> Parcel Sweeper Live
    Given Operator refresh page
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {activated-hub-name} |
      | trackingId | CREATED              |
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName  | {hub-name}       |
      | textColor | {blue-hex-color} |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName   | GLOBAL INBOUND        |
      | textColor | {dark-gray-hex-color} |

  @CloseNewWindows
  Scenario: NOT ROLE_HUB_ADMIN - Assigned To Multiple Hub - Multiple Sort Task
    Given Operator login with client id = "{sort-role-hub-staff-assigned-user-client-id}" and client secret = "{sort-role-hub-staff-assigned-user-client-secret}"
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"{address1}","address2":"","postcode":{postcode},"country":"SG"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Then DB Sort - verify "{sort-role-hub-staff-assigned-user-client-id}" is a hub user with role "ROLE_HUB_STAFF"
    Given Operator go to menu Routing -> Parcel Sweeper Live
    Given Operator refresh page
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {default-hub-name} |
      | trackingId | CREATED            |
      | task       | {default-task}     |
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName  | {hub-name}       |
      | textColor | {blue-hex-color} |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName   | GLOBAL INBOUND        |
      | textColor | {dark-gray-hex-color} |

  @CloseNewWindows
  Scenario: NOT ROLE_HUB_ADMIN - Assigned To Single Hub - Single Sort Task
    Given Operator login with client id = "{staff-assigned-single-user-client-id}" and client secret = "{staff-assigned-single-user-client-secret}"
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Then DB Sort - verify "{staff-assigned-single-user-client-id}" is a hub user with role "ROLE_HUB_STAFF"
    Given Operator go to menu Routing -> Parcel Sweeper Live
    Given Operator refresh page
    When Operator provides data on Parcel Sweeper Live page:
      | trackingId | CREATED |
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName  | {hub-name}       |
      | textColor | {blue-hex-color} |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName   | GLOBAL INBOUND        |
      | textColor | {dark-gray-hex-color} |

  @CloseNewWindows
  Scenario: NOT ROLE_HUB_ADMIN - Assigned To Multiple Hub - Multiple Sort Task
    Given Operator login with client id = "{staff-assigned-multi-user-client-id}" and client secret = "{staff-assigned-multi-user-client-secret}"
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"{address1}","address2":"","postcode":{postcode},"country":"SG"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Then DB Sort - verify "{staff-assigned-multi-user-client-id}" is a hub user with role "ROLE_HUB_STAFF"
    Given Operator go to menu Routing -> Parcel Sweeper Live
    Given Operator refresh page
    When Operator provides data on Parcel Sweeper Live page:
      | trackingId | CREATED            |
      | task       | {default-task}     |
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName  | {hub-name}       |
      | textColor | {blue-hex-color} |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName   | GLOBAL INBOUND        |
      | textColor | {dark-gray-hex-color} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op