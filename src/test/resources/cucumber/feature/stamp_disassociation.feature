@OperatorV2 @StampDisassociation
Feature: Stamp Disassociation

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator should not be able to disassociate order that has no stamp ID (uid:9c006a83-8b32-425c-b423-65ca78944277)
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                      |
      | v2OrderRequest    | { "type":"Return", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":0 } |
    And API Operator get order details
    When Operator go to menu New Features -> Stamp Disassociation
    And Operator enter Stamp ID of the created order on Stamp Disassociation page
    Then Operator verify the label says "stamp id not available" on Stamp Disassociation page
    And Operator verify order details on Stamp Disassociation page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
