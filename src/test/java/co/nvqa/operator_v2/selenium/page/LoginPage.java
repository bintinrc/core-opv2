package co.nvqa.operator_v2.selenium.page;

import co.nvqa.common.utils.NvTestRuntimeException;
import co.nvqa.operator_v2.util.TestConstants;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.List;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.Cookie;
import org.openqa.selenium.InvalidElementStateException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.html5.LocalStorage;
import org.openqa.selenium.html5.WebStorage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Soewandi Wirjawan
 */
@SuppressWarnings("WeakerAccess")
public class LoginPage extends OperatorV2SimplePage {

  private static final Logger LOGGER = LoggerFactory.getLogger(LoginPage.class);

  private static final String GOOGLE_EXPECTED_URL_1 = "https://accounts.google.com/ServiceLogin";
  private static final String GOOGLE_EXPECTED_URL_2 = "https://accounts.google.com/signin/oauth/identifier";
  private static final String GOOGLE_EXPECTED_URL_3 = "https://accounts.google.com/o/oauth2/auth/identifier";

  public LoginPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void loadPage() {
    boolean loaded = false;
    do {
      try {
        getWebDriver().get(TestConstants.OPERATOR_PORTAL_LOGIN_URL);
        waitUntilPageLoaded();
        loaded = true;
      } catch (Exception ex) {
        executeScript("window.open()");
        final String currentWindowHandle = getWebDriver().getWindowHandle();
        String newWindowHandle = null;

        for (String windowHandle : getWebDriver().getWindowHandles()) {
          if (!windowHandle.equals(currentWindowHandle)) {
            newWindowHandle = windowHandle;
            break;
          }
        }

        getWebDriver().close();
        getWebDriver().switchTo().window(newWindowHandle);
      }
    } while (!loaded);
  }

  /**
   * Inserting 'acceptedTnC' key into local storage to handle the Terms and Condition popup on opv2
   */
  private void handleTncPopup() {
    try {
      LOGGER.info("Inserting TnC Popup acceptance");
      LocalStorage ls = ((WebStorage) getWebDriver()).getLocalStorage();
      ls.setItem("acceptedTnC", "true");
      assertNotNull(ls.getItem("acceptedTnC"));
    } catch (Exception ex) {
      LOGGER.error(ex.getMessage());
    }
  }

  public void forceLogin(String operatorBearerToken) {
    LOGGER.info("FORCE LOGIN BY INJECTING COOKIES TO BROWSER");

    try {
      final String userCookie = URLEncoder.encode(TestConstants.OPERATOR_PORTAL_USER_COOKIE,
          "UTF-8");
      LOGGER.info("ninja_access_token = " + operatorBearerToken);
      LOGGER.info("user = " + userCookie);

      getWebDriver().manage().addCookie(new Cookie("ninja_access_token", operatorBearerToken,
          TestConstants.OPERATOR_PORTAL_COOKIE_DOMAIN, "/", null));
      getWebDriver().manage().addCookie(
          new Cookie("user", userCookie, TestConstants.OPERATOR_PORTAL_COOKIE_DOMAIN, "/", null));
      executeScript("window.open()");
      final String currentWindowHandle = getWebDriver().getWindowHandle();
      String newWindowHandle = null;
      handleTncPopup();
      for (String windowHandle : getWebDriver().getWindowHandles()) {
        if (!windowHandle.equals(currentWindowHandle)) {
          newWindowHandle = windowHandle;
          break;
        }
      }
      getWebDriver().close();
      getWebDriver().switchTo().window(newWindowHandle);
      getWebDriver().get(TestConstants.OPERATOR_PORTAL_ALL_ORDER_URL);
    } catch (UnsupportedEncodingException ex) {
      throw new NvTestRuntimeException(ex);
    } finally {
      // nothing
    }
  }

  public void clickLoginButton() {
    click("//button[@ng-click='ctrl.login()']");
    waitUntilPageLoaded();
  }

