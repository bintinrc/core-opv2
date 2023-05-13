@Deprecated
Feature: Download AWB

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteShipper
  Scenario Outline: Operator Print Waybill to Show Details Based on Shipper Settings - Show Shipper Details - <Note>
    Given Operator go to menu Shipper -> All Shippers
    And Operator create new Shipper with basic settings using data below:
      | isShipperActive                  | true                  |
      | shipperType                      | Normal                |
      | ocVersion                        | v4                    |
      | services                         | STANDARD              |
      | trackingType                     | Fixed                 |
      | isAllowCod                       | false                 |
      | isAllowCashPickup                | true                  |
      | isPrepaid                        | true                  |
      | isAllowStagedOrders              | false                 |
      | isMultiParcelShipper             | false                 |
      | isDisableDriverAppReschedule     | false                 |
      | pricingScriptName                | {pricing-script-name} |
      | industryName                     | {industry-name}       |
      | salesPerson                      | {sales-person}        |
      | labelPrinting.showShipperDetails | true                  |
    And API Operator evict shipper's cache
    And API Operator fetch id of the created shipper
    Given API Shipper create V4 order for shipper legacy id "{KEY_CREATED_SHIPPER.legacyId}" using internal order create endpoint with data below:
      | generateFromAndTo | RANDOM           |
      | v4OrderRequest    | <v4OrderRequest> |
    When Operator go to menu Order -> All Orders
    When Operator find multiple orders by uploading CSV on All Orders page
    Then Operator verify all orders in CSV is found on All Orders page with correct info
    When Operator print Waybill for single order on All Orders page
    Then Operator verify waybill for single order on All Orders page:
      | trackingId  | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                      |
      | fromName    | {KEY_CREATED_ORDER.fromName}                               |
      | fromContact | {KEY_CREATED_ORDER.fromContact}                            |
      | fromAddress | {KEY_CREATED_ORDER.buildShortFromAddressWithCountryString} |
      | toName      | {KEY_CREATED_ORDER.toName}                                 |
      | toContact   | {KEY_CREATED_ORDER.toContact}                              |
      | toAddress   | {KEY_CREATED_ORDER.buildShortToAddressWithCountryString}   |
    Examples:
      | Note   | v4OrderRequest                                                                                                                                                                                                                                                                                                                  |
      | Normal | {"service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
      | Return | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |

  @DeleteShipper
  Scenario Outline: Operator Print Waybill to Show Details Based on Shipper Settings - Hide Shipper Details - <Note>
    Given Operator go to menu Shipper -> All Shippers
    And Operator create new Shipper with basic settings using data below:
      | isShipperActive                  | true                  |
      | shipperType                      | Normal                |
      | ocVersion                        | v4                    |
      | services                         | STANDARD              |
      | trackingType                     | Fixed                 |
      | isAllowCod                       | false                 |
      | isAllowCashPickup                | true                  |
      | isPrepaid                        | true                  |
      | isAllowStagedOrders              | false                 |
      | isMultiParcelShipper             | false                 |
      | isDisableDriverAppReschedule     | false                 |
      | pricingScriptName                | {pricing-script-name} |
      | industryName                     | {industry-name}       |
      | salesPerson                      | {sales-person}        |
      | labelPrinting.showShipperDetails | false                 |
    And API Operator evict shipper's cache
    And API Operator fetch id of the created shipper
    Given API Shipper create V4 order for shipper legacy id "{KEY_CREATED_SHIPPER.legacyId}" using internal order create endpoint with data below:
      | generateFromAndTo | RANDOM           |
      | v4OrderRequest    | <v4OrderRequest> |
    When Operator go to menu Order -> All Orders
    When Operator find multiple orders by uploading CSV on All Orders page
    Then Operator verify all orders in CSV is found on All Orders page with correct info
    When Operator print Waybill for single order on All Orders page
    Then Operator verify waybill for single order on All Orders page:
      | trackingId  | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]}                    |
      | fromName    | <fromName>                                               |
      | fromContact | null                                                     |
      | fromAddress | null                                                     |
      | toName      | {KEY_CREATED_ORDER.toName}                               |
      | toContact   | {KEY_CREATED_ORDER.toContact}                            |
      | toAddress   | {KEY_CREATED_ORDER.buildShortToAddressWithCountryString} |
    Examples:
      | Note   | fromName                     | v4OrderRequest                                                                                                                                                                                                                                                                                                                  |
      | Normal | {KEY_CREATED_SHIPPER.name}   | {"service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
      | Return | {KEY_CREATED_ORDER.fromName} | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |

  Scenario: Operator Print Waybill for Single Order on All Orders Page and Verify the Downloaded PDF Contains Correct Info (uid:4989c98b-9a7d-4f87-8bc3-d7b3692ce279)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery":12.3, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> All Orders
    When Operator find multiple orders by uploading CSV on All Orders page
    Then Operator verify all orders in CSV is found on All Orders page with correct info
    When Operator print Waybill for single order on All Orders page
    Then Operator verify the printed waybill for single order on All Orders page contains correct info

  Scenario: Operator Print Waybill for Multiple Orders on All Orders page - with unusual characters
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder  | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","from":{"name":"Elsa Customer","phone_number":"+6583014911","email":"elsa@ninja.com","address":{"address1":"233E ST. JOHN'S ROAD","address2":"é <br> проверка","postcode":"757995","city":"Singapore","country":"Singapore","latitude":1.45694483734937,"longitude":103.825580873988}},"to":{"name":"Elsa Sender","phone_number":"+6583014912","email":"elsaf@ninja.com","address":{"address1":"9 TUA KONG GREEN","address2":"é <br> проверка","country":"Singapore","postcode":"455384","city":"Singapore","latitude":1.3184395712682,"longitude":103.925311276846}},"parcel_job":{ "is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"},"delivery_instruction": "é <br> проверка"}} |
    When Operator go to menu Order -> All Orders
    When Operator find multiple orders by uploading CSV on All Orders page
    When Operator print Waybill for multiple orders on All Orders page
    Then Operator verify the printed waybill for multiple orders on All Orders page contains correct info

  Scenario: Operator Print Waybill for Multiple Orders on All Orders page - with TH, VN, MM chars
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder  | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","from":{"name":"Elsa Customer","phone_number":"+6583014911","email":"elsa@ninja.com","address":{"address1":"233E ST. JOHN'S ROAD","address2":"ă, âêô, ơư, đ WHEELOCK PLACE အမှတ်၂၃၆ ကအေးရိပ်မွန်၅လမ","postcode":"757995","city":"Singapore","country":"Singapore","latitude":1.45694483734937,"longitude":103.825580873988}},"to":{"name":"Elsa Sender","phone_number":"+6583014912","email":"elsaf@ninja.com","address":{"address1":"9 TUA KONG GREEN","address2":"ă, âêô, ơư, đ WHEELOCK PLACE အမှတ်၂၃၆ ကအေးရိပ်မွန်၅လမ","country":"Singapore","postcode":"455384","city":"Singapore","latitude":1.3184395712682,"longitude":103.925311276846}},"parcel_job":{ "is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"},"delivery_instruction": "ă, âêô, ơư, đ WHEELOCK PLACE အမှတ်၂၃၆ ကအေးရိပ်မွန်၅လမ"}} |
    When Operator go to menu Order -> All Orders
    When Operator find multiple orders by uploading CSV on All Orders page
    When Operator print Waybill for multiple orders on All Orders page
    Then Operator verify the printed waybill for multiple orders on All Orders page contains correct info

  Scenario: Operator Print the Airway Bill On Edit Order Page (uid:e017c4ea-2015-420d-a86e-a884ffbf89e0)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator print Airway Bill on Edit Order page
    Then Operator verify the printed Airway bill for single order on Edit Orders page contains correct info

  Scenario: Operator Print the Airway Bill On Edit Order Page - with unusual characters
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","from":{"name":"Elsa Customer","phone_number":"+6583014911","email":"elsa@ninja.com","address":{"address1":"233E ST. JOHN'S ROAD","address2":"é <br> проверка","postcode":"757995","city":"Singapore","country":"Singapore","latitude":1.45694483734937,"longitude":103.825580873988}},"to":{"name":"Elsa Sender","phone_number":"+6583014912","email":"elsaf@ninja.com","address":{"address1":"9 TUA KONG GREEN","address2":"é <br> проверка","country":"Singapore","postcode":"455384","city":"Singapore","latitude":1.3184395712682,"longitude":103.925311276846}},"parcel_job":{ "is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"},"delivery_instruction": "é <br> проверка"}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator print Airway Bill on Edit Order page
    Then Operator verify the printed Airway bill for single order on Edit Orders page contains correct info

  Scenario: Operator Print the Airway Bill On Edit Order Page - with TH, VN, MM chars
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","from":{"name":"Elsa Customer","phone_number":"+6583014911","email":"elsa@ninja.com","address":{"address1":"233E ST. JOHN'S ROAD","address2":"ă, âêô, ơư, đ WHEELOCK PLACE အမှတ်၂၃၆ ကအေးရိပ်မွန်၅လမ","postcode":"757995","city":"Singapore","country":"Singapore","latitude":1.45694483734937,"longitude":103.825580873988}},"to":{"name":"Elsa Sender","phone_number":"+6583014912","email":"elsaf@ninja.com","address":{"address1":"9 TUA KONG GREEN","address2":"ă, âêô, ơư, đ WHEELOCK PLACE အမှတ်၂၃၆ ကအေးရိပ်မွန်၅လမ","country":"Singapore","postcode":"455384","city":"Singapore","latitude":1.3184395712682,"longitude":103.925311276846}},"parcel_job":{ "is_pickup_required":false,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"},"delivery_instruction": "ă, âêô, ơư, đ WHEELOCK PLACE အမှတ်၂၃၆ ကအေးရိပ်မွန်၅လမ"}} |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator print Airway Bill on Edit Order page
    Then Operator verify the printed Airway bill for single order on Edit Orders page contains correct info


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op