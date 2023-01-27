@DeleteCreatedZone @DeleteDriver @Skip
Scenario: Load Reserve Fleet Driver Involved by Selecting Zone (uid:xxx)
Given API Operator create zone using data below:
| hubName | {hub-name} |
| hubId   | {hub-id}   |
And API Operator create new Driver using data below:
| driverCreateRequest | {"driver":{"availability":true,"codLimit":100,"comments":"This driver is created by \"Automation Test\" for testing purpose.","contacts":[{"active":true,"details":"{{DRIVER_CONTACT_DETAIL}}","type":"{contact-type-name}"}],"driverType":"{driver-type-name}","employmentStartDate":"{gradle-current-date-yyyy-MM-dd}","firstName":"{{RANDOM_FIRST_NAME}}","hubId":381,"lastName":"{{RANDOM_LAST_NAME}}","licenseNumber":"D{{TIMESTAMP}}","maxOnDemandJobs":1,"password":"D00{{TIMESTAMP}}","tags":{},"username":"D{{TIMESTAMP}}","vehicles":[{"active":true,"capacity":100,"ownVehicle":false,"vehicleNo":"D{{TIMESTAMP}}","vehicleType":"{vehicle-type}"}],"zonePreferences":[{"cost":1,"latitude":"{{RANDOM_LATITUDE}}","longitude":"{{RANDOM_LONGITUDE}}","maxWaypoints":1,"minWaypoints":1,"rank":1,"zoneId":{KEY_LIST_OF_CREATED_ZONES_ID[1]}}]}} |
And DB Operator sets flags of driver with id "{KEY_LIST_OF_CREATED_DRIVERS[1].id}" to 1
When Operator go to menu Fleet -> Driver Seeding
And Operator refresh page
And Operator selects zones on Driver Seeding page:
| {KEY_LIST_OF_CREATED_ZONES[1].name} |
And Operator check 'Reserve Fleet Drivers' checkbox on Driver Seeding page
Then Following drivers are listed on Driver Seeding page:
| {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName} |
And Following drivers are displayed on the map on Driver Seeding page:
| {KEY_LIST_OF_CREATED_DRIVERS[1].getFullName} |