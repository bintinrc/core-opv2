package co.nvqa.operator_v2.util;

import co.nvqa.common.ui.support.CommonUiTestConstants;

/**
 * @author Soewandi Wirjawan
 */
public final class TestConstants extends CommonUiTestConstants {

  public static String SHELL_NAME;
  public static String OPERATOR_PORTAL_BASE_URL;
  public static final String OPERATOR_PORTAL_ALL_ORDER_URL;
  public static final String OPERATOR_PORTAL_COOKIE_DOMAIN;
  public static final String OPERATOR_PORTAL_LOGIN_URL;
  public static final String OPERATOR_PORTAL_USER_COOKIE;
  public static final int VERY_LONG_WAIT_FOR_TOAST;
  public static final long RPM_SHIPPER_ID;
  public static final long RPM_SHIPPER_ID_LEGACY;

  static {
    SHELL_NAME = "angular";
    OPERATOR_PORTAL_BASE_URL = NV_API_BASE.replace("api", "operatorv2") + "/#";
    OPERATOR_PORTAL_ALL_ORDER_URL = OPERATOR_PORTAL_BASE_URL + "/order";
    OPERATOR_PORTAL_COOKIE_DOMAIN = getString("operator-portal-cookie-domain");
    OPERATOR_PORTAL_LOGIN_URL = OPERATOR_PORTAL_BASE_URL + "/login";
    OPERATOR_PORTAL_USER_COOKIE = getString("operator-portal-user-cookie");
    VERY_LONG_WAIT_FOR_TOAST = 90;
    RPM_SHIPPER_ID = getLong("rpm-shipper-id");
    RPM_SHIPPER_ID_LEGACY = getLong("rpm-shipper-id-legacy");
  }

  private TestConstants() {
  }
}
