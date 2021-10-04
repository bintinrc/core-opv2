@StationHome @StationManagement @StationHomePage
Feature: Station Management Homepage

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @coverage-manual @coverage-operator-manual @step-done @station-happy-path @NVQA-3829
  Scenario Outline: Station Management Homepage Navigation Panel (<hiptest-uid>)
    Given Operator go to menu Station Management Tool -> Station Management Homepage
    When Operator selects the hub as "<HubName>" and proceed
    Then verifies that the following navigation links are displayed under the header:"<Header1>"
      | Route Engine - Zonal Routing |
      | Parcel Sweeper Live          |
      | Shipment Management          |
      | Shipment Inbound             |
      | Van Inbound                  |
      | Route Log                    |
      | Outbound Monitoring          |
      | Route Monitoring             |
      | Route Inbound                |
      | Recovery                     |
    And verifies that the following navigation links are displayed under the header:"<Header2>"
      | Driver Performance Report |
      | COD Report                |
    And verifies that the page:"<PageName>" is loaded on new tab on clicking the link:"<LinkName>"

    Examples:
      | HubName      | Header1                      | Header2 | PageName                     | LinkName                       | hiptest-uid                              |
      | {hub-name-1} | Standard Operating Procedure | Reports | Route Engine - Zonal Routing | Route Engine - Zonal Routing   | uid:c366e948-5a13-4209-874f-fac9db68e439 |
      | {hub-name-1} | Standard Operating Procedure | Reports | Parcel Sweeper Live          | Parcel Sweeper Live            | uid:80a5876f-3679-46e3-b337-17339904b1c3 |
      | {hub-name-1} | Standard Operating Procedure | Reports | Shipment Management          | Shipment Management            | uid:398bb047-3d41-4275-be8c-0cbbf369b667 |
      | {hub-name-1} | Standard Operating Procedure | Reports | Shipment Inbound             | Shipment Inbound               | uid:896cc837-7fe5-4e0c-9ac6-8eac95946522 |
      | {hub-name-1} | Standard Operating Procedure | Reports | Van Inbound                  | Van Inbound                    | uid:78145e86-00d3-4f6d-9f98-0c387d17fba3 |
      | {hub-name-1} | Standard Operating Procedure | Reports | Route Log                    | Route Log                      | uid:f529ec4a-b726-46f4-8fc5-892ccde9e1ff |
      | {hub-name-1} | Standard Operating Procedure | Reports | Outbound Monitoring          | Outbound/Route Load Monitoring | uid:cc055202-d5e9-4c07-86e9-4a5274930ce8 |
      | {hub-name-1} | Standard Operating Procedure | Reports | Route Monitoring             | Route Monitoring               | uid:7fb27950-016a-4d86-9eb3-be0fd516f6ac |
      | {hub-name-1} | Standard Operating Procedure | Reports | Route Inbound                | Route Inbound                  | uid:0e1412e5-923d-4cae-a3c3-fc56695c3aed |
      | {hub-name-1} | Standard Operating Procedure | Reports | Recovery                     | Recovery                       | uid:65666a52-59e3-4131-91fe-473cdfb046c0 |
      | {hub-name-1} | Standard Operating Procedure | Reports | Driver Performance Report    | Driver Performance             | uid:24ee3ae1-9d5c-4615-9ae7-0cbec6776a43 |
      | {hub-name-1} | Standard Operating Procedure | Reports | COD Report                   | COD Report                     | uid:8c31a90a-02b0-490a-8436-c94b9cb656de |

  @coverage-manual @coverage-operator-manual @step-done @NVQA-3868
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
      | Malay      | Station Management Homepage | Selamat Datang ke Alat Bantuan Pengurusan Stesen   | Refresh the page to retrieve updated data   | uid:5395f602-3b67-478b-950f-a7bbba1aaed1 |
      | Indonesian | Beranda Manajemen Stasiun   | Selamat Datang di Perangkat Station Management     | Perbarui halaman untuk melihat data terbaru | uid:738ef484-e6bc-448c-99f9-d6effdacbd89 |
      | Vietnam    | Trang quản lý trạm          | Xin chào đến trang quản lý hàng hóa trạm giao nhận | Tải lại trang để cập nhận số liệu mới nhất  | uid:1c4a9d07-b0a8-4824-9fc4-2200045a43cd |
      | Thai       | โฮมเพจการจัดการสถานี          | ยินดีต้อนรับสู่ Station Management Tool                   | รีเฟรชหน้าเพื่อดึงข้อมูลที่อัปเดต                     | uid:4e5263ca-1c8f-4dfd-b73b-416296639dd4 |
      | Burmese    | Station Management Homepage | Station Management Tool မှ ကြိုဆိုပါသည်။              | Refresh the page to retrieve updated data   | uid:b39aa6ed-03cd-4571-a094-135a2c5e71a4 |
      | English    | Station Management Homepage | Welcome to Station Management Tool                 | Refresh the page to retrieve updated data   | uid:71904a8b-f17a-4606-9efb-e8177f79f7eb |

  @coverage-manual @coverage-operator-manual @step-done @station-happy-path @NVQA-3869
  Scenario: Able to Access Station Management Homepage Through URL (uid:3823b3b9-a2ab-45d5-80b6-67c6ec0d0db0)
    Given Operator go to menu Station Management Tool -> Station Management Homepage
    When Operator selects the hub as "{hub-name-1}" and proceed
    And verifies that the url path parameter changes to hub-id:"{hub-id-1}"
    And updates station hub-id as "{hub-id-2}" directly in the url
    And verifies that the hub has changed to:"{hub-name-2}" in header dropdown
    And reloads operator portal to reset the test state

  @coverage-manual @coverage-operator-manual @step-done @NVQA-3869
  Scenario: Station Management Homepage URL is Updated Following The Hub (uid:4018e123-49da-4ea0-9962-e7894625aca8)
    Given Operator go to menu Station Management Tool -> Station Management Homepage
    When Operator selects the hub as "{hub-name-1}" and proceed
    And verifies that the url path parameter changes to hub-id:"{hub-id-1}"
    Then Operator changes hub as "{hub-name-2}" through the dropdown in header
    And verifies that the url path parameter changes to hub-id:"{hub-id-2}"
    And reloads operator portal to reset the test state

  @coverage-manual @coverage-operator-manual @step-done @NVQA-3869
  Scenario Outline: Required to Select Hub When Hub ID in URL is Wrong (uid:d721e257-5455-4e17-ab0e-9885e6f66f38)
    Given Operator go to menu Station Management Tool -> Station Management Homepage
    When Operator selects the hub as "{hub-name-1}" and proceed
    And verifies that the url path parameter changes to hub-id:"{hub-id-1}"
    And updates station hub-id as "<InvalidHubId>" directly in the url
    Then verifies that the toast message "<ToastMessage>" is displayed
    And verifies that station management home screen url is loaded
    And Operator selects the hub as "{hub-name-1}" and proceed
    And verifies that the url path parameter changes to hub-id:"{hub-id-1}"

    Examples:
      | InvalidHubId | ToastMessage   |
      | 997          |  Hub not found |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op