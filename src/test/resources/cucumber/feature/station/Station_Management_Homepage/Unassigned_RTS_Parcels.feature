@StationManagement @UnassignedRTSParcels
Feature: Unassigned RTS Parcels

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @Happypath @ForceSuccessOrder
  Scenario Outline: View Number of Unassigned RTS Parcels Parcels For Route (uid:6ff63ae8-93ba-45fe-857e-6dc05604fa1b)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":"{hub-id-Global}" } |
    And API Operator sweep parcel in the hub
      | hubId | <HubId>                         |
      | scan  | {KEY_CREATED_ORDER_TRACKING_ID} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator RTS order on Edit Order page using data below:
      | reason       | Nobody at address              |
      | deliveryDate | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot     | All Day (9AM - 10PM)           |
    And Operator updates the destination HubId "<DestinationHubId>" in Parcels table
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID          |
      | Last Scan Type       |
      | Last Scan Time       |
      | Recovery Ticket Type |
      | Ticket Status        |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |

    Examples:
      | HubName       | HubId       | DestinationHubId | TileName  | ModalName                      |
      | {hub-name-14} | {hub-id-14} | {hub-id-14}      | For Route | RTS parcels not added to route |

  @Happypath @ForceSuccessOrder
  Scenario Outline: View Number of Unassigned RTS Parcels Parcels For Shipment (uid:657c1c0e-4954-440c-8114-39d2fb1c2865)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":"{hub-id-Global}" } |
    And API Operator sweep parcel in the hub
      | hubId | <HubId>                         |
      | scan  | {KEY_CREATED_ORDER_TRACKING_ID} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator RTS order on Edit Order page using data below:
      | reason       | Nobody at address              |
      | deliveryDate | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot     | All Day (9AM - 10PM)           |
    And Operator updates the destination HubId "<DestinationHubId>" in Parcels table
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID          |
      | Last Scan Type       |
      | Last Scan Time       |
      | Recovery Ticket Type |
      | Ticket Status        |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |

    Examples:
      | HubName       | HubId       | DestinationHubId | TileName     | ModalName                           |
      | {hub-name-14} | {hub-id-14} | {hub-id-8}       | For Shipment | Unassigned RTS parcels for shipment |

  @Happypath @ForceSuccessOrder @ArchiveRoute
  Scenario Outline: Number of Unassigned RTS Parcels Parcels For Route - Add Parcel to Route (uid:c32c0f3b-21f7-4878-a826-b5bb0730858e)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":"{hub-id-Global}" } |
    And API Operator sweep parcel in the hub
      | hubId | <HubId>                         |
      | scan  | {KEY_CREATED_ORDER_TRACKING_ID} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator RTS order on Edit Order page using data below:
      | reason       | Nobody at address              |
      | deliveryDate | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot     | All Day (9AM - 10PM)           |
    And Operator updates the destination HubId "<DestinationHubId>" in Parcels table
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID          |
      | Last Scan Type       |
      | Last Scan Time       |
      | Recovery Ticket Type |
      | Ticket Status        |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And Operator refresh page v1
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has decreased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator expects no results when searching for the orders by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    Examples:
      | HubName       | HubId       | DestinationHubId | TileName  | ModalName                      |
      | {hub-name-14} | {hub-id-14} | {hub-id-14}      | For Route | RTS parcels not added to route |

  @Happypath @ForceSuccessOrder @ArchiveRoute
  Scenario Outline: Number of Unassigned RTS Parcels Parcels For Shipment - Add Parcel to Shipment (uid:71c7c0a5-92a3-4e78-9a32-8de413a3d8a5)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":"{hub-id-Global}" } |
    And API Operator sweep parcel in the hub
      | hubId | <HubId>                         |
      | scan  | {KEY_CREATED_ORDER_TRACKING_ID} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator RTS order on Edit Order page using data below:
      | reason       | Nobody at address              |
      | deliveryDate | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot     | All Day (9AM - 10PM)           |
    And Operator updates the destination HubId "<DestinationHubId>" in Parcels table
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID          |
      | Last Scan Type       |
      | Last Scan Time       |
      | Recovery Ticket Type |
      | Ticket Status        |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator creates shipment using data below:
      | createShipmentRequest | {"shipment": {"shipment_type": "LAND_HAUL", "orig_hub_id": <HubId>, "dest_hub_id": <DestinationHubId>, "comments": "<Comments>", "orig_hub_country": "<Country>", "dest_hub_country": "<Country>", "curr_hub_country": "<Country>", "status": "Pending", "end_date": null }}' |
    And API Operator adds parcels to shipment using following data:
      | country    | <Country>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
      | actionType | ADD                             |
    And Operator refresh page v1
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has decreased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator expects no results when searching for the orders by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |

    Examples:
      | HubName       | HubId       | DestinationHubId | Country | Comments  | TileName     | ModalName                           |
      | {hub-name-14} | {hub-id-14} | {hub-id-8}       | sg      | GENERATED | For Shipment | Unassigned RTS parcels for shipment |


  @ForceSuccessOrder @SystemIdNotSg @default-id
  Scenario Outline: [ID, TH, VN] Last Scan Time Parcels For Route Should Match Country's Timezone UTC +7
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"STANDARD","from": {"name": "QA-STATION-TEST-FROM","phone_number": "+6281231422926","email": "senderV4@nvqa.co","address": {"address1": "Jl. Gedung Sate No.48","country": "ID","province": "Jawa Barat ","city": "Kota Bandung","postcode": "60272","latitude": -6.921837,"longitude": 107.636803}},"to": {"name": "QA-STATION-TEST-TO","phone_number": "+6281231422926","email": "recipientV4@nvqa.co","address": {"address1": "Jalan Tebet Timur, 12","country": "ID","province": "DKI Jakarta","kecamatan": "Jakarta Selatan","postcode": "11280","latitude": -6.240501,"longitude": 106.841408}},"parcel_job":{ "cash_on_delivery": 100,"insured_value": 85000,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":"{hub-id-Global}" } |
    And API Operator sweep parcel in the hub
      | hubId | <HubId>                         |
      | scan  | {KEY_CREATED_ORDER_TRACKING_ID} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator RTS order on Edit Order page using data below:
      | reason       | Nobody at address              |
      | deliveryDate | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot     | All Day (9AM - 10PM)           |
    And Operator updates the destination HubId "<DestinationHubId>" in Parcels table
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID          |
      | Last Scan Type       |
      | Last Scan Time       |
      | Recovery Ticket Type |
      | Ticket Status        |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator gets the order details from modal "<ModalName>"
    And DB Operator verifies that Last Scan time is +7 hours from station>parcels.last_scan_time


    Examples:
      | HubName      | HubId      | DestinationHubId | TileName  | ModalName                      | Country   |
      | {hub-name-1} | {hub-id-1} | {hub-id-1}       | For Route | RTS parcels not added to route | Indonesia |

  @ForceSuccessOrder
  Scenario Outline: [SG, MY, PH] Last Scan Time Parcels For Route Should Match Country's Timezone UTC +8
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":"{hub-id-Global}" } |
    And API Operator sweep parcel in the hub
      | hubId | <HubId>                         |
      | scan  | {KEY_CREATED_ORDER_TRACKING_ID} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator RTS order on Edit Order page using data below:
      | reason       | Nobody at address              |
      | deliveryDate | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot     | All Day (9AM - 10PM)           |
    And Operator updates the destination HubId "<DestinationHubId>" in Parcels table
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID          |
      | Last Scan Type       |
      | Last Scan Time       |
      | Recovery Ticket Type |
      | Ticket Status        |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator gets the order details from modal "<ModalName>"
    And DB Operator verifies that Last Scan time is +8 hours from station>parcels.last_scan_time


    Examples:
      | HubName       | HubId       | DestinationHubId | TileName  | ModalName                      |
      | {hub-name-14} | {hub-id-14} | {hub-id-14}      | For Route | RTS parcels not added to route |

  @ForceSuccessOrder @SystemIdNotSg @default-id
  Scenario Outline: [ID, TH, VN] Last Scan Time Parcels For Shipment Should Match Country's Timezone UTC+7
    Given Operator loads Operator portal home page
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":"{hub-id-Global}" } |
    And API Operator sweep parcel in the hub
      | hubId | <HubId>                         |
      | scan  | {KEY_CREATED_ORDER_TRACKING_ID} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator RTS order on Edit Order page using data below:
      | reason       | Nobody at address              |
      | deliveryDate | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot     | All Day (9AM - 10PM)           |
    And Operator updates the destination HubId "<DestinationHubId>" in Parcels table
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID          |
      | Last Scan Type       |
      | Last Scan Time       |
      | Recovery Ticket Type |
      | Ticket Status        |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator gets the order details from modal "<ModalName>"
    And DB Operator verifies that Last Scan time is +7 hours from station>parcels.last_scan_time

    Examples:
      | HubName      | HubId      | DestinationHubId | TileName     | ModalName                           | Country   |
      | {hub-name-1} | {hub-id-1} | {hub-id-2}       | For Shipment | Unassigned RTS parcels for shipment | Indonesia |

  @ForceSuccessOrder
  Scenario Outline: [SG, MY, PH] Last Scan Time Parcels For Route Should Match Country's Timezone UTC +8
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":"{hub-id-Global}" } |
    And API Operator sweep parcel in the hub
      | hubId | <HubId>                         |
      | scan  | {KEY_CREATED_ORDER_TRACKING_ID} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    When Operator RTS order on Edit Order page using data below:
      | reason       | Nobody at address              |
      | deliveryDate | {gradle-next-1-day-yyyy-MM-dd} |
      | timeslot     | All Day (9AM - 10PM)           |
    And Operator updates the destination HubId "<DestinationHubId>" in Parcels table
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID          |
      | Last Scan Type       |
      | Last Scan Time       |
      | Recovery Ticket Type |
      | Ticket Status        |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     |
      | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator gets the order details from modal "<ModalName>"
    And DB Operator verifies that Last Scan time is +8 hours from station>parcels.last_scan_time

    Examples:
      | HubName       | HubId       | DestinationHubId | TileName     | ModalName                           |
      | {hub-name-14} | {hub-id-14} | {hub-id-8}       | For Shipment | Unassigned RTS parcels for shipment |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op