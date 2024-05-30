package co.nvqa.operator_v2.selenium.page;

import co.nvqa.common.utils.NvTestWaitTimeoutException;
import co.nvqa.operator_v2.exception.NvTestCoreUrlMismatchError;
import co.nvqa.operator_v2.exception.page.NvTestCoreMainPageException;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.util.TestConstants;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Soewandi Wirjawan
 */
@SuppressWarnings("WeakerAccess")
public class MainPage extends OperatorV2SimplePage implements MaskedPage {

  private static final Logger LOGGER = LoggerFactory.getLogger(MainPage.class);
  private static final String XPATH_OF_TOAST_WELCOME_DASHBOARD = "//div[@id='toast-container']//div[@class='toast-message']/div[@class='toast-right']/div[@class='toast-bottom'][text()='Welcome to your operator dashboard.']";
  private static final Map<String, String> MAP_OF_END_URL = new HashMap<>();

  private static final List<String> LIST_OF_MASKED_PAGE_URL = new ArrayList<>();

  @FindBy(css = "button[aria-label='Open Sidenav']")
  public Button openSideNav;

  static {
    MAP_OF_END_URL.put("1. Create Route Groups", "create-route-groups");
    MAP_OF_END_URL.put("1.1. Create Route Groups V1.5", "create-route-groups-v1_5");
    MAP_OF_END_URL.put("2. Route Group Management", "route-group");
    MAP_OF_END_URL.put("3. Route Engine - Zonal Routing", "zonal-routing");
    MAP_OF_END_URL.put("4. Route Engine - Bulk Add to Route", "add-parcel-to-route");
    MAP_OF_END_URL.put("All Orders", "order-v2");
    MAP_OF_END_URL.put("All Shippers", "shippers");
    MAP_OF_END_URL.put("Printer Settings", "printers");
    MAP_OF_END_URL.put("Recovery Tickets Scanning", "recovery-ticket-scanning");
    MAP_OF_END_URL.put("Route Cash Inbound", "cod");
    MAP_OF_END_URL.put("Third Party Shippers", "third-party-shipper");
    MAP_OF_END_URL.put("Third Party Order Management", "third-party-order");
    MAP_OF_END_URL.put("Outbound/Route Load Monitoring", "outbound-monitoring");
    MAP_OF_END_URL.put("Outbound Load Monitoring", "outbound-monitoring");
    MAP_OF_END_URL.put("Update Delivery Address with CSV", "order-delivery-update");
    MAP_OF_END_URL.put("Route Monitoring V2", "route-monitoring-paged");
    MAP_OF_END_URL.put("Pickup Jobs", "pickup-appointment");

    // for all page with masked, add this to the url
    LIST_OF_MASKED_PAGE_URL.add("\\/order\\/\\d*");
    LIST_OF_MASKED_PAGE_URL.add("\\/order-v2$");
    LIST_OF_MASKED_PAGE_URL.add("\\/route-manifest\\/\\d*");
  }

  public MainPage(WebDriver webDriver) {
    super(webDriver);
  }

  private String grabEndURL(String navTitle) {
    navTitle = navTitle.trim();
    String endUrl;

    if (MAP_OF_END_URL.containsKey(navTitle)) {
      endUrl = MAP_OF_END_URL.get(navTitle);
    } else {
      endUrl = navTitle.toLowerCase().replaceAll(" ", "-");
    }

    return endUrl;
  }

