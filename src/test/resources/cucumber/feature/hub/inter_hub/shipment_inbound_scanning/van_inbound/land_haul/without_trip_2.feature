@OperatorV2 @MiddleMile @Hub @InterHub @ShipmentInboundScanning @VanInbound @WithoutTrip2
Feature: Shipment Van Inbound Without Trip Scanning 2

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipment
  Scenario: Van Inbound Completed Shipment In Origin Hub (uid:5cca1cbe-9ae1-4959-bb28-e257a961ec8b)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When API Operator change the status of the shipment into "Completed"
    And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id     | {KEY_CREATED_SHIPMENT_ID} |
      | status | Completed                 |
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {hub-name-2} in Shipment Inbound Scanning page
    Then Click on Yes, continue on dialog box
    Then Operator verify scan text message "Still In transit" appears in Shipment Inbound Box

  @DeleteShipment
  Scenario: Van Inbound Completed Shipment Not In Origin Hub (uid:eab6d9b4-d433-41de-ae68-dfb2da3eb59e)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When API Operator change the status of the shipment into "Completed"
    And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id     | {KEY_CREATED_SHIPMENT_ID} |
      | status | Completed                 |
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {hub-name-2} in Shipment Inbound Scanning page
    Then Click on Yes, continue on dialog box
    Then Operator verify scan text message "Still In transit" appears in Shipment Inbound Box

  @DeleteShipment
  Scenario: Van Inbound Cancelled Shipment In Origin Hub
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When API Operator change the status of the shipment into "Cancelled"
    And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id     | {KEY_CREATED_SHIPMENT_ID} |
      | status | Cancelled                 |
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {hub-name-2} in Shipment Inbound Scanning page
    And Click on No, goback on dialog box for shipment "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verify small message "shipment {KEY_CREATED_SHIPMENT_ID} is in terminal state: [Cancelled]" appears in Shipment Inbound Box

  @DeleteShipment
  Scenario: Van Inbound Cancelled Shipment Not In Origin Hub (uid:a7c716a4-aa89-4af7-b9d0-8d9e37caf766)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When API Operator change the status of the shipment into "Cancelled"
    And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id     | {KEY_CREATED_SHIPMENT_ID} |
      | status | Cancelled                 |
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {hub-name-2} in Shipment Inbound Scanning page
    And Click on No, goback on dialog box for shipment "{KEY_CREATED_SHIPMENT_ID}"
    Then Operator verify small message "shipment {KEY_CREATED_SHIPMENT_ID} is in terminal state: [Cancelled]" appears in Shipment Inbound Box

  @HappyPath @DeleteShipment
  Scenario: Van Inbound Pending Shipment In Origin Hub (uid:12043574-7019-492d-a0f6-0b6147ad518b)
    Given Operator go to menu Utilities -> QRCode Printing
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {hub-name} on Shipment Inbound Scanning page
    And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_CREATED_SHIPMENT_ID} |
      | status      | Transit                   |
      | currHubName | {hub-name}                |

  @HappyPath @DeleteShipment
  Scenario: Van Inbound Pending Shipment Not In Origin Hub (uid:7f3b7d1b-ece1-4db1-96d3-f0b78e2a8e6f)
    Given Operator go to menu Utilities -> QRCode Printing
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {hub-name-2} in Shipment Inbound Scanning page
    Then Operator verify small message "shipment {KEY_CREATED_SHIPMENT_ID} is [Pending], but scanned at [{hub-name-2}], please inbound into van in the origin hub [{hub-name}]" appears in Shipment Inbound Box
    And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_CREATED_SHIPMENT_ID} |
      | status      | Pending                   |
      | currHubName | {hub-name-2}              |

  @DeleteShipment @ForceSuccessOrder
  Scenario: Van Inbound Closed Shipment In Origin Hub (uid:b1066eda-3133-457c-904e-f4fc1515582a)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given Operator go to menu Inter-Hub -> Add To Shipment
    When Operator scan the created order to shipment in hub {hub-name} to hub id = {hub-name-2}
    And Operator close the shipment which has been created
    And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_CREATED_SHIPMENT_ID} |
      | status      | Closed                    |
      | currHubName | {hub-name}                |
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {hub-name} on Shipment Inbound Scanning page
    And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_CREATED_SHIPMENT_ID} |
      | status      | Transit                   |
      | currHubName | {hub-name}                |

  @DeleteShipment @ForceSuccessOrder
  Scenario: Van Inbound Closed Shipment Not In Origin Hub (uid:ad08e9b7-6905-4c45-be60-03f9859d7f0a)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    Given Operator go to menu Inter-Hub -> Add To Shipment
    When Operator scan the created order to shipment in hub {hub-name} to hub id = {hub-name-2}
    And Operator close the shipment which has been created
    And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_CREATED_SHIPMENT_ID} |
      | status      | Closed                    |
      | currHubName | {hub-name}                |
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {hub-name-2} in Shipment Inbound Scanning page
    Then Operator verify small message "shipment {KEY_CREATED_SHIPMENT_ID} is [Closed], but scanned at [{hub-name-2}], please inbound into van in the origin hub [{hub-name}]" appears in Shipment Inbound Box
    And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_CREATED_SHIPMENT_ID} |
      | status      | Closed                    |
      | currHubName | {hub-name-2}              |

  @DeleteShipment
  Scenario: Van Inbound Wrong Shipment (uid:9596ed71-8be2-4343-b7ad-e35544e6b819)
    Given Operator go to menu Utilities -> QRCode Printing
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    And Operator inbound scanning wrong Shipment -1 Into Van in hub "{hub-name}" on Shipment Inbound Scanning page
    Then Operator verify small message "Shipment id -1 not found" appears in Shipment Inbound Box

  @DeleteShipment
  Scenario: Van Inbound Transit Shipment In Origin Hub (uid:43f4bacc-e862-4410-89b1-15be54463875)
    Given Operator go to menu Utilities -> QRCode Printing
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {hub-name} on Shipment Inbound Scanning page
    And Operator refresh page
    When Operator inbound scanning Shipment Into Van in hub {hub-name} on Shipment Inbound Scanning page
    Then Operator verify small message "Shipment id {KEY_CREATED_SHIPMENT_ID} cannot change status from Transit to Transit" appears in Shipment Inbound Box
    And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_CREATED_SHIPMENT_ID} |
      | origHubName | {hub-name}                |
      | currHubName | {hub-name}                |
      | destHubName | {hub-name-2}              |
      | status      | Transit                   |
    And Operator open the shipment detail for the shipment "{KEY_CREATED_SHIPMENT_ID}" on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page:
      | source | SHIPMENT_VAN_INBOUND(OpV2) |
      | result | Transit                    |
      | userId | qa@ninjavan.co             |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op