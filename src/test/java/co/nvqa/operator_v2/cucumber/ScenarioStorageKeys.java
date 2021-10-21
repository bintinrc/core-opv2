package co.nvqa.operator_v2.cucumber;

import co.nvqa.commons.cucumber.StandardScenarioStorageKeys;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("unused")
public interface ScenarioStorageKeys extends StandardScenarioStorageKeys {

  String KEY_MAIN_WINDOW_HANDLE = "KEY_MAIN_WINDOW_HANDLE";
  String KEY_PICKUP_INSTRUCTION = "KEY_PICKUP_INSTRUCTION";
  String KEY_DELIVERY_INSTRUCTION = "KEY_DELIVERY_INSTRUCTION";

  String KEY_CREATED_USER_MANAGEMENT = "KEY_CREATED_USER_MANAGEMENT";
  String KEY_UPDATED_USER_MANAGEMENT = "KEY_UPDATED_USER_MANAGEMENT";
  String KEY_SELECTED_GRANT_TYPE = "KEY_SELECTED_GRANT_TYPE";

  String KEY_CREATED_RESERVATION_GROUP = "KEY_CREATED_RESERVATION_GROUP";

  String KEY_IMPLANTED_MANIFEST_HUB_NAME = "KEY_IMPLANTED_MANIFEST_HUB_NAME";
  String KEY_IMPLANTED_MANIFEST_ORDER_SCANNED_AT = "KEY_IMPLANTED_MANIFEST_ORDER_SCANNED_AT";

  String KEY_PRIORITY_LEVELS_TRANSACTION_TO_PRIORITY_LEVEL = "KEY_PRIORITY_LEVELS_TRANSACTION_TO_PRIORITY_LEVEL";

  String KEY_CREATED_MOVEMENT_SCHEDULE = "KEY_CREATED_MOVEMENT_SCHEDULE";
  String KEY_SUB_SHIPPER_SELLER_LEGACY_ID = "KEY_SUB_SHIPPER_SELLER_LEGACY_ID";
  String KEY_SUB_SHIPPER_SELLER_ID = "KEY_SUB_SHIPPER_SELLER_ID";
  String KEY_LIST_SUB_SHIPPER_SELLER_ID = "KEY_LIST_SUB_SHIPPER_SELLER_ID";
  String KEY_LIST_SUB_SHIPPER_SELLER_NAME = "KEY_LIST_SUB_SHIPPER_SELLER_NAME";
  String KEY_LIST_SUB_SHIPPER_SELLER_EMAIL = "KEY_LIST_SUB_SHIPPER_SELLER_EMAIL";

  String KEY_TRIP_ID = "KEY_TRIP_ID";

  String KEY_NUMBER_OF_PARCELS_IN_HUB = "KEY_NUMBER_OF_PARCELS_IN_HUB";
  String KEY_NUMBER_OF_PARCELS_IN_HUB_BY_SIZE = "KEY_NUMBER_OF_PARCELS_IN_HUB_BY_SIZE";
  String KEY_STATION_COD_REPORT_DETAILS_GRID = "KEY_STATION_COD_REPORT_DETAILS_GRID";
}
