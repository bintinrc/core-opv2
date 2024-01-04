package co.nvqa.operator_v2.util;

import co.nvqa.common.ui.support.CommonUiTestConstants;

/**
 * @author Soewandi Wirjawan
 */
@SuppressWarnings("WeakerAccess")
public final class TestConstants extends CommonUiTestConstants {

  public static final String OPERATOR_PORTAL_BASE_URL;
  public static final String DASH_PORTAL_BASE_URL;
  public static final String OPERATOR_PORTAL_LOGIN_URL;

  public static final String OPERATOR_PORTAL_ALL_ORDER_URL;
  public static final String OPERATOR_PORTAL_UID;
  public static final String OPERATOR_PORTAL_PWD;
  public static final boolean OPERATOR_PORTAL_FORCE_LOGIN_BY_INJECTING_COOKIES;
  public static final String OPERATOR_PORTAL_USER_COOKIE;
  public static final String OPERATOR_PORTAL_COOKIE_DOMAIN;
  public static final String CSV_UPLOAD_FILE_NAME;

  public static final long SHIPPER_V2_ID;
  public static final long SHIPPER_V2_LEGACY_ID;
  public static final String SHIPPER_V2_NAME;
  public static final String SHIPPER_V2_CLIENT_ID;
  public static final String SHIPPER_V2_CLIENT_SECRET;

  public static final long SHIPPER_V4_ID;
  public static final long SHIPPER_V4_LEGACY_ID;
  public static final String SHIPPER_V4_NAME;
  public static final String SHIPPER_V4_CLIENT_ID;
  public static final String SHIPPER_V4_CLIENT_SECRET;

  public static final long NINJA_DRIVER_ID;
  public static final String NINJA_DRIVER_NAME;
  public static final String NINJA_DRIVER_USERNAME;
  public static final String NINJA_DRIVER_PASSWORD;

  public static final long HUB_ID;
  public static final String HUB_NAME;

  public static String SORT_BELT_MANAGER_DEVICE;
  public static String SORT_BELT_MANAGER_HUB;
  public static Integer SORT_BELT_MANAGER_DEVICE_ARMS_COUNT;
  public static String SORT_BELT_MANAGER_DEFAULT_LOGIC;

  public static final int VERY_LONG_WAIT_FOR_TOAST = 90;

  public static final String ADDRESSING_PRESET_NAME;
  public static final String ADDRESSING_SHIPPER_NAME;

  public static final long OPV2_DP_DP_ID;
  public static final long OPV2_DP_BULK_UPDATE_SAME_PARTNER_ID;
  public static final long OPV2_DP_BULK_UPDATE_INACTIVE_ID;
  public static final long SAME_PARTNER_BULK_UPDATE_OPV2_DP_1_ID;
  public static final long SAME_PARTNER_BULK_UPDATE_OPV2_DP_2_ID;
  public static final long SAME_PARTNER_BULK_UPDATE_OPV2_DP_3_ID;
  public static final long IMDA_PICK_BULK_UPDATE_OPV2_DP_1_ID;
  public static final long IMDA_PICK_BULK_UPDATE_OPV2_DP_2_ID;
  public static final long RPM_SHIPPER_ID;
  public static final long RPM_SHIPPER_ID_LEGACY;

  static {
    OPERATOR_PORTAL_BASE_URL = NV_API_BASE.replace("api", "operatorv2") + "/#";
    DASH_PORTAL_BASE_URL = getString("dash-portal-base-url");
    OPERATOR_PORTAL_LOGIN_URL = OPERATOR_PORTAL_BASE_URL + "/login";
    OPERATOR_PORTAL_ALL_ORDER_URL = OPERATOR_PORTAL_BASE_URL + "/order";
    OPERATOR_PORTAL_UID = getString("operator-portal-uid");
    OPERATOR_PORTAL_PWD = getString("operator-portal-pwd");

    OPERATOR_PORTAL_FORCE_LOGIN_BY_INJECTING_COOKIES = getBoolean(
        "operator-portal-force-login-by-injecting-cookies");
    OPERATOR_PORTAL_USER_COOKIE = getString("operator-portal-user-cookie");
    OPERATOR_PORTAL_COOKIE_DOMAIN = getString("operator-portal-cookie-domain");
    CSV_UPLOAD_FILE_NAME = getString("csv-upload-file-name");

    SHIPPER_V2_ID = getLong("shipper-v2-id");
    SHIPPER_V2_LEGACY_ID = getLong("shipper-v2-legacy-id");
    SHIPPER_V2_NAME = getString("shipper-v2-name");
    SHIPPER_V2_CLIENT_ID = getString("shipper-v2-client-id");
    SHIPPER_V2_CLIENT_SECRET = getString("shipper-v2-client-secret");

    SHIPPER_V4_ID = getLong("shipper-v4-id");
    SHIPPER_V4_LEGACY_ID = getLong("shipper-v4-legacy-id");
    SHIPPER_V4_NAME = getString("shipper-v4-name");
    SHIPPER_V4_CLIENT_ID = getString("shipper-v4-client-id");
    SHIPPER_V4_CLIENT_SECRET = getString("shipper-v4-client-secret");

    NINJA_DRIVER_ID = getLong("ninja-driver-id");
    NINJA_DRIVER_NAME = getString("ninja-driver-name");
    NINJA_DRIVER_USERNAME = getString("ninja-driver-username");
    NINJA_DRIVER_PASSWORD = getString("ninja-driver-password");

    HUB_ID = getLong("hub-id");
    HUB_NAME = getString("hub-name");

    SORT_BELT_MANAGER_HUB = getString("sbm-hub");
    SORT_BELT_MANAGER_DEVICE = getString("sbm-device");
    SORT_BELT_MANAGER_DEVICE_ARMS_COUNT = getInt("sbm-device-arm-count");
    SORT_BELT_MANAGER_DEFAULT_LOGIC = getString("sbm-default-logic");

    ADDRESSING_PRESET_NAME = getString("addressing-preset-name");
    ADDRESSING_SHIPPER_NAME = getString("addressing-shipper-v4-name");

    OPV2_DP_DP_ID = getLong("opv2-dp-dp-id");
    OPV2_DP_BULK_UPDATE_SAME_PARTNER_ID = getLong("opv2-dp-bulk-update-same-partner-id");
    OPV2_DP_BULK_UPDATE_INACTIVE_ID = getLong("opv2-dp-bulk-update-inactive-id");
    SAME_PARTNER_BULK_UPDATE_OPV2_DP_1_ID = getLong("same-partner-bulk-update-opv2-dp-1-id");
    SAME_PARTNER_BULK_UPDATE_OPV2_DP_2_ID = getLong("same-partner-bulk-update-opv2-dp-2-id");
    SAME_PARTNER_BULK_UPDATE_OPV2_DP_3_ID = getLong("same-partner-bulk-update-opv2-dp-3-id");
    IMDA_PICK_BULK_UPDATE_OPV2_DP_1_ID = getLong("imda-pick-bulk-update-opv2-dp-1-id");
    IMDA_PICK_BULK_UPDATE_OPV2_DP_2_ID = getLong("imda-pick-bulk-update-opv2-dp-2-id");

    RPM_SHIPPER_ID = getLong("rpm-shipper-id");
    RPM_SHIPPER_ID_LEGACY = getLong("rpm-shipper-id-legacy");
  }

  private TestConstants() {
  }
}
