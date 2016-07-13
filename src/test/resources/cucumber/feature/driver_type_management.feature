Feature: driver type management

  Scenario: op login into operator portal
    Given op is in op portal login page
    When login button is clicked
    When login as "{operator-portal-uid}" with password "{operator-portal-pwd}"
    Then op is in dp administrator

  Scenario: op download driver type management file
    Given op click navigation dp administrator
    Given op click navigation driver type management
    When download driver type management file
    Then driver type management file should exist

  Scenario: op create driver type
    Given op click navigation dp administrator
    Given op click navigation driver type management
    When create driver type button is clicked
    Then created driver type should exist

  Scenario: op edit driver type
    Given op click navigation dp administrator
    Given op click navigation driver type management
    When searching created driver and edit
    Then verify changes of created driver type

  Scenario: op delete driver type
    Given op click navigation dp administrator
    Given op click navigation driver type management
    When searching created driver
    When created driver is deleted
    Then the created driver should not exist

  Scenario: op download driver type management file
    Given op click navigation dp administrator
    Given op click navigation driver type management
    When download driver type management file
    Then driver type management file should exist

  Scenario: op filter driver type management by delivery date
    Given op click navigation dp administrator
    Given op click navigation driver type management
    When driver type management is filtered by Normal Delivery of Delivery Type

  Scenario: op filter driver type management by C2C + Return Pick Up
    Given op click navigation dp administrator
    Given op click navigation driver type management
    When driver type management is filtered by C2C + Return Pick Up of Delivery Type

  Scenario: op filter driver type management by Reservation Pick Up
    Given op click navigation dp administrator
    Given op click navigation driver type management
    When driver type management is filtered by Reservation Pick Up of Delivery Type


  Scenario: op filter driver type management by Priority
    Given op click navigation dp administrator
    Given op click navigation driver type management
    When driver type management is filtered by Priority of Priority Level

  Scenario: op filter driver type management by Non-Priority
    Given op click navigation dp administrator
    Given op click navigation driver type management
    When driver type management is filtered by Non-Priority of Priority Level

  Scenario: op filter driver type management by Less than 3 Parcels
    Given op click navigation dp administrator
    Given op click navigation driver type management
    When driver type management is filtered by Less than 3 Parcels of Reservation Size

  Scenario: op filter driver type management by Less than 10 Parcels
    Given op click navigation dp administrator
    Given op click navigation driver type management
    When driver type management is filtered by Less than 10 Parcels of Reservation Size

  Scenario: op filter driver type management by Trolley Required
    Given op click navigation dp administrator
    Given op click navigation driver type management
    When driver type management is filtered by Trolley Required of Reservation Size

  Scenario: op filter driver type management by Half Van Load
    Given op click navigation dp administrator
    Given op click navigation driver type management
    When driver type management is filtered by Half Van Load of Reservation Size

  Scenario: op filter driver type management by Full Van Load
    Given op click navigation dp administrator
    Given op click navigation driver type management
    When driver type management is filtered by Full Van Load of Reservation Size

  Scenario: op filter driver type management by Larger than Van Load
    Given op click navigation dp administrator
    Given op click navigation driver type management
    When driver type management is filtered by Larger than Van Load of Reservation Size

  Scenario: op filter driver type management by Small
    Given op click navigation dp administrator
    Given op click navigation driver type management
    When driver type management is filtered by Small of Parcel Size

  Scenario: op filter driver type management by Medium
    Given op click navigation dp administrator
    Given op click navigation driver type management
    When driver type management is filtered by Medium of Parcel Size

  Scenario: op filter driver type management by Large
    Given op click navigation dp administrator
    Given op click navigation driver type management
    When driver type management is filtered by Large of Parcel Size

  Scenario: op filter driver type management by Extra Large
    Given op click navigation dp administrator
    Given op click navigation driver type management
    When driver type management is filtered by Extra Large of Parcel Size

  Scenario: op filter driver type management by 9AM to 6PM
    Given op click navigation dp administrator
    Given op click navigation driver type management
    When driver type management is filtered by 9AM to 6PM of Timeslot

  Scenario: op filter driver type management by 9AM to 10PM
    Given op click navigation dp administrator
    Given op click navigation driver type management
    When driver type management is filtered by 9AM to 10PM of Timeslot

  Scenario: op filter driver type management by 9AM to 12PM
    Given op click navigation dp administrator
    Given op click navigation driver type management
    When driver type management is filtered by 9AM to 12PM of Timeslot

  Scenario: op filter driver type management by 12PM to 3PM
    Given op click navigation dp administrator
    Given op click navigation driver type management
    When driver type management is filtered by 12PM to 3PM of Timeslot

  Scenario: op filter driver type management by 3PM to 6PM
    Given op click navigation dp administrator
    Given op click navigation driver type management
    When driver type management is filtered by 3PM to 6PM of Timeslot

  Scenario: op filter driver type management by 6PM to 10PM
    Given op click navigation dp administrator
    Given op click navigation driver type management
    When driver type management is filtered by 6PM to 10PM of Timeslot

  Scenario: op logout from operator portal
    Given op click navigation dp administrator
    When logout button is clicked
    Then op back in the login page
    Then close browser