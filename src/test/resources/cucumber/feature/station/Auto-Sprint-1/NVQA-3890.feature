@StationHome @Story-1
Feature: Number of Parcels In Hub

  @LaunchBrowser @ShouldAlwaysRun @NVQA-3890
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @Case-1 @NVQA-3890
  Scenario Outline: Change the Language to <Language> and Open Station Management Homepage (<hiptest-uid>)
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
      | Hubs             | Transaction Status |
      | SingaporeQ1(JKB) | PP - Pickup        |
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
      | Language | PageHeader         |
      | English  | Station COD Report |


  @Case-2 @NVQA-3890
  Scenario Outline: Change the Language to <Language> and Open Station Management Homepage (<hiptest-uid>)
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
      | Hab              | Status Transaksi |
      | SingaporeQ1(JKB) | PP - Pengambilan |
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
      | Language | PageHeader         |
      | Malay    | Station COD Report |

  @Case-3 @NVQA-3890
  Scenario Outline: Change the Language to <Language> and Open Station Management Homepage (<hiptest-uid>)
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
      | Hub              | Status transaksi |
      | SingaporeQ1(JKB) | PP - Penjemputan |
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
      | Language   | PageHeader         |
      | Indonesian | Station COD Report |

  @Case-4 @NVQA-3890
  Scenario Outline: Change the Language to <Language> and Open Station Management Homepage (<hiptest-uid>)
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
      | Trạm             | Trạng thái giao dịch |
      | SingaporeQ1(JKB) | Lấy hàng             |
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
      | Language | PageHeader         |
      | Vietnam  | Station COD Report |

  @Case-5 @NVQA-3890
  Scenario Outline: Change the Language to <Language> and Open Station Management Homepage (<hiptest-uid>)
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
      | ฮับ              | สถานะของ Transaction |
      | SingaporeQ1(JKB) | PP - งานเข้ารับ      |
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
      | Language | PageHeader         |
      | Thai     | Station COD Report |


  @Case-6 @NVQA-3890
  Scenario Outline: Change the Language to <Language> and Open Station Management Homepage (<hiptest-uid>)
    Given Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <PageHeader>
    Then verifies that the following UI elements are displayed in station cod report page
      | လုပ်ဆောင်မှု ပြီးစီးသည့်ရက် |
      | ပင်မနေရာများ                |
      | လုပ်ဆောင်မှု အမျိုးအစား     |
      | လုပ်ဆောင်မှု အခြေအနေ        |
    And verifies that the following buttons are displayed in disabled state
      | Clear Selection |
      | Load Selection  |
    And chooses start and end date on transaction end date using the following data:
      | transactionEndDateFrom | {gradle-previous-2-day-dd/MM/yyyy} |
      | transactionEndDateTo   | {gradle-current-date-dd/MM/yyyy}   |
    And searches for station cod report by applying following filters:
      | ပင်မနေရာများ     | လုပ်ဆောင်မှု အခြေအနေ   |
      | SingaporeQ1(JKB) | PP - ပစ္စည်းကောက်ခြင်း |
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
      | Language | PageHeader         |
      | Burmese  | Station COD Report |

  @KillBrowser @ShouldAlwaysRun @NVQA-3890
  Scenario: Kill Browser
    Given no-op