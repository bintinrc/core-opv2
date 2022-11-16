@CWF @ShouldAlwaysRun
Feature: Pickup Appointment Job Page Part 1

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ShowHideFilters
  Scenario: Show/hide filters on Pickup Jobs page
    When Operator loads Shipper Address Configuration page Pickup Appointment

    Then qa verify filters on Pickup Jobs page are shown
      | dateStart      | {gradle-current-date-dd/MM/yyyy} |
      | priority       | All                              |
      | jobServiceType | Scheduled                        |
      | jobStatus      | Ready for Routing, Routed        |

    When Operator click on Show or hide dropdown button
    Then qa verify filters are hidden

  @ClearSelectionFilters
  Scenario: Clear Selection filters on Pickup Jobs page
    When Operator loads Shipper Address Configuration page Pickup Appointment
    And Operator fills in the Shippers field with valid shipper = "{normal-shipper-pickup-appointment-1-id}"
    And Operator click on Clear Selection button

    Then qa verify filters on Pickup Jobs page are shown
      | dateStart      | {gradle-current-date-dd/MM/yyyy} |
      | priority       | All                              |
      | jobServiceType | Scheduled                        |
      | jobStatus      | Ready for Routing, Routed        |

  @FillInFilters
  Scenario: Fill in filters on Pickup Jobs page
    When Operator loads Shipper Address Configuration page Pickup Appointment
    Then qa verify filters on Pickup Jobs page are shown
      | dateStart      | {gradle-current-date-dd/MM/yyyy} |
      | priority       | All                              |
      | jobServiceType | Scheduled                        |
      | jobStatus      | Ready for Routing, Routed        |

    When operator click Preset Filters field
    Then qa verify dropdown menu shown with a list of saved preset

    When operator click Data Range field
#    Then qa verify a data range picker shown
#    And qa verify data start to end limited to 7 days

#    When operator click Priority field
    Then qa verify a dropdown menu shown with priority option

    When operator click Job Service Type field
    Then qa verify a dropdown menu shown with no data

    When operator click Job Service Level field
    Then qa verify a dropdown menu shown with job service level option
#    And qa verify fields allow multiple input

    When operator click Job Status field
    Then qa verify a dropdown menu shown with job status option

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op