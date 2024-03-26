package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.utils.StandardTestConstants;
import co.nvqa.operator_v2.selenium.page.MainPage;
import co.nvqa.operator_v2.selenium.page.MainPageReact;
import co.nvqa.operator_v2.util.TestConstants;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Given;
import java.util.HashMap;
import java.util.Map;


/**
 * @author Soewandi Wirjawan
 */
@ScenarioScoped
public class MainSteps extends AbstractSteps {

  private MainPage mainPage;
  private MainPageReact mainPageReact;

  private static final Map<String, String> MAP_OF_REACT_NAV_MENU_NAME = new HashMap<>();
  private static final Map<String, String> MAP_OF_REACT_PAGE_URL = new HashMap<>();


  static {
    // Map(<angular_name>,<react_name>)
    MAP_OF_REACT_NAV_MENU_NAME.put("Add Order to Route", "Add order to route");

    // Map(<angular_url>,<react_url>)
    MAP_OF_REACT_PAGE_URL.put("/order", "/order-v2");
  }

  public MainSteps() {
  }

  @Override
  public void init() {
    mainPage = new MainPage(getWebDriver());
    mainPageReact = new MainPageReact(getWebDriver());
  }

  @Given("Operator go to menu {} -> {}")
  public void operatorGoToMenu(String parentMenuName, String childMenuName) {
    if (TestConstants.SHELL_NAME.equalsIgnoreCase("react")) {
      mainPageReact.clickNavigation(getReactMenuName(parentMenuName),
          getReactMenuName(childMenuName));
    } else {
      mainPage.clickNavigation(parentMenuName, childMenuName);
    }
  }

  @Given("Operator go to menu {value} -> {value}")
  public void operatorGoToMenuWithoutQuote(String parentMenuName, String childMenuName) {
    operatorGoToMenu(parentMenuName, childMenuName);
    takesScreenshot();
  }

  @Given("Operator go to this URL {string}")
  public void operatorGoToThisUrl(String url) {
    mainPage.goToUrl(url);
  }

  @Given("Operator refresh page")
  public void operatorRefreshPage() {
    mainPage.refreshPage();
  }

  @Given("Operator refresh page without unmask")
  public void operatorRefreshPageWithoutUnmask() {
    mainPage.refreshPage(false);
  }

  @Given("Operator switch to {} shell")
  public void operatorSwitchShell(String shellName) {
    TestConstants.SHELL_NAME = shellName.toLowerCase();
    if (TestConstants.SHELL_NAME.equalsIgnoreCase("react")) {
      TestConstants.OPERATOR_PORTAL_BASE_URL =
          StandardTestConstants.NV_API_BASE.replace("api", "operatorv2") + "/react/#";
      mainPageReact.goToUrl(getReactUrl(mainPage.getCurrentUrl()));
    } else {
      TestConstants.OPERATOR_PORTAL_BASE_URL =
          StandardTestConstants.NV_API_BASE.replace("api", "operatorv2") + "/#";
      mainPage.goToUrl(mainPage.getCurrentUrl());
    }
  }

  private static String getReactMenuName(String menuName) {
    return MAP_OF_REACT_NAV_MENU_NAME.getOrDefault(menuName, menuName);
  }

  private static String getReactUrl(String originalUrl) {
    // Check if the URL contains "#", replace it with "/react/#"
    int hashIndex = originalUrl.indexOf("#");
    if (hashIndex != -1) {
      String baseUrl = originalUrl.substring(0, hashIndex);
      String path = originalUrl.substring(hashIndex);
      String patchedUrl = baseUrl + "react/" + path;
      // Check if the last path URL matches and replace it with end url if found in the map
      int lastSlashIndex = patchedUrl.lastIndexOf("/");
      String lastPath = patchedUrl.substring(lastSlashIndex);
      if (MAP_OF_REACT_PAGE_URL.containsKey(lastPath)) {
        patchedUrl = patchedUrl.substring(0, lastSlashIndex) + MAP_OF_REACT_PAGE_URL.get(lastPath);
      }
      return patchedUrl;
    } else {
      return originalUrl;
    }
  }
}
