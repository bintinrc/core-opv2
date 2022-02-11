@StationManagement @StationHome @StationTooltip
Feature: English (SG, MY, PH)

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario Outline: English Tooltip for COD Collected from Countries (uid:04c0d965-a469-4eea-8d4d-5adf0fe1a065)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: "<TileText>"
      | Route inbound has been done and drivers have handed over the COD/COP collected to the station managers |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language | TileText                    |
      | {hub-name-9} | English  | COD collected from couriers |

  Scenario Outline: English Tooltip for COD not Collected yet from Courier (uid:a0f2595a-a279-4f13-9bef-59b036f167be  )
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: "<TileText>"
      | COD/COP that drivers have collected but have not handed over the cash to the station managers |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language | TileText                            |
      | {hub-name-9} | English  | COD not collected yet from couriers |

  Scenario Outline: English Tooltip for Number of Missing Parcels (uid:9fcfa840-6841-4c31-b045-2f3ff7832e43)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: "<TileText>"
      | PETS tickets assigned to station are missing, AND |
      | Granular status is "on hold", AND                 |
      | Ticket status is not resolved                     |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language | TileText        |
      | {hub-name-9} | English  | Missing parcels |

  Scenario Outline: English Tooltip for Number of Damaged Parcels (uid:e1e47e09-4010-4f33-87ab-1ffebf58f83e)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: "<TileText>"
      | PETS tickets assigned to station are damaged, AND |
      | Granular status is "on hold", AND                 |
      | Ticket status is not resolved                     |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language | TileText        |
      | {hub-name-9} | English  | Damaged parcels |

  Scenario Outline: English Tooltip for Number of Parcels with Exception Cases (uid:7d13d600-1ad4-426c-9ed4-16e5e6ef3fdd)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: "<TileText>"
      | PETS tickets assigned to station are NOT missing or damaged, AND |
      | Granular status is "on hold", AND                                |
      | Ticket status is not resolved                                    |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language | TileText                               |
      | {hub-name-9} | English  | Number of parcels with exception cases |

  Scenario Outline: English Tooltip for Parcel in Hub (uid:861822ab-5f81-4b0f-b7d2-07a9dfc78f6a)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: "<TileText>"
      | Last scan is in hub, AND                                |
      | Has no driver inbound scan or shipment van inbound scan |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language | TileText                 |
      | {hub-name-9} | English  | Number of parcels in hub |

  Scenario Outline: English Tooltip for COD Column (uid:a7838662-8f14-4e2d-83cd-d1ba3a3156af)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    Then Operator verifies that the following text is displayed on hover over the tile text: "<ColumnHeader>"
      | The total COD that drivers have collected but have not handed over to station managers on route level.\n\nIf driver has handed over the COD collected to station manager, "Completed" will be displayed. |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language | TileName                            | ModalName                           | ColumnHeader          |
      | {hub-name-9} | English  | COD not collected yet from couriers | COD not collected yet from couriers | COD Amount to Collect |

  Scenario Outline: English Tooltip for Priority Parcel on Vehicle for Delivery (uid:fa5c4bcf-6112-4493-9c05-4b0f4fc74038)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: "<TileText>"
      | Destination hub is the selected hub on Station Management Homepage, AND |
      | Has a PRIOR order tag, AND                                              |
      | Granular status is "On vehicle for delivery"                            |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language | TileText                                 |
      | {hub-name-9} | English  | Priority parcels on vehicle for delivery |

  Scenario Outline: English Tooltip for Total Completion Rate (uid:2d28aa1c-b979-4eef-ab65-a09e3031d704)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: "<TileText>"
      | Percentage of total number of waypoints attempted out of total number of waypoints routed |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language | TileText              |
      | {hub-name-9} | English  | Total completion rate |

  Scenario Outline: English Tooltip for Parcel in Incoming Shipment (uid:a1b3e582-79ac-4e1f-b6e9-fa34a1e2bdc0)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: "<TileText>"
      | Shipment arrival time is +/- 24 hours based on calculated ETA, AND |
      | Shipment status is "transit" or "at transit hub"                   |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language | TileText                     |
      | {hub-name-9} | English  | Parcels in incoming shipment |

  Scenario Outline: English Tooltip for Priority Parcel in Hub (uid:fb084202-15f6-44fa-becd-7a06472c2298)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: "<TileText>"
      | Last scan is in hub, AND                                     |
      | Has no driver inbound scan or shipment van inbound scan, AND |
      | Has a PRIOR order tag.                                       |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language | TileText                |
      | {hub-name-9} | English  | Priority parcels in hub |

  Scenario Outline: English Tooltip for Unassigned RTS Parcels for Route (uid:d37ff887-2eef-469c-9a97-a70bf9e9c3b5)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: "<TileText>"
      | RTS destination hub is the selected hub on Station Management Homepage, AND |
      | Not in a route yet                                                          |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language | TileText  |
      | {hub-name-9} | English  | For Route |

  Scenario Outline: English Tooltip for Unassigned RTS Parcels for Shipment (uid:34f7b8c4-d922-4d8a-8de7-24072f1d2b05)
    Given Operator loads Operator portal home page
    And Operator opens profile and navigates to settings screen
    When Operator selects language as "<Language>"
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    Then Operator verifies that the following text is displayed on hover over the tile text: "<TileText>"
      | RTS destination hub is not the same as the selected hub on Station Management Homepage, AND |
      | Not added to a shipment yet                                                                 |
    And Operator verifies that the mouseover text is not displayed on moving away from the tile title

    Examples:
      | HubName      | Language | TileText     |
      | {hub-name-9} | English  | For Shipment |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op