@StationManagement @StationCODReport
Feature: Station COD Report

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario Outline: Change the Language to Malay and Open Station COD Report (uid:acd850b6-7b12-452c-8bce-74ef61d1696f)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <PageHeader>
    Then Operator verifies that the following UI elements are displayed in station cod report page
      | Tarikh Akhir Transaksi |
      | Hab                    |
      | Jenis Transaksi        |
      | Status Transaksi       |
    And Operator verifies that the following buttons are displayed in disabled state
      | Clear Selection |
      | Load Selection  |
    And Operator chooses start and end date on transaction end date using the following data:
      | transactionEndDateFrom | {gradle-previous-2-day-dd/MM/yyyy} |
      | transactionEndDateTo   | {gradle-current-date-dd/MM/yyyy}   |
    And Operator searches for station cod report by applying following filters:
      | Hab       | Status Transaksi |
      | <HubName> | <TransStatus>    |
    And Operator verifies that tabs - Details and Summary are displayed after the search
    And Operator verifies that the following columns are displayed under "Butiran" tab
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
    And Operator navigates to summary tab in the result grid
    And Operator verifies that the following columns are displayed under "Ringkasan" tab
      | Nama Pemandu |
      | Hab          |
      | ID Route     |
      | Jumlah COD   |

    Examples:
      | Language | PageHeader         | HubName      | TransStatus       |
      | Malay    | Station COD Report | {hub-name-2} | DD - Penghantaran |

  Scenario Outline: Change the Language to Indonesia and Open Station COD Report (uid:e925c864-daa1-4a48-b9ba-878ea4f7aea3)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    And Operator selects language as "<Language>"
    When Operator go to menu Station Management Tool -> <PageHeader>
    Then Operator verifies that the following UI elements are displayed in station cod report page
      | Tanggal akhir transaksi |
      | Hub                     |
      | Tipe Transaksi          |
      | Status transaksi        |
    And Operator verifies that the following buttons are displayed in disabled state
      | Hapus Pilihan |
      | Muat Pilihan  |
    And Operator chooses start and end date on transaction end date using the following data:
      | transactionEndDateFrom | {gradle-previous-2-day-dd/MM/yyyy} |
      | transactionEndDateTo   | {gradle-current-date-dd/MM/yyyy}   |
    And Operator searches for station cod report by applying following filters:
      | Hub       | Status transaksi |
      | <HubName> | <TransStatus>    |
    And Operator verifies that tabs - Details and Summary are displayed after the search
    And Operator verifies that the following columns are displayed under "Rincian" tab
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
    And Operator navigates to summary tab in the result grid
    And Operator verifies that the following columns are displayed under "Ringkasan" tab
      | Nama Driver |
      | Hub         |
      | Route ID    |
      | Jumlah COD  |

    Examples:
      | Language   | PageHeader         | HubName      | TransStatus     |
      | Indonesian | Station COD Report | {hub-name-2} | DD - Pengiriman |

  Scenario Outline: Change the Language to Vietnam and Open Station COD Report (uid:a61275bc-d5d3-4e5c-ba05-58c1e8e28118)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    And Operator selects language as "<Language>"
    When Operator go to menu Station Management Tool -> <PageHeader>
    Then Operator verifies that the following UI elements are displayed in station cod report page
      | Ngày phát sinh giao dịch cuối cùng |
      | Trạm                               |
      | Loại trạng thái                    |
      | Trạng thái giao dịch               |
    And Operator verifies that the following buttons are displayed in disabled state
      | Huỷ lựa chọn     |
      | Hiển thị dữ liệu |
    And Operator chooses start and end date on transaction end date using the following data:
      | transactionEndDateFrom | {gradle-previous-2-day-dd/MM/yyyy} |
      | transactionEndDateTo   | {gradle-current-date-dd/MM/yyyy}   |
    And Operator searches for station cod report by applying following filters:
      | Trạm      | Trạng thái giao dịch |
      | <HubName> | <TransStatus>        |
    And Operator verifies that tabs - Details and Summary are displayed after the search
    And Operator verifies that the following columns are displayed under "Chi tiết" tab
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
    And Operator navigates to summary tab in the result grid
    And Operator verifies that the following columns are displayed under "Tóm tắt" tab
      | Tên tài xế  |
      | Trạm        |
      | Mã lộ trình |
      | Số tiền COD |

    Examples:
      | Language | PageHeader         | HubName      | TransStatus |
      | Vietnam  | Station COD Report | {hub-name-2} | Giao hàng   |

  Scenario Outline: Change the Language to Thai and Open Station COD Report (uid:0630bc6a-9da2-4a3f-be6a-1d27069e3e7a)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    And Operator selects language as "<Language>"
    When Operator go to menu Station Management Tool -> <PageHeader>
    Then Operator verifies that the following UI elements are displayed in station cod report page
      | วันที่นำส่งพัสดุสำเร็จ |
      | ฮับ                    |
      | สถานะของ Transaction   |
      | ประเภทของ Transaction  |
    And Operator verifies that the following buttons are displayed in disabled state
      | ล้างข้อมูลที่เลือก |
      | โหลดข้อมูลที่เลือก |
    And Operator chooses start and end date on transaction end date using the following data:
      | transactionEndDateFrom | {gradle-previous-2-day-dd/MM/yyyy} |
      | transactionEndDateTo   | {gradle-current-date-dd/MM/yyyy}   |
    And Operator searches for station cod report by applying following filters:
      | ฮับ       | สถานะของ Transaction |
      | <HubName> | <TransStatus>        |
    And Operator verifies that tabs - Details and Summary are displayed after the search
    And Operator verifies that the following columns are displayed under "รายละเอียด" tab
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
    And Operator navigates to summary tab in the result grid
    And Operator verifies that the following columns are displayed under "สรุป" tab
      | พนักงาน     |
      | ฮับ         |
      | เลขประจำรูท |
      | จำนวน COD   |

    Examples:
      | Language | PageHeader         | HubName      | TransStatus   |
      | Thai     | Station COD Report | {hub-name-2} | DD - งานนำส่ง |

  Scenario Outline: Change the Language to Burmese and Open Station COD Report (uid:d1b77e0f-df8e-47c7-8b91-04eb13b8c4c2)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <PageHeader>
    Then Operator verifies that the following UI elements are displayed in station cod report page
      | လုပ်ဆောင်မှု ပြီးစီးသည့်ရက် |
      | ပင်မနေရာများ                |
      | လုပ်ဆောင်မှု အမျိုးအစား     |
      | လုပ်ဆောင်မှု အခြေအနေ        |
    And Operator verifies that the following buttons are displayed in disabled state
      | Clear Selection |
      | Load Selection  |
    And Operator chooses start and end date on transaction end date using the following data:
      | transactionEndDateFrom | {gradle-previous-2-day-dd/MM/yyyy} |
      | transactionEndDateTo   | {gradle-current-date-dd/MM/yyyy}   |
    And Operator searches for station cod report by applying following filters:
      | ပင်မနေရာများ | လုပ်ဆောင်မှု အခြေအနေ |
      | <HubName>    | <TransStatus>        |
    And Operator verifies that tabs - Details and Summary are displayed after the search
    And Operator verifies that the following columns are displayed under "အသေးစိတ်" tab
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
    And Operator navigates to summary tab in the result grid
    And Operator verifies that the following columns are displayed under "สรุป" tab
      | Driver အမည်    |
      | ပင်မနေရာ       |
      | လမ်းကြောင်း ID |
      | COD ပမာဏ       |

    Examples:
      | Language | PageHeader         | HubName      | TransStatus                |
      | Burmese  | Station COD Report | {hub-name-2} | DD - ပစ္စည်းပို့ဆောင်ခြင်း |

  Scenario Outline: Change the Language to English and Open Station COD Report (uid:fe2fa1b3-a69a-4751-a312-02ceb0ee3edc)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    And Operator selects language as "<Language>"
    When Operator go to menu Station Management Tool -> <PageHeader>
    Then Operator verifies that the following UI elements are displayed in station cod report page
      | Transaction End Date |
      | Hubs                 |
      | Transaction Type     |
      | Transaction Status   |
    And Operator verifies that the following buttons are displayed in disabled state
      | Clear Selection |
      | Load Selection  |
    And Operator chooses start and end date on transaction end date using the following data:
      | transactionEndDateFrom | {gradle-previous-2-day-dd/MM/yyyy} |
      | transactionEndDateTo   | {gradle-current-date-dd/MM/yyyy}   |
    And Operator searches for station cod report by applying following filters:
      | Hubs      | Transaction Status |
      | <HubName> | <TransStatus>      |
    And Operator verifies that tabs - Details and Summary are displayed after the search
    And Operator verifies that the following columns are displayed under "Details" tab
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
    And Operator navigates to summary tab in the result grid
    And Operator verifies that the following columns are displayed under "Summary" tab
      | Driver Name |
      | Hub         |
      | Route ID    |
      | COD Amount  |

    Examples:
      | Language | PageHeader         | HubName      | TransStatus   |
      | English  | Station COD Report | {hub-name-2} | DD - Delivery |

  @Happypath @ArchiveRoute @default-sg
  Scenario Outline: [SG, MY, TH, PH] View COD Amount in Detail Tab (uid:5acdcfa0-f03b-4f8d-adc7-b4f4c0eff567)
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery": <CODAmount>, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions":{ "size":"S", "weight":"1.0" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":"{hub-id-Global}" } |
    And API Operator sweep parcel in the hub
      | hubId | <HubId>                         |
      | scan  | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator wait until order granular status changes to "On Vehicle for Delivery"
    And Operator click Order Settings -> Manually Complete Order on Edit Order page
    And Operator completes COD order manually by updating reason for change as "<ChangeReason>"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator go to menu Station Management Tool -> Station COD Report
    And Operator chooses start and end date on transaction end date using the following data:
      | transactionEndDateFrom | {gradle-previous-1-day-dd/MM/yyyy} |
      | transactionEndDateTo   | {gradle-current-date-dd/MM/yyyy}   |
    And Operator searches for station cod report by applying following filters:
      | Hubs      | Transaction Status |
      | <HubName> | <TransStatus>      |
    And Operator searches for the details in result grid using the following search criteria:
      | Tracking ID/ Reservation ID | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator gets the order details from details tab of station cod report
    And Operator verifies that the following details are displayed in details tab:
      | Route ID                    | {KEY_CREATED_ROUTE_ID}           |
      | Tracking ID/ Reservation ID | {KEY_CREATED_ORDER_TRACKING_ID}  |
      | Hub                         | <HubName>                        |
      | Route Date                  | {gradle-current-date-yyyy-MM-dd} |
      | Transaction Status          | <TransactionStatus>              |
      | Granular Status             | <GranularStatus>                 |
      | Collected At                | <CollectedAt>                    |
      | COD Amount                  | <CODAmount>                      |
      | Shipper Name                | {shipper-v4-name}                |
      | Driver Name                 | {ninja-driver-name}              |
      | Driver ID                   | {ninja-driver-id}                |
    And Operator verifies that the COD amount: "<CODAmount>" is separated by comma for thousands and by dot for decimals

    Examples:
      | HubId      | HubName      | CODAmount | ChangeReason | TransactionStatus | GranularStatus | TransStatus   | CollectedAt |
      | {hub-id-2} | {hub-name-2} | 1500.5    | GENERATED    | Success           | Completed      | DD - Delivery | Delivery    |

  @ArchiveRoute @default-id
  Scenario Outline: [ID, VN] View COD Amount in Detail Tab (uid:f163c350-3f78-4a28-b16f-84c5bc7b33f4)
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"STANDARD","from": {"name": "QA-STATION-TEST-FROM","phone_number": "+6281231422926","email": "senderV4@nvqa.co","address": {"address1": "Jl. Gedung Sate No.48","country": "ID","province": "Jawa Barat ","city": "Kota Bandung","postcode": "60272","latitude": -6.921837,"longitude": 107.636803}},"to": {"name": "QA-STATION-TEST-TO","phone_number": "+6281231422926","email": "recipientV4@nvqa.co","address": {"address1": "Jalan Tebet Timur, 12","country": "ID","province": "DKI Jakarta","kecamatan": "Jakarta Selatan","postcode": "11280","latitude": -6.240501,"longitude": 106.841408}},"parcel_job":{ "cash_on_delivery": <CODAmount>,"insured_value": 85000,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00","timezone": "Asia/Ho_Chi_Minh"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00","timezone": "Asia/Ho_Chi_Minh"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":"{hub-id-Global}" } |
    And API Operator sweep parcel in the hub
      | hubId | <HubId>                         |
      | scan  | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator fill the tracking ID on Van Inbound Page then click enter
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator click on start route after van inbounding
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator wait until order granular status changes to "On Vehicle for Delivery"
    And Operator click Order Settings -> Manually Complete Order on Edit Order page
    And Operator completes COD order manually by updating reason for change as "<ChangeReason>"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator go to menu Station Management Tool -> Station COD Report
    And Operator chooses start and end date on transaction end date using the following data:
      | transactionEndDateFrom | {gradle-previous-1-day-dd/MM/yyyy} |
      | transactionEndDateTo   | {gradle-current-date-dd/MM/yyyy}   |
    And Operator searches for station cod report by applying following filters:
      | Hubs      | Transaction Status |
      | <HubName> | <TransStatus>      |
    And Operator searches for the details in result grid using the following search criteria:
      | Tracking ID/ Reservation ID | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator gets the order details from details tab of station cod report
    And Operator verifies that the following details are displayed in details tab:
      | Route ID                    | {KEY_CREATED_ROUTE_ID}           |
      | Tracking ID/ Reservation ID | {KEY_CREATED_ORDER_TRACKING_ID}  |
      | Hub                         | <HubName>                        |
      | Route Date                  | {gradle-current-date-yyyy-MM-dd} |
      | Transaction Status          | <TransactionStatus>              |
      | Granular Status             | <GranularStatus>                 |
      | Collected At                | <CollectedAt>                    |
      | COD Amount                  | <CODAmount>                      |
      | Shipper Name                | {shipper-v4-name}                |
      | Driver Name                 | {ninja-driver-name}              |
      | Driver ID                   | {ninja-driver-id}                |
    And Operator verifies that the COD amount: "<CODAmount>" is separated by dot for thousands and by comma for decimals

    Examples:
      | HubId      | HubName      | CODAmount | ChangeReason | TransactionStatus | GranularStatus | TransStatus   | CollectedAt |
      | {hub-id-1} | {hub-name-1} | 1500.5    | GENERATED    | Success           | Completed      | DD - Delivery | Delivery    |

  @Happypath @ArchiveRoute @default-sg
  Scenario Outline: [SG, MY, TH, PH] View COD Collected in Summary Tab (uid:bad20f02-1d6e-4014-a9fc-226b21a0b8cb)
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery": <CODAmount>, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions":{ "size":"S", "weight":"1.0" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":"{hub-id-Global}" } |
    And API Operator sweep parcel in the hub
      | hubId | <HubId>                         |
      | scan  | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator wait until order granular status changes to "On Vehicle for Delivery"
    And Operator click Order Settings -> Manually Complete Order on Edit Order page
    And Operator completes COD order manually by updating reason for change as "<ChangeReason>"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator go to menu Station Management Tool -> Station COD Report
    And Operator chooses start and end date on transaction end date using the following data:
      | transactionEndDateFrom | {gradle-previous-1-day-dd/MM/yyyy} |
      | transactionEndDateTo   | {gradle-current-date-dd/MM/yyyy}   |
    And Operator searches for station cod report by applying following filters:
      | Hubs      | Transaction Status |
      | <HubName> | <TransStatus>      |
    And Operator navigates to summary tab in the result grid
    And Operator searches for the details in result grid using the following search criteria:
      | Driver Name | {ninja-driver-name} |
      | Hub         | <HubName>           |
    And Operator gets the order details from summary tab of station cod report
    And Operator verifies that the following details are displayed in summary tab:
      | Driver Name | {ninja-driver-name}    |
      | Hub         | <HubName>              |
      | Route ID    | {KEY_CREATED_ROUTE_ID} |
      | COD Amount  | <CODAmount>            |
    And Operator verifies that the following columns are displayed under cash collected table
      | Total Pickup      |
      | Total Delivery    |
      | Total Reservation |
      | Sum of Total      |
    And Operator verifies that the COD amount: "<CODAmount>" is separated by comma for thousands and by dot for decimals
    And Operator verifies that the COD collected amount is separated by comma for thousands and by dot for decimals

    Examples:
      | HubId      | HubName      | CODAmount | ChangeReason | TransStatus   |
      | {hub-id-2} | {hub-name-2} | 1500.5    | GENERATED    | DD - Delivery |

  @ArchiveRoute @default-id
  Scenario Outline: [ID, VN] View COD Collected in Summary Tab (uid:623d8469-1bea-4fdd-a7d7-721683628256)
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"STANDARD","from": {"name": "QA-STATION-TEST-FROM","phone_number": "+6281231422926","email": "senderV4@nvqa.co","address": {"address1": "Jl. Gedung Sate No.48","country": "ID","province": "Jawa Barat ","city": "Kota Bandung","postcode": "60272","latitude": -6.921837,"longitude": 107.636803}},"to": {"name": "QA-STATION-TEST-TO","phone_number": "+6281231422926","email": "recipientV4@nvqa.co","address": {"address1": "Jalan Tebet Timur, 12","country": "ID","province": "DKI Jakarta","kecamatan": "Jakarta Selatan","postcode": "11280","latitude": -6.240501,"longitude": 106.841408}},"parcel_job":{ "cash_on_delivery": <CODAmount>,"insured_value": 85000,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00","timezone": "Asia/Ho_Chi_Minh"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00","timezone": "Asia/Ho_Chi_Minh"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":"{hub-id-Global}" } |
    And API Operator sweep parcel in the hub
      | hubId | <HubId>                         |
      | scan  | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator fill the tracking ID on Van Inbound Page then click enter
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator click on start route after van inbounding
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator wait until order granular status changes to "On Vehicle for Delivery"
    And Operator click Order Settings -> Manually Complete Order on Edit Order page
    And Operator completes COD order manually by updating reason for change as "<ChangeReason>"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator go to menu Station Management Tool -> Station COD Report
    And Operator chooses start and end date on transaction end date using the following data:
      | transactionEndDateFrom | {gradle-previous-1-day-dd/MM/yyyy} |
      | transactionEndDateTo   | {gradle-current-date-dd/MM/yyyy}   |
    And Operator searches for station cod report by applying following filters:
      | Hubs      | Transaction Status |
      | <HubName> | <TransStatus>      |
    And Operator navigates to summary tab in the result grid
    And Operator searches for the details in result grid using the following search criteria:
      | Driver Name | {ninja-driver-name} |
      | Hub         | <HubName>             |
    And Operator gets the order details from summary tab of station cod report
    And Operator verifies that the following details are displayed in summary tab:
      | Driver Name | {ninja-driver-name}    |
      | Hub         | <HubName>              |
      | Route ID    | {KEY_CREATED_ROUTE_ID} |
      | COD Amount  | <CODAmount>            |
    And Operator verifies that the following columns are displayed under cash collected table
      | Total Pickup      |
      | Total Delivery    |
      | Total Reservation |
      | Sum of Total      |
    And Operator verifies that the COD amount: "<CODAmount>" is separated by dot for thousands and by comma for decimals
    And Operator verifies that the COD collected amount is separated by dot for thousands and by comma for decimals

    Examples:
      | HubId      | HubName      | CODAmount | ChangeReason | TransStatus   |
      | {hub-id-1} | {hub-name-1} | 1500.5    | GENERATED    | DD - Delivery |

  @ArchiveRoute @default-sg
  Scenario Outline: [SG, MY, PH] Transaction End Date Should Match Country's Timezone UTC+8 (uid:6522d856-e82f-4eb4-8d1d-d82344eea5d7)
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery": <CODAmount>, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions":{ "size":"S", "weight":"1.0" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":"{hub-id-Global}" } |
    And API Operator sweep parcel in the hub
      | hubId | <HubId>                         |
      | scan  | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator wait until order granular status changes to "On Vehicle for Delivery"
    And Operator click Order Settings -> Manually Complete Order on Edit Order page
    And Operator completes COD order manually by updating reason for change as "<ChangeReason>"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator go to menu Station Management Tool -> Station COD Report
    And Operator chooses start and end date on transaction end date using the following data:
      | transactionEndDateFrom | {gradle-previous-1-day-dd/MM/yyyy} |
      | transactionEndDateTo   | {gradle-current-date-dd/MM/yyyy}   |
    And Operator searches for station cod report by applying following filters:
      | Hubs      | Transaction Status |
      | <HubName> | <TransStatus>      |
    And Operator searches for the details in result grid using the following search criteria:
      | Tracking ID/ Reservation ID | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator gets the order details from details tab of station cod report
    And Operator verifies that the following details are displayed in details tab:
      | Route ID                    | {KEY_CREATED_ROUTE_ID}           |
      | Tracking ID/ Reservation ID | {KEY_CREATED_ORDER_TRACKING_ID}  |
      | Hub                         | <HubName>                        |
      | Route Date                  | {gradle-current-date-yyyy-MM-dd} |
      | Transaction Status          | <TransactionStatus>              |
      | Granular Status             | <GranularStatus>                 |
      | Collected At                | <CollectedAt>                    |
      | COD Amount                  | <CODAmount>                      |
      | Shipper Name                | {shipper-v4-name}                |
      | Driver Name                 | {ninja-driver-name}              |
      | Driver ID                   | {ninja-driver-id}                |
    And DB Operator verifies that transaction end datetime is +8 hours from job_service_end_datetime_utc in station database

    Examples:
      | HubId      | HubName      | CODAmount | ChangeReason | TransactionStatus | GranularStatus | TransStatus   | CollectedAt |
      | {hub-id-2} | {hub-name-2} | 1500.5    | GENERATED    | Success           | Completed      | DD - Delivery | Delivery    |

  @ArchiveRoute @default-id
  Scenario Outline: [ID, TH, VN] Transaction End Date Should Match Country's Timezone UTC+7 (uid:31fc432f-6be1-43ab-9764-f520c98920a0)
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"STANDARD","from": {"name": "QA-STATION-TEST-FROM","phone_number": "+6281231422926","email": "senderV4@nvqa.co","address": {"address1": "Jl. Gedung Sate No.48","country": "ID","province": "Jawa Barat ","city": "Kota Bandung","postcode": "60272","latitude": -6.921837,"longitude": 107.636803}},"to": {"name": "QA-STATION-TEST-TO","phone_number": "+6281231422926","email": "recipientV4@nvqa.co","address": {"address1": "Jalan Tebet Timur, 12","country": "ID","province": "DKI Jakarta","kecamatan": "Jakarta Selatan","postcode": "11280","latitude": -6.240501,"longitude": 106.841408}},"parcel_job":{ "cash_on_delivery": <CODAmount>,"insured_value": 85000,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00","timezone": "Asia/Ho_Chi_Minh"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions": {"size": "S", "weight": 1.0 },"delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00","timezone": "Asia/Ho_Chi_Minh"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":"{hub-id-Global}" } |
    And API Operator sweep parcel in the hub
      | hubId | <HubId>                         |
      | scan  | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator fill the tracking ID on Van Inbound Page then click enter
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator click on start route after van inbounding
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator wait until order granular status changes to "On Vehicle for Delivery"
    And Operator click Order Settings -> Manually Complete Order on Edit Order page
    And Operator completes COD order manually by updating reason for change as "<ChangeReason>"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator go to menu Station Management Tool -> Station COD Report
    And Operator chooses start and end date on transaction end date using the following data:
      | transactionEndDateFrom | {gradle-previous-1-day-dd/MM/yyyy} |
      | transactionEndDateTo   | {gradle-current-date-dd/MM/yyyy}   |
    And Operator searches for station cod report by applying following filters:
      | Hubs      | Transaction Status |
      | <HubName> | <TransStatus>      |
    And Operator searches for the details in result grid using the following search criteria:
      | Tracking ID/ Reservation ID | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator gets the order details from details tab of station cod report
    And Operator verifies that the following details are displayed in details tab:
      | Route ID                    | {KEY_CREATED_ROUTE_ID}           |
      | Tracking ID/ Reservation ID | {KEY_CREATED_ORDER_TRACKING_ID}  |
      | Hub                         | <HubName>                        |
      | Route Date                  | {gradle-current-date-yyyy-MM-dd} |
      | Transaction Status          | <TransactionStatus>              |
      | Granular Status             | <GranularStatus>                 |
      | Collected At                | <CollectedAt>                    |
      | COD Amount                  | <CODAmount>                      |
      | Shipper Name                | {shipper-v4-name}                |
      | Driver Name                 | {ninja-driver-name}              |
      | Driver ID                   | {ninja-driver-id}                |
    And DB Operator verifies that transaction end datetime is +7 hours from job_service_end_datetime_utc in station database

    Examples:
      | HubId      | HubName      | CODAmount | ChangeReason | TransactionStatus | GranularStatus | TransStatus   | CollectedAt |
      | {hub-id-1} | {hub-name-1} | 1500.5    | GENERATED    | Success           | Completed      | DD - Delivery | Delivery    |

  @ArchiveRoute
  Scenario Outline: View Updated Driver Name (uid:3f3c7bfc-ee27-403d-b613-93a4621ecac0)
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery": <CODAmount>, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions":{ "size":"S", "weight":"1.0" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":"{hub-id-Global}" } |
    And API Operator sweep parcel in the hub
      | hubId | <HubId>                         |
      | scan  | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id-2} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator fill the tracking ID on Van Inbound Page then click enter
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator go to menu Inbounding -> Van Inbound
    And Operator fill the route ID on Van Inbound Page then click enter
    And Operator click on start route after van inbounding
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator wait until order granular status changes to "On Vehicle for Delivery"
    And Operator click Order Settings -> Manually Complete Order on Edit Order page
    And Operator completes COD order manually by updating reason for change as "<ChangeReason>"
    And Operator verify order status is "Completed" on Edit Order page
    And Operator go to menu Fleet -> Driver Strength
    When Operator filter driver strength using data below:
      | zones       | {zone-name}        |
      | driverTypes | {driver-type-name} |
    And Operator updates driver details with the following info:
      | displayName | AUTO-DRIVER-{gradle-current-date-yyyyMMddHHmmsss} |
    And Operator verifies that success react notification displayed:
      | top | Driver Updated |
    And API Operator clears incoming shipment cache
    And Operator go to menu Station Management Tool -> Station COD Report
    And Operator chooses start and end date on transaction end date using the following data:
      | transactionEndDateFrom | {gradle-previous-1-day-dd/MM/yyyy} |
      | transactionEndDateTo   | {gradle-current-date-dd/MM/yyyy}   |
    And Operator searches for station cod report by applying following filters:
      | Hubs      | Transaction Status |
      | <HubName> | <TransStatus>      |
    And Operator searches for the details in result grid using the following search criteria:
      | Tracking ID/ Reservation ID | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator gets the order details from details tab of station cod report
    Then Operator verifies that the updated driver name: "{KEY_UPDATED_DRIVER_DISPLAY_NAME}" is displayed in the grid
    And Operator navigates to summary tab in the result grid
    And Operator searches for the details in result grid using the following search criteria:
      | Driver Name | {KEY_UPDATED_DRIVER_DISPLAY_NAME} |
      | Hub         | <HubName>                         |
      | Route ID    | {KEY_CREATED_ROUTE_ID}            |
    And Operator gets the order details from summary tab of station cod report
    And Operator verifies that the updated driver name: "{KEY_UPDATED_DRIVER_DISPLAY_NAME}" is displayed in the grid

    Examples:
      | HubId      | HubName      | CODAmount | ChangeReason | TransStatus   |
      | {hub-id-2} | {hub-name-2} | 1500.5    | GENERATED    | DD - Delivery |

  @Happypath @ArchiveRoute
  Scenario Outline: Download CSV of COD Report Detail (uid:69ca23d3-f0f9-4929-89e9-089321d3b5b7)
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery": <CODAmount>, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions":{ "size":"S", "weight":"1.0" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":"{hub-id-Global}" } |
    And API Operator sweep parcel in the hub
      | hubId | <HubId>                         |
      | scan  | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator wait until order granular status changes to "On Vehicle for Delivery"
    And Operator click Order Settings -> Manually Complete Order on Edit Order page
    And Operator completes COD order manually by updating reason for change as "<ChangeReason>"
    And Operator verify order status is "Completed" on Edit Order page
    And Operator go to menu Station Management Tool -> Station COD Report
    And Operator chooses start and end date on transaction end date using the following data:
      | transactionEndDateFrom | {gradle-previous-1-day-dd/MM/yyyy} |
      | transactionEndDateTo   | {gradle-current-date-dd/MM/yyyy}   |
    And Operator searches for station cod report by applying following filters:
      | Hubs      | Transaction Status |
      | <HubName> | <TransStatus>      |
    Then Operator searches for the details in result grid using the following search criteria:
      | Tracking ID/ Reservation ID | {KEY_CREATED_ORDER_TRACKING_ID} |
    And Operator gets the order details from details tab of station cod report
    And Operator verifies that the downloaded CSV file matches with the expected details in "<TabName>" tab
    And Operator verifies that COD amount is rounded off to two decimal in CSV downloaded from "<TabName>" tab

    Examples:
      | HubId      | HubName      | CODAmount | ChangeReason | TransStatus   | TabName |
      | {hub-id-2} | {hub-name-2} | 1500.5    | GENERATED    | DD - Delivery | Details |

  @Happypath @ArchiveRoute
  Scenario Outline: Download CSV of COD Report Summary (uid:e732bb2b-c198-4406-bc0c-1c34450e7d97)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "cash_on_delivery": <CODAmount>, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "dimensions":{ "size":"S", "weight":"1.0" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":"{hub-id-Global}" } |
    And API Operator sweep parcel in the hub
      | hubId | <HubId>                         |
      | scan  | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator wait until order granular status changes to "On Vehicle for Delivery"
    And Operator click Order Settings -> Manually Complete Order on Edit Order page
    And Operator completes COD order manually by updating reason for change as "<ChangeReason>"
    Then Operator verify order status is "Completed" on Edit Order page
    And Operator go to menu Station Management Tool -> Station COD Report
    And Operator chooses start and end date on transaction end date using the following data:
      | transactionEndDateFrom | {gradle-previous-1-day-dd/MM/yyyy} |
      | transactionEndDateTo   | {gradle-current-date-dd/MM/yyyy}   |
    And Operator searches for station cod report by applying following filters:
      | Hubs      | Transaction Status |
      | <HubName> | <TransStatus>      |
    And Operator navigates to summary tab in the result grid
    And Operator searches for the details in result grid using the following search criteria:
      | Driver Name | {ninja-driver-name} |
      | Hub         | <HubName>           |
    And Operator gets the order details from summary tab of station cod report
    And Operator verifies that the downloaded CSV file matches with the expected details in "<TabName>" tab
    And Operator verifies that COD amount is rounded off to two decimal in CSV downloaded from "<TabName>" tab

    Examples:
      | HubId      | HubName      | CODAmount | ChangeReason | TransStatus   | TabName |
      | {hub-id-2} | {hub-name-2} | 1500.5    | GENERATED    | DD - Delivery | Summary |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op