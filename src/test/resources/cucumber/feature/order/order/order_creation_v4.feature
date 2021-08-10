@OperatorV2 @Order @Orders @OrderCreationV4
Feature: Order Creation V4

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator download sample file of order creation V4 (uid:4d73b5f9-8483-4416-8f5d-609bc775ec18)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Order -> Order Creation V4
    When Operator download Sample File of OCV4 on Order Creation V4 page using data below:
      | shipperName               | {shipper-v4-name}                            |
      | orderType                 | Marketplace                                  |
      | additionalConfigurations  | Stamp Shipper, Pickup Required, Cash Enabled |
      | serviceLevel              | Same Day                                     |
      | deliveryDate              | 2018-12-11                                   |
      | deliveryTimeslot          | 9AM - 12PM                                   |
      #Preset selector below is an optional when we select "Cash Enabled" on additional configurations
      | cashAmount                | 100                                          |
      | cashCollectionTransaction | Pickup                                       |
      | cashCollectionType        | Send                                         |
      #Preset selector below is an optional when we select "Pickup Required" on additional configurations
      | pickupDate                | 2018-12-11                                   |
      | pickupType                | Scheduled                                    |
      | pickupLevel               | Standard                                     |
      | pickupTimeslot            | 9AM - 12PM                                   |
      | reservationVolume         | Half-Van Load                                |
    Then Operator verify Sample CSV file on Order Creation V4 page downloaded successfully
    And Operator verify the downloaded CSV file is contains the correct value by following parameters:
      | orderType                 | Marketplace   |
      | serviceLevel              | Sameday       |
      | deliveryDate              | 2018-12-11    |
      | cashAmount                | 100           |
      | cashCollectionTransaction | Pickup        |
      | cashCollectionType        | Send          |
      | pickupDate                | 2018-12-11    |
      | pickupType                | Scheduled     |
      | pickupLevel               | Standard      |
      | reservationVolume         | Half-Van Load |

  Scenario: Operator should be able to create order V4 on Order Creation V4 (uid:3d0324fa-af93-4316-bb6a-41c1c959712d)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Order -> Order Creation V4
    When Operator create order V4 by uploading XLSX on Order Creation V4 page using data below:
      | shipperId         | {shipper-v4-legacy-id}                                                                                                                                                                                                                                                                                                           |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Then Operator verify order V4 is created successfully on Order Creation V4 page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
