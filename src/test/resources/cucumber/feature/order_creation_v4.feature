@OperatorV2 @OrderCreationV4
Feature: Order Creation V4

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator should be able to create order V4 on Order Creation V4 (uid:31da6c5d-6f2d-4782-a7be-0a27c171014b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Order -> Order Creation V4
    When Operator create order V4 by uploading XLSX on Order Creation V4 page using data below:
      | shipper_id    | 20106                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderParams | {"service_type":"Parcel","service_level":"Standard","requested_tracking_number":"{{shipper-order-ref-no}}","reference":{"merchant_order_number":"ship-{{shipper-order-ref-no}}"},"from":{"name":"[TEST] Han Solo Exports","phone_number":"91234567","email":"jane.doe@gmail.com","address":{"address1":"30 Jalan Kilang Barat","address2":"Ninja Van HQ","country":"SG","postcode":"159363"}},"to":{"name":"[TEST] James T Kirk","phone_number":"98765432","email":"james.t.kirik@gmail.com","address":{"address1":"998 Toa Payoh North","address2":"#01-10","country":"SG","postcode":"318993"}},"parcel_job":{"is_pickup_required":false,"pickup_instruction":"Pickup with care!","delivery_start_date":"{{tmp-pickup-date}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00","timezone":"Asia/Singapore"},"delivery_instruction":"If recipient is not around, leave parcel in power riser.","dimensions":{"weight":1.0,"size":"L"}}} |
    Then Operator verify order V4 is created successfully on Order Creation V4 page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
