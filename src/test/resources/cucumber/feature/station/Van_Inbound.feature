@StationManagement @Van-Inbound
Feature: Van Inbound

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario Outline: Proceed without Hub Inbounding Parcels in Pending Shipment (uid:11f153b1-8e54-4ddf-9823-f67987815814)
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <OrigHubName>                   |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator creates shipment using data below:
      | createShipmentRequest | {"shipment": {"shipment_type": "LAND_HAUL", "orig_hub_id": <OrigHubId>, "dest_hub_id": <DestHubId>, "comments": "<Comments>", "orig_hub_country": "<Country>", "dest_hub_country": "<Country>", "curr_hub_country": "<Country>", "status": "Pending", "end_date": null }}' |
    And API Operator adds parcels to shipment using following data:
      | country    | <Country>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
      | actionType | ADD                             |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<OrigHubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    Then Operator confirms that the modal: "<ModalName1>" is displayed and has 1 parcels
    And Operator verifies that tracking id is displayed and proceeds without hub inbounding
    And Operator fill the tracking ID on Van Inbound Page then click enter
    And Operator confirms that the modal: "<ModalName2>" is displayed and has tracking id displayed
    And Operator verifies the route is started on clicking route start button
    And Operator verifies that van inbound page is displayed after clicking back to route input screen
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order page
    And Operator verifies Latest Event is "DRIVER START ROUTE" on Edit Order page
    And Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_CREATED_ROUTE_ID}" Route ID on Route Logs page
    And Operator verify route details on Route Logs page using data below:
      | id     | {KEY_CREATED_ROUTE_ID} |
      | status | IN_PROGRESS            |

    Examples:
      | OrigHubId  | OrigHubName  | DestHubId  | Country | ModalName1                                        | ModalName2                   | Comments  |
      | {hub-id-8} | {hub-name-8} | {hub-id-9} | sg      | List of parcels that have yet to shipment inbound | Parcel Not Yet Hub Inbounded | GENERATED |

  Scenario Outline: Proceed without Hub Inbounding Parcels in Transit Shipment (uid:7712631d-b091-4aa7-ab7e-99ba57be85ac)
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <OrigHubName>                   |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator creates shipment using data below:
      | createShipmentRequest | {"shipment": {"shipment_type": "LAND_HAUL", "orig_hub_id": <OrigHubId>, "dest_hub_id": <DestHubId>, "comments": "<Comments>", "orig_hub_country": "<Country>", "dest_hub_country": "<Country>", "curr_hub_country": "<Country>", "status": "Pending", "end_date": null }}' |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<OrigHubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator adds parcels to shipment using following data:
      | country    | <Country>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
      | actionType | ADD                             |
    And API Operator performs van inbound by updating shipment status using data below:
      | scanValue  | {KEY_CREATED_SHIPMENT_ID} |
      | hubCountry | <Country>                 |
      | hubId      | <OrigHubId>               |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    Then Operator confirms that the modal: "<ModalName1>" is displayed and has 1 parcels
    And Operator verifies that tracking id is displayed and proceeds without hub inbounding
    And Operator fill the tracking ID on Van Inbound Page then click enter
    And Operator confirms that the modal: "<ModalName2>" is displayed and has tracking id displayed
    And Operator verifies the route is started on clicking route start button
    And Operator verifies that van inbound page is displayed after clicking back to route input screen
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name | DRIVER INBOUND SCAN |
    And Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_CREATED_ROUTE_ID}" Route ID on Route Logs page
    And Operator verify route details on Route Logs page using data below:
      | id     | {KEY_CREATED_ROUTE_ID} |
      | status | IN_PROGRESS            |

    Examples:
      | OrigHubId  | OrigHubName  | DestHubId  | Country | ModalName1                                        | ModalName2                   | Comments  |
      | {hub-id-8} | {hub-name-8} | {hub-id-9} | sg      | List of parcels that have yet to shipment inbound | Parcel Not Yet Hub Inbounded | GENERATED |

  Scenario Outline: Proceed without Hub Inbounding Parcels at Transit Hub Shipment (uid:2cbbb2e5-0f48-4d82-8256-835ad3896824)
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <OrigHubName>                   |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator creates shipment using data below:
      | createShipmentRequest | {"shipment": {"shipment_type": "LAND_HAUL", "orig_hub_id": <OrigHubId>, "dest_hub_id": <DestHubId>, "comments": "<Comments>", "orig_hub_country": "<Country>", "dest_hub_country": "<Country>", "curr_hub_country": "<Country>", "status": "Pending", "end_date": null }}' |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<OrigHubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator adds parcels to shipment using following data:
      | country    | <Country>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
      | actionType | ADD                             |
    And API Operator performs hub inbound by updating shipment status using data below:
      | scanValue  | {KEY_CREATED_SHIPMENT_ID} |
      | hubCountry | <Country>                 |
      | hubId      | <TransHubId>              |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    Then Operator confirms that the modal: "<ModalName1>" is displayed and has 1 parcels
    And Operator verifies that tracking id is displayed and proceeds without hub inbounding
    And Operator fill the tracking ID on Van Inbound Page then click enter
    And Operator confirms that the modal: "<ModalName2>" is displayed and has tracking id displayed
    And Operator verifies the route is started on clicking route start button
    And Operator verifies that van inbound page is displayed after clicking back to route input screen
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name | DRIVER INBOUND SCAN |
    And Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_CREATED_ROUTE_ID}" Route ID on Route Logs page
    And Operator verify route details on Route Logs page using data below:
      | id     | {KEY_CREATED_ROUTE_ID} |
      | status | IN_PROGRESS            |

    Examples:
      | OrigHubId  | OrigHubName  | DestHubId  | TransHubId | Country | ModalName1                                        | ModalName2                   | Comments  |
      | {hub-id-8} | {hub-name-8} | {hub-id-9} | {hub-id-0} | sg      | List of parcels that have yet to shipment inbound | Parcel Not Yet Hub Inbounded | GENERATED |

  Scenario Outline: Proceed without Hub Inbounding Parcels in Closed Shipment (uid:c693992e-ba1e-4533-b89e-95e4bc9ca174)
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <OrigHubName>                   |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator creates shipment using data below:
      | createShipmentRequest | {"shipment": {"shipment_type": "LAND_HAUL", "orig_hub_id": <OrigHubId>, "dest_hub_id": <DestHubId>, "comments": "<Comments>", "orig_hub_country": "<Country>", "dest_hub_country": "<Country>", "curr_hub_country": "<Country>", "status": "Pending", "end_date": null }}' |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<OrigHubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator adds parcels to shipment using following data:
      | country    | <Country>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
      | actionType | ADD                             |
    And API Operator closes the shipment using created shipper id
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    Then Operator confirms that the modal: "<ModalName1>" is displayed and has 1 parcels
    And Operator verifies that tracking id is displayed and proceeds without hub inbounding
    And Operator fill the tracking ID on Van Inbound Page then click enter
    And Operator confirms that the modal: "<ModalName2>" is displayed and has tracking id displayed
    And Operator verifies the route is started on clicking route start button
    And Operator verifies that van inbound page is displayed after clicking back to route input screen
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name | DRIVER INBOUND SCAN |
    And Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_CREATED_ROUTE_ID}" Route ID on Route Logs page
    And Operator verify route details on Route Logs page using data below:
      | id     | {KEY_CREATED_ROUTE_ID} |
      | status | IN_PROGRESS            |

    Examples:
      | OrigHubId  | OrigHubName  | DestHubId  | Country | ModalName1                                        | ModalName2                   | Comments  |
      | {hub-id-8} | {hub-name-8} | {hub-id-9} | sg      | List of parcels that have yet to shipment inbound | Parcel Not Yet Hub Inbounded | GENERATED |

  Scenario Outline: Complete Shipment Before Scan Parcel to Van Inbound (uid:a244ba55-96d4-417d-af81-42549ea00786)
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <OrigHubName>                   |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator creates shipment using data below:
      | createShipmentRequest | {"shipment": {"shipment_type": "LAND_HAUL", "orig_hub_id": <OrigHubId>, "dest_hub_id": <DestHubId>, "comments": "<Comments>", "orig_hub_country": "<Country>", "dest_hub_country": "<Country>", "curr_hub_country": "<Country>", "status": "Pending", "end_date": null }}' |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<OrigHubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator adds parcels to shipment using following data:
      | country    | <Country>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
      | actionType | ADD                             |
    And API Operator performs van inbound by updating shipment status using data below:
      | scanValue  | {KEY_CREATED_SHIPMENT_ID} |
      | hubCountry | <Country>                 |
      | hubId      | <OrigHubId>               |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    Then Operator confirms that the modal: "<ModalName1>" is displayed and has 1 parcels
    And Operator verifies that tracking id is displayed and proceeds with hub inbounding
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning Shipment Into Hub in hub <DestHubName> on Shipment Inbound Scanning page
    And Operator check alert message on Shipment Inbound Scanning page using data below:
      | alert | Last scanned:{KEY_CREATED_SHIPMENT_ID} |
    And Operator verifies that the following messages display on the card after inbounding
      | scanState         | Destination Reached                       |
      | scanMessage       | Open Shipment                             |
      | scannedShipmentId | Shipment ID(s)\n{KEY_CREATED_SHIPMENT_ID} |
    And Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator fill the tracking ID on Van Inbound Page then click enter
    And Operator verifies the route is started on clicking route start button
    And Operator verifies that van inbound page is displayed after clicking back to route input screen
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order page
    And Operator verify order event on Edit order page using data below:
      | name | DRIVER INBOUND SCAN |
    And Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_CREATED_ROUTE_ID}" Route ID on Route Logs page
    And Operator verify route details on Route Logs page using data below:
      | id     | {KEY_CREATED_ROUTE_ID} |
      | status | IN_PROGRESS            |

    Examples:
      | OrigHubId  | OrigHubName  | DestHubId  | DestHubName  | Country | ModalName1                                        | Comments  |
      | {hub-id-8} | {hub-name-8} | {hub-id-9} | {hub-name-9} | sg      | List of parcels that have yet to shipment inbound | GENERATED |

  Scenario Outline: Proceed without Hub Inbounding Parcels in Incomplete Latest Shipment (uid:d4b0564e-b745-4121-a348-0992ed169598)
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <OrigHubName>                   |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<OrigHubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator creates shipment using data below:
      | createShipmentRequest | {"shipment": {"shipment_type": "LAND_HAUL", "orig_hub_id": <OrigHubId>, "dest_hub_id": <DestHubId>, "comments": "<Comments>", "orig_hub_country": "<Country>", "dest_hub_country": "<Country>", "curr_hub_country": "<Country>", "status": "Pending", "end_date": null }}' |
    And API Operator adds parcels to shipment using following data:
      | country    | <Country>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
      | actionType | ADD                             |
    And API Operator performs hub inbound by updating shipment status using data below:
      | scanValue  | {KEY_CREATED_SHIPMENT_ID} |
      | hubCountry | <Country>                 |
      | hubId      | <DestHubId>               |
    And API Operator creates shipment using data below:
      | createShipmentRequest | {"shipment": {"shipment_type": "LAND_HAUL", "orig_hub_id": <OrigHubId>, "dest_hub_id": <DestHubId>, "comments": "<Comments>", "orig_hub_country": "<Country>", "dest_hub_country": "<Country>", "curr_hub_country": "<Country>", "status": "Pending", "end_date": null }}' |
    And API Operator adds parcels to shipment using following data:
      | country    | <Country>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
      | actionType | ADD                             |
    And API Operator performs van inbound by updating shipment status using data below:
      | scanValue  | {KEY_CREATED_SHIPMENT_ID} |
      | hubCountry | <Country>                 |
      | hubId      | <OrigHubId>               |
    And Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    Then Operator confirms that the modal: "<ModalName1>" is displayed and has 1 parcels
    And Operator verifies that tracking id is displayed and proceeds without hub inbounding
    And Operator fill the tracking ID on Van Inbound Page then click enter
    And Operator confirms that the modal: "<ModalName2>" is displayed and has tracking id displayed
    And Operator verifies the route is started on clicking route start button
    And Operator verifies that van inbound page is displayed after clicking back to route input screen
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order event on Edit order page using data below:
      | name | DRIVER INBOUND SCAN |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order page
    And Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_CREATED_ROUTE_ID}" Route ID on Route Logs page
    And Operator verify route details on Route Logs page using data below:
      | id     | {KEY_CREATED_ROUTE_ID} |
      | status | IN_PROGRESS            |

    Examples:
      | OrigHubId  | OrigHubName  | DestHubId  | Country | ModalName1                                        | ModalName2                   | Comments  |
      | {hub-id-8} | {hub-name-8} | {hub-id-9} | sg      | List of parcels that have yet to shipment inbound | Parcel Not Yet Hub Inbounded | GENERATED |

  Scenario Outline: Van Inbound Parcels in Completed Shipment (uid:6fba8e5f-55b7-4402-925d-ca00660a8746)
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <OrigHubName>                   |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<OrigHubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator creates shipment using data below:
      | createShipmentRequest | {"shipment": {"shipment_type": "LAND_HAUL", "orig_hub_id": <OrigHubId>, "dest_hub_id": <DestHubId>, "comments": "<Comments>", "orig_hub_country": "<Country>", "dest_hub_country": "<Country>", "curr_hub_country": "<Country>", "status": "Pending", "end_date": null }}' |
    And API Operator adds parcels to shipment using following data:
      | country    | <Country>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
      | actionType | ADD                             |
    And API Operator performs hub inbound by updating shipment status using data below:
      | scanValue  | {KEY_CREATED_SHIPMENT_ID} |
      | hubCountry | <Country>                 |
      | hubId      | <DestHubId>               |
    And Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator fill the tracking ID on Van Inbound Page then click enter
    And Operator verifies the route is started on clicking route start button
    And Operator verifies that van inbound page is displayed after clicking back to route input screen
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order event on Edit order page using data below:
      | name | DRIVER INBOUND SCAN |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order page
    And Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_CREATED_ROUTE_ID}" Route ID on Route Logs page
    And Operator verify route details on Route Logs page using data below:
      | id     | {KEY_CREATED_ROUTE_ID} |
      | status | IN_PROGRESS            |

    Examples:
      | OrigHubId  | OrigHubName  | DestHubId  | Country | Comments  |
      | {hub-id-8} | {hub-name-8} | {hub-id-9} | sg      | GENERATED |

  Scenario Outline: Van Inbound Parcels in Cancelled Shipment (uid:9973ea31-d21f-4787-9a19-b800d97f4355)
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <OrigHubName>                   |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<OrigHubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator creates shipment using data below:
      | createShipmentRequest | {"shipment": {"shipment_type": "LAND_HAUL", "orig_hub_id": <OrigHubId>, "dest_hub_id": <DestHubId>, "comments": "<Comments>", "orig_hub_country": "<Country>", "dest_hub_country": "<Country>", "curr_hub_country": "<Country>", "status": "Pending", "end_date": null }}' |
    And API Operator adds parcels to shipment using following data:
      | country    | <Country>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
      | actionType | ADD                             |
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    And Operator cancels the created shipment on Shipment Management page
    And Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator fill the tracking ID on Van Inbound Page then click enter
    And Operator verifies the route is started on clicking route start button
    And Operator verifies that van inbound page is displayed after clicking back to route input screen
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order event on Edit order page using data below:
      | name | DRIVER INBOUND SCAN |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order page
    And Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_CREATED_ROUTE_ID}" Route ID on Route Logs page
    And Operator verify route details on Route Logs page using data below:
      | id     | {KEY_CREATED_ROUTE_ID} |
      | status | IN_PROGRESS            |

    Examples:
      | OrigHubId  | OrigHubName  | DestHubId  | Country | Comments  |
      | {hub-id-8} | {hub-name-8} | {hub-id-9} | sg      | GENERATED |

  Scenario Outline: Van Inbound Parcels Not in Any Shipment (uid:c9292f60-eb4a-485c-8004-3711b20f3a71)
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <OrigHubName>                   |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<OrigHubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator fill the tracking ID on Van Inbound Page then click enter
    And Operator verifies the route is started on clicking route start button
    And Operator verifies that van inbound page is displayed after clicking back to route input screen
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order event on Edit order page using data below:
      | name | DRIVER INBOUND SCAN |
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order page
    And Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_CREATED_ROUTE_ID}" Route ID on Route Logs page
    And Operator verify route details on Route Logs page using data below:
      | id     | {KEY_CREATED_ROUTE_ID} |
      | status | IN_PROGRESS            |

    Examples:
      | OrigHubId  | OrigHubName  |
      | {hub-id-8} | {hub-name-8} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op