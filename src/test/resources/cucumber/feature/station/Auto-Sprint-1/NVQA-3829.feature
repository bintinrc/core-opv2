@StationHome @Story-2
Feature: Number of Parcels In Hub

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @Case-1
  Scenario Outline: Case-1
    Given Operator go to menu Station Management Tool -> Station Management Homepage
    When Operator selects the hub as "<HubName>" and proceed
    Then verifies that the following navigation links are displayed under the header:"<Header1>"
      | Route Engine - Zonal Routing |
      | Parcel Sweeper Live          |
      | Shipment Management          |
      | Shipment Inbound             |
      | Van Inbound                  |
      | Route Log                    |
      | Outbound Monitoring          |
      | Route Monitoring             |
      | Route Inbound                |
      | Recovery                     |
    And verifies that the following navigation links are displayed under the header:"<Header2>"
      | Driver Performance Report |
      | COD Report                |
    And verifies that the page:"<PageName>" is loaded on new tab on clicking the link:"<LinkName>"

    Examples:
      | HubName      | Header1                      | Header2 | PageName                     | LinkName                     | hiptest-uid                              |
      | {hub-name-1} | Standard Operating Procedure | Reports | Route Engine - Zonal Routing | Route Engine - Zonal Routing | uid:c366e948-5a13-4209-874f-fac9db68e439 |
      | {hub-name-1} | Standard Operating Procedure | Reports | Parcel Sweeper Live          | Parcel Sweeper Live          | uid:80a5876f-3679-46e3-b337-17339904b1c3 |
      | {hub-name-1} | Standard Operating Procedure | Reports | Shipment Management          | Shipment Management          | uid:398bb047-3d41-4275-be8c-0cbbf369b667 |
      | {hub-name-1} | Standard Operating Procedure | Reports | Shipment Inbound             | Shipment Inbound             | uid:896cc837-7fe5-4e0c-9ac6-8eac95946522 |
      | {hub-name-1} | Standard Operating Procedure | Reports | Van Inbound                  | Van Inbound                  | uid:78145e86-00d3-4f6d-9f98-0c387d17fba3 |
      | {hub-name-1} | Standard Operating Procedure | Reports | Route Log                    | Route Log                    | uid:f529ec4a-b726-46f4-8fc5-892ccde9e1ff |
      | {hub-name-1} | Standard Operating Procedure | Reports | Outbound Monitoring          | Outbound Monitoring          | uid:cc055202-d5e9-4c07-86e9-4a5274930ce8 |
      | {hub-name-1} | Standard Operating Procedure | Reports | Route Monitoring             | Route Monitoring             | uid:7fb27950-016a-4d86-9eb3-be0fd516f6ac |
      | {hub-name-1} | Standard Operating Procedure | Reports | Route Inbound                | Route Inbound                | uid:0e1412e5-923d-4cae-a3c3-fc56695c3aed |
      | {hub-name-1} | Standard Operating Procedure | Reports | Recovery                     | Recovery                     | uid:65666a52-59e3-4131-91fe-473cdfb046c0 |
      | {hub-name-1} | Standard Operating Procedure | Reports | Driver Performance Report    | Driver Performance Report    | uid:24ee3ae1-9d5c-4615-9ae7-0cbec6776a43 |
      | {hub-name-1} | Standard Operating Procedure | Reports | COD Report                   | COD Report                   | uid:8c31a90a-02b0-490a-8436-c94b9cb656de |


      #| {hub-name-1} | Standard Operating Procedure | Reports | Shipment Management | Shipment Management |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op