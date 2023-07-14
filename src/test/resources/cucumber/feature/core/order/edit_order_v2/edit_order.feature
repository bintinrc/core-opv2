@OperatorV2 @Core @EditOrderV2 @EditOrderPage
Feature: Edit Order Details

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @happy-path
  Scenario Outline: Operator Change Delivery Verification Method from Edit Order - <delivery_verification_mode> to <new_delivery_verification_mode>
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"allow_doorstep_dropoff":true,"enforce_delivery_verification":false,"delivery_verification_mode":"<delivery_verification_mode>","is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    And Operator set Delivery Verification Required to "<new_delivery_verification_mode>" on Edit Order V2 page
    Then Operator verifies that success react notification displayed:
      | top                | Delivery verification required updated successfully |
      | waitUntilInvisible | true                                                |
    Then Operator verifies order details on Edit Order V2 page:
      | deliveryVerificationType | <new_delivery_verification_mode> |
    And Operator verify order event on Edit Order V2 page using data below:
      | name | UPDATE DELIVERY VERIFICATION |
    And DB Core - verify orders record:
      | id                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                      |
      | shipperRefMetadata | ^.*"delivery_verification_mode":"<new_delivery_verification_mode_db>".* |
    And DB Core - verify order_delivery_verifications record:
      | orderId                  | {KEY_LIST_OF_CREATED_ORDERS[1].id}  |
      | deliveryVerificationMode | <new_delivery_verification_mode_db> |
    Examples:
      | delivery_verification_mode | new_delivery_verification_mode | new_delivery_verification_mode_db |
      | OTP                        | None                           | NONE                              |
      | NONE                       | OTP                            | OTP                               |
