@OperatorV2 @CoreV2 @PickupAppointment @PickupAppointmentJobPage1 @FilterPA
Feature: Pickup Appointment Job Page Part 1

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{Operator-portal-uid}" and password = "{Operator-portal-pwd}"

  @ShowHideFilters
  Scenario: Show/hide filters on Pickup Jobs page
    When Operator goes to Pickup Jobs Page
    Then QA verify filters on Pickup Jobs page are shown
      | dateStart      | {gradle-current-date-dd/MM/yyyy} |
      | priority       | All                              |
      | jobServiceType | Scheduled                        |
      | jobStatus      | Ready for Routing, Routed        |
    When Operator click on Show or hide dropdown button
    Then QA verify filters are hidden

  @ClearSelectionFilters
  Scenario: Clear Selection filters on Pickup Jobs page
    When Operator goes to Pickup Jobs Page
    Then Operator fills in the Shippers field with valid shipper = "{normal-shipper-pickup-appointment-1-id}"
    And Operator click on Clear Selection button
    Then QA verify filters on Pickup Jobs page are shown
      | dateStart      | {gradle-current-date-dd/MM/yyyy} |
      | priority       | All                              |
      | jobServiceType | Scheduled                        |
      | jobStatus      | Ready for Routing, Routed        |

  @FillInFilters @HappyPath
  Scenario: Fill in filters on Pickup Jobs page
    When Operator goes to Pickup Jobs Page
    Then QA verify filters on Pickup Jobs page are shown
      | dateStart      | {gradle-current-date-dd/MM/yyyy} |
      | priority       | All                              |
      | jobServiceType | Scheduled                        |
      | jobStatus      | Ready for Routing, Routed        |
    When Operator click Data Range field
    And QA verify data start to end limited to 7 days
    When Operator click Priority field
    Then QA verify a dropdown menu shown with priority option
    When Operator click Job Service Type field
    Then QA verify a service type dropdown menu shown
    When Operator click Job Service Level field
    Then QA verify a service level dropdown menu shown
    And Select multiple service level
    When Operator click Job Status field
    Then QA verify a job status dropdown menu shown
    And Select multiple job Status
    When Operator click Job Zone field
    Then QA verify a zones dropdown menu shown
    And Select multiple job Zone
      | zones | {zone-name}, {zone-name-3} |
    When Operator click Job Shipper field
    And QA verify Shipper list will be shown after operator type 3 characters or more "123" in the Shipper field
    Then Operator fills in the Shippers field with valid shipper = "{normal-shipper-pickup-appointment-1-id}"
    Then QA verify filters on Pickup Jobs page are shown
      | dateStart       | {gradle-current-date-dd/MM/yyyy}                  |
      | priority        | All                                               |
      | jobServiceType  | Scheduled                                         |
      | jobServiceLevel | Premium, Standard                                 |
      | jobStatus       | Ready for Routing, Routed, In Progress, Cancelled |
      | zones           | {zone-name}, {zone-name-3}                        |
      | shippers        | 830859 - Pickup Appointment Job Normal            |

  Scenario: View pickup jobs filters on Pickup Jobs page result table
    When Operator goes to Pickup Jobs Page
    Given Operator clicks "Load Selection" button on Pickup Jobs page
    Then Operator verifies the Table on Pickup Jobs Page

  @HappyPath
  Scenario: View pickup jobs on Pickup Jobs page
    When Operator goes to Pickup Jobs Page
    Then QA verify filters on Pickup Jobs page are shown
      | dateStart      | {gradle-current-date-dd/MM/yyyy} |
      | priority       | All                              |
      | jobServiceType | Scheduled                        |
      | jobStatus      | Ready for Routing, Routed        |
    Given Operator clicks "Load Selection" button on Pickup Jobs page
    Then Operator verifies the Table on Pickup Jobs Page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op