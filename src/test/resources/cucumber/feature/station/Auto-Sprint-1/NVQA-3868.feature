@StationHome @Story-4
Feature: Number of Parcels In Hub

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @Case-1
  Scenario Outline: Change the Language to <Language> and Open Station Management Homepage (<hiptest-uid>)
    Given Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <PageHeader>
    Then verifies that the text:"<ModalText>" is displayed on the hub modal selection
    And Operator chooses the hub as "{hub-name-1}" displayed in "<Language>" and proceed
    And verifies that the station home :"<PageHeader>" is displayed as expected
    And verifies that the info on page refresh text: "<PageRefreshText>" is shown on top left of the page
    And reloads operator portal to reset the test state

    Examples:
      | Language   | PageHeader                  | ModalText                                          | PageRefreshText                             | hiptest-uid                              |
      | English    | Station Management Homepage | Welcome to Station Management Tool                 | Refresh the page to retrieve updated data   | uid:71904a8b-f17a-4606-9efb-e8177f79f7eb |
      | Malay      | Station Management Homepage | Selamat Datang ke Alat Bantuan Pengurusan Stesen   | Refresh the page to retrieve updated data   | uid:5395f602-3b67-478b-950f-a7bbba1aaed1 |
      | Indonesian | Beranda Manajemen Stasiun   | Selamat Datang di Perangkat Station Management     | Perbarui halaman untuk melihat data terbaru | uid:738ef484-e6bc-448c-99f9-d6effdacbd89 |
      | Vietnam    | Trang quản lý trạm          | Xin chào đến trang quản lý hàng hóa trạm giao nhận | Tải lại trang để cập nhận số liệu mới nhất  | uid:1c4a9d07-b0a8-4824-9fc4-2200045a43cd |
      | Thai       | โฮมเพจการจัดการสถานี        | ยินดีต้อนรับสู่ Station Management Tool                    | รีเฟรชหน้าเพื่อดึงข้อมูลที่อัปเดต                     | uid:4e5263ca-1c8f-4dfd-b73b-416296639dd4 |
      | Burmese    | Station Management Homepage | Station Management Tool မှ ကြိုဆိုပါသည်။              | Refresh the page to retrieve updated data   | uid:b39aa6ed-03cd-4571-a094-135a2c5e71a4 |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op