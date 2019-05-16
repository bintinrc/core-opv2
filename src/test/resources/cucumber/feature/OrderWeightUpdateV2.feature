@OperatorV2 @OperatorV2Part2 @OrderWeightUpdateV2
Feature: Order Weight Update V2

  @LaunchBrowser @ShouldAlwaysRun @ForceNotHeadless
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario Outline: Operator create order V2 on Order Weight Update V2 (<hiptest-uid> )
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Order -> Order Creation V2
    When Operator create order V2 by uploading CSV on Order Weight Update V2 page using data below:
      | orderCreationV2Template | { "shipper_id":{shipper-v2-legacy-id}, "order_type":"Normal", "parcel_size":1, "weight":2, "length":3, "width":5, "height":7, "delivery_date":"{{cur_date}}", "delivery_timewindow_id":1, "max_delivery_days":3, "pickup_date":"{{cur_date}}", "pickup_timewindow_id":1 } |
    Then Operator verify order V2 is created successfully on Order Weight Update V2 page
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Special Pages -> Order Weight Update

    When Operator Order Weight update CSV Upload on Order Weight Update V2 page
    Then Operator Order Weight update on Order Weight Update V2 page
    Given Operator go to menu Order -> All Orders
    Then Operator Search Button For Orders on Order Weight Update V2 page
    Then Operator Verify Order Weight update Successfully on Order Weight Update V2 page
    Then Operator Edit Order on Order Weight Update V2 page
    Then Operator Verify Order Weight on Order Weight Update V2 page
    Examples:
      | Note   | hiptest-uid                              | orderType |
      | Normal | uid:e58a4c81-1b83-4115-bbee-584764277d30 | Normal    |

#  Scenario Outline: Operator create order V2 on Order Weight Update V2 (<hiptest-uid> )
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Order -> Order Creation V2
#  When Operator create order V2 by uploading CSV on Order Weight Update V2 page for multiple orders using data below:
#      | orderCreationV2Template_1 | { "shipper_id":{shipper-v2-legacy-id}, "order_type":"Normal", "parcel_size":1, "weight":2, "length":3, "width":5, "height":7, "delivery_date":"{{cur_date}}", "delivery_timewindow_id":1, "max_delivery_days":3, "pickup_date":"{{cur_date}}", "pickup_timewindow_id":1 } |
#      | orderCreationV2Template_2 | { "shipper_id":{shipper-v2-legacy-id}, "order_type":"Normal", "parcel_size":2, "weight":4, "length":2, "width":2, "height":2, "delivery_date":"{{cur_date}}", "delivery_timewindow_id":2, "max_delivery_days":3, "pickup_date":"{{cur_date}}", "pickup_timewindow_id":2 } |
#      | orderCreationV2Template_3 | { "shipper_id":{shipper-v2-legacy-id}, "order_type":"Normal", "parcel_size":1, "weight":3, "length":7, "width":5, "height":5, "delivery_date":"{{cur_date}}", "delivery_timewindow_id":3, "max_delivery_days":3, "pickup_date":"{{cur_date}}", "pickup_timewindow_id":3 } |
#
#
#    Then Operator verify order V2 is created successfully on Order Weight Update V2 page
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Special Pages -> Order Weight Update
#    When Operator Order Weight update CSV Upload on Order Weight Update V2 page
#    Then Operator Order Weight update on Order Weight Update V2 page
#    Examples:
#      | Note   | hiptest-uid                              | orderType |
#      | Normal | uid:e58a4c81-1b83-4115-bbee-584764277d30 | Normal    |



  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
