@OperatorV2Deprecated @OperatorV2Part2Deprecated
Feature: Pricing Scripts

  @LaunchBrowser @EnableProxy @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator create, update and delete script on Pricing Scripts menu. (uid:0c1175e7-b5af-474c-b0a8-3b89ea786a59)
    Given Operator go to menu Shipper -> Pricing Scripts
    When Operator create new script on Pricing Scripts page
    Then Operator verify the new script on Pricing Scripts is created successfully
    When Operator update script on Pricing Scripts page
    Then Operator verify the script on Pricing Scripts page is updated successfully
    When Operator delete script on Pricing Scripts page
    Then Operator verify the script on Pricing Scripts page is deleted successfully

  Scenario Outline: Operator do Run Test at selected Pricing Scripts. (<hiptest-uid>)
    Given Operator refresh page
    Given Operator go to menu Shipper -> Pricing Scripts
    Given Operator have two default script "Script Cucumber Test 1" and "Script Cucumber Test 2"
    When Operator click Run Test on Operator V2 Portal using this Script Check below:
      | deliveryType | <deliveryType> |
      | orderType    | <orderType>    |
      | timeslotType | <timeslotType> |
      | size         | <size>         |
      | weight       | 2              |
      | insuredValue | <insurance>    |
      | codValue     | <cod>          |
    Then Operator will find the price result:
      | deliveryFee  | SGD <deliveryFee> |
      | codFee       | SGD <cod>         |
      | insuranceFee | SGD <insurance>   |
      | gst          | SGD 7             |
      | handlingFee  | SGD 11            |
      | total        | SGD <total>       |
      | comments     | OK              |
    Examples:
      | Note                               | hiptest-uid                              | orderType | deliveryType | timeslotType | size | total  | deliveryFee | insurance | cod |
      | NORMAL - STANDARD - NONE - S       | uid:317ae297-3148-4c7a-8a5f-493bd0414fa5 | NORMAL    | STANDARD     | NONE         | S    | 22.256 | 9.8         | 0         | 0   |
      | NORMAL - NEXT_DAY - DAY_NIGHT - XL | uid:7c32f2be-7af3-4aba-a569-58ba34e6b599 | NORMAL    | NEXT_DAY     | DAY_NIGHT    | XL   | 24.396 | 11.8        | 0         | 0   |
      | C2C - EXPRESS - DAY_NIGHT - M      | uid:debec413-5470-41fc-bcf3-e8b5a8dd8148 | C2C       | EXPRESS      | DAY_NIGHT    | M    | 24.182 | 11.6        | 0         | 0   |
      | C2C - SAME_DAY - NONE - XL         | uid:a6f888dd-33ff-46fe-b49e-d9f1e1e81eeb | C2C       | SAME_DAY     | NONE         | XL   | 24.824 | 12.2        | 0         | 0   |
      | RETURN - NEXT_DAY - TIMESLOT - L   | uid:0aee7e86-0a1a-4065-b08a-9c466b65c8be | RETURN    | NEXT_DAY     | TIMESLOT     | L    | 24.61  | 12          | 0         | 0   |
      | RETURN - STANDARD - TIMESLOT - M   | uid:23cd797e-1225-4a56-857f-3a54df98e804 | RETURN    | STANDARD     | TIMESLOT     | M    | 23.968 | 11.4        | 0         | 0   |

  Scenario: Operator linking a Pricing Scripts to a Shipper. (uid:0800ac82-a359-4d5f-a666-12b6d3877540)
    Given Operator refresh page
    Given Operator go to menu Shipper -> Pricing Scripts
    Given Operator have two default script "Script Cucumber Test 1" and "Script Cucumber Test 2"
    When Operator linking Pricing Scripts "Script Cucumber Test 1" or "Script Cucumber Test 2" to shipper "Pricing Script Link Shipper"
    Then Operator verify the script is linked to the shipper successfully

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
