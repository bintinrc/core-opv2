@StationManagement @StationCODReport
Feature: Number of Parcels In Hub

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @Case-1
  Scenario Outline: Case-1
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery": <CODAmount>, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions":{ "size":"S", "weight":"1.0" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | {hub-name-1}                    |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator fill the tracking ID on Van Inbound Page then click enter
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order scan updated
    And Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator click on start route after van inbounding
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order page
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Order Settings -> Manually Complete Order on Edit Order page
    And completes COD order manually by updating reason for change as "<ChangeReason>"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator go to menu Station Management Tool -> Station COD Report
    And chooses start and end date on transaction end date using the following data:
      | transactionEndDateFrom | {gradle-previous-1-day-dd/MM/yyyy} |
      | transactionEndDateTo   | {gradle-current-date-dd/MM/yyyy}   |
    And searches for station cod report by applying following filters:
      | Hubs      | Transaction Status |
      | <HubName> | <TransStatus>      |
    And searches for the details in result grid using the following search criteria:
      | Tracking ID/ Reservation ID | {KEY_CREATED_ORDER_TRACKING_ID} |
    And gets the order details from details tab of station cod report
    And verifies that the following details are displayed in details tab:
      | Route ID                    | {KEY_CREATED_ROUTE_ID}          |
      | Tracking ID/ Reservation ID | {KEY_CREATED_ORDER_TRACKING_ID} |
      | Hub                         | <HubName>                       |
      | Route Date      | {gradle-current-date-yyyy-MM-dd} |
      | Transaction Status          | <TransactionStatus>             |
      | Granular Status             | <GranularStatus>                |
      | Collected At                | <CollectedAt>                   |
      | COD Amount                  | <CODAmount>                     |
      | Shipper Name                | {shipper-v4-name}               |
      | Driver Name                 | {ninja-driver-name}             |
      | Driver ID                   | {ninja-driver-id}               |
    And verifies that the COD amount: "<CODAmount>" is separated by comma for thousands and by dot for decimals
    And reloads operator portal to reset the test state

    Examples:
      | HubId      | HubName      | CODAmount | ChangeReason | TransactionStatus | GranularStatus | TransStatus   | CollectedAt |
      | {hub-id-1} | {hub-name-1} | 1500.5    | GENERATED    | Success           | Completed      | DD - Delivery | Delivery    |


  @Case-1
  Scenario Outline: Case-1
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery": <CODAmount>, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions":{ "size":"S", "weight":"1.0" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | {hub-name-1}                    |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator fill the tracking ID on Van Inbound Page then click enter
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order scan updated
    And Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator click on start route after van inbounding
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order page
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Order Settings -> Manually Complete Order on Edit Order page
    And completes COD order manually by updating reason for change as "<ChangeReason>"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator go to menu Station Management Tool -> Station COD Report
    And chooses start and end date on transaction end date using the following data:
      | transactionEndDateFrom | {gradle-previous-1-day-dd/MM/yyyy} |
      | transactionEndDateTo   | {gradle-current-date-dd/MM/yyyy}   |
    And searches for station cod report by applying following filters:
      | Hubs      | Transaction Status |
      | <HubName> | <TransStatus>      |
    And navigates to summary tab in the result grid
    And searches for the details in result grid using the following search criteria:
      | Driver Name | {ninja-driver-name} |
      | Hub         | <HubName>           |
    And gets the order details from summary tab of station cod report
    And verifies that the following details are displayed in summary tab:
      | Driver Name | {ninja-driver-name}    |
      | Hub         | <HubName>              |
      | Route ID    | {KEY_CREATED_ROUTE_ID} |
      | COD Amount  | <CODAmount>            |
    And verifies that the following columns are displayed under cash collected table
      | Total Pickup      |
      | Total Delivery    |
      | Total Reservation |
      | Sum of Total      |
    And verifies that the COD amount: "<CODAmount>" is separated by comma for thousands and by dot for decimals
    And verifies that the COD collected amount is separated by comma for thousands and by dot for decimals
    And reloads operator portal to reset the test state

    Examples:
      | HubId      | HubName      | CODAmount | ChangeReason | TransStatus   |
      | {hub-id-1} | {hub-name-1} | 1500.5    | GENERATED    | DD - Delivery |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op