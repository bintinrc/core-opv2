@OperatorV2 @Driver @Fleet @DriverAnnouncementV2
Feature: Driver Announcement

  Background:
    When Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator Open an Announcement on Driver Announcement page
    Given Operator loads Operator portal home page
    And Operator go to menu Fleet -> Driver Announcement
    And Operator select the first row on Driver Announcement page
    Then Operator close announcement drawer on Driver Announcement page

  Scenario: Operator Open a Payroll Report on Driver Announcement page
    Given Operator loads Operator portal home page
    And Operator go to menu Fleet -> Driver Announcement
    And Operator select the first row on Driver Announcement page
    And Operator verify csv file attach in Driver Announcement drawer
    Then Operator close announcement drawer on Driver Announcement page

  Scenario Outline: Operator Search Announcement by "<category>"
    Given Operator loads Operator portal home page
    And Operator go to menu Fleet -> Driver Announcement
    And Operator search "<keyword>" on Driver Announcement page
    And Operator select the first row on Driver Announcement page
    Then Operator verifies announcement "<category>" contains "<keyword>"
    Examples:
      | category | keyword |
      | title    | Payroll |
      | body     | Payroll |

  Scenario: Operator Send New Normal Announcement
    Given Operator loads Operator portal home page
    And Operator go to menu Fleet -> Driver Announcement
    And Operator create normal Announcement on Driver Announcement page
      | recipientType | All                        |
      | recipient     | QA automation announcement |
      | subject       | Automation test            |
      | isImportant   | false                      |
      | body          | This is an automation test |
    Then Operator verify Driver Announcement successfully sent

  Scenario: Operator Send New Important Normal Announcement
    Given Operator loads Operator portal home page
    And Operator go to menu Fleet -> Driver Announcement
    And Operator create normal Announcement on Driver Announcement page
      | recipientType | All                        |
      | recipient     | QA automation announcement |
      | subject       | Automation test            |
      | isImportant   | true                       |
      | body          | This is an automation test |
    Then Operator verify Driver Announcement successfully sent

  Scenario: Operator Send New HTML Announcement
    Given Operator loads Operator portal home page
    And Operator go to menu Fleet -> Driver Announcement
    And Operator create normal Announcement on Driver Announcement page
      | recipientType | All                                 |
      | recipient     | QA automation announcement          |
      | subject       | Automation test                     |
      | isImportant   | true                                |
      | html          | <h1>This is an automation test</h1> |
    Then Operator verify Driver Announcement successfully sent


