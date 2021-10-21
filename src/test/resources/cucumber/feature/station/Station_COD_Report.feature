@StationManagement @StationCODReport
Feature: Station COD Report

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario Outline: Change the Language to English and Open Station COD Report (uid:fe2fa1b3-a69a-4751-a312-02ceb0ee3edc)
    Given Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <PageHeader>
    Then verifies that the following UI elements are displayed in station cod report page
      | Transaction End Date |
      | Hubs                 |
      | Transaction Type     |
      | Transaction Status   |
    And verifies that the following buttons are displayed in disabled state
      | Clear Selection |
      | Load Selection  |
    And chooses start and end date on transaction end date using the following data:
      | transactionEndDateFrom | {gradle-previous-2-day-dd/MM/yyyy} |
      | transactionEndDateTo   | {gradle-current-date-dd/MM/yyyy}   |
    And searches for station cod report by applying following filters:
      | Hubs      | Transaction Status |
      | <HubName> | <TransStatus>      |
    And verifies that tabs - Details and Summary are displayed after the search
    And verifies that the following columns are displayed under "Details" tab
      | Route ID                    |
      | Tracking ID/ Reservation ID |
      | Hub                         |
      | Route Date                  |
      | Transaction End Datetime    |
      | Transaction Status          |
      | Granular Status             |
      | Collected At                |
      | COD Amount                  |
      | Shipper Name                |
      | Driver Name                 |
      | Driver ID                   |
    And navigates to summary tab in the result grid
    And verifies that the following columns are displayed under "Summary" tab
      | Driver Name |
      | Hub         |
      | Route ID    |
      | COD Amount  |
    And reloads operator portal to reset the test state

    Examples:
      | Language | PageHeader         | HubName      | TransStatus   |
      | English  | Station COD Report | {hub-name-1} | DD - Delivery |

  Scenario Outline: Change the Language to Malay and Open Station COD Report (uid:acd850b6-7b12-452c-8bce-74ef61d1696f)
    Given Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <PageHeader>
    Then verifies that the following UI elements are displayed in station cod report page
      | Tarikh Akhir Transaksi |
      | Hab                    |
      | Jenis Transaksi        |
      | Status Transaksi       |
    And verifies that the following buttons are displayed in disabled state
      | Clear Selection |
      | Load Selection  |
    And chooses start and end date on transaction end date using the following data:
      | transactionEndDateFrom | {gradle-previous-2-day-dd/MM/yyyy} |
      | transactionEndDateTo   | {gradle-current-date-dd/MM/yyyy}   |
    And searches for station cod report by applying following filters:
      | Hab       | Status Transaksi |
      | <HubName> | <TransStatus>    |
    And verifies that tabs - Details and Summary are displayed after the search
    And verifies that the following columns are displayed under "Butiran" tab
      | ID Route                    |
      | ID Penjejakan / ID Tempahan |
      | Hab                         |
      | Tarikh Route                |
      | Waktu Akhir Transaksi       |
      | Status Transaksi            |
      | Status Butiran              |
      | Dipungut Di                 |
      | Jumlah COD                  |
      | Nama Pengirim               |
      | Nama Pemandu                |
      | ID Pemandu                  |
    And navigates to summary tab in the result grid
    And verifies that the following columns are displayed under "Ringkasan" tab
      | Nama Pemandu |
      | Hab          |
      | ID Route     |
      | Jumlah COD   |
    And reloads operator portal to reset the test state

    Examples:
      | Language | PageHeader         | HubName      | TransStatus       |
      | Malay    | Station COD Report | {hub-name-1} | DD - Penghantaran |

  Scenario Outline: Change the Language to Indonesia and Open Station COD Report (uid:e925c864-daa1-4a48-b9ba-878ea4f7aea3)
    Given Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <PageHeader>
    Then verifies that the following UI elements are displayed in station cod report page
      | Tanggal akhir transaksi |
      | Hub                     |
      | Tipe Transaksi          |
      | Status transaksi        |
    And verifies that the following buttons are displayed in disabled state
      | Hapus Pilihan |
      | Muat Pilihan  |
    And chooses start and end date on transaction end date using the following data:
      | transactionEndDateFrom | {gradle-previous-2-day-dd/MM/yyyy} |
      | transactionEndDateTo   | {gradle-current-date-dd/MM/yyyy}   |
    And searches for station cod report by applying following filters:
      | Hub       | Status transaksi |
      | <HubName> | <TransStatus>    |
    And verifies that tabs - Details and Summary are displayed after the search
    And verifies that the following columns are displayed under "Rincian" tab
      | Route ID                |
      | Tracking ID             |
      | Hub                     |
      | Tanggal Rute            |
      | Tanggal akhir transaksi |
      | Status transaksi        |
      | Status granular         |
      | Terkumpul pada          |
      | Jumlah COD              |
      | Nama Pengirim           |
      | Nama Driver             |
      | ID Driver               |
    And navigates to summary tab in the result grid
    And verifies that the following columns are displayed under "Ringkasan" tab
      | Nama Driver |
      | Hub         |
      | Route ID    |
      | Jumlah COD  |
    And reloads operator portal to reset the test state

    Examples:
      | Language   | PageHeader         | HubName      | TransStatus     |
      | Indonesian | Station COD Report | {hub-name-1} | DD - Pengiriman |

  Scenario Outline: Change the Language to Vietnam and Open Station COD Report (uid:a61275bc-d5d3-4e5c-ba05-58c1e8e28118)
    Given Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <PageHeader>
    Then verifies that the following UI elements are displayed in station cod report page
      | Ngày phát sinh giao dịch cuối cùng |
      | Trạm                               |
      | Loại trạng thái                    |
      | Trạng thái giao dịch               |
    And verifies that the following buttons are displayed in disabled state
      | Huỷ lựa chọn     |
      | Hiển thị dữ liệu |
    And chooses start and end date on transaction end date using the following data:
      | transactionEndDateFrom | {gradle-previous-2-day-dd/MM/yyyy} |
      | transactionEndDateTo   | {gradle-current-date-dd/MM/yyyy}   |
    And searches for station cod report by applying following filters:
      | Trạm      | Trạng thái giao dịch |
      | <HubName> | <TransStatus>        |
    And verifies that tabs - Details and Summary are displayed after the search
    And verifies that the following columns are displayed under "Chi tiết" tab
      | Mã lộ trình                    |
      | Mã đơn hàng / Mã điểm lấy hàng |
      | Trạm                           |
      | Ngày phát sinh lộ trình        |
      | Thời gian kết thúc giao dịch   |
      | Trạng thái giao dịch           |
      | Trạng thái chi tiết đơn hàng   |
      | Thu tại                        |
      | Số tiền COD                    |
      | Tên đối tác                    |
      | Tên tài xế                     |
      | Mã tài xế                      |
    And navigates to summary tab in the result grid
    And verifies that the following columns are displayed under "Tóm tắt" tab
      | Tên tài xế  |
      | Trạm        |
      | Mã lộ trình |
      | Số tiền COD |
    And reloads operator portal to reset the test state

    Examples:
      | Language | PageHeader         | HubName      | TransStatus |
      | Vietnam  | Station COD Report | {hub-name-1} | Giao hàng   |

  Scenario Outline: Change the Language to Thai and Open Station COD Report (uid:0630bc6a-9da2-4a3f-be6a-1d27069e3e7a)
    Given Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <PageHeader>
    Then verifies that the following UI elements are displayed in station cod report page
      | วันที่นำส่งพัสดุสำเร็จ |
      | ฮับ                    |
      | สถานะของ Transaction   |
      | ประเภทของ Transaction  |
    And verifies that the following buttons are displayed in disabled state
      | ล้างข้อมูลที่เลือก |
      | โหลดข้อมูลที่เลือก |
    And chooses start and end date on transaction end date using the following data:
      | transactionEndDateFrom | {gradle-previous-2-day-dd/MM/yyyy} |
      | transactionEndDateTo   | {gradle-current-date-dd/MM/yyyy}   |
    And searches for station cod report by applying following filters:
      | ฮับ       | สถานะของ Transaction |
      | <HubName> | <TransStatus>        |
    And verifies that tabs - Details and Summary are displayed after the search
    And verifies that the following columns are displayed under "รายละเอียด" tab
      | เลขประจำรูท                     |
      | Tracking ID หรือ Reservation ID |
      | ฮับ                             |
      | รูทวันที่                       |
      | วันและเวลาของ Transaction       |
      | สถานะของ Transaction            |
      | สถานะโดยละเอียด                 |
      | เก็บเมื่อ                       |
      | จำนวน COD                       |
      | ชื่อผู้ส่ง                      |
      | พนักงาน                         |
      | Driver ID                       |
    And navigates to summary tab in the result grid
    And verifies that the following columns are displayed under "สรุป" tab
      | พนักงาน     |
      | ฮับ         |
      | เลขประจำรูท |
      | จำนวน COD   |
    And reloads operator portal to reset the test state

    Examples:
      | Language | PageHeader         | HubName      | TransStatus   |
      | Thai     | Station COD Report | {hub-name-1} | DD - งานนำส่ง |

  Scenario Outline: Change the Language to Burmese and Open Station COD Report (uid:d1b77e0f-df8e-47c7-8b91-04eb13b8c4c2)
    Given Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <PageHeader>
    Then verifies that the following UI elements are displayed in station cod report page
      | လုပ်ဆောင်မှု ပြီးစီးသည့်ရက် |
      | ပင်မနေရာများ            |
      | လုပ်ဆောင်မှု အမျိုးအစား    |
      | လုပ်ဆောင်မှု အခြေအနေ     |
    And verifies that the following buttons are displayed in disabled state
      | Clear Selection |
      | Load Selection  |
    And chooses start and end date on transaction end date using the following data:
      | transactionEndDateFrom | {gradle-previous-2-day-dd/MM/yyyy} |
      | transactionEndDateTo   | {gradle-current-date-dd/MM/yyyy}   |
    And searches for station cod report by applying following filters:
      | ပင်မနေရာများ | လုပ်ဆောင်မှု အခြေအနေ |
      | <HubName>    | <TransStatus>        |
    And verifies that tabs - Details and Summary are displayed after the search
    And verifies that the following columns are displayed under "အသေးစိတ်" tab
      | လမ်းကြောင်း ID                     |
      | ခြေရာခံ ID/ Reservation ID         |
      | ပင်မနေရာ                           |
      | Route ရက်စွဲ                       |
      | လုပ်ဆောင်မှု နောက်ဆုံးရက်စွဲအချိန် |
      | လုပ်ဆောင်မှု အခြေအနေ               |
      | နောက်ဆုံးအခြေအနေ                   |
      | မှာ သိမ်းဆည်းထားသည်                |
      | COD ပမာဏ                           |
      | Shipper အမည်                       |
      | Driver အမည်                        |
      | Driver ID                          |
    And navigates to summary tab in the result grid
    And verifies that the following columns are displayed under "สรุป" tab
      | Driver အမည်    |
      | ပင်မနေရာ       |
      | လမ်းကြောင်း ID |
      | COD ပမာဏ       |
    And reloads operator portal to reset the test state

    Examples:
      | Language | PageHeader         | HubName      | TransStatus                |
      | Burmese  | Station COD Report | {hub-name-1} | DD - ပစ္စည်းပို့ဆောင်ခြင်း |

  @default-sg
  Scenario Outline: [SG, MY, TH, PH] View COD Amount in Detail Tab (uid:5acdcfa0-f03b-4f8d-adc7-b4f4c0eff567)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery": <CODAmount>, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions":{ "size":"S", "weight":"1.0" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | {hub-name-1}                    |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator fill the tracking ID on Van Inbound Page then click enter
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order scan updated
    And Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator click on start route after van inbounding
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order page
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Order Settings -> Manually Complete Order on Edit Order page
    And completes COD order manually by updating reason for change as "<ChangeReason>"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator go to menu Station Management Tool -> Station COD Report
    And chooses start and end date on transaction end date using the following data:
      | transactionEndDateFrom | {gradle-previous-1-day-dd/MM/yyyy} |
      | transactionEndDateTo   | {gradle-current-date-dd/MM/yyyy}   |
    And searches for station cod report by applying following filters:
      | Hubs      | Transaction Status |
      | <HubName> | <TransStatus>      |
    And searches for the details in result grid using the following search criteria:
      | Tracking ID/ Reservation ID | {KEY_CREATED_ORDER_TRACKING_ID} |
    And gets the order details from details tab of station cod report
    And verifies that the following details are displayed in details tab:
      | Route ID                    | {KEY_CREATED_ROUTE_ID}          |
      | Tracking ID/ Reservation ID | {KEY_CREATED_ORDER_TRACKING_ID} |
      | Hub                         | <HubName>                       |
      | Route Date                  | {gradle-current-date-yyyy-MM-dd}|
      | Transaction Status          | <TransactionStatus>             |
      | Granular Status             | <GranularStatus>                |
      | Collected At                | <CollectedAt>                   |
      | COD Amount                  | <CODAmount>                     |
      | Shipper Name                | {shipper-v4-name}               |
      | Driver Name                 | {ninja-driver-name}             |
      | Driver ID                   | {ninja-driver-id}               |
    And verifies that the COD amount: "<CODAmount>" is separated by comma for thousands and by dot for decimals
    And reloads operator portal to reset the test state

    Examples:
      | HubId      | HubName      | CODAmount | ChangeReason | TransactionStatus | GranularStatus | TransStatus   | CollectedAt |
      | {hub-id-1} | {hub-name-1} | 1500.5    | GENERATED    | Success           | Completed      | DD - Delivery | Delivery    |

  @default-id
  Scenario Outline: [ID, VN] View COD Amount in Detail Tab (uid:f163c350-3f78-4a28-b16f-84c5bc7b33f4)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"STANDARD","from": {"name": "QA-STATION-TEST-FROM","phone_number": "+6281231422926","email": "senderV4@nvqa.co","address": {"address1": "Jl. Gedung Sate No.48","country": "ID","province": "Jawa Barat ","city": "Kota Bandung","postcode": "60272","latitude": -6.921837,"longitude": 107.636803}},"to": {"name": "QA-STATION-TEST-TO","phone_number": "+6281231422926","email": "recipientV4@nvqa.co","address": {"address1": "Jalan Tebet Timur, 12","country": "ID","province": "DKI Jakarta","kecamatan": "Jakarta Selatan","postcode": "11280","latitude": -6.240501,"longitude": 106.841408}},"parcel_job":{ "cash_on_delivery": <CODAmount>,"insured_value": 85000,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id-1}, "hubId":<HubId>, "vehicleId":{vehicle-id-1}, "driverId":{ninja-driver-id-1} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator fill the tracking ID on Van Inbound Page then click enter
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order scan updated
    And Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator click on start route after van inbounding
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order page
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Order Settings -> Manually Complete Order on Edit Order page
    And completes COD order manually by updating reason for change as "<ChangeReason>"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator go to menu Station Management Tool -> Station COD Report
    And chooses start and end date on transaction end date using the following data:
      | transactionEndDateFrom | {gradle-previous-1-day-dd/MM/yyyy} |
      | transactionEndDateTo   | {gradle-current-date-dd/MM/yyyy}   |
    And searches for station cod report by applying following filters:
      | Hubs      | Transaction Status |
      | <HubName> | <TransStatus>      |
    And searches for the details in result grid using the following search criteria:
      | Tracking ID/ Reservation ID | {KEY_CREATED_ORDER_TRACKING_ID} |
    And gets the order details from details tab of station cod report
    And verifies that the following details are displayed in details tab:
      | Route ID                    | {KEY_CREATED_ROUTE_ID}          |
      | Tracking ID/ Reservation ID | {KEY_CREATED_ORDER_TRACKING_ID} |
      | Hub                         | <HubName>                       |
      | Route Date                  | {gradle-current-date-yyyy-MM-dd} |
      | Transaction Status          | <TransactionStatus>             |
      | Granular Status             | <GranularStatus>                |
      | Collected At                | <CollectedAt>                   |
      | COD Amount                  | <CODAmount>                     |
      | Shipper Name                | {shipper-v4-name}               |
      | Driver Name                 | {ninja-driver-name-1}           |
      | Driver ID                   | {ninja-driver-id-1}             |
    And verifies that the COD amount: "<CODAmount>" is separated by dot for thousands and by comma for decimals
    And reloads operator portal to reset the test state

    Examples:
      | HubId      | HubName      | CODAmount | ChangeReason | TransactionStatus | GranularStatus | TransStatus   | CollectedAt |
      | {hub-id-1} | {hub-name-1} | 1500.5    | GENERATED    | Success           | Completed      | DD - Delivery | Delivery    |

  @default-sg
  Scenario Outline: [SG, MY, TH, PH] View COD Collected in Summary Tab (uid:bad20f02-1d6e-4014-a9fc-226b21a0b8cb)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery": <CODAmount>, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions":{ "size":"S", "weight":"1.0" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | {hub-name-1}                    |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator fill the tracking ID on Van Inbound Page then click enter
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order scan updated
    And Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator click on start route after van inbounding
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order page
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Order Settings -> Manually Complete Order on Edit Order page
    And completes COD order manually by updating reason for change as "<ChangeReason>"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator go to menu Station Management Tool -> Station COD Report
    And chooses start and end date on transaction end date using the following data:
      | transactionEndDateFrom | {gradle-previous-1-day-dd/MM/yyyy} |
      | transactionEndDateTo   | {gradle-current-date-dd/MM/yyyy}   |
    And searches for station cod report by applying following filters:
      | Hubs      | Transaction Status |
      | <HubName> | <TransStatus>      |
    And navigates to summary tab in the result grid
    And searches for the details in result grid using the following search criteria:
      | Driver Name | {ninja-driver-name} |
      | Hub         | <HubName>           |
    And gets the order details from summary tab of station cod report
    And verifies that the following details are displayed in summary tab:
      | Driver Name | {ninja-driver-name}    |
      | Hub         | <HubName>              |
      | Route ID    | {KEY_CREATED_ROUTE_ID} |
      | COD Amount  | <CODAmount>            |
    And verifies that the following columns are displayed under cash collected table
      | Total Pickup      |
      | Total Delivery    |
      | Total Reservation |
      | Sum of Total      |
    And verifies that the COD amount: "<CODAmount>" is separated by comma for thousands and by dot for decimals
    And verifies that the COD collected amount is separated by comma for thousands and by dot for decimals
    And reloads operator portal to reset the test state

    Examples:
      | HubId      | HubName      | CODAmount | ChangeReason | TransStatus   |
      | {hub-id-1} | {hub-name-1} | 1500.5    | GENERATED    | DD - Delivery |

  @default-id
  Scenario Outline: [ID, VN] View COD Collected in Summary Tab (uid:623d8469-1bea-4fdd-a7d7-721683628256)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"STANDARD","from": {"name": "QA-STATION-TEST-FROM","phone_number": "+6281231422926","email": "senderV4@nvqa.co","address": {"address1": "Jl. Gedung Sate No.48","country": "ID","province": "Jawa Barat ","city": "Kota Bandung","postcode": "60272","latitude": -6.921837,"longitude": 107.636803}},"to": {"name": "QA-STATION-TEST-TO","phone_number": "+6281231422926","email": "recipientV4@nvqa.co","address": {"address1": "Jalan Tebet Timur, 12","country": "ID","province": "DKI Jakarta","kecamatan": "Jakarta Selatan","postcode": "11280","latitude": -6.240501,"longitude": 106.841408}},"parcel_job":{ "cash_on_delivery": <CODAmount>,"insured_value": 85000,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And Operator go to menu Inbounding -> Global Inbound
    And Operator global inbounds parcel using data below:
      | hubName    | <HubName>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id-1}, "hubId":<HubId>, "vehicleId":{vehicle-id-1}, "driverId":{ninja-driver-id-1} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator fill the tracking ID on Van Inbound Page then click enter
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order scan updated
    And Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator click on start route after van inbounding
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order page
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Order Settings -> Manually Complete Order on Edit Order page
    And completes COD order manually by updating reason for change as "<ChangeReason>"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator go to menu Station Management Tool -> Station COD Report
    And chooses start and end date on transaction end date using the following data:
      | transactionEndDateFrom | {gradle-previous-1-day-dd/MM/yyyy} |
      | transactionEndDateTo   | {gradle-current-date-dd/MM/yyyy}   |
    And searches for station cod report by applying following filters:
      | Hubs      | Transaction Status |
      | <HubName> | <TransStatus>      |
    And navigates to summary tab in the result grid
    And searches for the details in result grid using the following search criteria:
      | Driver Name | {ninja-driver-name-1} |
      | Hub         | <HubName>           |
    And gets the order details from summary tab of station cod report
    And verifies that the following details are displayed in summary tab:
      | Driver Name | {ninja-driver-name-1}    |
      | Hub         | <HubName>              |
      | Route ID    | {KEY_CREATED_ROUTE_ID} |
      | COD Amount  | <CODAmount>            |
    And verifies that the following columns are displayed under cash collected table
      | Total Pickup      |
      | Total Delivery    |
      | Total Reservation |
      | Sum of Total      |
    And verifies that the COD amount: "<CODAmount>" is separated by dot for thousands and by comma for decimals
    And verifies that the COD collected amount is separated by dot for thousands and by comma for decimals
    And reloads operator portal to reset the test state

    Examples:
      | HubId      | HubName      | CODAmount | ChangeReason | TransStatus   |
      | {hub-id-1} | {hub-name-1} | 1500.5    | GENERATED    | DD - Delivery |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op