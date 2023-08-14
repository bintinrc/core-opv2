@StationManagement @Van-Inbound
Feature: Van Inbound

  Background:
    When Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @Happypath @ForceSuccessOrder @ArchiveRoute @MediumPriority
  Scenario Outline: Unable to Van Inbound Parcels in Pending Shipment
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <OrigHubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
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
    And Operator fill the tracking ID on Van Inbound Page then click enter
    And Operator verifies unable to Van Inbound message is displayed
    And Operator closes the modal
    And Operator click Parcels Yet to scan area on Van Inbound Page
    Then Operator verifies the following details in the modal
      | ModalName      | <ModalName>                     |
      | Tracking ID    | {KEY_CREATED_ORDER_TRACKING_ID} |
      | WarningMessage | Please hub inbound shipment!    |

    Examples:
      | OrigHubId  | OrigHubName  | DestHubId  | Country | ModalName         | Comments  |
      | {hub-id-8} | {hub-name-8} | {hub-id-9} | sg      | Unscanned Parcels | GENERATED |

  @ForceSuccessOrder @ArchiveRoute @HighPriority
  Scenario Outline: Unable Van Inbound Parcels in Transit Shipment
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <OrigHubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    And API Operator creates shipment using data below:
      | createShipmentRequest | {"shipment": {"shipment_type": "LAND_HAUL", "orig_hub_id": <OrigHubId>, "dest_hub_id": <DestHubId>, "comments": "<Comments>", "orig_hub_country": "<Country>", "dest_hub_country": "<Country>", "curr_hub_country": "<Country>", "status": "Pending", "end_date": null }}' |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<OrigHubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator adds parcels to shipment using following data:
      | country    | <Country>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
      | actionType | ADD                             |
    When API Operator closes the shipment using created shipper id
    And API Operator performs van inbound by updating shipment status using data below:
      | scanValue  | {KEY_CREATED_SHIPMENT_ID} |
      | hubCountry | <Country>                 |
      | hubId      | <OrigHubId>               |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator fill the tracking ID on Van Inbound Page then click enter
    And Operator verifies unable to Van Inbound message is displayed
    And Operator closes the modal
    And Operator click Parcels Yet to scan area on Van Inbound Page
    Then Operator verifies the following details in the modal
      | ModalName      | <ModalName>                     |
      | Tracking ID    | {KEY_CREATED_ORDER_TRACKING_ID} |
      | WarningMessage | Please hub inbound shipment!    |

    Examples:
      | OrigHubId  | OrigHubName  | DestHubId  | Country | ModalName         | Comments  |
      | {hub-id-8} | {hub-name-8} | {hub-id-9} | sg      | Unscanned Parcels | GENERATED |

  @ForceSuccessOrder @ArchiveRoute @MediumPriority
  Scenario Outline: Unable Van Inbound Parcels at Transit Hub Shipment
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <OrigHubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
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
    And Operator fill the tracking ID on Van Inbound Page then click enter
    And Operator verifies unable to Van Inbound message is displayed
    And Operator closes the modal
    And Operator click Parcels Yet to scan area on Van Inbound Page
    Then Operator verifies the following details in the modal
      | ModalName      | <ModalName>                     |
      | Tracking ID    | {KEY_CREATED_ORDER_TRACKING_ID} |
      | WarningMessage | Please hub inbound shipment!    |

    Examples:
      | OrigHubId  | OrigHubName  | DestHubId  | TransHubId | Country | ModalName         | Comments  |
      | {hub-id-8} | {hub-name-8} | {hub-id-9} | {hub-id-0} | sg      | Unscanned Parcels | GENERATED |

  @ForceSuccessOrder @ArchiveRoute @MediumPriority
  Scenario Outline: Unable to Van Inbound Parcels in Closed Shipment
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <OrigHubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
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
    And Operator fill the tracking ID on Van Inbound Page then click enter
    And Operator verifies unable to Van Inbound message is displayed
    And Operator closes the modal
    And Operator click Parcels Yet to scan area on Van Inbound Page
    Then Operator verifies the following details in the modal
      | ModalName      | <ModalName>                     |
      | Tracking ID    | {KEY_CREATED_ORDER_TRACKING_ID} |
      | WarningMessage | Please hub inbound shipment!    |

    Examples:
      | OrigHubId  | OrigHubName  | DestHubId  | Country | ModalName         | Comments  |
      | {hub-id-8} | {hub-name-8} | {hub-id-9} | sg      | Unscanned Parcels | GENERATED |

  @Happypath @ForceSuccessOrder @ArchiveRoute @HighPriority
  Scenario Outline: Complete Shipment Before Scan Parcel to Van Inbound (uid:a244ba55-96d4-417d-af81-42549ea00786)
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <OrigHubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    And API Operator creates shipment using data below:
      | createShipmentRequest | {"shipment": {"shipment_type": "LAND_HAUL", "orig_hub_id": <OrigHubId>, "dest_hub_id": <DestHubId>, "comments": "<Comments>", "orig_hub_country": "<Country>", "dest_hub_country": "<Country>", "curr_hub_country": "<Country>", "status": "Pending", "end_date": null }}' |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<OrigHubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator adds parcels to shipment using following data:
      | country    | <Country>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
      | actionType | ADD                             |
    When API Operator closes the shipment using created shipper id
    And API Operator performs van inbound by updating shipment status using data below:
      | scanValue  | {KEY_CREATED_SHIPMENT_ID} |
      | hubCountry | <Country>                 |
      | hubId      | <OrigHubId>               |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator fill the tracking ID on Van Inbound Page then click enter
    And Operator verifies unable to Van Inbound message is displayed
    And Operator clicks the Hub Inbound Shipment button
    And Operator inbound scanning Shipment Into Hub in hub <DestHubName> on Shipment Inbound Scanning page
    And Operator check alert message on Shipment Inbound Scanning page using data below:
      | alert | Last Scanned {KEY_CREATED_SHIPMENT_ID} |
    And Operator verifies that the following messages display on the card after inbounding
      | scanState         | Destination Reached                         |
      | scanMessage       | Open Shipment                               |
      | scannedShipmentId | 1 Shipment ID(s)\n{KEY_CREATED_SHIPMENT_ID} |
    And Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator click Parcels Yet to scan area on Van Inbound Page
    Then Operator verifies the following details in the modal
      | ModalName   | <ModalName>                     |
      | Tracking ID | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator closes the dialog
    And Operator fill the tracking ID on Van Inbound Page then click enter
    And Operator verifies the route is started on clicking route start button
    And Operator closes the dialog
    And Operator click Parcels Yet to scan area on Van Inbound Page
    Then Operator verifies Parcel is not available in the modal

    Examples:
      | OrigHubId  | OrigHubName  | DestHubId  | DestHubName  | Country | ModalName         | Comments  |
      | {hub-id-8} | {hub-name-8} | {hub-id-9} | {hub-name-9} | sg      | Unscanned Parcels | GENERATED |

  @ForceSuccessOrder @ArchiveRoute @MediumPriority
  Scenario Outline: Unable to Van Inbound Parcels in Incomplete Latest Shipment
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <OrigHubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
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
    When API Operator closes the shipment using created shipper id
    And API Operator performs van inbound by updating shipment status using data below:
      | scanValue  | {KEY_CREATED_SHIPMENT_ID} |
      | hubCountry | <Country>                 |
      | hubId      | <OrigHubId>               |
    And Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator fill the tracking ID on Van Inbound Page then click enter
    And Operator verifies unable to Van Inbound message is displayed
    And Operator closes the modal
    And Operator click Parcels Yet to scan area on Van Inbound Page
    Then Operator verifies the following details in the modal
      | ModalName      | <ModalName>                     |
      | Tracking ID    | {KEY_CREATED_ORDER_TRACKING_ID} |
      | WarningMessage | Please hub inbound shipment!    |

    Examples:
      | OrigHubId  | OrigHubName  | DestHubId  | Country | ModalName         | Comments  |
      | {hub-id-8} | {hub-name-8} | {hub-id-9} | sg      | Unscanned Parcels | GENERATED |

  @ArchiveRoute @HighPriority
  Scenario Outline: Van Inbound Parcels in Completed Shipment (uid:6fba8e5f-55b7-4402-925d-ca00660a8746)
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <OrigHubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
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

  @ArchiveRoute @MediumPriority
  Scenario Outline: Van Inbound Parcels in Cancelled Shipment (uid:9973ea31-d21f-4787-9a19-b800d97f4355)
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <OrigHubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
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
    And Operator go to menu Inter-Hub -> Shipment Management
    When API Operator cancels the shipment using below data:
      | shipmentId | KEY_CREATED_SHIPMENT_ID |
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

  @ArchiveRoute @HighPriority
  Scenario Outline: Van Inbound Parcels Not in Any Shipment (uid:c9292f60-eb4a-485c-8004-3711b20f3a71)
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <OrigHubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
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

  @ForceSuccessOrder @ArchiveRoute
  Scenario Outline: View Parcel Yet to Scan Details
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <OrigHubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
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
    And Operator click Parcels Yet to scan area on Van Inbound Page
    Then Operator verifies the following details in the modal
      | ModalName      | <ModalName>                     |
      | Tracking ID    | {KEY_CREATED_ORDER_TRACKING_ID} |
      | WarningMessage | Please hub inbound shipment!    |
    Then Operator verifies edit order page is displayed on clicking the view button

    Examples:
      | OrigHubId  | OrigHubName  | DestHubId  | Country | ModalName         | Comments  |
      | {hub-id-8} | {hub-name-8} | {hub-id-9} | sg      | Unscanned Parcels | GENERATED |

  @ForceSuccessOrder @ArchiveRoute @HighPriority
  Scenario Outline: Unable Van Inbound Parcels Yet to Parcel Sweep
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
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
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<OrigHubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator fill the tracking ID on Van Inbound Page then click enter
    And Operator verifies unable to Van Inbound message is displayed
    And Operator closes the modal
    And Operator click Parcels Yet to scan area on Van Inbound Page
    Then Operator verifies the following details in the modal
      | ModalName      | <ModalName>                     |
      | Tracking ID    | {KEY_CREATED_ORDER_TRACKING_ID} |
      | WarningMessage | Please perform parcel sweep!    |

    Examples:
      | OrigHubId  | OrigHubName  | DestHubId  | Country | ModalName         | Comments  |
      | {hub-id-8} | {hub-name-8} | {hub-id-9} | sg      | Unscanned Parcels | GENERATED |

  @ForceSuccessOrder @ArchiveRoute @HighPriority
  Scenario Outline: Unable Van Inbound Parcels in Pending Shipment and Yet to Parcel Swept
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
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
    And Operator fill the tracking ID on Van Inbound Page then click enter
    And Operator verifies unable to Van Inbound message is displayed
    And Operator closes the modal
    And Operator click Parcels Yet to scan area on Van Inbound Page
    Then Operator verifies the following details in the modal
      | ModalName      | <ModalName>                                           |
      | Tracking ID    | {KEY_CREATED_ORDER_TRACKING_ID}                       |
      | WarningMessage | Please hub inbound shipment and perform parcel sweep! |

    Examples:
      | OrigHubId  | OrigHubName  | DestHubId  | Country | ModalName         | Comments  |
      | {hub-id-8} | {hub-name-8} | {hub-id-9} | sg      | Unscanned Parcels | GENERATED |

  @ForceSuccessOrder @ArchiveRoute @HighPriority
  Scenario Outline: Parcel Sweep Before Scan Parcel to Van Inbound
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<OrigHubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator fill the tracking ID on Van Inbound Page then click enter
    And Operator verifies unable to Van Inbound message is displayed
    And API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <OrigHubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    And Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator click Parcels Yet to scan area on Van Inbound Page
    Then Operator verifies the following details in the modal
      | ModalName   | <ModalName>                     |
      | Tracking ID | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator closes the dialog
    And Operator fill the tracking ID on Van Inbound Page then click enter
    And Operator verifies the route is started on clicking route start button
    And Operator closes the dialog
    And Operator click Parcels Yet to scan area on Van Inbound Page
    Then Operator verifies Parcel is not available in the modal

    Examples:
      | OrigHubId  | OrigHubName  | DestHubId  | Country | ModalName         | Comments  |
      | {hub-id-8} | {hub-name-8} | {hub-id-9} | sg      | Unscanned Parcels | GENERATED |

  @ForceSuccessOrder @ArchiveRoute @MediumPriority
  Scenario Outline: Unable to Van Inbound Parcels Due to Parcel Sweep at Wrong Hub
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Sort - Operator global inbound
      | globalInboundRequest | {"inbound_type":"SORTING_HUB","inbounded_by":null,"route_id":null,"dimensions":{"width":null,"height":null,"length":null,"weight":null,"size":null},"to_reschedule":false,"to_show_shipper_info":false,"tags":[],"hub_user":null,"device_id":null} |
      | trackingId           | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId}                                                                                                                                                                                                         |
      | hubId                | {hub-id-Global}                                                                                                                                                                                                                                    |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<CorrectHubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator sweep parcel in the hub
      | hubId | <WrongHubId>                    |
      | scan  | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator fill the tracking ID on Van Inbound Page then click enter
    And Operator verifies unable to Van Inbound message is displayed
    And Operator closes the modal
    And Operator click Parcels Yet to scan area on Van Inbound Page
    Then Operator verifies the following details in the modal
      | ModalName      | <ModalName>                     |
      | Tracking ID    | {KEY_CREATED_ORDER_TRACKING_ID} |
      | WarningMessage | Please perform parcel sweep!    |

    Examples:
      | CorrectHubId | CorrectHubName | WrongHubId | WrongHubName | Country | ModalName         | Comments  |
      | {hub-id-8}   | {hub-name-8}   | {hub-id-9} | {hub-name-9} | sg      | Unscanned Parcels | GENERATED |

  @ForceSuccessOrder @ArchiveRoute
  Scenario Outline: Unable to Van Inbound Parcels Due to Latest Parcel Sweep at Wrong Hub
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <CorrectHubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<CorrectHubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Sort - Operator parcel sweep
      | taskId             | 868538                                                                                       |
      | hubId              | <WrongHubId>                                                                                      |
      | parcelSweepRequest | {"scan":"{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}","to_return_dp_id":true,"hub_user":null} |
    And Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator fill the tracking ID on Van Inbound Page then click enter
    And Operator verifies unable to Van Inbound message is displayed
    And Operator closes the modal
    And Operator click Parcels Yet to scan area on Van Inbound Page
    Then Operator verifies the following details in the modal
      | ModalName      | <ModalName>                     |
      | Tracking ID    | {KEY_CREATED_ORDER_TRACKING_ID} |
      | WarningMessage | Please perform parcel sweep!    |

    Examples:
      | CorrectHubId | CorrectHubName | WrongHubId | WrongHubName | Country | ModalName         | Comments  |
      | {hub-id-8}   | {hub-name-8}   | {hub-id-9} | {hub-name-9} | sg      | Unscanned Parcels | GENERATED |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op