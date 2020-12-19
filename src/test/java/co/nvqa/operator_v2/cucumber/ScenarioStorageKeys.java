package co.nvqa.operator_v2.cucumber;

import co.nvqa.commons.cucumber.StandardScenarioStorageKeys;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("unused")
public interface ScenarioStorageKeys extends StandardScenarioStorageKeys {

  String KEY_ROUTE_GROUP_NAME = "KEY_ROUTE_GROUP_NAME";
  String KEY_LIST_OF_ROUTE_GROUP_NAMES = "KEY_LIST_OF_ROUTE_GROUP_NAMES";
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

  String KEY_CREATED_ZONE = "KEY_CREATED_ZONE";
  String KEY_SUB_SHIPPER_SELLER_IDS = "KEY_SUB_SHIPPER_SELLER_IDS";

  String KEY_ORDER_BILLING_SSB_URL = "KEY_ORDER_BILLING_SSB_URL";
  String KEY_ORDER_BILLING_SSB_AGGREGATED_DATA = "KEY_ORDER_BILLING_SSB_AGGREGATED_DATA";
  String KEY_ORDER_BILLING_PRICED_ORDER_DETAILS_CSV = "KEY_ORDER_BILLING_PRICED_ORDER_DETAILS_CSV";
  String KEY_ORDER_BILLING_CSV_FILE_COUNT = "KEY_ORDER_BILLING_CSV_FILE_COUNT";

  String KEY_TRIP_ID = "KEY_TRIP_ID";
}
