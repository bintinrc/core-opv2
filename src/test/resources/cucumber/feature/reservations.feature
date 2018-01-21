@OperatorV2Disabled @Reservations
Feature: Reservations

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  Scenario: Operator create new Reservation (uid:b2a5084c-16f9-42ce-9203-131574e5f3d2)
    Given API Operator create new shipper address using data below:
      | shipperId       | {shipper-v2-id} |
      | generateAddress | RANDOM          |
    Given Operator go to menu Shipper Support -> Reservations
    When Operator create new Reservation using data below:
      | shipperName  | {shipper-v2-name}   |
      | timeslot     | 9AM-12PM            |
      | approxVolume | Less than 3 Parcels |
    Then Operator verify the new Reservation is created successfully
      | expectedTimeslotTextOnCalendar | 10:00 AM - 1:00 PM |

  Scenario: Operator create and edit Reservation (uid:a7b7630f-5723-45c4-9575-1b9ed572be17)
    Given API Operator create new shipper address using data below:
      | shipperId       | {shipper-v2-id} |
      | generateAddress | RANDOM          |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper Support -> Reservations
    When Operator create new Reservation using data below:
      | shipperName  | {shipper-v2-name}   |
      | timeslot     | 9AM-12PM            |
      | approxVolume | Less than 3 Parcels |
    Then Operator verify the new Reservation is created successfully
      | expectedTimeslotTextOnCalendar | 10:00 AM - 1:00 PM |
    When Operator update the new Reservation using data below:
      | timeslot     | 12PM-3PM          |
    Then Operator verify the new Reservation is updated successfully
      | expectedTimeslotTextOnCalendar | 12:00 PM - 3:00 PM |

  Scenario: Operator create and delete Reservation (uid:4d256cf6-cada-491d-855f-900e7f01c8d6)
    Given API Operator create new shipper address using data below:
      | shipperId       | {shipper-v2-id} |
      | generateAddress | RANDOM          |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper Support -> Reservations
    When Operator create new Reservation using data below:
      | shipperName  | {shipper-v2-name}   |
      | timeslot     | 9AM-12PM            |
      | approxVolume | Less than 3 Parcels |
    Then Operator verify the new Reservation is created successfully
      | expectedTimeslotTextOnCalendar | 10:00 AM - 1:00 PM |
    When Operator delete the new Reservation
    Then Operator verify the new Reservation is deleted successfully

  Scenario: Operator create, edit, and delete Reservation (uid:7d8deed7-7ccd-4d29-8645-16aa43a90931)
    Given API Operator create new shipper address using data below:
      | shipperId       | {shipper-v2-id} |
      | generateAddress | RANDOM          |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Shipper Support -> Reservations
    When Operator create new Reservation using data below:
      | shipperName  | {shipper-v2-name}   |
      | timeslot     | 9AM-12PM            |
      | approxVolume | Less than 3 Parcels |
    Then Operator verify the new Reservation is created successfully
      | expectedTimeslotTextOnCalendar | 10:00 AM - 1:00 PM |
    Then Operator verify the new Reservation is created successfully
      | expectedTimeslotTextOnCalendar | 10:00 AM - 1:00 PM |
    When Operator update the new Reservation using data below:
      | timeslot     | 12PM-3PM          |
    When Operator delete the new Reservation
    Then Operator verify the new Reservation is deleted successfully

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
