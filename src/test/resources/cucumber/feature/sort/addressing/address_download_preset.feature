@Sort @AddressDownload
Feature: Address Download

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Create New Filter Preset With Address Status Filter Successfully - Verified (uid:40a315d1-a519-476a-8010-766cde6e215d)
    Given Operator go to menu Addressing -> Address Download
    Then Operator verifies that the page is fully loaded
    When Operator clicks on the ellipses
    And Operator clicks on "create" Preset Option on the Address Download Page
    And Operator creates a preset using "address_status_verified" filter
    Then Operator verifies that there will be success preset creation toast shown
    And Operator verifies that the created preset is existed
    When Operator deletes the created preset
    Then Operator verifies that there will be success preset deletion toast shown
    And Operator verifies that the created preset is deleted

  Scenario: Create New Filter Preset With Address Status Filter Successfully - Unverified (uid:6ad12dbf-3b6d-44ff-abcb-60267f96e8b9)
    Given Operator go to menu Addressing -> Address Download
    Then Operator verifies that the page is fully loaded
    When Operator clicks on the ellipses
    And Operator clicks on "create" Preset Option on the Address Download Page
    And Operator creates a preset using "address_status_unverified" filter
    Then Operator verifies that there will be success preset creation toast shown
    And Operator verifies that the created preset is existed
    When Operator deletes the created preset
    Then Operator verifies that there will be success preset deletion toast shown
    And Operator verifies that the created preset is deleted

  Scenario: Create New Filter Preset With Shipper Filter Successfully (uid:f12b234a-92cd-40a4-962a-58fc1c456633)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Addressing -> Address Download
    Then Operator verifies that the page is fully loaded
    When Operator clicks on the ellipses
    And Operator clicks on "create" Preset Option on the Address Download Page
    And Operator creates a preset using "shipper_ids" filter
    Then Operator verifies that there will be success preset creation toast shown
    And Operator verifies that the created preset is existed
    When Operator deletes the created preset
    Then Operator verifies that there will be success preset deletion toast shown
    And Operator verifies that the created preset is deleted

  Scenario: Create New Filter Preset With Master Shipper Filter Successfully (uid:13485982-b5e3-46e9-8ff4-959737c7fe69)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Addressing -> Address Download
    Then Operator verifies that the page is fully loaded
    When Operator clicks on the ellipses
    And Operator clicks on "create" Preset Option on the Address Download Page
    And Operator creates a preset using "marketplace_ids" filter
    Then Operator verifies that there will be success preset creation toast shown
    And Operator verifies that the created preset is existed
    When Operator deletes the created preset
    Then Operator verifies that there will be success preset deletion toast shown
    And Operator verifies that the created preset is deleted

  Scenario: Create New Filter Preset With Zone Filter Successfully (uid:c4008989-7412-48af-b00a-44f8893543e1)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Addressing -> Address Download
    Then Operator verifies that the page is fully loaded
    When Operator clicks on the ellipses
    And Operator clicks on "create" Preset Option on the Address Download Page
    And Operator creates a preset using "zone_ids" filter
    Then Operator verifies that there will be success preset creation toast shown
    And Operator verifies that the created preset is existed
    When Operator deletes the created preset
    Then Operator verifies that there will be success preset deletion toast shown
    And Operator verifies that the created preset is deleted

  Scenario: Create New Filter Preset With Destination Hub Filter Successfully (uid:b5c68510-b791-4dc1-8b24-aad229aced28)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Addressing -> Address Download
    Then Operator verifies that the page is fully loaded
    When Operator clicks on the ellipses
    And Operator clicks on "create" Preset Option on the Address Download Page
    And Operator creates a preset using "hub_ids" filter
    Then Operator verifies that there will be success preset creation toast shown
    And Operator verifies that the created preset is existed
    When Operator deletes the created preset
    Then Operator verifies that there will be success preset deletion toast shown
    And Operator verifies that the created preset is deleted

  Scenario: Create New Filter Preset With RTS Filter Successfully - No (uid:2d0c6714-6451-4d5e-b92b-33b03489742e)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Addressing -> Address Download
    Then Operator verifies that the page is fully loaded
    When Operator clicks on the ellipses
    And Operator clicks on "create" Preset Option on the Address Download Page
    And Operator creates a preset using "rts_no" filter
    Then Operator verifies that there will be success preset creation toast shown
    And Operator verifies that the created preset is existed
    When Operator deletes the created preset
    Then Operator verifies that there will be success preset deletion toast shown
    And Operator verifies that the created preset is deleted

  Scenario: Create New Filter Preset With RTS Filter Successfully - Yes (uid:3cafa693-247b-49c5-91dc-b3b0e25f3664)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Addressing -> Address Download
    Then Operator verifies that the page is fully loaded
    When Operator clicks on the ellipses
    And Operator clicks on "create" Preset Option on the Address Download Page
    And Operator creates a preset using "rts_yes" filter
    Then Operator verifies that there will be success preset creation toast shown
    And Operator verifies that the created preset is existed
    When Operator deletes the created preset
    Then Operator verifies that there will be success preset deletion toast shown
    And Operator verifies that the created preset is deleted

  Scenario: Search Filter Preset (uid:b00356ed-c52a-4279-9850-00a4c779c0da)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Addressing -> Address Download
    Then Operator verifies that the page is fully loaded
    When Operator clicks on the ellipses
    And Operator clicks on "create" Preset Option on the Address Download Page
    And Operator creates a preset using "address_status_verified" filter
    Then Operator verifies that there will be success preset creation toast shown
    And Operator verifies that the created preset is existed
    When Operator deletes the created preset
    Then Operator verifies that there will be success preset deletion toast shown
    And Operator verifies that the created preset is deleted

  Scenario: Update Filter Successfully (uid:e6828599-7d51-4702-9994-488275d2047f)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Addressing -> Address Download
    Then Operator verifies that the page is fully loaded
    When Operator clicks on the ellipses
    And Operator clicks on "create" Preset Option on the Address Download Page
    And Operator creates a preset using "address_status_verified" filter
    Then Operator verifies that there will be success preset creation toast shown
    And Operator verifies that the created preset is existed
    When Operator clicks on the ellipses
    And Operator clicks on "edit" Preset Option on the Address Download Page
    And Operator edits the created preset
    Then Operator verifies that there will be success preset edit toast shown
    When Operator deletes the created preset
    Then Operator verifies that there will be success preset deletion toast shown
    And Operator verifies that the created preset is deleted

  Scenario: Delete Filter Successfully (uid:12a4de1c-9954-4d13-afcf-194405309dd8)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Addressing -> Address Download
    Then Operator verifies that the page is fully loaded
    When Operator clicks on the ellipses
    And Operator clicks on "create" Preset Option on the Address Download Page
    And Operator creates a preset using "address_status_verified" filter
    Then Operator verifies that there will be success preset creation toast shown
    And Operator verifies that the created preset is existed
    When Operator deletes the created preset
    Then Operator verifies that there will be success preset deletion toast shown
    And Operator verifies that the created preset is deleted

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op