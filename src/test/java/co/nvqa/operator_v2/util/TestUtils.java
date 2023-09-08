package co.nvqa.operator_v2.util;

import co.nvqa.common.ui.support.CommonUiTestUtils;
import co.nvqa.common.utils.JsonUtils;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.TimeUnit;
import org.apache.commons.lang3.SystemUtils;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Soewandi Wirjawan
 */
@SuppressWarnings("WeakerAccess")
public class TestUtils extends CommonUiTestUtils {

  private static final Logger LOGGER = LoggerFactory.getLogger(TestUtils.class);

  private TestUtils() {
  }

  public static String getOperatorTimezone(WebDriver webDriver) {
    String cookie = webDriver.manage().getCookieNamed("user").getValue();

    try {
      String userJson = URLDecoder.decode(cookie, StandardCharsets.UTF_8.name());
      return (String) JsonUtils.fromJsonCamelCaseToMap(userJson).get("timezone");
    } catch (IOException ex) {
      LOGGER.error("Failed to get timezone from browser cookies.", ex);
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

  public static Keys getControlKeyByPlatform() {
    if (SystemUtils.IS_OS_MAC) {
      return Keys.COMMAND;
    }
    return Keys.CONTROL;
  }

  public static String readFromFile(File file) {
    StringBuilder fileText = new StringBuilder();

    try (BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(file)))) {
      String input;

      while ((input = br.readLine()) != null) {
        if (fileText.length() > 0) {
          fileText.append(System.lineSeparator());
        }

        fileText.append(input);
      }
    } catch (IOException ex) {
      LOGGER.warn("File '{}' failed to read. Cause: {}....", file.getAbsolutePath(),
          ex.getMessage());
    }

    return fileText.toString();
  }

  public static void findElementAndClick(String elementString, String locator, WebDriver webDriver){
    WebElement element = null;
    if(locator.equals("id")){
      element = webDriver.findElement(By.id(elementString));
    }else if(locator.equals("xpath")){
      element = webDriver.findElement(By.xpath(elementString));
    }else if(locator.equals("class")){
      element = webDriver.findElement(By.className(elementString));
    }
    element.click();
  }

  public static void callJavaScriptExecutor(String argument, WebElement element, WebDriver webDriver){
    JavascriptExecutor jse = ((JavascriptExecutor)webDriver);
    jse.executeScript(argument, element);
  }
}
