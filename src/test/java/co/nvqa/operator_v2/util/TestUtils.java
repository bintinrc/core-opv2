package co.nvqa.operator_v2.util;

import co.nvqa.common_selenium.util.CommonSeleniumTestUtils;
import co.nvqa.commons.util.JsonUtils;
import co.nvqa.commons.util.NvLogger;
import java.io.IOException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.TimeUnit;
import org.openqa.selenium.WebDriver;

/**
 * @author Soewandi Wirjawan
 */
@SuppressWarnings("WeakerAccess")
public class TestUtils extends CommonSeleniumTestUtils {

  private TestUtils() {
  }

  public static String getOperatorTimezone(WebDriver webDriver) {
    String cookie = webDriver.manage().getCookieNamed("user").getValue();

    try {
      String userJson = URLDecoder.decode(cookie, StandardCharsets.UTF_8.name());
      return (String) JsonUtils.fromJsonCamelCaseToMap(userJson).get("timezone");
    } catch (IOException ex) {
      NvLogger.error("Failed to get timezone from browser cookies.", ex);
    }

    return null;
  }

  public static int dayToInteger(String day) {
    switch (day.toUpperCase()) {
      case "SUNDAY":
        return 1;
      case "MONDAY":
        return 2;
      case "TUESDAY":
        return 3;
      case "WEDNESDAY":
        return 4;
      case "THURSDAY":
        return 5;
      case "FRIDAY":
        return 6;
      case "SATURDAY":
        return 7;
      default:
        return 0;
    }
  }

  public static String integerToMonth(int month) {
    switch (month) {
      case 0:
        return "January";
      case 1:
        return "February";
      case 2:
        return "March";
      case 3:
        return "April";
      case 4:
        return "May";
      case 5:
        return "June";
      case 6:
        return "July";
      case 7:
        return "August";
      case 8:
        return "September";
      case 9:
        return "October";
      case 10:
        return "November";
      case 11:
        return "December";
      default:
        return null;
    }
  }

  public static String getStartTime(int timewindow) {
    switch (timewindow) {
      case -3:
        return "18:00:00";
      case -2:
        return "09:00:00";
      case -1:
        return "09:00:00";
      case 0:
        return "09:00:00";
      case 1:
        return "12:00:00";
      case 2:
        return "15:00:00";
      case 3:
        return "18:00:00";
      default:
        return "09:00:00";
    }
  }

  public static String getEndTime(int timewindow) {
    switch (timewindow) {
      case -3:
        return "22:00:00";
      case -2:
        return "18:00:00";
      case -1:
        return "22:00:00";
      case 0:
        return "12:00:00";
      case 1:
        return "15:00:00";
      case 2:
        return "18:00:00";
      case 3:
        return "22:00:00";
      default:
        return "09:00:00";
    }
  }

  public static void setImplicitTimeout(WebDriver webDriver, long seconds) {
    webDriver.manage().timeouts().implicitlyWait(seconds, TimeUnit.SECONDS);
  }

  @SuppressWarnings("unused")
  public static void resetImplicitTimeout(WebDriver webDriver) {
    setImplicitTimeout(webDriver, TestConstants.SELENIUM_IMPLICIT_WAIT_TIMEOUT_IN_SECONDS);
  }
}
