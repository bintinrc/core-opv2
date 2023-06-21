@OperatorV2 @Core @Routing @RoutingJob4 @CreateRouteGroups @TransactionFiltersPart3 @CRG7
Feature: Create Route Groups - Transaction Filters

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario Outline: Operator Filter Transaction Timeslot on Create Route Groups - Transaction Filters - Timeslot = <timeslots>
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
      | timeslots | startTime | endTime |
      | 12-3pm    | 12:00     | 15:00   |
      | 3-6pm     | 15:00     | 18:00   |
      | 6-10pm    | 18:00     | 22:00   |
      | 9-12pm    | 09:00     | 12:00   |
      | Anytime   | 09:00     | 22:00   |
      | Day       | 09:00     | 18:00   |

  Scenario Outline: Operator Filter Parcel Size on Create Route Groups - Transaction Filters - Parcel Size = <parcelSize>
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
      | parcelSize  | size |
      | Bulky (XXL) | XXL  |
      | Extra Large | XL   |
      | Large       | L    |
      | Medium      | M    |
      | Small       | S    |
      | Extra Small | XS   |

  Scenario Outline: Operator Filter Order by Service Type on Create Route Groups Page - Transaction Filters - Corporate
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
      | serviceType |
      | Corporate   |

  Scenario Outline: Operator Filter Order by Service Type on Create Route Groups Page - Transaction Filters - Corporate Return
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
      | serviceType      |
      | Corporate Return |

  Scenario Outline: Operator Filter Order by Service Type on Create Route Groups Page - Transaction Filters - Corporate Document
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
      | serviceType        |
      | Corporate Document |

  Scenario: Operator Filter Order by Service Type on Create Route Groups Page - Transaction Filters - Corporate AWB
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
