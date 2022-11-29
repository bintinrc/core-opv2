@PickupAppointment @JobPage @Part2
Feature: Pickup Appointment Job Page Part 2 - Preset Filter

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{Operator-portal-uid}" and password = "{Operator-portal-pwd}"

  @CreatePresetFilters @DeletePresetFilter
  Scenario: Create preset filters on Pickup Jobs page
    When Operator loads Shipper Address Configuration page Pickup Appointment

    Then QA verify filters on Pickup Jobs page are shown
      | dateStart      | {gradle-current-date-dd/MM/yyyy} |
      | priority       | All                              |
      | jobServiceType | Scheduled                        |
      | jobStatus      | Ready for Routing, Routed        |

    When Operator filled in the filters
      | priority        | Priority                                 |
      | jobServiceLevel | Premium                                  |
      | jobStatus       | Failed                                   |
      | zones           | newZone                                  |
      | masterShippers  | Ninjavan                                 |
      | shippers        | {normal-shipper-pickup-appointment-1-id} |

    And Operator click on Create or Modify Preset button
    And Operator click on Save as Preset button

    Then QA verify Save as Preset modal shown

    When Operator fills in the Preset Name field with a name = "test preset name"
    And Operator click on Save button

    Then QA verify New Preset Created popup shown on top right of the page
    And QA verify the preset name is shown on Preset Filters dropdown on top left of the page
    And QA verify filters on Pickup Jobs page are shown
      | dateStart       | {gradle-current-date-dd/MM/yyyy}                                                      |
      | priority        | Priority                                                                              |
      | jobServiceType  | Scheduled                                                                             |
      | jobServiceLevel | Premium                                                                               |
      | jobStatus       | Ready for Routing, Routed, Failed                                                     |
      | zones           | newZone                                                                               |
      | masterShippers  | Ninjavan                                                                              |
      | shippers        | {normal-shipper-pickup-appointment-1-id} - {normal-shipper-pickup-appointment-1-name} |

    When Operator make API request to get preset id by name

  @UpdatePresetFilters @DeletePresetFilter
  Scenario: Update preset filters on Pickup Jobs page
    Given API Operator create new Preset filters using data below:
      | createPresetFiltersRequest | {"name":"test preset name","value":{"priority":{"value":"All"},"shippers":[],"masterShippers":[],"zones":[],"jobStatus":[{"value":"ready-for-routing","label":"Ready for Routing"},{"value":"routed","label":"Routed"}],"serviceLevel":[],"serviceType":[{"value":"Scheduled"}]}} |

    When Operator loads Shipper Address Configuration page Pickup Appointment
    And Operator fills in the Preset Filters preset with name = "test preset name"

    Then QA verify filters on Pickup Jobs page are shown
      | dateStart      | {gradle-current-date-dd/MM/yyyy} |
      | priority       | All                              |
      | jobServiceType | Scheduled                        |
      | jobStatus      | Ready for Routing, Routed        |

    And Operator filled in the filters
      | priority        | Priority                                 |
      | jobServiceLevel | Premium                                  |
      | jobStatus       | Failed                                   |
      | zones           | newZone                                  |
      | masterShippers   | Ninjavan                                 |
      | shippers        | {normal-shipper-pickup-appointment-1-id} |

    When Operator click on Create or Modify Preset button
    And Operator click on Update Current Preset button

    Then QA verify Update Preset modal shown

    When Operator click on Confirm button

    Then QA verify Current Preset Updated popup shown on top right of the page
    And QA verify filters on Pickup Jobs page are shown
      | dateStart       | {gradle-current-date-dd/MM/yyyy}                                                      |
      | priority        | Priority                                                                              |
      | jobServiceType  | Scheduled                                                                             |
      | jobServiceLevel | Premium                                                                               |
      | jobStatus       | Ready for Routing, Routed, Failed                                                     |
      | zones           | newZone                                                                               |
      | masterShippers  | Ninjavan                                                                              |
      | shippers        | {normal-shipper-pickup-appointment-1-id} - {normal-shipper-pickup-appointment-1-name} |

    When Operator make API request to get preset id by name

  Scenario: Delete preset filters on Pickup Jobs page
    Given API Operator create new Preset filters using data below:
      | createPresetFiltersRequest | {"name":"test preset name","value":{"priority":{"value":"All"},"shippers":[{"value":{normal-shipper-pickup-appointment-1-global-id},"label":"{normal-shipper-pickup-appointment-1-id} - {normal-shipper-pickup-appointment-1-name}"}],"masterShippers":[{"value":36,"label":"Ninjavan"}],"zones":[{"value":33219,"label":"newZone"}],"jobStatus":[{"value":"ready-for-routing","label":"Ready for Routing"},{"value":"routed","label":"Routed"}],"serviceLevel":[{"value":"Premium"}],"serviceType":[{"value":"Scheduled"}]}} |

    When Operator loads Shipper Address Configuration page Pickup Appointment
    And Operator fills in the Preset Filters preset with name = "test preset name"

    Then QA verify filters on Pickup Jobs page are shown
      | dateStart       | {gradle-current-date-dd/MM/yyyy}                                                      |
      | priority        | All                                                                                   |
      | jobServiceType  | Scheduled                                                                             |
      | jobServiceLevel | Premium                                                                               |
      | jobStatus       | Ready for Routing, Routed                                                             |
      | zones           | newZone                                                                               |
      | masterShippers  | Ninjavan                                                                              |
      | shippers        | {normal-shipper-pickup-appointment-1-id} - {normal-shipper-pickup-appointment-1-name} |

    When Operator click on Create or Modify Preset button
    And Operator click on Delete button

    Then QA verify Delete Preset modal shown

    When Operator click on Confirm button

    Then QA verify Preset Deleted popup shown on top right of the page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
