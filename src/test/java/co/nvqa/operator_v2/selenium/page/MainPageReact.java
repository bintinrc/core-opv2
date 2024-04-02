package co.nvqa.operator_v2.selenium.page;

import co.nvqa.common.utils.NvTestWaitTimeoutException;
import co.nvqa.operator_v2.exception.NvTestCoreUrlMismatchError;
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
public class MainPageReact extends OperatorV2SimplePage implements MaskedPage {

  private static final Logger LOGGER = LoggerFactory.getLogger(MainPageReact.class);
  private static final Map<String, String> MAP_OF_END_URL = new HashMap<>();
  private static final List<String> LIST_OF_MASKED_PAGE_URL = new ArrayList<>();

  @FindBy(css = "[data-testid='ninja-van-label-testid']")
  public Button toggleSideNav;

  static {
    MAP_OF_END_URL.put("All Orders", "order-v2");
    MAP_OF_END_URL.put("Add order to route", "add-order-to-route");

    // add the url of all pages that have masked element inside
    LIST_OF_MASKED_PAGE_URL.add("\\/order-v2\\/\\d*"); // Edit Order
    LIST_OF_MASKED_PAGE_URL.add("\\/order-v2$"); // All Orders
  }

  public MainPageReact(WebDriver webDriver) {
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
    if (!isElementVisible(
        "//div[contains(text(), 'NINJA VAN') and @data-testid='ninja-van-label-testid']")) {
      toggleSideNav.click();
    }
  }

  public void clickNavigation(String parentTitle, String navTitle, String urlPart) {
    Button parentNav = new Button(getWebDriver(),
        f("//button[starts-with(@id, 'headlessui-disclosure-button-') and normalize-space() = '%s']",
            parentTitle));
    Button childNav = new Button(getWebDriver(),
        f("//div[contains(@data-testid, 'sidenav-item.navigation') and normalize-space() ='%s']",
            navTitle));

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
