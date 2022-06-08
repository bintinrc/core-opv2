@StationManagement @StationHome @StationTooltip
Feature: Thai

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario Outline: Thai Tooltip for COD Collected from Courier
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <SubMenu>
    And Operator chooses the hub as "<HubName>" displayed in "<Language>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: "<TileText>"
      | COD เรียกเก็บกรณี Route Inbound เสร็จสิ้น |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language | SubMenu            | TileText      |
      | {hub-name-9} | Thai     | โฮมเพจการจัดการสถานี | COD ที่เก็บมาแล้ว |

  Scenario Outline: Thai Tooltip for COD not Collected yet from Courier (uid:d0cea2b6-d033-4f00-93ec-838abafcf803)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <SubMenu>
    And Operator chooses the hub as "<HubName>" displayed in "<Language>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: "<TileText>"
      | จำนวนเงิน COD ที่รอการเรียกเก็บจากพนักงานขับรถแต่ยังไม่ดำเนินการ Route Inbound |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language | SubMenu            | TileText       |
      | {hub-name-9} | Thai     | โฮมเพจการจัดการสถานี | COD ที่ยังไม่ได้เก็บ |

  Scenario Outline: Thai Tooltip for Number of Missing Parcels (uid:2d61ea2e-0d41-4edc-887e-e3ccbbeeff67)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <SubMenu>
    And Operator chooses the hub as "<HubName>" displayed in "<Language>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: "<TileText>"
      | PETs ticket ที่ได้รับมอบหมายไปยังฮับโดยพัสดุสูญหายหรือเสียหายแล้ว |
      | สถานะปัจจุบัน คือ "on-hold"                               |
      | สถานะ Ticket ยังไม่ได้รับการแก้ไข                          |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language | SubMenu            | TileText        |
      | {hub-name-9} | Thai     | โฮมเพจการจัดการสถานี | Missing parcels |

  Scenario Outline: Thai Tooltip for Number of Damaged Parcels (uid:6a512f89-9e00-4d98-876c-e914403283b7)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <SubMenu>
    And Operator chooses the hub as "<HubName>" displayed in "<Language>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: "<TileText>"
      | Ticket PETS ที่ถูกมอบหมายไปยังสเตชันมีสถานนะเสียหาย ,เเละ |
      | สเตตัส‘พักไว้’, เเละ                                  |
      | สเตตัส 'ยังไม่ได้ถูกเเก้ไข'                              |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language | SubMenu            | TileText        |
      | {hub-name-9} | Thai     | โฮมเพจการจัดการสถานี | Damaged parcels |

  Scenario Outline: Thai Tooltip for Number of Parcels with Exception Cases (uid:c141f3c9-1f8a-46c6-a0f2-9af0fff80f59)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <SubMenu>
    And Operator chooses the hub as "<HubName>" displayed in "<Language>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: '<TileText>'
      | PETs ticket ที่ได้รับมอบหมายไปยังฮับโดยพัสดุยังไม่สูญหายหรือเสียหาย |
      | สถานะปัจจุบัน คือ "on-hold"                                |
      | สถานะ Ticket ยังไม่ได้รับการแก้ไข                           |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language | SubMenu            | TileText              |
      | {hub-name-9} | Thai     | โฮมเพจการจัดการสถานี | พัสดุที่อยู่ภายใต้เงื่อนไขพิเศษ |

  Scenario Outline: Thai Tooltip for Parcel in Hub (uid:c1f6e698-0b54-4747-997f-e45f360c6b61)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <SubMenu>
    And Operator chooses the hub as "<HubName>" displayed in "<Language>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: "<TileText>"
      | สแกนครั้งล่าสุดที่ฮับ                                    |
      | ไม่ถูก Driver Inbound scan และ Shipment Van Inbound scan |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language | SubMenu            | TileText   |
      | {hub-name-9} | Thai     | โฮมเพจการจัดการสถานี | พัสดุภายในฮับ |

  Scenario Outline: Thai Tooltip for COD Column (uid:f9ce2470-23ae-4f15-a2b8-b728bc3b331a)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <SubMenu>
    And Operator chooses the hub as "<HubName>" displayed in "<Language>" and proceed
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    Then Operator verifies that the following text is displayed on hover over the tile text: "<ColumnHeader>"
      | จำนวนเงิน COD ที่รอการเรียกเก็บจากพนักงานขับรถแต่ยังไม่ดำเนินการ Route Inbound\n\nกรณี Route Inbound เสร็จสิ้น สถานะจะเปลี่ยนเป็น "Completed" |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language | SubMenu            | TileName       | ModalName      | ColumnHeader          |
      | {hub-name-9} | Thai     | โฮมเพจการจัดการสถานี | COD ที่ยังไม่ได้เก็บ | COD ที่ยังไม่ได้เก็บ | COD Amount to Collect |

  Scenario Outline: Thai Tooltip for Priority Parcel on Vehicle for Delivery (uid:103ac116-60a3-412f-b5f7-4fd415f63d4e)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <SubMenu>
    And Operator chooses the hub as "<HubName>" displayed in "<Language>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: '<TileText>'
      | ฮับปลายทางโชว์ที่ Station Management Homepage            |
      | พัสดุมีการ Tag Prior ในระบบ                             |
      | สถานะพัสดุ (Granular Status) คือ "พัสดุอยู่ในระหว่างการจัดส่ง" |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title


    Examples:
      | HubName      | Language | SubMenu            | TileText        |
      | {hub-name-9} | Thai     | โฮมเพจการจัดการสถานี | พัสดุด่วนที่กำลังนำส่ง |

  Scenario Outline: Thai Tooltip for Total Completion Rate (uid:771a6974-0a17-4b31-9ee5-62d6b841f96b)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <SubMenu>
    And Operator chooses the hub as "<HubName>" displayed in "<Language>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: "<TileText>"
      | เปอร์เซ็นต์ของจำนวนจุดที่พยายามออกนำส่งทั้งหมดจากจำนวนพัสดุทั้งหมดใน Waypoint |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language | SubMenu            | TileText         |
      | {hub-name-9} | Thai     | โฮมเพจการจัดการสถานี | อัตราการนำส่งสำเร็จ |

  Scenario Outline: Thai Tooltip for Parcel in Incoming Shipment (uid:a8ac78ff-de5f-470b-816e-8ddc5ee4ade6)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <SubMenu>
    And Operator chooses the hub as "<HubName>" displayed in "<Language>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: "<TileText>"
      | เวลาที่ Shipment มายังฮับภายใน 24 ชั่วโมงโดยคำนวนจาก ETA (Estimate arrival time) |
      | สถานะของชิปเม้นท์คือ "Transit" หรือ "At Transit hub"                             |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language | SubMenu            | TileText            |
      | {hub-name-9} | Thai     | โฮมเพจการจัดการสถานี | พัสดุที่กำลังเดินทางมาที่ฮับ |

  Scenario Outline: Thai Tooltip for Priority Parcel in Hub (uid:a0ea7874-7c9e-44fa-9bc2-8c23cbc893f0)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <SubMenu>
    And Operator chooses the hub as "<HubName>" displayed in "<Language>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: "<TileText>"
      | สแกนครั้งล่าสุดที่ฮับ                                    |
      | ไม่ถูก Driver Inbound scan และ Shipment Van Inbound scan |
      | พัสดุถูก Tag PRIOR                                       |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language | SubMenu            | TileText            |
      | {hub-name-9} | Thai     | โฮมเพจการจัดการสถานี | พัสดุด่วนภายในฮับ |

  Scenario Outline: Thai Tooltip for Unassigned RTS Parcels for Route (uid:22367b2d-3ddd-4627-8d89-eacb4f576571)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <SubMenu>
    And Operator chooses the hub as "<HubName>" displayed in "<Language>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: "<TileText>"
      | พัสดุ RTS ที่ฮับปลายทางโชว์ที่ Station Management Homepage |
      | พัสดุยังไม่ถูกนำเข้า Route                               |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language | SubMenu            | TileText  |
      | {hub-name-9} | Thai     | โฮมเพจการจัดการสถานี | For Route |

  Scenario Outline: Thai Tooltip for Unassigned RTS Parcels for Shipment (uid:a84db1b1-3c09-471a-8ef9-4a87d207536f)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <SubMenu>
    And Operator chooses the hub as "<HubName>" displayed in "<Language>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: "<TileText>"
      | ฮับปลายทางของพัสดุ RTS ไม่ตรงกับฮับที่เลือกใน Station Management Homepage |
      | ยังไม่ได้บรรจุเข้าไปในชิปเม้น                                           |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language | SubMenu            | TileText     |
      | {hub-name-9} | Thai     | โฮมเพจการจัดการสถานี | For Shipment |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op