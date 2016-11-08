@selenium
Feature: Pricing Scripts

  Scenario: op login into operator portal
    Given op is in op portal login page
    When login button is clicked
    When login as "{operator-portal-uid}" with password "{operator-portal-pwd}"
    Then op is in main page

  Scenario: Operator create, update and delete script on Pricing Scripts menu. (uid:0c1175e7-b5af-474c-b0a8-3b89ea786a59)
    Given op click navigation Pricing Scripts in Shipper
    When op create new script on Pricing Scripts
    Then new script on Pricing Scripts created successfully
    When op update script on Pricing Scripts
    Then script on Pricing Scripts updated successfully
    When op delete script on Pricing Scripts
    Then script on Pricing Scripts deleted successfully

  Scenario Outline: Operator do Run Test at selected Pricing Scripts. (<hiptest-uid>)
    Given op click navigation Pricing Scripts in Shipper
    Given op have two default script "Script Cucumber Test 1" and "Script Cucumber Test 2"
    When op click Run Test on Operator V2 Portal using this Script Check below:
      | deliveryType | <deliveryType> |
      | orderType    | <orderType>    |
      | timeslotType | <timeslotType> |
      | size         | <size>         |
      | weight       | 2              |
      | insuredValue | <insurance>    |
      | codValue     | <cod>          |
    Then op will find the price result:
      | deliveryFee  | S$<deliveryFee> |
      | codFee       | S$<cod>         |
      | insuranceFee | S$<insurance>   |
      | gst          | S$7             |
      | handlingFee  | S$11            |
      | total        | S$<total>       |
      | comments     | OK              |
    Examples:
      | Note                               | hiptest-uid                              | orderType | deliveryType | timeslotType | size | total | deliveryFee | insurance | cod |
      | NORMAL - STANDARD - NONE - S       | uid:317ae297-3148-4c7a-8a5f-493bd0414fa5 | NORMAL    | STANDARD     | NONE         | S    | 35.8  | 9.8         | 3         | 5   |
      | NORMAL - NEXT_DAY - DAY_NIGHT - XL | uid:7c32f2be-7af3-4aba-a569-58ba34e6b599 | NORMAL    | NEXT_DAY     | DAY_NIGHT    | XL   | 37.8  | 11.8        | 3         | 5   |
      | C2C - EXPRESS - DAY_NIGHT - M      | uid:debec413-5470-41fc-bcf3-e8b5a8dd8148 | C2C       | EXPRESS      | DAY_NIGHT    | M    | 37.6  | 11.6        | 3         | 5   |
      | C2C - SAME_DAY - NONE - XL         | uid:a6f888dd-33ff-46fe-b49e-d9f1e1e81eeb | C2C       | SAME_DAY     | NONE         | XL   | 38.2  | 12.2        | 3         | 5   |
      | RETURN - NEXT_DAY - TIMESLOT - L   | uid:0aee7e86-0a1a-4065-b08a-9c466b65c8be | RETURN    | NEXT_DAY     | TIMESLOT     | L    | 38    | 12          | 3         | 5   |
      | RETURN - STANDARD - TIMESLOT - M   | uid:23cd797e-1225-4a56-857f-3a54df98e804 | RETURN    | STANDARD     | TIMESLOT     | M    | 37.4  | 11.4        | 3         | 5   |

  Scenario: Operator linking a Pricing Scripts to a Shipper. (uid:0800ac82-a359-4d5f-a666-12b6d3877540)
    Given op click navigation Pricing Scripts in Shipper
    Given op have two default script "Script Cucumber Test 1" and "Script Cucumber Test 2"
    When op linking Pricing Scripts "Script Cucumber Test 1" or "Script Cucumber Test 2" to shipper "Pricing Script Link Shipper"
    Then Pricing Scripts linked to the shipper successfully

  @closeBrowser
  Scenario: close browser