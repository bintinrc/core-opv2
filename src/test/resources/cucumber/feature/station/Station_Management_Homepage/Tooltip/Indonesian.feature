@StationManagement @StationHome @StationTooltip
Feature: Indonesian

  Background:
    When Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario Outline: Indonesian Tooltip for COD Collected from Courier
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <SubMenu>
    And Operator chooses the hub as "<HubName>" displayed in "<Language>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: "<TileText>"
      | Route inbound telah dilakukan dan kurir telah menyerahkan COD / COP yang dikumpulkan ke IC station |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language   | SubMenu                   | TileText                      |
      | {hub-name-9} | Indonesian | Beranda Manajemen Stasiun | COD yang terkumpul dari kurir |

  Scenario Outline: Indonesian Tooltip for COD not Collected yet from Courier (uid:9bea9e89-9afa-4d87-bd47-07b37e39e92c)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <SubMenu>
    And Operator chooses the hub as "<HubName>" displayed in "<Language>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: "<TileText>"
      | COD / COP yang telah dikumpulkan oleh kurir tetapi belum menyerahkan uang tunai kepada IC station |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language   | SubMenu                   | TileText                            |
      | {hub-name-9} | Indonesian | Beranda Manajemen Stasiun | COD yang belum terkumpul dari kurir |

  Scenario Outline: Indonesian Tooltip for Number of Missing Parcels (uid:23468468-1fb5-457f-b040-faa15d1935e3)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <SubMenu>
    And Operator chooses the hub as "<HubName>" displayed in "<Language>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: "<TileText>"
      | Tiket PETS di station yang hilang, DAN |
      | Status granular "ditahan", DAN         |
      | Status tiket PETS belum terselesaikan  |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language   | SubMenu                   | TileText     |
      | {hub-name-9} | Indonesian | Beranda Manajemen Stasiun | Paket Hilang |

  Scenario Outline: Indonesian Tooltip for Number of Damaged Parcels (uid:07939525-0792-4741-9529-da01e930141d)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <SubMenu>
    And Operator chooses the hub as "<HubName>" displayed in "<Language>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: "<TileText>"
      | Tiket PETS di station yang rusak, DAN |
      | Status granular "ditahan", DAN        |
      | Status tiket PETS belum terselesaikan |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language   | SubMenu                   | TileText    |
      | {hub-name-9} | Indonesian | Beranda Manajemen Stasiun | Paket Rusak |

  Scenario Outline: Indonesian Tooltip for Number of Parcels with Exception Cases (uid:98b30503-7c22-43d6-8e66-57109eb2ae6f)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <SubMenu>
    And Operator chooses the hub as "<HubName>" displayed in "<Language>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: '<TileText>'
      | Tiket PETS di station yang TIDAK hilang atau rusak, DAN |
      | Status granular "ditahan", DAN                          |
      | Status PETS tiket belum terselesaikan                   |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language   | SubMenu                   | TileText                                   |
      | {hub-name-9} | Indonesian | Beranda Manajemen Stasiun | Jumlah paket dengan tag "Parcel Exception" |

  Scenario Outline: Indonesian Tooltip for Parcel in Hub (uid:b68d4c42-bee4-4d85-8041-dd7b28ca7304)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <SubMenu>
    And Operator chooses the hub as "<HubName>" displayed in "<Language>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: "<TileText>"
      | Scan terakhir ada di hub, DAN                                          |
      | tidak memiliki scan inbound driver scan atau shipment van inbound scan |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language   | SubMenu                   | TileText            |
      | {hub-name-9} | Indonesian | Beranda Manajemen Stasiun | Jumlah paket di hub |

  Scenario Outline: Indonesian Tooltip for COD Column (uid:7aa42753-3e6c-439a-b260-41ae1e247dbe)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <SubMenu>
    And Operator chooses the hub as "<HubName>" displayed in "<Language>" and proceed
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    Then Operator verifies that the following text is displayed on hover over the tile text: "<ColumnHeader>"
      | Total COD yang dikumpulkan kurir tetapi belum diserahkan kepada IC station pada tingkat rute.\n\nJika kurir telah menyerahkan COD yang dikumpulkan ke IC station, status "Completed" akan ditampilkan. |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language   | SubMenu                   | TileName                            | ModalName                           | ColumnHeader          |
      | {hub-name-9} | Indonesian | Beranda Manajemen Stasiun | COD yang belum terkumpul dari kurir | COD yang belum terkumpul dari kurir | COD Amount to Collect |

  Scenario Outline: Indonesian Tooltip for Priority Parcel on Vehicle for Delivery (uid:0e1682de-0ee9-444e-885d-4626f4abb2d7)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <SubMenu>
    And Operator chooses the hub as "<HubName>" displayed in "<Language>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: '<TileText>'
      | Hub tujuan adalah hub yang dipilih di Station Management Homepage, DAN |
      | Memiliki order tag "PRIOR", dan                                        |
      | Status granularnya adalah "On vehicle for delivery"                    |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language   | SubMenu                   | TileText                                     |
      | {hub-name-9} | Indonesian | Beranda Manajemen Stasiun | Paket prioritas di "On Vehicle for Delivery" |

  Scenario Outline: Indonesian Tooltip for Total Completion Rate (uid:8a85ecc2-4a5a-4013-a7d1-a83b357b2d15)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <SubMenu>
    And Operator chooses the hub as "<HubName>" displayed in "<Language>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: "<TileText>"
      | Persentase dari waypoint yang dicoba dibagi waypoint yang dirutekan |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language   | SubMenu                   | TileText              |
      | {hub-name-9} | Indonesian | Beranda Manajemen Stasiun | Total Completion Rate |

  Scenario Outline: Indonesian Tooltip for Parcel in Incoming Shipment (uid:83d4ec5b-b5ba-4802-af63-ac8db8a9b8ff)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <SubMenu>
    And Operator chooses the hub as "<HubName>" displayed in "<Language>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: "<TileText>"
      | Waktu kedatangan shipment adalah +/- 24 jam berdasarkan perhitungan ETA, DAN |
      | Status shipment adalah "transit" atau "at transit hub"                       |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language   | SubMenu                   | TileText                                     |
      | {hub-name-9} | Indonesian | Beranda Manajemen Stasiun | Jumlah paket dalam Shipment yang akan datang |

  Scenario Outline: Indonesian Tooltip for Priority Parcel in Hub (uid:6e8e9950-b84d-4644-bfb0-2cdb5c14aadc)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <SubMenu>
    And Operator chooses the hub as "<HubName>" displayed in "<Language>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: "<TileText>"
      | Scan terakhir berada di hub, DAN                                      |
      | Belum terscan inbound driver scan atau shipment van inbound scan, DAN |
      | Memiliki order tag "PRIOR"                                            |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language   | SubMenu                   | TileText               |
      | {hub-name-9} | Indonesian | Beranda Manajemen Stasiun | Paket prioritas di Hub |

  Scenario Outline: Indonesian Tooltip for Unassigned RTS Parcels for Route (uid:7314c484-6320-4f45-b1fb-8c07900acccd)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <SubMenu>
    And Operator chooses the hub as "<HubName>" displayed in "<Language>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: "<TileText>"
      | Hub tujuan RTS adalah hub yang dipilih di Station Management Homepage, DAN |
      | belum dalam dirutekan                                                      |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language   | SubMenu                   | TileText  |
      | {hub-name-9} | Indonesian | Beranda Manajemen Stasiun | For Route |

  Scenario Outline: Indonesian Tooltip for Unassigned RTS Parcels for Shipment (uid:99b7111f-1ab8-4f0d-9262-da0d27d121d6)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> <SubMenu>
    And Operator chooses the hub as "<HubName>" displayed in "<Language>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: "<TileText>"
      | Hub tujuan RTS tidak sama dengan hub yang dipilih pada Station Management Homepage, DAN |
      | belum dimasukkan ke shipment                                                            |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language   | SubMenu                   | TileText     |
      | {hub-name-9} | Indonesian | Beranda Manajemen Stasiun | For Shipment |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op