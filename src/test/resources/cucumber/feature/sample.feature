@Sample
Feature: Sample Feature

  @LaunchBrowser
  Scenario: Launch browser.

  Scenario: Test Open Google, Yahoo, and Google Roboto font sample.
    When browser open "https://www.traveloka.com/"
    Then take screenshot with delay 1s
    Then print browser console log
    When browser open "https://www.google.com"
    Then take screenshot with delay 2s
    Then print browser console log
    When browser open "https://id.search.yahoo.com/search?p=karyasarma&fr=yfp-t-713"
    Then take screenshot with delay 2s
    Then print browser console log
    When browser open "https://fonts.google.com/specimen/Roboto"
    Then take screenshot with delay 1s
    Then print browser console log

  @KillBrowser
  Scenario: Kill Browser
