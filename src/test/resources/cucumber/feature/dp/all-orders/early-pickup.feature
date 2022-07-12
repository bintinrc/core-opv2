@OperatorV2 @DpEarlyPickup @DpAdministrationV2 @DP
Feature: Early Pickup

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Driver Drop Off Order - Trigger Early Pickup - Multiple Orders - Send to Doorstep
    Given Operator go to menu Order -> All Orders
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {opv2-dp-order-creation-shipper-client-id}                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {opv2-dp-order-creation-shipper-client-secret}                                                                                                                                                                                                                                                                                                  |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Normal", "service_level":"Standard","to":{"name":"Latika Jamnal","phone_number":"+6596548707","email":"ninjavan.qa3@gmail.com","address":{"country":"SG","address2":"Redhill MRT","address1":"51 Lengkok Bahru","postcode":"150051"}}, "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
    Given API Operator assign delivery waypoint of an order to DP Include Today with ID = "{opv2-dp-dpms-id}"
    When API DP get the DP Details by DP ID = "{opv2-dp-dp-id}"
    And API Operator get order events by created order id
    And DB Operator gets all details for ninja collect confirmed status
    Then Operator verifies that all the details for Confirmed Status are right
    Given API Operator get DP information by DP ID for DP with ID = "{opv2-dp-dpms-id}"
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator Van Inbound parcel
    Given API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    Given API Operator get order details
    Given DB Operator get DP job id from Hibernate
    Given API Driver v5 success dp drop off
    When DB Operator gets all details for ninja collect driver drop off confirmed status
    Then Operator verifies that all the details for ninja collect driver drop off confirmed status are right
    When Operator clicks Clear All Selections and Load Selection button on All Orders Page
    And Operator apply Early pickup action and chooses "Send To Doorstep" with ""
    Then Downloaded csv file contains correct orders and message "Pickup Reservation Created"
    And DB operator verifies pickup date is today
    And DB operator verifies collect job is created
    When API Operator get order details by saved Order ID
    And Operator verifies the delivery address is doorstep address "51 Lengkok Bahru" and "Redhill MRT"

  Scenario: Driver Drop Off Order - Trigger Early Pickup - Multiple Orders - Return to Sender
    Given Operator go to menu Order -> All Orders
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {opv2-dp-order-creation-shipper-client-id}                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {opv2-dp-order-creation-shipper-client-secret}                                                                                                                                                                                                                                                                                                  |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Normal", "service_level":"Standard","to":{"name":"Latika Jamnal","phone_number":"+6596548707","email":"ninjavan.qa3@gmail.com","address":{"country":"SG","address2":"Redhill MRT","address1":"51 Lengkok Bahru","postcode":"150051"}}, "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
    Given API Operator assign delivery waypoint of an order to DP Include Today with ID = "{opv2-dp-dpms-id}"
    When API DP get the DP Details by DP ID = "{opv2-dp-dp-id}"
    And API Operator get order events by created order id
    And DB Operator gets all details for ninja collect confirmed status
    Then Operator verifies that all the details for Confirmed Status are right
    Given API Operator get DP information by DP ID for DP with ID = "{opv2-dp-dpms-id}"
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator Van Inbound parcel
    Given API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    Given API Operator get order details
    Given DB Operator get DP job id from Hibernate
    Given API Driver v5 success dp drop off
    When DB Operator gets all details for ninja collect driver drop off confirmed status
    Then Operator verifies that all the details for ninja collect driver drop off confirmed status are right
    When Operator clicks Clear All Selections and Load Selection button on All Orders Page
    And Operator apply Early pickup action and chooses "Return To Sender" with ""
    Then Downloaded csv file contains correct orders and message "Pickup Reservation Created"
    And DB operator verifies pickup date is today
    And DB operator verifies collect job is created
    When API Operator get order details by saved Order ID
    Then Operator verifies the delivery address is rts

  Scenario: Driver Drop Off Order - Overstayed Order - Trigger Early Pickup - Multiple Orders - Send to Doorstep
    Given Operator go to menu Order -> All Orders
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {opv2-dp-order-creation-shipper-client-id}                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {opv2-dp-order-creation-shipper-client-secret}                                                                                                                                                                                                                                                                                                  |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Normal", "service_level":"Standard","to":{"name":"Latika Jamnal","phone_number":"+6596548707","email":"ninjavan.qa3@gmail.com","address":{"country":"SG","address2":"Redhill MRT","address1":"51 Lengkok Bahru","postcode":"150051"}}, "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
    Given API Operator assign delivery waypoint of an order to DP Include Today with ID = "{opv2-dp-dpms-id}"
    When API DP get the DP Details by DP ID = "{opv2-dp-dp-id}"
    And API Operator get order events by created order id
    And DB Operator gets all details for ninja collect confirmed status
    Then Operator verifies that all the details for Confirmed Status are right
    Given API Operator get DP information by DP ID for DP with ID = "{opv2-dp-dpms-id}"
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator Van Inbound parcel
    Given API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    Given API Operator get order details
    Given DB Operator get DP job id from Hibernate
    Given API Driver v5 success dp drop off
    And Operator waits for 5 seconds
    When DB Operator gets all details for ninja collect driver drop off confirmed status
    Then Operator verifies that all the details for ninja collect driver drop off confirmed status are right
    Given DB Operator set pickup date of DP reservation to current date from Hibernate
    Given API Operator trigger Add Overstayed Orders
    Given DB Operator set collect until date of DP reservation to yesterday's date from Hibernate
    Given API Operator trigger overstay to create new reservation
    And DB Operator gets the Order ID by Tracking ID
    Given DB Operator gets Reservation ID based on Order ID from order pickups table
    When DB Operator gets the reservation date details for created order
    When Operator clicks Clear All Selections and Load Selection button on All Orders Page
    And Operator apply Early pickup action and chooses "Send To Doorstep" with ""
    Then Downloaded csv file contains correct orders and message "Pickup Reservation Created"
    And DB operator verifies pickup date is today
    And DB operator verifies collect job is created
    When API Operator get order details by saved Order ID

  Scenario: Driver Drop Off Order - Overstayed Order - Trigger Early Pickup - Multiple Orders - Return to Sender
    Given Operator go to menu Order -> All Orders
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {opv2-dp-order-creation-shipper-client-id}                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {opv2-dp-order-creation-shipper-client-secret}                                                                                                                                                                                                                                                                                                  |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Normal", "service_level":"Standard","to":{"name":"Latika Jamnal","phone_number":"+6596548707","email":"ninjavan.qa3@gmail.com","address":{"country":"SG","address2":"Redhill MRT","address1":"51 Lengkok Bahru","postcode":"150051"}}, "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
    Given API Operator assign delivery waypoint of an order to DP Include Today with ID = "{opv2-dp-dpms-id}"
    When API DP get the DP Details by DP ID = "{opv2-dp-dp-id}"
    And API Operator get order events by created order id
    And DB Operator gets all details for ninja collect confirmed status
    Then Operator verifies that all the details for Confirmed Status are right
    Given API Operator get DP information by DP ID for DP with ID = "{opv2-dp-dpms-id}"
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator Van Inbound parcel
    Given API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    Given API Operator get order details
    Given DB Operator get DP job id from Hibernate
    Given API Driver v5 success dp drop off
    When DB Operator gets all details for ninja collect driver drop off confirmed status
    Then Operator verifies that all the details for ninja collect driver drop off confirmed status are right
    Given DB Operator set pickup date of DP reservation to current date from Hibernate
    Given API Operator trigger Add Overstayed Orders
    Given DB Operator set collect until date of DP reservation to yesterday's date from Hibernate
    Given API Operator trigger overstay to create new reservation
    And DB Operator gets the Order ID by Tracking ID
    Given DB Operator gets Reservation ID based on Order ID from order pickups table
    When DB Operator gets the reservation date details for created order
    When Operator clicks Clear All Selections and Load Selection button on All Orders Page
    And Operator apply Early pickup action and chooses "Return To Sender" with ""
    Then Downloaded csv file contains correct orders and message "Pickup Reservation Created"
    And DB operator verifies pickup date is today
    And DB operator verifies collect job is created
    When API Operator get order details by saved Order ID
    Then Operator verifies the delivery address is rts

  Scenario: Driver Drop Off - Trigger Earlier Pickup - After Pickup Date
    Given Operator go to menu Order -> All Orders
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {opv2-dp-order-creation-shipper-client-id}                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {opv2-dp-order-creation-shipper-client-secret}                                                                                                                                                                                                                                                                                                  |
      |  generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Normal", "service_level":"Standard","to":{"name":"Latika Jamnal","phone_number":"+6596548707","email":"ninjavan.qa3@gmail.com","address":{"country":"SG","address2":"Redhill MRT","address1":"51 Lengkok Bahru","postcode":"150051"}}, "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
    Given API Operator assign delivery waypoint of an order to DP Include Today with ID = "{opv2-dp-dpms-id}"
    When API DP get the DP Details by DP ID = "{opv2-dp-dp-id}"
    And API Operator get order events by created order id
    And DB Operator gets all details for ninja collect confirmed status
    Then Operator verifies that all the details for Confirmed Status are right
    Given API Operator get DP information by DP ID for DP with ID = "{opv2-dp-dpms-id}"
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator Van Inbound parcel
    Given API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    Given API Operator get order details
    Given DB Operator get DP job id from Hibernate
    And API Operator do the DP Success for From Driver Flow
    Given API Driver v5 success dp drop off
    And Operator waits for 5 seconds
    When DB Operator gets all details for ninja collect driver drop off confirmed status
    Then Operator verifies that all the details for ninja collect driver drop off confirmed status are right
    When Operator clicks Clear All Selections and Load Selection button on All Orders Page
    And Operator apply Early pickup action and chooses "Send To Doorstep" with "date"
    Then Downloaded csv file contains correct orders and message "Requested early pickup_date is after scheduled pickup date"

  Scenario: Driver Drop Off Order - Trigger Early Pickup - Multiple Orders - Send to Doorstep - Driver Collect
    Given Operator go to menu Order -> All Orders
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {opv2-dp-order-creation-shipper-client-id}                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {opv2-dp-order-creation-shipper-client-secret}                                                                                                                                                                                                                                                                                                  |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Normal", "service_level":"Standard","to":{"name":"Latika Jamnal","phone_number":"+6596548707","email":"ninjavan.qa3@gmail.com","address":{"country":"SG","address2":"Redhill MRT","address1":"51 Lengkok Bahru","postcode":"150051"}}, "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
    Given API Operator assign delivery waypoint of an order to DP Include Today with ID = "{opv2-dp-dpms-id}"
    When API DP get the DP Details by DP ID = "{opv2-dp-dp-id}"
    And API Operator get order events by created order id
    And DB Operator gets all details for ninja collect confirmed status
    Then Operator verifies that all the details for Confirmed Status are right
    Given API Operator get DP information by DP ID for DP with ID = "{opv2-dp-dpms-id}"
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator Van Inbound parcel
    Given API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    Given API Operator get order details
    Given DB Operator get DP job id from Hibernate
    Given API Driver v5 success dp drop off
    And Operator waits for 5 seconds 
    When DB Operator gets all details for ninja collect driver drop off confirmed status
    Then Operator verifies that all the details for ninja collect driver drop off confirmed status are right
    When Operator clicks Clear All Selections and Load Selection button on All Orders Page
    And Operator apply Early pickup action and chooses "Send To Doorstep" with ""
    Then Downloaded csv file contains correct orders and message "Pickup Reservation Created"
    And DB operator verifies pickup date is today
    And DB operator verifies collect job is created
    When API Operator get order details by saved Order ID
    And Operator verifies the delivery address is doorstep address "51 Lengkok Bahru" and "Redhill MRT"
    And DB Operator gets the Order ID by Tracking ID
    Given DB Operator gets Reservation ID based on Order ID from order pickups table
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add string reservation pick-up ID to the route
    Given API Operator start the route
    And API Driver collect all his routes
    And API Driver get Reservation Job
    And DB Operator get DP job id from Hibernate
    And API Operator do the DP Success for To Driver Flow
    And API Driver "2.2" success reservation from dp
    And Operator waits for 5 seconds
    When DB Operator gets all the data input for Driver Collection Order from database
    Then Operator verifies the data on the database for driver collect scenarios are all right
    When API Operator get order details by saved Order ID
    Then Operator verifies the order status is "TRANSIT" and granular status is "ENROUTE_TO_SORTING_HUB"

  Scenario: Driver Drop Off Order - Trigger Early Pickup - Multiple Orders - Return to Sender - Driver Collect
    Given Operator go to menu Order -> All Orders
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {opv2-dp-order-creation-shipper-client-id}                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {opv2-dp-order-creation-shipper-client-secret}                                                                                                                                                                                                                                                                                                  |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Normal", "service_level":"Standard","to":{"name":"Latika Jamnal","phone_number":"+6596548707","email":"ninjavan.qa3@gmail.com","address":{"country":"SG","address2":"Redhill MRT","address1":"51 Lengkok Bahru","postcode":"150051"}}, "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
    Given API Operator assign delivery waypoint of an order to DP Include Today with ID = "{opv2-dp-dpms-id}"
    When API DP get the DP Details by DP ID = "{opv2-dp-dp-id}"
    And API Operator get order events by created order id
    And DB Operator gets all details for ninja collect confirmed status
    Then Operator verifies that all the details for Confirmed Status are right
    Given API Operator get DP information by DP ID for DP with ID = "{opv2-dp-dpms-id}"
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator Van Inbound parcel
    Given API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    Given API Operator get order details
    Given DB Operator get DP job id from Hibernate
    Given API Driver v5 success dp drop off
    And Operator waits for 5 seconds
    When DB Operator gets all details for ninja collect driver drop off confirmed status
    Then Operator verifies that all the details for ninja collect driver drop off confirmed status are right
    When Operator clicks Clear All Selections and Load Selection button on All Orders Page
    And Operator apply Early pickup action and chooses "Return To Sender" with ""
    Then Downloaded csv file contains correct orders and message "Pickup Reservation Created"
    And DB operator verifies pickup date is today
    And DB operator verifies collect job is created
    When API Operator get order details by saved Order ID
    Then Operator verifies the delivery address is rts
    And DB Operator gets the Order ID by Tracking ID
    Given DB Operator gets Reservation ID based on Order ID from order pickups table
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add string reservation pick-up ID to the route
    Given API Operator start the route
    And API Driver collect all his routes
    And API Driver get Reservation Job
    And DB Operator get DP job id from Hibernate
    And API Operator do the DP Success for To Driver Flow
    And API Driver "2.2" success reservation from dp
    And Operator waits for 5 seconds
    When DB Operator gets all the data input for Driver Collection Order from database
    Then Operator verifies the data on the database for driver collect scenarios are all right
    When API Operator get order details by saved Order ID
    Then Operator verifies the order status is "TRANSIT" and granular status is "ENROUTE_TO_SORTING_HUB"

  Scenario: Driver Drop Off Order - Trigger Early Pickup - Multiple Orders - Send to Doorstep - Customer Collect
    Given Operator go to menu Order -> All Orders
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {opv2-dp-order-creation-shipper-client-id}                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {opv2-dp-order-creation-shipper-client-secret}                                                                                                                                                                                                                                                                                                  |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Normal", "service_level":"Standard","to":{"name":"Latika Jamnal","phone_number":"+6596548707","email":"ninjavan.qa3@gmail.com","address":{"country":"SG","address2":"Redhill MRT","address1":"51 Lengkok Bahru","postcode":"150051"}}, "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
    Given API Operator assign delivery waypoint of an order to DP Include Today with ID = "{opv2-dp-dpms-id}"
    When API DP get the DP Details by DP ID = "{opv2-dp-dp-id}"
    And API Operator get order events by created order id
    And DB Operator gets all details for ninja collect confirmed status
    Then Operator verifies that all the details for Confirmed Status are right
    Given API Operator get DP information by DP ID for DP with ID = "{opv2-dp-dpms-id}"
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator Van Inbound parcel
    Given API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    Given API Operator get order details
    Given DB Operator get DP job id from Hibernate
    Given API Driver v5 success dp drop off
    And Operator waits for 5 seconds 
    When DB Operator gets all details for ninja collect driver drop off confirmed status
    Then Operator verifies that all the details for ninja collect driver drop off confirmed status are right
    When Operator clicks Clear All Selections and Load Selection button on All Orders Page
    And Operator apply Early pickup action and chooses "Send To Doorstep" with ""
    Then Downloaded csv file contains correct orders and message "Pickup Reservation Created"
    And DB operator verifies pickup date is today
    And DB operator verifies collect job is created
    When API Operator get order details by saved Order ID
    And Operator verifies the delivery address is doorstep address "51 Lengkok Bahru" and "Redhill MRT"
    Given DB Operator gets Customer Unlock Code Based on Tracking ID
    And API DP do the Customer Collection from dp with ID = "{opv2-dp-dp-id}"
    When DB Operator gets all the data input for Customer Collection Order from database
    Then Operator verifies the data on the database for Customer Collect scenarios are all right

  Scenario: Driver Drop Off Order - Trigger Early Pickup - Multiple Orders - Return to Sender - Customer Collect
    Given Operator go to menu Order -> All Orders
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {opv2-dp-order-creation-shipper-client-id}                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {opv2-dp-order-creation-shipper-client-secret}                                                                                                                                                                                                                                                                                                  |
      | generateFrom        | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Normal", "service_level":"Standard","to":{"name":"Latika Jamnal","phone_number":"+6596548707","email":"ninjavan.qa3@gmail.com","address":{"country":"SG","address2":"Redhill MRT","address1":"51 Lengkok Bahru","postcode":"150051"}}, "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
    Given API Operator assign delivery waypoint of an order to DP Include Today with ID = "{opv2-dp-dpms-id}"
    When API DP get the DP Details by DP ID = "{opv2-dp-dp-id}"
    And API Operator get order events by created order id
    And DB Operator gets all details for ninja collect confirmed status
    Then Operator verifies that all the details for Confirmed Status are right
    Given API Operator get DP information by DP ID for DP with ID = "{opv2-dp-dpms-id}"
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator Van Inbound parcel
    Given API Operator start the route
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    Given API Operator get order details
    Given DB Operator get DP job id from Hibernate
    Given API Driver v5 success dp drop off
    And Operator waits for 5 seconds
    When DB Operator gets all details for ninja collect driver drop off confirmed status
    Then Operator verifies that all the details for ninja collect driver drop off confirmed status are right
    When Operator clicks Clear All Selections and Load Selection button on All Orders Page
    And Operator apply Early pickup action and chooses "Return To Sender" with ""
    Then Downloaded csv file contains correct orders and message "Pickup Reservation Created"
    And DB operator verifies pickup date is today
    And DB operator verifies collect job is created
    When API Operator get order details by saved Order ID
    Then Operator verifies the delivery address is rts
    Given DB Operator gets Customer Unlock Code Based on Tracking ID
    And API DP do the Customer Collection from dp with ID = "{opv2-dp-dp-id}"
    When DB Operator gets all the data input for Customer Collection Order from database
    Then Operator verifies the data on the database for Customer Collect scenarios are all right