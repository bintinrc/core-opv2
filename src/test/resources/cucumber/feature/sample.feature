@Sample
Feature: Sample Feature

  @LaunchBrowser
  Scenario: Launch browser.

  Scenario: Test Open Google, Yahoo, and Google Roboto font sample.
    When browser open "http://www.w3schools.com/cssref/tryit.asp?filename=trycss3_font-face_rule"
    Then take screenshot with delay 5s
    Then print browser console log

  @KillBrowser
  Scenario: Kill Browser