  public void enterCredential(String username, String password) {
    final StringBuilder googlePageUrlSb = new StringBuilder();

    waitUntil(() ->
    {
      String currentUrl = getCurrentUrl();
      googlePageUrlSb.setLength(0);
      googlePageUrlSb.append(currentUrl);
      boolean isExpectedUrlFound = StringUtils.startsWithAny(currentUrl, GOOGLE_EXPECTED_URL_1,
          GOOGLE_EXPECTED_URL_2, GOOGLE_EXPECTED_URL_3);

      LOGGER.info("========== GOOGLE LOGIN PAGE ==========");
      LOGGER.info("Current URL          : " + currentUrl);
      LOGGER.info("Expected URL 1       : " + GOOGLE_EXPECTED_URL_1);
      LOGGER.info("Expected URL 2       : " + GOOGLE_EXPECTED_URL_2);
      LOGGER.info("Expected URL 3       : " + GOOGLE_EXPECTED_URL_3);
      LOGGER.info("Is Expected URL Found: " + isExpectedUrlFound);
      LOGGER.info("=======================================");

      return isExpectedUrlFound;
    }, TestConstants.SELENIUM_WEB_DRIVER_WAIT_TIMEOUT_IN_MILLISECONDS);

    final String googlePageUrl = googlePageUrlSb.toString();

    if (googlePageUrl.startsWith(GOOGLE_EXPECTED_URL_1)) {
      enterCredentialWithMethod1(username, password);
    } else if (StringUtils.startsWithAny(googlePageUrl, GOOGLE_EXPECTED_URL_2,
        GOOGLE_EXPECTED_URL_3)) {
      enterCredentialWithMethod2(username, password);
    }
  }

  public void enterCredentialWithMethod1(String username, String password) {
    sendKeys("//input[@id='Email'][@name='Email']", username);
    click("//input[@id='next'][@name='signIn']");
    sendKeys("//input[@id='Passwd'][@name='Passwd']", password);
    click("//input[@id='signIn'][@name='signIn']");
  }

  @SuppressWarnings("unchecked")
  public void enterCredentialWithMethod2(String username, String password) {
    sendKeys("//input[@id='identifierId'][@name='identifier']", username);
    click("//div[@id='identifierNext']");
    pause100ms();
    retryIfExpectedExceptionOccurred(() -> sendKeys("//input[@name='password']", password),
        InvalidElementStateException.class);
    click("//div[@id='passwordNext']");
  }

  public void checkForGoogleSimpleVerification(String location) {
    final List<WebElement> listOfWebElements = findElementsByXpath(
        "//span[text()='Enter the city you usually sign in from']");

    if (!listOfWebElements.isEmpty()) {
      click("//span[text()='Enter the city you usually sign in from']/../..");
      pause1s();

      WebElement txtAnswerWe = waitUntilVisibilityOfElementLocated(
          "//input[@id='answer' and @type='text']");
      txtAnswerWe.clear();
      txtAnswerWe.sendKeys(location);

      click("//input[@id='submit' and @type='submit']");
      pause1s();
    }
  }

  public void backToLoginPage() {
    pause1s();
    String currentUrl = getCurrentUrl();
    Assertions.assertThat(currentUrl).as("Default Operator Portal URL not loaded.")
        .contains(TestConstants.OPERATOR_PORTAL_LOGIN_URL);
  }

  public void changeCountry(String countryName) {
    // Checking for error toast
    if (isElementExistFast("//div[contains(@class,'toast-error')]")) {
      click("//button[contains(@class,'nvYellow')]");
      pause2s();
    }

    click("//button[contains(@ng-click,'$mdOpenMenu($event)') and @aria-label='Profile']");

    // Check if Country option is opened
    while (!isElementExistFast(
        "//md-select[@ng-model='domain.current']/md-select-value[contains(@id,'select_value_label')]")) {
      click("//button[contains(@ng-click,'$mdOpenMenu($event)') and @aria-label='Profile']");
    }

    click(
        "//md-select[@ng-model='domain.current']/md-select-value[contains(@id,'select_value_label')]");
    click(f("//md-option[contains(@ng-repeat,'domain.all')]//span[text()='%s']", countryName));
    getWebDriver().navigate().refresh();
    pause3s();
  }
}
