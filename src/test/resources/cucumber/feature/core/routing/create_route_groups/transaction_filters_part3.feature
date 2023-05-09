@OperatorV2 @Core @Routing @RoutingJob4 @CreateRouteGroups @TransactionFiltersPart3 @CRG7
Feature: Create Route Groups - Transaction Filters

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario Outline: Operator Filter Transaction Timeslot on Create Route Groups - Transaction Filters - Timeslot = <timeslots> (<hiptest-uid>)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"<startTime>","end_time":"<endTime>"}}} |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | creationTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | creationTimeTo   | {gradle-next-1-day-yyyy-MM-dd} |
      | shipper          | {filter-shipper-name}          |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    Given Operator add following filters on Transactions Filters section on Create Route Groups page:
      | timeslots | <timeslots> |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction record on Create Route Groups page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                |
      | type       | DELIVERY Transaction                                     |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                  |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} |
    Examples:
      | timeslots | startTime | endTime | hiptest-uid                              |
      | 12-3pm    | 12:00     | 15:00   | uid:ebdfe3a8-108d-437d-80d8-4833ddf6ca70 |
      | 3-6pm     | 15:00     | 18:00   | uid:9de49540-44bb-4764-a560-fd4379ae001e |
      | 6-10pm    | 18:00     | 22:00   | uid:f5ec2f7e-18c4-47dd-96ed-e85ae16997a1 |
      | 9-12pm    | 09:00     | 12:00   | uid:b34c1af0-64b0-4747-81fb-9b784b167741 |
      | Anytime   | 09:00     | 22:00   | uid:5a23b593-47cb-4867-bd09-0eb8c6d9ed91 |
      | Day       | 09:00     | 18:00   | uid:a408168d-f299-4366-a703-3e179b996d63 |
      | Night     | 18:00     | 22:00   | uid:90816330-9865-4f8c-9e22-5530c56e9668 |

  Scenario Outline: Operator Filter Parcel Size on Create Route Groups - Transaction Filters - Parcel Size = <parcelSize> (<hiptest-uid>)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest    | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"dimensions":{"size":"<size>","volume":1.0,"weight":4.0},"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | creationTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | creationTimeTo   | {gradle-next-1-day-yyyy-MM-dd} |
      | shipper          | {filter-shipper-name}          |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    Given Operator add following filters on Transactions Filters section on Create Route Groups page:
      | parcelSize | <parcelSize> |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction record on Create Route Groups page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                  |
      | type       | PICKUP Transaction                                         |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                    |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressString} |
    Then Operator verifies Transaction record on Create Route Groups page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                |
      | type       | DELIVERY Transaction                                     |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                  |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} |
    Examples:
      | parcelSize  | size | hiptest-uid                              |
      | Bulky (XXL) | XXL  | uid:9a233818-0771-4c81-bbe4-0588cf30f7bc |
      | Extra Large | XL   | uid:2df4a63c-59d9-4885-805f-ec8d3c054c92 |
      | Large       | L    | uid:5cfd610b-b390-453c-8a62-ee4ae8856bc4 |
      | Medium      | M    | uid:f9a63c13-9da9-479c-9c7e-d089e64b9601 |
      | Small       | S    | uid:20988608-803f-4479-b50d-d928c4feefc8 |
      | Extra Small | XS   | uid:10a6796a-66e3-4801-a1d2-78684e848054 |

  Scenario Outline: Operator Filter Order by Service Type on Create Route Groups Page - Transaction Filters - Corporate (<hiptest-uid>)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper set Shipper V4 using data below:
      | legacyId | {shipper-v4-corporate-legacy-id} |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                                                                                              |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest    | { "service_type":"<serviceType>","corporate":{"branch_id":"{shipper-v4-corporate-subshipper-branch-id}"},"service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | creationTimeFrom | {gradle-next-0-day-yyyy-MM-dd}             |
      | creationTimeTo   | {gradle-next-1-day-yyyy-MM-dd}             |
      | shipper          | {filter-shipper-name-corporate-subshipper} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    And Operator add following filters on Transactions Filters section on Create Route Groups page:
      | orderServiceType | <serviceType> |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction records on Create Route Groups page using data below:
      | trackingId                                | type                 | shipper                                 | address                                                    | status         |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressString} | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString}   | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortFromAddressString} | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortToAddressString}   | Pending Pickup |
    Examples:
      | serviceType | hiptest-uid                              |
      | Corporate   | uid:e9550294-1f8b-4e43-a7ec-234239ab9d67 |

  Scenario Outline: Operator Filter Order by Service Type on Create Route Groups Page - Transaction Filters - Corporate Return (<hiptest-uid>)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper set Shipper V4 using data below:
      | legacyId | {shipper-v4-corporate-legacy-id} |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                                                                                              |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest    | { "service_type":"<serviceType>","corporate":{"branch_id":"{shipper-v4-corporate-subshipper-branch-id}"},"service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | creationTimeFrom | {gradle-next-0-day-yyyy-MM-dd}             |
      | creationTimeTo   | {gradle-next-1-day-yyyy-MM-dd}             |
      | Shipper          | {filter-shipper-name-corporate-subshipper} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    And Operator add following filters on Transactions Filters section on Create Route Groups page:
      | orderServiceType | <serviceType> |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction records on Create Route Groups page using data below:
      | trackingId                                | type                 | shipper                                 | address                                                    | status         |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressString} | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString}   | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortFromAddressString} | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortToAddressString}   | Pending Pickup |
    Examples:
      | serviceType      | hiptest-uid                              |
      | Corporate Return | uid:26f1fb1c-23d5-4126-8285-c325f0e7b838 |

  Scenario Outline: Operator Filter Order by Service Type on Create Route Groups Page - Transaction Filters - Corporate Document (<hiptest-uid>)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper set Shipper V4 using data below:
      | legacyId | {shipper-v4-corporate-legacy-id} |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                                                                                              |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest    | { "service_type":"<serviceType>","corporate":{"branch_id":"{shipper-v4-corporate-subshipper-branch-id}"},"service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | creationTimeFrom | {gradle-next-0-day-yyyy-MM-dd}             |
      | creationTimeTo   | {gradle-next-1-day-yyyy-MM-dd}             |
      | Shipper          | {filter-shipper-name-corporate-subshipper} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    And Operator add following filters on Transactions Filters section on Create Route Groups page:
      | orderServiceType | <serviceType> |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction records on Create Route Groups page using data below:
      | trackingId                                | type                 | shipper                                 | address                                                    | status         |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressString} | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString}   | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortFromAddressString} | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortToAddressString}   | Pending Pickup |
    Examples:
      | serviceType        | hiptest-uid                              |
      | Corporate Document | uid:8670e666-5a26-4450-aa4f-e00acd7472d5 |

  Scenario: Operator Filter Order by Service Type on Create Route Groups Page - Transaction Filters - Corporate AWB (uid:599a191b-43b6-45ca-896e-c91e159d8f4f)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator generate 2 Corporate AWB Tracking Id
    And API Shipper set Shipper V4 using data below:
      | legacyId | {shipper-v4-corporate-legacy-id} |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest    | {"service_type":"Corporate AWB","requested_tracking_number":"{KEY_CORPORATE_AWB_TRACKING_LIST[1].trackingId}","corporate":{"branch_id":"{shipper-v4-corporate-subshipper-branch-id}"},"service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest    | {"service_type":"Corporate AWB","requested_tracking_number":"{KEY_CORPORATE_AWB_TRACKING_LIST[2].trackingId}","corporate":{"branch_id":"{shipper-v4-corporate-subshipper-branch-id}"},"service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | creationTimeFrom | {gradle-next-0-day-yyyy-MM-dd}             |
      | creationTimeTo   | {gradle-next-1-day-yyyy-MM-dd}             |
      | Shipper          | {filter-shipper-name-corporate-subshipper} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    And Operator add following filters on Transactions Filters section on Create Route Groups page:
      | orderServiceType | Corporate AWB |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction records on Create Route Groups page using data below:
      | trackingId                                | type                 | shipper                                 | address                                                    | status         |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressString} | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString}   | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortFromAddressString} | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortToAddressString}   | Pending Pickup |

  Scenario: Operator Filter Order by Service Type on Create Route Groups Page - Transaction Filters - Marketplace Sort (uid:e49e7cbc-d702-43cf-bc49-05201f83b8e1)
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper set Shipper V4 using data below:
      | shipperV4ClientId     | {shipper-v4-marketplace-sort-client-id}     |
      | shipperV4ClientSecret | {shipper-v4-marketplace-sort-client-secret} |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest    | { "service_type":"Marketplace Sort","requested_tracking_number":"RBS{{6-random-digits}}","sort":{"to_3pl":"ROADBULL"},"marketplace":{"seller_id": "seller-ABC01","seller_company_name":"ABC Shop"},"service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | creationTimeFrom | {gradle-next-0-day-yyyy-MM-dd}         |
      | creationTimeTo   | {gradle-next-1-day-yyyy-MM-dd}         |
      | Shipper          | {filter-shipper-name-marketplace-sort} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    And Operator add following filters on Transactions Filters section on Create Route Groups page:
      | orderServiceType | Marketplace Sort |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction records on Create Route Groups page using data below:
      | trackingId                                | type                 | shipper                                 | address                                                    | status         |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressString} | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString}   | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortFromAddressString} | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortToAddressString}   | Pending Pickup |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op