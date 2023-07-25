Feature: Test

  @exclude
  Scenario: Create Driver
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 days next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Testing for automation","availability":true} |

  @exclude @DeleteCreatedPorts @DeleteCreatedHubs
  Scenario: Create Port
    When API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Seaport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |
    When API MM - Operator creates new Port with data below:
      | requestBody | {"type":"Airport","port_code":"GENERATED","port_name":"GENERATED","region":"DEFU","city":"Singapore","system_id":"sg","latitude":-1,"longitude":-1} |

  @exclude
  Scenario: Create Air Haul Trip
    When API MM - Operator creates new "To/From Airport" Air Haul Trip with data below:
      | requestBody | {"origin_hub_id":"{hub-id}","origin_hub_system_id":"sg","destination_hub_id":"{airport-hub-id-1}","destination_hub_system_id":"sg","departure_date_time":"{date: 4 hours next, yyyy-MM-dd'T'HH:mm:ss'Z'}","duration":60,"comment":"Created by automation."} |
    When API MM - Operator creates new "To/From Airport" Air Haul Trip with data below:
      | requestBody | {"origin_hub_id":"{hub-id}","origin_hub_system_id":"sg","destination_hub_id":"{airport-hub-id-1}","destination_hub_system_id":"sg","departure_date_time":"{date: 4 hours next, yyyy-MM-dd'T'HH:mm:ss'Z'}","duration":60,"comment":"Created by automation."} |
      | extraData   | {"drivers":[{"driver_id":1091970,"primary":true,"username":"ianmmdasg","license_expiry_date":"2026-08-01","employment_start_date":"2021-08-09","employment_end_date":"2029-08-01"}]}                                                                        |
    When API MM - Operator creates new "Flight" Air Haul Trip with data below:
      | requestBody | {"origin_hub_id":"{airport-hub-id-1}","origin_hub_system_id":"sg","destination_hub_id":"{airport-hub-id-2}","destination_hub_system_id":"sg","departure_date_time":"{date: 4 hours next, yyyy-MM-dd'T'HH:mm:ss'Z'}","duration":60,"comment":"Created by automation."} |
      | extraData   | {"at_origin_processing_time_min":60,"at_destination_processing_time_min":60,"flight_no":"123"}                                                                                                                                                            |

  @exclude
  Scenario: Create Driver and Assign to Air Haul Trip
    When API MM - Operator creates new Middle Mile Driver with data below:
      | requestBody | {"username":"GENERATED","password":"{default-password}","first_name":"GENERATED","last_name":"GENERATED","license_number":"GENERATED","license_type":"Class 3A","driver_type":"Middle-Mile-Driver","license_expiry_date":"{date: 3 days next, yyyy-MM-dd}","contacts":[{"active":true,"details":"{default-phone}","type":"Mobile Phone"}],"employment_type":"In-House - Full-Time","employment_start_date":"{date: 0 days next, yyyy-MM-dd}","employment_end_date":"{date: 3 days next, yyyy-MM-dd}","hub_id":"{hub-id}","comments":"Testing for automation","availability":true} |
    When API MM - Operator creates new "To/From Airport" Air Haul Trip with data below:
      | requestBody | {"origin_hub_id":"{hub-id}","origin_hub_system_id":"sg","destination_hub_id":"{airport-hub-id-1}","destination_hub_system_id":"sg","departure_date_time":"{date: 4 hours next, yyyy-MM-dd'T'HH:mm:ss'Z'}","duration":60,"comment":"Created by automation."} |
      | extraData   | {"drivers": "KEY_MM_LIST_OF_CREATED_MIDDLE_MILE_DRIVERS[1]"}                                                                                                                                                                                              |

  @exclude
  Scenario: Cleanup Unused Ports
    * Util MM - Clean up unused "airport" data
    * Util MM - Clean up unused "seaport" data

  @exclude @DeleteCreatedShipments
  Scenario: Create Shipment
    When API Operator create multiple 4 new shipment with type "LAND_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
