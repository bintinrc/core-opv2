@selenium
Feature: driver type management

  Scenario: op login into operator portal
    Given op is in op portal login page
    When login button is clicked
    When login as "{operator-portal-uid}" with password "{operator-portal-pwd}"
    Then op is in dp administration

  Scenario: op download driver type management file (uid:a1f987ea-5292-41e3-8781-666e77cd4555)
    Given op click navigation Driver Type Management
    When download driver type management file
    Then driver type management file should exist

  Scenario: op create driver type (uid:ea2463ad-5215-44e5-b566-064ffb81c42c)
    Given op click navigation Driver Type Management
    When create driver type button is clicked
    Then created driver type should exist

  Scenario: op edit driver type (uid:3ec5bf32-68e6-406c-bd05-88c920cc187a)
    Given op click navigation Driver Type Management
    When searching created driver and edit
    Then verify changes of created driver type

  Scenario: op filter driver type management by delivery date (uid:6389d609-4c56-4856-8204-0246bce0f3d0)
    Given op click navigation Driver Type Management
    When driver type management is filtered by Normal Delivery of Delivery Type

  Scenario: op filter driver type management by C2C + Return Pick Up (uid:adf1b75e-e88d-4dfc-99c9-82f4ac3d8e84)
    Given op click navigation Driver Type Management
    When driver type management is filtered by C2C + Return Pick Up of Delivery Type

  Scenario: op filter driver type management by Reservation Pick Up (uid:58a0a7c2-478f-493d-9f7a-dce7b9b80d35)
    Given op click navigation Driver Type Management
    When driver type management is filtered by Reservation Pick Up of Delivery Type

  Scenario: op filter driver type management by Priority (uid:0ee859ee-65c2-4eb3-a2b4-56e8fe25cc2f)
    Given op click navigation Driver Type Management
    When driver type management is filtered by Priority of Priority Level

  Scenario: op filter driver type management by Non-Priority (uid:a781c1ab-02d6-42ff-866e-5421d8b7b180)
    Given op click navigation Driver Type Management
    When driver type management is filtered by Non-Priority of Priority Level

  Scenario: op filter driver type management by Less than 3 Parcels (uid:32f9251f-8ee3-4789-a1b7-0d2cdd4354e8)
    Given op click navigation DP Administration
    Given op click navigation Driver Type Management
    When driver type management is filtered by Less Than 3 Parcels of Reservation Size

  Scenario: op filter driver type management by Less than 10 Parcels (uid:fcb002e7-b1ab-4587-8c23-1d258b8dc4fe)
    Given op click navigation Driver Type Management
    When driver type management is filtered by Less Than 10 Parcels of Reservation Size

  Scenario: op filter driver type management by Trolley Required (uid:a8e592f4-a079-4bc6-bf72-8a3a02acc9a3)
    Given op click navigation Driver Type Management
    When driver type management is filtered by Trolley Required of Reservation Size

  Scenario: op filter driver type management by Half Van Load (uid:976ca5ff-22ae-4b5e-8968-8c705a3ed44f)
    Given op click navigation Driver Type Management
    When driver type management is filtered by Half Van Load of Reservation Size

  Scenario: op filter driver type management by Full Van Load (uid:0fddd96d-3784-4db7-b0a4-a8749c231973)
    Given op click navigation Driver Type Management
    When driver type management is filtered by Full Van Load of Reservation Size

  Scenario: op filter driver type management by Larger than Van Load (uid:7ae0c02a-202d-4d56-8a69-e32adf5be6af)
    Given op click navigation Driver Type Management
    When driver type management is filtered by Larger Than Van Load of Reservation Size

  Scenario: op filter driver type management by Small (uid:d731ae1d-4e4a-4b18-a3d5-503fd69ede7e)
    Given op click navigation Driver Type Management
    When driver type management is filtered by Small of Parcel Size

  Scenario: op filter driver type management by Medium (uid:32ecfa2a-dd8a-4b19-b4de-ca1a74f81471)
    Given op click navigation Driver Type Management
    When driver type management is filtered by Medium of Parcel Size

  Scenario: op filter driver type management by Large (uid:ab9fc83e-8453-4e0f-af9c-05d1384373e9)
    Given op click navigation Driver Type Management
    When driver type management is filtered by Large of Parcel Size

  Scenario: op filter driver type management by Extra Large (uid:8b5bccc3-bda8-4445-99b0-3a9b94877657)
    Given op click navigation Driver Type Management
    When driver type management is filtered by Extra Large of Parcel Size

  Scenario: op filter driver type management by 9AM to 6PM (uid:6ae4ef97-3891-4938-b861-d8addf60fa25)
    Given op click navigation Driver Type Management
    When driver type management is filtered by 9AM To 6PM of Timeslot

  Scenario: op filter driver type management by 9AM to 10PM (uid:0f04a728-a23f-419a-bac3-2712764dfa8b)
    Given op click navigation Driver Type Management
    When driver type management is filtered by 9AM TO 10PM of Timeslot

  Scenario: op filter driver type management by 9AM to 12PM (uid:af8ab673-e4ef-4eae-956c-83c9bcc774de)
    Given op click navigation Driver Type Management
    When driver type management is filtered by 9AM TO 12PM of Timeslot

  Scenario: op filter driver type management by 12PM to 3PM (uid:9dfee534-bcf1-4bf3-8e63-5abba766a73c)
    Given op click navigation Driver Type Management
    When driver type management is filtered by 12PM TO 3PM of Timeslot

  Scenario: op filter driver type management by 3PM to 6PM (uid:8dfca2a0-a406-4e59-9c5c-c00bb61d1bae)
    Given op click navigation Driver Type Management
    When driver type management is filtered by 3PM TO 6PM of Timeslot

  Scenario: op filter driver type management by 6PM to 10PM (uid:a59a9afe-356c-4653-b913-18cf9a77096e)
    Given op click navigation Driver Type Management
    When driver type management is filtered by 6PM TO 10PM of Timeslot

  Scenario: op delete driver type (uid:82959c45-2b6d-4899-98aa-02e88f59793e)
    Given op click navigation Driver Type Management
    When searching created driver
    When created driver is deleted
    Then the created driver should not exist

  @closeBrowser
  Scenario: close browser