@OperatorV2 @OperatorV2Part2 @OrderCreationV2 @CWF @SIT
Feature: Order Creation V2

  @LaunchBrowser @ShouldAlwaysRun @ForceNotHeadless
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator download and verify Sample CSV file on Order Creation V2 page (uid:d378cebc-8a7a-4aae-b92d-d4559f56ebca)
    Given Operator go to menu Order -> Order Creation V2
    When Operator download Sample CSV file on Order Creation V2 page
    Then Operator verify Sample CSV file on Order Creation V2 page downloaded successfully

  Scenario: Operator uploading invalid CSV file on Order Creation V2 page (uid:5c564800-29e7-48c3-a88e-feaf585a06d0)
    Given Operator go to menu Order -> Order Creation V2
    When Operator uploading invalid CSV file on Order Creation V2 page
    Then Operator verify Order is not created by Creation V2 page

  Scenario Outline: Operator create order V2 on Order Creation V2 (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Order -> Order Creation V2
    When Operator create order V2 by uploading CSV on Order Creation V2 page using data below:
      | orderCreationV2Template | { "shipper_id":{shipper-v2-legacy-id}, "order_type":"<orderType>", "parcel_size":1, "weight":2, "length":3, "width":5, "height":7, "delivery_date":"{{cur_date}}", "delivery_timewindow_id":1, "max_delivery_days":3, "pickup_date":"{{cur_date}}", "pickup_timewindow_id":1 } |
    Then Operator verify order V2 is created successfully on Order Creation V2 page
    Examples:
      | Note   | hiptest-uid                              | orderType |
      | Normal | uid:e58a4c81-1b83-4115-bbee-584764277d30 | Normal    |
      | Return | uid:d3d37cf1-32e9-4e08-bc8c-b407e9e2930d | Return    |
#      | C2C    | uid:bed66e60-2242-4987-a487-7ff54f8a4d02 | C2C       |

#  Scenario Outline: Operator create order V3 on Order Creation V2 (<hiptest-uid>)
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Order -> Order Creation V2
#    When Operator create order V3 by uploading CSV on Order Creation V2 page using data below:
#      | orderCreationV2Template | { "shipper_id":{shipper-v3-id}, "order_type":"<orderType>", "parcel_size":1, "weight":2, "length":3, "width":5, "height":7, "delivery_date":"{{cur_date}}", "delivery_timewindow_id":1, "max_delivery_days":3, "pickup_date":"{{cur_date}}", "pickup_timewindow_id":1 } |
#    Then Operator verify order V3 is created successfully on Order Creation V2 page
#    Examples:
#      | Note   | hiptest-uid                              | orderType |
#      | Normal | uid:6f4b512a-1c04-4fea-8e86-d47a71bba437 | Normal    |
#      | C2C    | uid:6124eb8b-3af9-483b-9337-da8c0e11a8f8 | C2C       |
#      | Return | uid:a597ba95-4fa6-47d5-a5a0-62167696219b | Return    |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op