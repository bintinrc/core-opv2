@Sort @Utilities @AddressVerificationPart1
Feature: Address Verification

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

#   Deprecated Scenario
#   Keeping the scenarios first becaus I think will be reuseable for other scenarios that haven't covered

#  Scenario: AV RTS orders - RTS zone exist
#    When Operator go to menu Utilities -> Address Verification
#    And Operator refresh page v1
#    Then Address Verification page is loaded
#    Given API Shipper create an order using below json as request body
#      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
#      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
#      | v4OrderRequest      | {"service_type":"Parcel","service_level":"SameDay","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"09:00","end_time":"22:00", "timezone":"Asia/Jakarta"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00", "timezone":"Asia/Jakarta"},"dimensions":{"size":"S","weight":1,"length":"10","width":"10","height":"10"}},"from":{"name": "Kenny Shipper", "phone_number": "+62123456789", "email": "kenny.wirianto@test.co", "address":{"address1": "Lippo Mall Puri", "address2": "Lippo Mall Puri", "country": "ID", "postcode": "11610", "province": "Sort", "city": "Out Of", "kecamatan": "Zone"}},"to":{"name":"Automation Customer","email":"automation.customer@ninjavan.co","phone_number":"+62123456789","address":{"address1":"Grand Indonesia","address2":"Grand Indonesia","postcode":"10310","country":"ID","province":"Sort","city":"Out Of","kecamatan":"Zone"}}} |
#    And API Operator gets destination hub of the created order
#    When API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_HUB_INFO.id},"tags":[5570]} |
#    When API Operator RTS created order:
#      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
#    And DB operator gets details for delivery transactions by order id
#    And DB operator gets details for delivery waypoint
#    And API Operator get Addressing Zone from a lat long with type "RTS"
#    When Operator initialize address pool with all options checked in Address Verification page
#    Then Operator verifies that success react notification displayed:
#      | top | Address pool initialized |
#    When Operator fetch addresses from initialized pool from zone "{ooz-zone-name}"
#    And Operator clicks on 'Edit' button for -1 address on Address Verification page
#    And Operator fills address parameters in Edit Address modal on Address Verification page:
#      | latitude  | {av-rts-zone-latitude}  |
#      | longitude | {av-rts-zone-longitude} |
#    And Operator clicks 'Save' button in Edit Address modal on Address Verification page:
#    Then Operator verifies that success react notification displayed:
#      | top    | Address event created         |
#      | bottom | Waypoint successfully updated |
#    When API Operator get "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" order details
#    And DB Operator verify Jaro Scores of Delivery Transaction waypoint of created order are archived
#    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
#    Then Operator verify order event on Edit order page using data below:
#      | name | VERIFY ADDRESS |
#    And Operator verifies Zone is "{av-rts-zone-short-name}" on Edit Order page
#
#  Scenario: AV RTS orders - RTS zone does not exist
#    When Operator go to menu Utilities -> Address Verification
#    And Operator refresh page v1
#    Then Address Verification page is loaded
#    Given API Shipper create an order using below json as request body
#      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
#      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
#      | v4OrderRequest      | {"service_type":"Parcel","service_level":"SameDay","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"09:00","end_time":"22:00", "timezone":"Asia/Jakarta"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00", "timezone":"Asia/Jakarta"},"dimensions":{"size":"S","weight":1,"length":"10","width":"10","height":"10"}},"from":{"name": "Kenny Shipper", "phone_number": "+62123456789", "email": "kenny.wirianto@test.co", "address":{"address1": "Lippo Mall Puri", "address2": "Lippo Mall Puri", "country": "ID", "postcode": "11610", "province": "SORT", "city": "NO", "kecamatan": "ZONE"}},"to":{"name":"Automation Customer","email":"automation.customer@ninjavan.co","phone_number":"+62123456789","address":{"address1":"Grand Indonesia","address2":"Grand Indonesia","postcode":"10310","country":"ID","province":"SORT","city":"NO","kecamatan":"ZONE"}}} |
#    And API Operator gets destination hub of the created order
#    When API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_HUB_INFO.id},"tags":[5570]} |
#    When API Operator RTS created order:
#      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
#    And DB operator gets details for delivery transactions by order id
#    And DB operator gets details for delivery waypoint
#    And API Operator get Addressing Zone from a lat long with type "RTS"
#    When Operator initialize address pool with all options checked in Address Verification page
#    Then Operator verifies that success react notification displayed:
#      | top | Address pool initialized |
#    When Operator fetch addresses from initialized pool from zone "{ooz-zone-name}"
#    And Operator clicks on 'Edit' button for -1 address on Address Verification page
#    And Operator fills address parameters in Edit Address modal on Address Verification page:
#      | latitude  | {av-zone-latitude}  |
#      | longitude | {av-zone-longitude} |
#    And Operator clicks 'Save' button in Edit Address modal on Address Verification page:
#    Then Operator verifies that success react notification displayed:
#      | top    | Address event created         |
#      | bottom | Waypoint successfully updated |
#    When API Operator get "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" order details
#    And DB Operator verify Jaro Scores of Delivery Transaction waypoint of created order are archived
#    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
#    Then Operator verify order event on Edit order page using data below:
#      | name | VERIFY ADDRESS |
#    And Operator verifies Zone is "{av-zone-short-name}" on Edit Order page
#
#  Scenario: AV RTS orders - Zone is NULL
#    When Operator go to menu Utilities -> Address Verification
#    And Operator refresh page v1
#    Then Address Verification page is loaded
#    Given API Shipper create an order using below json as request body
#      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
#      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
#      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"09:00","end_time":"22:00", "timezone":"Asia/Jakarta"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00", "timezone":"Asia/Jakarta"},"dimensions":{"size":"S","weight":1,"length":"10","width":"10","height":"10"}},"from":{"name": "Kenny Shipper", "phone_number": "+62123456789", "email": "kenny.wirianto@test.co", "address":{"address1": "Lippo Mall Puri", "address2": "Lippo Mall Puri", "country": "ID", "postcode": "11610", "province": "SORT", "city": "NO", "kecamatan": "ZONE"}},"to":{"name":"Automation Customer","email":"automation.customer@ninjavan.co","phone_number":"+62123456789","address":{"address1":"Grand Indonesia","address2":"Grand Indonesia","postcode":"10310","country":"ID","province":"SORT","city":"NO","kecamatan":"ZONE"}}} |
#    And API Operator gets destination hub of the created order
#    When API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_HUB_INFO.id},"tags":[5570]} |
#    When API Operator RTS created order:
#      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
#    And DB operator gets details for delivery transactions by order id
#    And DB operator gets details for delivery waypoint
#    And API Operator get Addressing Zone from a lat long with type "RTS"
#    When Operator initialize address pool with all options checked in Address Verification page
#    Then Operator verifies that success react notification displayed:
#      | top | Address pool initialized |
#    When Operator fetch addresses from initialized pool from zone "{ooz-zone-name}"
#    And Operator clicks on 'Edit' button for -1 address on Address Verification page
#    And Operator fills address parameters in Edit Address modal on Address Verification page:
#      | latitude  | {av-ooz-zone-latitude}  |
#      | longitude | {av-ooz-zone-longitude} |
#    And Operator clicks 'Save' button in Edit Address modal on Address Verification page:
#    Then Operator verifies that success react notification displayed:
#      | top    | Address event created         |
#      | bottom | Waypoint successfully updated |
#    When API Operator get "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" order details
#    And DB Operator verify Jaro Scores of Delivery Transaction waypoint of created order are archived
#    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
#    Then Operator verify order event on Edit order page using data below:
#      | name | VERIFY ADDRESS |
#    And Operator verifies Zone is "{av-ooz-zone-short-name}" on Edit Order page
#
#  Scenario: AV Non RTS orders - RTS zone exist
#    When Operator go to menu Utilities -> Address Verification
#    And Operator refresh page v1
#    Then Address Verification page is loaded
#    Given API Shipper create an order using below json as request body
#      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
#      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
#      | v4OrderRequest      | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"09:00","end_time":"22:00", "timezone":"Asia/Jakarta"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00", "timezone":"Asia/Jakarta"},"dimensions":{"size":"S","weight":1,"length":"10","width":"10","height":"10"}},"from":{"name": "Kenny Shipper", "phone_number": "+62123456789", "email": "kenny.wirianto@test.co", "address":{"address1": "Lippo Mall Puri", "address2": "Lippo Mall Puri", "country": "ID", "postcode": "11610", "province": "Sort", "city": "Out Of", "kecamatan": "Zone"}},"to":{"name":"Automation Customer","email":"automation.customer@ninjavan.co","phone_number":"+62123456789","address":{"address1":"Grand Indonesia","address2":"Grand Indonesia","postcode":"10310","country":"ID","province":"Sort","city":"NO","kecamatan":"Zone"}}} |
#    And API Operator gets destination hub of the created order
#    When API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_HUB_INFO.id},"tags":[5570]} |
#    And DB operator gets details for delivery transactions by order id
#    And DB operator gets details for delivery waypoint
#    And API Operator get Addressing Zone from a lat long with type "STANDARD"
#    When Operator initialize address pool with all options checked in Address Verification page
#    Then Operator verifies that success react notification displayed:
#      | top | Address pool initialized |
#    When Operator fetch addresses from initialized pool from zone "{av-zone-without-rts-zone}"
#    And Operator clicks on 'Edit' button for -1 address on Address Verification page
#    And Operator fills address parameters in Edit Address modal on Address Verification page:
#      | latitude  | {av-rts-zone-latitude-2}  |
#      | longitude | {av-rts-zone-longitude-2} |
#    And Operator clicks 'Save' button in Edit Address modal on Address Verification page:
#    Then Operator verifies that success react notification displayed:
#      | top    | Address event created         |
#      | bottom | Waypoint successfully updated |
#    When API Operator get "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" order details
#    And DB Operator verify Jaro Scores of Delivery Transaction waypoint of created order are archived
#    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
#    Then Operator verify order event on Edit order page using data below:
#      | name | VERIFY ADDRESS |
#    And Operator verifies Zone is "{av-standard-zone-name}" on Edit Order page
#
#  Scenario: AV Non RTS orders - RTS zone does not exist
#    When Operator go to menu Utilities -> Address Verification
#    And Operator refresh page v1
#    Then Address Verification page is loaded
#    Given API Shipper create an order using below json as request body
#      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
#      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
#      | v4OrderRequest      | {"service_type":"Parcel","service_level":"SameDay","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"09:00","end_time":"22:00", "timezone":"Asia/Jakarta"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00", "timezone":"Asia/Jakarta"},"dimensions":{"size":"S","weight":1,"length":"10","width":"10","height":"10"}},"from":{"name": "Kenny Shipper", "phone_number": "+62123456789", "email": "kenny.wirianto@test.co", "address":{"address1": "Lippo Mall Puri", "address2": "Lippo Mall Puri", "country": "ID", "postcode": "11610", "province": "SORT", "city": "NO", "kecamatan": "ZONE"}},"to":{"name":"Automation Customer","email":"automation.customer@ninjavan.co","phone_number":"+62123456789","address":{"address1":"Grand Indonesia","address2":"Grand Indonesia","postcode":"10310","country":"ID","province":"SORT","city":"NO","kecamatan":"ZONE"}}} |
#    And API Operator gets destination hub of the created order
#    When API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_HUB_INFO.id},"tags":[5570]} |
#    And DB operator gets details for delivery transactions by order id
#    And DB operator gets details for delivery waypoint
#    And API Operator get Addressing Zone from a lat long with type "STANDARD"
#    When Operator initialize address pool with all options checked in Address Verification page
#    Then Operator verifies that success react notification displayed:
#      | top | Address pool initialized |
#    When Operator fetch addresses from initialized pool from zone "{av-zone-without-rts-zone}"
#    And Operator clicks on 'Edit' button for -1 address on Address Verification page
#    And Operator fills address parameters in Edit Address modal on Address Verification page:
#      | latitude  | {av-zone-latitude}  |
#      | longitude | {av-zone-longitude} |
#    And Operator clicks 'Save' button in Edit Address modal on Address Verification page:
#    Then Operator verifies that success react notification displayed:
#      | top    | Address event created         |
#      | bottom | Waypoint successfully updated |
#    When API Operator get "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" order details
#    And DB Operator verify Jaro Scores of Delivery Transaction waypoint of created order are archived
#    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
#    Then Operator verify order event on Edit order page using data below:
#      | name | VERIFY ADDRESS |
#    And Operator verifies Zone is "{av-zone-short-name}" on Edit Order page
#
#  Scenario: AV Non RTS orders - Zone is NULL
#    When Operator go to menu Utilities -> Address Verification
#    And Operator refresh page v1
#    Then Address Verification page is loaded
#    Given API Shipper create an order using below json as request body
#      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
#      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
#      | v4OrderRequest      | {"service_type":"Parcel","service_level":"SameDay","parcel_job":{"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"09:00","end_time":"22:00", "timezone":"Asia/Jakarta"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00", "timezone":"Asia/Jakarta"},"dimensions":{"size":"S","weight":1,"length":"10","width":"10","height":"10"}},"from":{"name": "Kenny Shipper", "phone_number": "+62123456789", "email": "kenny.wirianto@test.co", "address":{"address1": "Lippo Mall Puri", "address2": "Lippo Mall Puri", "country": "ID", "postcode": "11610", "province": "SORT", "city": "NO", "kecamatan": "ZONE"}},"to":{"name":"Automation Customer","email":"automation.customer@ninjavan.co","phone_number":"+62123456789","address":{"address1":"Grand Indonesia","address2":"Grand Indonesia","postcode":"10310","country":"ID","province":"SORT","city":"NO","kecamatan":"ZONE"}}} |
#    And API Operator gets destination hub of the created order
#    When API Operator Global Inbound parcel using data below:
#      | globalInboundRequest | { "hubId":{KEY_HUB_INFO.id},"tags":[5570]} |
#    And DB operator gets details for delivery transactions by order id
#    And DB operator gets details for delivery waypoint
#    And API Operator get Addressing Zone from a lat long with type "STANDARD"
#    When Operator initialize address pool with all options checked in Address Verification page
#    Then Operator verifies that success react notification displayed:
#      | top | Address pool initialized |
#    When Operator fetch addresses from initialized pool from zone "{av-zone-without-rts-zone}"
#    And Operator clicks on 'Edit' button for -1 address on Address Verification page
#    And Operator fills address parameters in Edit Address modal on Address Verification page:
#      | latitude  | {av-ooz-zone-latitude}  |
#      | longitude | {av-ooz-zone-longitude} |
#    And Operator clicks 'Save' button in Edit Address modal on Address Verification page:
#    Then Operator verifies that success react notification displayed:
#      | top    | Address event created         |
#      | bottom | Waypoint successfully updated |
#    When API Operator get "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" order details
#    And DB Operator verify Jaro Scores of Delivery Transaction waypoint of created order are archived
#    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
#    Then Operator verify order event on Edit order page using data below:
#      | name | VERIFY ADDRESS |
#    And Operator verifies Zone is "{av-ooz-zone-short-name}" on Edit Order page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op