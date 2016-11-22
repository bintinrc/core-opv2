@Sample
Feature: Sample Feature

  @LaunchBrowser
  Scenario: Launch browser.

  Scenario: Test Open Google, Yahoo, and Google Roboto font sample.
    When browser open "https://github.com/"
    Then take screenshot with delay 10s
    When browser open "https://www.google.co.id/?gws_rd=cr&ei=l8EzWNqJB5-SvQSY9A0#q=karyasarma"
    Then take screenshot with delay 20s
    When browser open "https://id.search.yahoo.com/search?p=karyasarma&fr=yfp-t-713"
    Then take screenshot with delay 20s
    When browser open "https://fonts.google.com/specimen/Roboto"
    Then take screenshot with delay 10s

  @KillBrowser
  Scenario: Kill Browser