  public void verifyTheMainPageIsLoaded() {
    if (isElementExistWait2Seconds("//button[@aria-label='login.sign-in-button']")) {
      getWebDriver().navigate().refresh();
    }

    String mainDashboardUrl = grabEndURL("All Orders");

    try {
      waitUntil(() ->
      {
        String currentUrl = getCurrentUrl();
        LOGGER.trace(
            "verifyTheMainPageIsLoaded: Current URL = [{}] - Expected URL Ends With = [{}]",
            currentUrl, mainDashboardUrl);
        return currentUrl.endsWith(mainDashboardUrl);
      }, TestConstants.SELENIUM_WEB_DRIVER_WAIT_TIMEOUT_IN_MILLISECONDS);
    } catch (NvTestWaitTimeoutException e) {
      throw new NvTestCoreMainPageException(
          String.format("Expected URL Ends With = [%s] not found", mainDashboardUrl), e);
    }

    waitUntilPageLoaded();
    LOGGER.trace("Waiting until Welcome message toast disappear.");
    waitUntilInvisibilityOfElementLocated(XPATH_OF_TOAST_WELCOME_DASHBOARD,
        TestConstants.VERY_LONG_WAIT_FOR_TOAST);

    String currentUrl = getCurrentUrl();
    String countrySpecificDashboardUrl =
        TestConstants.NV_SYSTEM_ID.toLowerCase() + '/' + mainDashboardUrl;

    if (!currentUrl.endsWith(countrySpecificDashboardUrl)) {
      getWebDriver().navigate()
          .to(TestConstants.OPERATOR_PORTAL_BASE_URL + '/' + countrySpecificDashboardUrl);
    }
  }

  public void clickNavigation(String parentTitle, String navTitle) {
    WebDriver webDriver = getWebDriver();
    if (webDriver == null) {
      throw new RuntimeException("WebDriver session was not started");
    }
    webDriver.switchTo().defaultContent();
    closeDialogIfVisible();
    openNavigationPanel();
    String mainDashboard = grabEndURL(navTitle);
    clickNavigation(parentTitle, navTitle, mainDashboard);
  }

  public void openNavigationPanel() {
    if (isElementVisible("//i[@ng-if='!showLogo()']")) {
      openSideNav.click();
    }
  }

  public void clickNavigation(String parentTitle, String navTitle, String urlPart) {
    Button childNav = new Button(getWebDriver(), f("//nv-section-item/button[div='%s']", navTitle));
    Button parentNav = new Button(getWebDriver(),
        f("//nv-section-header/button[span='%s']", parentTitle));

    for (int i = 0; i < 2; i++) {
      if (!childNav.isDisplayedFast()) {
        try {
          parentNav.click();
        } catch (JavascriptException ex) {
          refreshPage();
          openNavigationPanel();
          parentNav.click();
        }
        pause200ms();
        closeDialogIfVisible();
      }

      pause100ms();
      boolean refreshPage = true;

      if (childNav.isDisplayedFast()) {
        try {
          childNav.click();
          pause200ms();
          closeDialogIfVisible();
          refreshPage = false;
        } catch (Exception ex) {
          LOGGER.warn("Failed to click nav child.", ex);
        }
      }

      if (refreshPage) {
        // Ensure no dialog that prevents menu from being clicked.
        refreshPage();
      } else {
        break;
      }
    }

    try {
      waitUntil(() -> {
        boolean result;
        String currentUrl = getCurrentUrl();
        LOGGER.info("clickNavigation: Current URL = [{}] - Expected URL Ends With = [{}]",
            currentUrl, urlPart);
        if ("linehaul".equals(urlPart)) {
          result = currentUrl.contains(urlPart);
        } else {
          result = currentUrl.endsWith(urlPart);
        }
        return result;
      }, TestConstants.SELENIUM_WEB_DRIVER_WAIT_TIMEOUT_IN_MILLISECONDS);
    } catch (NvTestWaitTimeoutException e) {
      throw new NvTestCoreUrlMismatchError(
          String.format("Expected URL Ends With = [%s] not found", urlPart), e);
    }

    waitUntilPageLoaded();
  }

  public void refreshPage() {
    refreshPage(true);
  }

  public void refreshPage(Boolean isUnmask) {
    super.refreshPage();
    if (isUnmask) {
      String currentUrl = getWebDriver().getCurrentUrl();
      LIST_OF_MASKED_PAGE_URL.forEach(endUrl -> {
        Pattern p = Pattern.compile(endUrl);
        Matcher m = p.matcher(currentUrl);
        if (m.find()) {
          try {
            List<WebElement> masks = getWebDriver().findElements(
                By.xpath(MaskedPage.MASKING_XPATH));
            operatorClickMaskingText(masks);
          } catch (Exception ex) {
            LOGGER.debug(ex.getMessage());
          }
        }
      });
    }
  }
}
