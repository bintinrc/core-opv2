@Sort @Utilities @AddressVerification
Feature: Address Verification

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: AV RTS orders - RTS zone exist
    When Operator go to menu Utilities -> Address Verification
    And Operator refresh page v1
    Then Address Verification page is loaded
    Given API Shipper create an order using below json as request body
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"SameDay","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00","timezone":"Asia/Singapore"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Singapore"},"dimensions":{"size":"S","weight":5,"length":"40","width":"41","height":"12"}},"from":{"name":"Hub Automation Shipper","email":"hub.automation.shipper@ninjavan.co","phone_number":"+6598984204","address":{"address1":"26 Address Verification Automation Ave","address2":"26 Address Verification Automation Ave","postcode":"960304","country":"SG"}},"to":{"name":"Hub Automation Customer","email":"hub.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"441 Address Verification Automation Ave","address2":"441 Address Verification Automation Ave","postcode":"960304","country":"SG"}}} |
    And API Operator gets destination hub of the created order
    When API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{KEY_HUB_INFO.id},"tags":[5570]} |
    When API Operator RTS created order:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And DB operator gets details for delivery transactions by order id
    And DB operator gets details for delivery waypoint
    And API Operator get Addressing Zone from a lat long with type "STANDARD"
    When Operator initialize address pool with all options checked in Address Verification page
    Then Operator verifies that success react notification displayed:
      | top | Address pool initialized |
    When Operator fetch addresses from initialized pool from zone "{KEY_ZONE_INFO.name}"
    And Operator clicks on 'Edit' button for -1 address on Address Verification page
    And Operator fills address parameters in Edit Address modal on Address Verification page:
      | latitude  | {av-rts-zone-latitude}  |
      | longitude | {av-rts-zone-longitude} |
    And Operator clicks 'Save' button in Edit Address modal on Address Verification page:
    Then Operator verifies that success react notification displayed:
      | top    | Address event created         |
      | bottom | Waypoint successfully updated |
    When API Operator get "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" order details
    And DB Operator verify Jaro Scores of Delivery Transaction waypoint of created order are archived
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order event on Edit order page using data below:
      | name | VERIFY ADDRESS |
    And Operator verifies Zone is "{av-rts-zone-short-name}" on Edit Order page

  Scenario: AV RTS orders - RTS zone does not exist
    When Operator go to menu Utilities -> Address Verification
    And Operator refresh page v1
    Then Address Verification page is loaded
    Given API Shipper create an order using below json as request body
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"SameDay","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00","timezone":"Asia/Singapore"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Singapore"},"dimensions":{"size":"S","weight":5,"length":"40","width":"41","height":"12"}},"from":{"name":"Hub Automation Shipper","email":"hub.automation.shipper@ninjavan.co","phone_number":"+6598984204","address":{"address1":"26 Address Verification Automation Ave","address2":"26 Address Verification Automation Ave","postcode":"960304","country":"SG"}},"to":{"name":"Hub Automation Customer","email":"hub.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"441 Address Verification Automation Ave","address2":"441 Address Verification Automation Ave","postcode":"960304","country":"SG"}}} |
    And API Operator gets destination hub of the created order
    When API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{KEY_HUB_INFO.id},"tags":[5570]} |
    When API Operator RTS created order:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And DB operator gets details for delivery transactions by order id
    And DB operator gets details for delivery waypoint
    And API Operator get Addressing Zone from a lat long with type "STANDARD"
    When Operator initialize address pool with all options checked in Address Verification page
    Then Operator verifies that success react notification displayed:
      | top | Address pool initialized |
    When Operator fetch addresses from initialized pool from zone "{KEY_ZONE_INFO.name}"
    And Operator clicks on 'Edit' button for -1 address on Address Verification page
    And Operator fills address parameters in Edit Address modal on Address Verification page:
      | latitude  | {av-zone-latitude}  |
      | longitude | {av-zone-longitude} |
    And Operator clicks 'Save' button in Edit Address modal on Address Verification page:
    Then Operator verifies that success react notification displayed:
      | top    | Address event created         |
      | bottom | Waypoint successfully updated |
    When API Operator get "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" order details
    And DB Operator verify Jaro Scores of Delivery Transaction waypoint of created order are archived
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order event on Edit order page using data below:
      | name | VERIFY ADDRESS |
    And Operator verifies Zone is "{av-zone-short-name}" on Edit Order page

  Scenario: AV RTS orders - Zone is NULL
    When Operator go to menu Utilities -> Address Verification
    And Operator refresh page v1
    Then Address Verification page is loaded
    Given API Shipper create an order using below json as request body
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"SameDay","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00","timezone":"Asia/Singapore"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Singapore"},"dimensions":{"size":"S","weight":5,"length":"40","width":"41","height":"12"}},"from":{"name":"Hub Automation Shipper","email":"hub.automation.shipper@ninjavan.co","phone_number":"+6598984204","address":{"address1":"26 Address Verification Automation Ave","address2":"26 Address Verification Automation Ave","postcode":"960304","country":"SG"}},"to":{"name":"Hub Automation Customer","email":"hub.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"441 Address Verification Automation Ave","address2":"441 Address Verification Automation Ave","postcode":"960304","country":"SG"}}} |
    And API Operator gets destination hub of the created order
    When API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{KEY_HUB_INFO.id},"tags":[5570]} |
    When API Operator RTS created order:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And DB operator gets details for delivery transactions by order id
    And DB operator gets details for delivery waypoint
    And API Operator get Addressing Zone from a lat long with type "STANDARD"
    When Operator initialize address pool with all options checked in Address Verification page
    Then Operator verifies that success react notification displayed:
      | top | Address pool initialized |
    When Operator fetch addresses from initialized pool from zone "{KEY_ZONE_INFO.name}"
    And Operator clicks on 'Edit' button for -1 address on Address Verification page
    And Operator fills address parameters in Edit Address modal on Address Verification page:
      | latitude  | {av-ooz-zone-latitude}  |
      | longitude | {av-ooz-zone-longitude} |
    And Operator clicks 'Save' button in Edit Address modal on Address Verification page:
    Then Operator verifies that success react notification displayed:
      | top    | Address event created         |
      | bottom | Waypoint successfully updated |
    When API Operator get "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" order details
    And DB Operator verify Jaro Scores of Delivery Transaction waypoint of created order are archived
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order event on Edit order page using data below:
      | name | VERIFY ADDRESS |
    And Operator verifies Zone is "{av-ooz-zone-short-name}" on Edit Order page

  Scenario: AV Non RTS orders - RTS zone exist
    When Operator go to menu Utilities -> Address Verification
    And Operator refresh page v1
    Then Address Verification page is loaded
    Given API Shipper create an order using below json as request body
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"SameDay","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00","timezone":"Asia/Singapore"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Singapore"},"dimensions":{"size":"S","weight":5,"length":"40","width":"41","height":"12"}},"from":{"name":"Hub Automation Shipper","email":"hub.automation.shipper@ninjavan.co","phone_number":"+6598984204","address":{"address1":"26 Address Verification Automation Ave","address2":"26 Address Verification Automation Ave","postcode":"960304","country":"SG"}},"to":{"name":"Hub Automation Customer","email":"hub.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"441 Address Verification Automation Ave","address2":"441 Address Verification Automation Ave","postcode":"960304","country":"SG"}}} |
    And API Operator gets destination hub of the created order
    When API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{KEY_HUB_INFO.id},"tags":[5570]} |
    And DB operator gets details for delivery transactions by order id
    And DB operator gets details for delivery waypoint
    And API Operator get Addressing Zone from a lat long with type "STANDARD"
    When Operator initialize address pool with all options checked in Address Verification page
    Then Operator verifies that success react notification displayed:
      | top | Address pool initialized |
    When Operator fetch addresses from initialized pool from zone "{KEY_ZONE_INFO.name}"
    And Operator clicks on 'Edit' button for -1 address on Address Verification page
    And Operator fills address parameters in Edit Address modal on Address Verification page:
      | latitude  | {av-rts-zone-latitude-2}  |
      | longitude | {av-rts-zone-longitude-2} |
    And Operator clicks 'Save' button in Edit Address modal on Address Verification page:
    Then Operator verifies that success react notification displayed:
      | top    | Address event created         |
      | bottom | Waypoint successfully updated |
    When API Operator get "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" order details
    And DB Operator verify Jaro Scores of Delivery Transaction waypoint of created order are archived
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order event on Edit order page using data below:
      | name | VERIFY ADDRESS |
    And Operator verifies Zone is "{av-zone-short-name}" on Edit Order page

  Scenario: AV Non RTS orders - RTS zone does not exist
    When Operator go to menu Utilities -> Address Verification
    And Operator refresh page v1
    Then Address Verification page is loaded
    Given API Shipper create an order using below json as request body
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"SameDay","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00","timezone":"Asia/Singapore"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Singapore"},"dimensions":{"size":"S","weight":5,"length":"40","width":"41","height":"12"}},"from":{"name":"Hub Automation Shipper","email":"hub.automation.shipper@ninjavan.co","phone_number":"+6598984204","address":{"address1":"26 Address Verification Automation Ave","address2":"26 Address Verification Automation Ave","postcode":"960304","country":"SG"}},"to":{"name":"Hub Automation Customer","email":"hub.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"441 Address Verification Automation Ave","address2":"441 Address Verification Automation Ave","postcode":"960304","country":"SG"}}} |
    And API Operator gets destination hub of the created order
    When API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{KEY_HUB_INFO.id},"tags":[5570]} |
    And DB operator gets details for delivery transactions by order id
    And DB operator gets details for delivery waypoint
    And API Operator get Addressing Zone from a lat long with type "STANDARD"
    When Operator initialize address pool with all options checked in Address Verification page
    Then Operator verifies that success react notification displayed:
      | top | Address pool initialized |
    When Operator fetch addresses from initialized pool from zone "{KEY_ZONE_INFO.name}"
    And Operator clicks on 'Edit' button for -1 address on Address Verification page
    And Operator fills address parameters in Edit Address modal on Address Verification page:
      | latitude  | {av-zone-latitude}  |
      | longitude | {av-zone-longitude} |
    And Operator clicks 'Save' button in Edit Address modal on Address Verification page:
    Then Operator verifies that success react notification displayed:
      | top    | Address event created         |
      | bottom | Waypoint successfully updated |
    When API Operator get "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" order details
    And DB Operator verify Jaro Scores of Delivery Transaction waypoint of created order are archived
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order event on Edit order page using data below:
      | name | VERIFY ADDRESS |
    And Operator verifies Zone is "{av-zone-short-name}" on Edit Order page

  Scenario: AV Non RTS orders - RTS zone does not exist
    When Operator go to menu Utilities -> Address Verification
    And Operator refresh page v1
    Then Address Verification page is loaded
    Given API Shipper create an order using below json as request body
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"SameDay","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00","timezone":"Asia/Singapore"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Singapore"},"dimensions":{"size":"S","weight":5,"length":"40","width":"41","height":"12"}},"from":{"name":"Hub Automation Shipper","email":"hub.automation.shipper@ninjavan.co","phone_number":"+6598984204","address":{"address1":"26 Address Verification Automation Ave","address2":"26 Address Verification Automation Ave","postcode":"960304","country":"SG"}},"to":{"name":"Hub Automation Customer","email":"hub.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"441 Address Verification Automation Ave","address2":"441 Address Verification Automation Ave","postcode":"960304","country":"SG"}}} |
    And API Operator gets destination hub of the created order
    When API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{KEY_HUB_INFO.id},"tags":[5570]} |
    And DB operator gets details for delivery transactions by order id
    And DB operator gets details for delivery waypoint
    And API Operator get Addressing Zone from a lat long with type "STANDARD"
    When Operator initialize address pool with all options checked in Address Verification page
    Then Operator verifies that success react notification displayed:
      | top | Address pool initialized |
    When Operator fetch addresses from initialized pool from zone "{KEY_ZONE_INFO.name}"
    And Operator clicks on 'Edit' button for -1 address on Address Verification page
    And Operator fills address parameters in Edit Address modal on Address Verification page:
      | latitude  | {av-ooz-zone-latitude}  |
      | longitude | {av-ooz-zone-longitude} |
    And Operator clicks 'Save' button in Edit Address modal on Address Verification page:
    Then Operator verifies that success react notification displayed:
      | top    | Address event created         |
      | bottom | Waypoint successfully updated |
    When API Operator get "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" order details
    And DB Operator verify Jaro Scores of Delivery Transaction waypoint of created order are archived
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order event on Edit order page using data below:
      | name | VERIFY ADDRESS |
    And Operator verifies Zone is "{av-ooz-zone-short-name}" on Edit Order page

  Scenario: Assign a Zone to Address From Address Verification Page
    When Operator go to menu Utilities -> Address Verification
    And Operator refresh page v1
    Then Address Verification page is loaded
    Given API Shipper create an order using below json as request body
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | {"service_type":"Parcel","service_level":"SameDay","parcel_job":{"is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00","timezone":"Asia/Singapore"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Singapore"},"dimensions":{"size":"S","weight":5,"length":"40","width":"41","height":"12"}},"from":{"name":"Hub Automation Shipper","email":"hub.automation.shipper@ninjavan.co","phone_number":"+6598984204","address":{"address1":"26 Address Verification Automation Ave","address2":"26 Address Verification Automation Ave","postcode":"960304","country":"SG"}},"to":{"name":"Hub Automation Customer","email":"hub.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"441 Address Verification Automation Ave","address2":"441 Address Verification Automation Ave","postcode":"960304","country":"SG"}}} |
    And API Operator gets destination hub of the created order
    When API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{KEY_HUB_INFO.id},"tags":[5570]} |
    And DB operator gets details for delivery transactions by order id
    And DB operator gets details for delivery waypoint
    And API Operator get Addressing Zone from a lat long with type "STANDARD"
    When Operator initialize address pool with all options checked in Address Verification page
    Then Operator verifies that success react notification displayed:
      | top | Address pool initialized |
    When Operator fetch addresses from initialized pool from zone "{KEY_ZONE_INFO.name}"
    When Operator assign "{av-zone-name}" zone to the last address on Address Verification page
    Then Operator verifies that success react notification displayed:
      | top | Success assign to zone |
    When API Operator get "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" order details
    And DB operator gets details for delivery transactions by order id
    And DB operator gets details for delivery waypoint
    And API Operator get Addressing Zone from a lat long with type "STANDARD"
    Then Operator verifies waypoint details:
      | latitude      | {KEY_ZONE_INFO.latitude}     |
      | longitude     | {KEY_ZONE_INFO.longitude}    |
      | routingZoneId | {KEY_ZONE_INFO.legacyZoneId} |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order event on Edit order page using data below:
      | name | VERIFY ADDRESS |
    And Operator verifies Zone is "{av-zone-short-name}" on Edit Order page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op