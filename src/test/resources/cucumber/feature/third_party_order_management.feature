@OperatorV2 @OperatorV2Part1 @ThirdPartyOrderManagement
Feature: Third Party Order Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator upload Single, edit and delete new Mapping on page Third Party Order Management (uid:29da63e4-d636-4c76-ae28-df53a3a7ff5c)
    Given Create an V4 order with the following attributes:
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","requested_tracking_number":"{{shipper-order-ref-no}}","reference":{"merchant_order_number":"ship-{{shipper-order-ref-no}}"},"from":{"name":"[TEST] Han Solo Exports","phone_number":"91234567","email":"jane.doe@gmail.com","address":{"address1":"30 Jalan Kilang Barat","address2":"Ninja Van HQ","country":"SG","postcode":"159363"}},"to":{"name":"[TEST] James T Kirk","phone_number":"98765432","email":"james.t.kirik@gmail.com","address":{"address1":"998 Toa Payoh North","address2":"#01-10","country":"SG","postcode":"318993"}},"parcel_job":{"is_pickup_required":false,"pickup_instruction":"Pickup with care!","delivery_start_date":"{{tmp-pickup-date}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Singapore"},"delivery_instruction":"If recipient is not around, leave parcel in power riser.","dimensions":{"weight":1.0,"size":"L"}}} |
    Given Operator go to menu Cross Border & 3PL -> Third Party Order Management
    When Operator uploads new mapping
    Then Operator verify the new mapping is created successfully
    When Operator edit the new mapping with a new data
    Then Operator verify the new edited data is updated successfully
    When Operator delete the new mapping
    Then Operator verify the new mapping is deleted successfully

  Scenario: Operator upload bulk new Mapping on page Third Party Order Management (uid:a61fc8df-f3e3-4f5b-a1f5-56aa33bad394)
    Given Create multiple V4 orders with the following attributes:
      | numberOfOrder  | 2 |
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","requested_tracking_number":"{{shipper-order-ref-no}}","reference":{"merchant_order_number":"ship-{{shipper-order-ref-no}}"},"from":{"name":"[TEST] Han Solo Exports","phone_number":"91234567","email":"jane.doe@gmail.com","address":{"address1":"30 Jalan Kilang Barat","address2":"Ninja Van HQ","country":"SG","postcode":"159363"}},"to":{"name":"[TEST] James T Kirk","phone_number":"98765432","email":"james.t.kirik@gmail.com","address":{"address1":"998 Toa Payoh North","address2":"#01-10","country":"SG","postcode":"318993"}},"parcel_job":{"is_pickup_required":false,"pickup_instruction":"Pickup with care!","delivery_start_date":"{{tmp-pickup-date}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Singapore"},"delivery_instruction":"If recipient is not around, leave parcel in power riser.","dimensions":{"weight":1.0,"size":"L"}}} |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Cross Border & 3PL -> Third Party Order Management
    When Operator uploads bulk mapping
    Then Operator verify multiple new mapping is created successfully

  Scenario: Operator upload Single new Mapping and complete the order on page Third Party Order Management (uid:f56de670-3197-4efe-8e39-e8cfb066794d)
    Given Create an V4 order with the following attributes:
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","requested_tracking_number":"{{shipper-order-ref-no}}","reference":{"merchant_order_number":"ship-{{shipper-order-ref-no}}"},"from":{"name":"[TEST] Han Solo Exports","phone_number":"91234567","email":"jane.doe@gmail.com","address":{"address1":"30 Jalan Kilang Barat","address2":"Ninja Van HQ","country":"SG","postcode":"159363"}},"to":{"name":"[TEST] James T Kirk","phone_number":"98765432","email":"james.t.kirik@gmail.com","address":{"address1":"998 Toa Payoh North","address2":"#01-10","country":"SG","postcode":"318993"}},"parcel_job":{"is_pickup_required":false,"pickup_instruction":"Pickup with care!","delivery_start_date":"{{tmp-pickup-date}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Singapore"},"delivery_instruction":"If recipient is not around, leave parcel in power riser.","dimensions":{"weight":1.0,"size":"L"}}} |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Cross Border & 3PL -> Third Party Order Management
    When Operator uploads new mapping
    Then Operator verify the new mapping is created successfully
    When Operator complete the new mapping order
    Then Operator verify the new mapping order is completed

  @KillBrowser
  Scenario: Kill Browser
    Given no-op
