@OperatorV2 @CoreV2 @PickupAppointment @PresetPickupJobPage
Feature: Preset on pickup jobs page

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{Operator-portal-uid}" and password = "{Operator-portal-pwd}"

  @DeletePickupAppointmentJobPresetFilter @HappyPath
  Scenario: Create preset filters on Pickup Jobs page
    Given API Lighthouse - Operator delete Pickup job preset with name = "testPreset"
    Given Operator goes to Pickup Jobs Page
    Then QA verify filters on Pickup Jobs page are shown
      | dateStart      | {gradle-current-date-dd/MM/yyyy} |
      | priority       | All                              |
      | jobServiceType | Scheduled                        |
      | jobStatus      | Ready for Routing, Routed        |
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
      | dateStart       | {gradle-current-date-dd/MM/yyyy}                                         |
      | priority        | All                                                                      |
      | jobServiceType  | Scheduled                                                                |
      | jobServiceLevel | Premium, Standard                                                        |
      | jobStatus       | Ready for Routing, Routed, In Progress, Cancelled                        |
      | zones           | {zone-name}, {zone-name-3}                                               |
      | shippers        | {normal-shipper-pickup-appointment-1-id} - Pickup Appointment Job Normal |
    When Operator click on Create Modify preset button in pickup appointment
    When Operator click on Save as Preset button in pickup appointment
    When Operator fill Preset name in pickup appointment with = "testPreset"
    When Operator click save in Preset modal in pickup appointment
    Then Operator verify notification is displayed with message = "New Preset Created" and description below:
      | description |
      | testPreset  |
    Given API Lighthouse - Operator get Pickup job preset with name = "testPreset"
    Then QA verify filters on Pickup Jobs page are shown
      | dateStart       | {gradle-current-date-dd/MM/yyyy}                  |
      | priority        | All                                               |
      | jobServiceType  | Scheduled                                         |
      | jobServiceLevel | Premium, Standard                                 |
      | jobStatus       | Ready for Routing, Routed, In Progress, Cancelled |
      | zones           | {zone-name}, {zone-name-3}                        |
      | shippers        | 830859 - Pickup Appointment Job Normal            |

  @DeletePickupAppointmentJobPresetFilter
  Scenario: Update preset filters on Pickup Jobs page
    Given API Lighthouse - Operator delete Pickup job preset with name = "automationCreateNew1"
    Given API Operator create new Preset filters using data below:
      | createPresetFiltersRequest | {"name":"automationCreateNew1","value":{"priority":{"value":"All"},"shippers":[],"masterShippers":[],"zones":[],"jobStatus":[{"value":"ready-for-routing","label":"Ready for Routing"},{"value":"routed","label":"Routed"}],"serviceLevel":[],"serviceType":[{"value":"Scheduled"}]}} |
    Given Operator goes to Pickup Jobs Page
    When Operator select Preset with name = "automationCreateNew1" in pickup appointment
    Then QA verify filters on Pickup Jobs page are shown
      | dateStart      | {gradle-current-date-dd/MM/yyyy} |
      | priority       | All                              |
      | jobServiceType | Scheduled                        |
      | jobStatus      | Ready for Routing, Routed        |
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
    When Operator click on Create Modify preset button in pickup appointment
    When Operator click on Update current Preset button in pickup appointment
    When Operator click save in Preset modal in pickup appointment
    Then Operator verify notification is displayed with message = "Current Preset Updated" and description below:
      | description         |
      | automationCreateNew1 |
    Given Operator goes to Pickup Jobs Page
    When Operator select Preset with name = "automationCreateNew1" in pickup appointment
    Then QA verify filters on Pickup Jobs page are shown
      | dateStart       | {gradle-current-date-dd/MM/yyyy}                  |
      | priority        | All                                               |
      | jobServiceType  | Scheduled                                         |
      | jobServiceLevel | Premium, Standard                                 |
      | jobStatus       | Ready for Routing, Routed, In Progress, Cancelled |
      | zones           | {zone-name}, {zone-name-3}                        |
      | shippers        | 830859 - Pickup Appointment Job Normal            |

  @DeletePickupAppointmentJobPresetFilter
  Scenario: Delete preset filters on Pickup Jobs page
    Given API Lighthouse - Operator delete Pickup job preset with name = "testCreateUsingNewStep"
    Given API Lighthouse - Create Preset Filter For Pickup Appointment Job with data below:
      | createPresetFiltersRequest | {"name":"testCreateUsingNewStep","value":{"priority":{"value":"All"},"shippers":[],"masterShippers":[],"zones":[],"jobStatus":[{"value":"ready-for-routing","label":"Ready for Routing"},{"value":"routed","label":"Routed"}],"serviceLevel":[],"serviceType":[{"value":"Scheduled"}]}} |
    Given Operator goes to Pickup Jobs Page
    When Operator select Preset with name = "testCreateUsingNewStep" in pickup appointment
    When Operator click on Create Modify preset button in pickup appointment
    And Operator click on Delete Preset Preset button in pickup appointment
    When Operator click save in Preset modal in pickup appointment
    Then Operator verify notification is displayed with message = "Preset Deleted" and description below:
      | description            |
      | testCreateUsingNewStep |
    Then Operator goes to Pickup Jobs Page
    When Operator verify Preset with name = "testCreateUsingNewStep" is not in pickup appointment

  @DeletePickupAppointmentJobPresetFilter
  Scenario: Save as new preset filters on Pickup Jobs page
    Given API Lighthouse - Operator delete Pickup job preset with name = "automationCreateNewTestNew"
    Given API Lighthouse - Operator delete Pickup job preset with name = "automationCreateNewTest"
    Given API Operator create new Preset filters using data below:
      | createPresetFiltersRequest | {"name":"automationCreateNewTest","value":{"priority":{"value":"All"},"shippers":[],"masterShippers":[],"zones":[],"jobStatus":[{"value":"ready-for-routing","label":"Ready for Routing"},{"value":"routed","label":"Routed"}],"serviceLevel":[],"serviceType":[{"value":"Scheduled"}]}} |
    Given Operator goes to Pickup Jobs Page
    When Operator select Preset with name = "automationCreateNewTest" in pickup appointment
    Then QA verify filters on Pickup Jobs page are shown
      | dateStart      | {gradle-current-date-dd/MM/yyyy} |
      | priority       | All                              |
      | jobServiceType | Scheduled                        |
      | jobStatus      | Ready for Routing, Routed        |
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
    When Operator click on Create Modify preset button in pickup appointment
    When Operator click on Save as New Preset Preset button in pickup appointment
    When Operator fill Preset name in pickup appointment with = "automationCreateNewTestNew"
    When Operator click save in Preset modal in pickup appointment
    Then Operator verify notification is displayed with message = "New Preset Created" and description below:
      | description                |
      | automationCreateNewTestNew |
