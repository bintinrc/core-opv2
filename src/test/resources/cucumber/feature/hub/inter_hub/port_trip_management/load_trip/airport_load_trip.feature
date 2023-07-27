@OperatorV2 @MiddleMile @Hub @InterHub @PortTripManagement @AirportLoadTrip
Feature: Airport Trip Management - Load Trip

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
	Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @HappyPath
  Scenario: Load Air Haul Trip by Departure Date
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Port Trip Management
	And Operator verifies that the Port Management Page is opened
	When Operator fill the departure date for Port Management
	  | startDate | {date: 1 days ago, yyyy-MM-dd-HH-mm}  |
	  | endDate   | {date: 1 days next, yyyy-MM-dd-HH-mm} |
	And Operator click on 'Load Trips' on Port Management
	Then Verify the parameters of loaded trips in Port Management
	  | startDate           | {date: 1 days ago, yyyy-MM-dd-HH-mm}  |
	  | endDate             | {date: 1 days next, yyyy-MM-dd-HH-mm} |
	  | originOrDestination | -                                     |

  Scenario: Load Air Haul Trip by Departure Date and Origin Facilities
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Port Trip Management
	And Operator verifies that the Port Management Page is opened
	When Operator fill the departure date for Port Management
	  | startDate | {date: 1 days ago, yyyy-MM-dd-HH-mm}  |
	  | endDate   | {date: 1 days next, yyyy-MM-dd-HH-mm} |
	When Operator fill the Origin Or Destination for Port Management
	  | originOrDestination | {local-airport-1-code} (Airport);{local-airport-2-code} (Airport) |
	And Operator click on 'Load Trips' on Port Management
	Then Verify the parameters of loaded trips in Port Management
	  | startDate           | {date: 1 days ago, yyyy-MM-dd-HH-mm}                               |
	  | endDate             | {date: 1 days next, yyyy-MM-dd-HH-mm}                              |
	  | originOrDestination | {local-airport-1-code} (Airport), {local-airport-2-code} (Airport) |

  Scenario: Load Air Haul Trip by Departure Date and Destination Facilities
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Port Trip Management
	And Operator verifies that the Port Management Page is opened
	When Operator fill the departure date for Port Management
	  | startDate | {date: 1 days ago, yyyy-MM-dd-HH-mm}  |
	  | endDate   | {date: 1 days next, yyyy-MM-dd-HH-mm} |
	When Operator fill the Origin Or Destination for Port Management
	  | originOrDestination | {local-airport-1-code} (Airport);{local-airport-2-code} (Airport) |
	And Operator click on 'Load Trips' on Port Management
	Then Verify the parameters of loaded trips in Port Management
	  | startDate           | {date: 1 days ago, yyyy-MM-dd-HH-mm}                               |
	  | endDate             | {date: 1 days next, yyyy-MM-dd-HH-mm}                              |
	  | originOrDestination | {local-airport-1-code} (Airport), {local-airport-2-code} (Airport) |

  @HappyPath
  Scenario: Load Air Haul Trip by Departure Date, Origin and Destination Facilities
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Port Trip Management
	And Operator verifies that the Port Management Page is opened
	When Operator fill the departure date for Port Management
	  | startDate | {date: 1 days ago, yyyy-MM-dd-HH-mm}  |
	  | endDate   | {date: 1 days next, yyyy-MM-dd-HH-mm} |
	When Operator fill the Origin Or Destination for Port Management
	  | originOrDestination | {local-airport-1-code} (Airport);{local-airport-2-code} (Airport);{local-airport-3-code} (Airport) |
	And Operator click on 'Load Trips' on Port Management
	Then Verify the parameters of loaded trips in Port Management
	  | startDate           | {date: 1 days ago, yyyy-MM-dd-HH-mm}                                                                 |
	  | endDate             | {date: 1 days next, yyyy-MM-dd-HH-mm}                                                                |
	  | originOrDestination | {local-airport-1-code} (Airport), {local-airport-2-code} (Airport), {local-airport-3-code} (Airport) |

  @HappyPath
  Scenario: Load Air Haul Trip by Departure Date and 4 Origin/Destination Facilities
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Port Trip Management
	And Operator verifies that the Port Management Page is opened
	When Operator fill the departure date for Port Management
	  | startDate | {date: 1 days ago, yyyy-MM-dd-HH-mm}  |
	  | endDate   | {date: 1 days next, yyyy-MM-dd-HH-mm} |
	When Operator fill the Origin Or Destination for Port Management
	  | originOrDestination | {local-airport-1-code} (Airport);{local-airport-2-code} (Airport);{local-airport-3-code} (Airport);{local-disabled-airport-code} (Airport) |
	And Verify operator cannot fill more than 4 Origin Or Destination for Port Management
	And Operator click on 'Load Trips' on Port Management
	Then Verify the parameters of loaded trips in Port Management
	  | startDate           | {date: 1 days ago, yyyy-MM-dd-HH-mm}                                                                                                          |
	  | endDate             | {date: 1 days next, yyyy-MM-dd-HH-mm}                                                                                                         |
	  | originOrDestination | {local-airport-1-code} (Airport), {local-airport-2-code} (Airport), {local-airport-3-code} (Airport), {local-disabled-airport-code} (Airport) |

  @HappyPath
  Scenario: Load Air Haul Trip by 1 month range Departure Date
	Given Operator go to menu Shipper Support -> Blocked Dates
	Given Operator go to menu Inter-Hub -> Port Trip Management
	And Operator verifies that the Port Management Page is opened
	When Operator fill the departure date for Port Management
	  | startDate | {date: 1 days ago, yyyy-MM-dd-HH-mm}   |
	  | endDate   | {date: 28 days next, yyyy-MM-dd-HH-mm} |
	When Operator fill the Origin Or Destination for Port Management
	  | originOrDestination | {local-airport-1-code} (Airport);{local-airport-2-code} (Airport);{local-airport-3-code} (Airport);{local-disabled-airport-code} (Airport) |
	And Operator click on 'Load Trips' on Port Management
	Then Verify the parameters of loaded trips in Port Management
	  | startDate           | {date: 1 days ago, yyyy-MM-dd-HH-mm}                                                                                                          |
	  | endDate             | {date: 28 days next, yyyy-MM-dd-HH-mm}                                                                                                        |
	  | originOrDestination | {local-airport-1-code} (Airport), {local-airport-2-code} (Airport), {local-airport-3-code} (Airport), {local-disabled-airport-code} (Airport) |


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
	Given no-op
