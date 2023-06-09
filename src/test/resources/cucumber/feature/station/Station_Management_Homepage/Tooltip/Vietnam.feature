@StationManagement @StationHome @StationTooltip @VietnamToolTip
Feature: Vietnam

  Background:
    When Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario Outline: Vietnam Tooltip for COD Collected from Courier
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <SubMenu>
    And Operator chooses the hub as "<HubName>" displayed in "<Language>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: "<TileText>"
      | Lộ trình giao hàng đã được thực hiện và lái xe đã bàn giao COD/COP cho quản lý trạm |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language | SubMenu            | TileText             |
      | {hub-name-9} | Vietnam  | Trang quản lý trạm | COD đã thu từ tài xế |

  Scenario Outline: Vietnam Tooltip for COD not Collected yet from Courier (uid:4cb5550b-c60e-45e2-be6c-570f4f13025e)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <SubMenu>
    And Operator chooses the hub as "<HubName>" displayed in "<Language>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: "<TileText>"
      | COD/COP đã được lái xe thu nhưng chưa được bàn giao cho quản lý trạm |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language | SubMenu            | TileText               |
      | {hub-name-9} | Vietnam  | Trang quản lý trạm | COD chưa thu từ tài xế |

  Scenario Outline: Vietnam Tooltip for Number of Missing Parcels (uid:4722ff6d-86ad-4007-a9eb-dc5c65c8ae6e)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <SubMenu>
    And Operator chooses the hub as "<HubName>" displayed in "<Language>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: "<TileText>"
      | Yêu cầu PETS của trạm là do mất, và |
      | Trạng thái là "đang chờ", và        |
      | Yêu cầu chưa được giải quyết        |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language | SubMenu            | TileText        |
      | {hub-name-9} | Vietnam  | Trang quản lý trạm | Missing parcels |

  Scenario Outline: Vietnam Tooltip for Number of Damaged Parcels (uid:70f7dbaa-93c3-426f-8c04-d0f967dd5d49)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <SubMenu>
    And Operator chooses the hub as "<HubName>" displayed in "<Language>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: "<TileText>"
      | Yêu cầu PETS của trạm là do hư hỏng, và |
      | Trạng thái là "đang chờ", và            |
      | Yêu cầu chưa được giải quyết            |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language | SubMenu            | TileText        |
      | {hub-name-9} | Vietnam  | Trang quản lý trạm | Damaged parcels |

  Scenario Outline: Vietnam Tooltip for Number of Parcels with Exception Cases (uid:8737b545-0c5a-4a59-907c-c1306f06f989)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <SubMenu>
    And Operator chooses the hub as "<HubName>" displayed in "<Language>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: '<TileText>'
      | Yêu cầu PETS của trạm không phải là Mất hoặc Hư hỏng, và |
      | Trạng thái là "đang chờ", và                             |
      | Yêu cầu chưa được giải quyết                             |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language | SubMenu            | TileText                             |
      | {hub-name-9} | Vietnam  | Trang quản lý trạm | Số đơn hàng có trạng thái bất thường |

  Scenario Outline: Vietnam Tooltip for Parcel in Hub (uid:b945a520-59b8-4429-803d-5a2d9f2f5588)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <SubMenu>
    And Operator chooses the hub as "<HubName>" displayed in "<Language>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: "<TileText>"
      | Lần cuối quét là ở trạm, và                                             |
      | Không có quét nhập vào lộ trình hoặc quét nhập vào lô hàng trung chuyển |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language | SubMenu            | TileText             |
      | {hub-name-9} | Vietnam  | Trang quản lý trạm | Số đơn hàng tại trạm |

  Scenario Outline: Vietnam Tooltip for COD Column (uid:9a5dfb91-e678-4d45-a1fb-f1ec05d613c7)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <SubMenu>
    And Operator chooses the hub as "<HubName>" displayed in "<Language>" and proceed
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    Then Operator verifies that the following text is displayed on hover over the tile text: "<ColumnHeader>"
      | Tổng số COD lái xe đã thu nhưng chưa được bàn giao cho quản lý trạm.\n\nNếu lái xe đã giao COD cho quản lý trạm, "Hoàn thành" sẽ được hiển thị |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language | SubMenu            | TileName               | ModalName              | ColumnHeader          |
      | {hub-name-9} | Vietnam  | Trang quản lý trạm | COD chưa thu từ tài xế | COD chưa thu từ tài xế | COD Amount to Collect |

  Scenario Outline: Vietnam Tooltip for Priority Parcel on Vehicle for Delivery (uid:3155f11b-771d-4dde-8111-81911b127c86)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <SubMenu>
    And Operator chooses the hub as "<HubName>" displayed in "<Language>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: '<TileText>'
      | Trạm giao hàng là trạm được chọn trên trang quản lý trạm, và |
      | Có mác ưu tiên, và                                           |
      | Trạng thái là "đang trên xe để giao hàng"                    |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language | SubMenu            | TileText                                  |
      | {hub-name-9} | Vietnam  | Trang quản lý trạm | Đơn hàng ưu tiên đang trên quá trình giao |

  Scenario Outline: Vietnam Tooltip for Total Completion Rate (uid:31716e22-0fb3-4d94-9634-4301694a27dd)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <SubMenu>
    And Operator chooses the hub as "<HubName>" displayed in "<Language>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: "<TileText>"
      | Tỷ lệ phần trăm số điểm giao / nhận đã thực hiện giao / nhận trên tổng số điểm được chỉ định trên lộ trình |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language | SubMenu            | TileText              |
      | {hub-name-9} | Vietnam  | Trang quản lý trạm | Tổng tỷ lệ thành công |

  Scenario Outline: Vietnam Tooltip for Parcel in Incoming Shipment (uid:e5910bd3-7b09-4499-b266-be70b6756f3e)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <SubMenu>
    And Operator chooses the hub as "<HubName>" displayed in "<Language>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: "<TileText>"
      | Thời gian đến dự kiến của hàng trung chuyển là trong vòng +/-24 tiếng, và                        |
      | Trạng thái của hàng trung chuyển là "đang trên đường vận chuyển" hoặc "đang ở trạm trung chuyển" |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language | SubMenu            | TileText                                    |
      | {hub-name-9} | Vietnam  | Trang quản lý trạm | Số lượng đơn hàng đang được chuyển đến trạm |

  Scenario Outline: Vietnam Tooltip for Priority Parcel in Hub (uid:018a5c51-e76c-4682-97fa-3dbc33bc42ed)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <SubMenu>
    And Operator chooses the hub as "<HubName>" displayed in "<Language>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: "<TileText>"
      | Lần cuối quét hàng là ở trạm, và                                            |
      | Không có quét nhập vào lộ trình hoặc quét nhập vào lô hàng trung chuyển, và |
      | Có mác ưu tiên                                                              |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language | SubMenu            | TileText                  |
      | {hub-name-9} | Vietnam  | Trang quản lý trạm | Đơn hàng ưu tiên tại trạm |

  Scenario Outline: Vietnam Tooltip for Unassigned RTS Parcels for Route (uid:f81e498d-19da-4c59-ac95-b5a9334d7967)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <SubMenu>
    And Operator chooses the hub as "<HubName>" displayed in "<Language>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: "<TileText>"
      | Trạm đến của đơn hàng RTS là trạm được chọn trên trang quản lý trạm, và |
      | Chưa ở trong lộ trình nào                                               |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language | SubMenu            | TileText  |
      | {hub-name-9} | Vietnam  | Trang quản lý trạm | For Route |

  Scenario Outline: Vietnam Tooltip for Unassigned RTS Parcels for Shipment (uid:99b7111f-1ab8-4f0d-9262-da0d27d121d6)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <SubMenu>
    And Operator chooses the hub as "<HubName>" displayed in "<Language>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: "<TileText>"
      | Trạm đến của đơn hàng RTS không phải là trạm được chọn trên trang quản lý trạm, và |
      | Chưa được nhập vào lô hàng trung chyển nào                                         |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language | SubMenu            | TileText     |
      | {hub-name-9} | Vietnam  | Trang quản lý trạm | For Shipment |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op