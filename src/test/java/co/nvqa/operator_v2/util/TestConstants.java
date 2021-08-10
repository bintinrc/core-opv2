package co.nvqa.operator_v2.util;

import co.nvqa.common_selenium.util.CommonSeleniumTestConstants;
import co.nvqa.commons.util.NvSystemProperties;

/**
 * @author Soewandi Wirjawan
 */
@SuppressWarnings("WeakerAccess")
public final class TestConstants extends CommonSeleniumTestConstants {

  public static final String OPERATOR_PORTAL_BASE_URL;
  public static final String DASH_PORTAL_BASE_URL;
  public static final String OPERATOR_PORTAL_LOGIN_URL;
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

  public static final int VERY_LONG_WAIT_FOR_TOAST = 90;

  static {
    String apiBase = NvSystemProperties
        .getString(NV_API_BASE, getString("operator-portal-base-url"));
    OPERATOR_PORTAL_BASE_URL = apiBase.replace("api", "operatorv2") + "/#";
    DASH_PORTAL_BASE_URL = getString("dash-portal-base-url");
    OPERATOR_PORTAL_LOGIN_URL = OPERATOR_PORTAL_BASE_URL + "/login";
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
  }

  private TestConstants() {
  }
}
