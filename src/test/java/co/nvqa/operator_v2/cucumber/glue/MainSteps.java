package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.utils.StandardTestConstants;
import co.nvqa.operator_v2.selenium.page.MainPage;
import co.nvqa.operator_v2.selenium.page.MainPageReact;
import co.nvqa.operator_v2.util.TestConstants;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Given;


/**
 * @author Soewandi Wirjawan
 */
@ScenarioScoped
public class MainSteps extends AbstractSteps {

  private MainPage mainPage;
  private MainPageReact mainPageReact;

  public MainSteps() {
  }

  @Override
  public void init() {
    mainPage = new MainPage(getWebDriver());
    mainPageReact = new MainPageReact(getWebDriver());
  }

  @Given("Operator go to menu {} -> {}")
  public void operatorGoToMenu(String parentMenuName, String childMenuName) {
    switch (TestConstants.SHELL_NAME.toLowerCase()) {
      case "angular":
        mainPage.clickNavigation(parentMenuName, childMenuName);
        break;
      case "react":
        mainPageReact.clickNavigation(parentMenuName, getReactChildMenuName(childMenuName));
        break;
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
    switch (shellName.toLowerCase()) {
      case "angular":
        TestConstants.OPERATOR_PORTAL_BASE_URL =
            StandardTestConstants.NV_API_BASE.replace("api", "operatorv2") + "/#";
        break;
      case "react":
        TestConstants.OPERATOR_PORTAL_BASE_URL =
            StandardTestConstants.NV_API_BASE.replace("api", "operatorv2") + "/react/#";
        break;
    }
    mainPage.goToUrl(patchUrlToReact(mainPage.getCurrentUrl()));
  }

  private static String getReactChildMenuName(String childMenuName) {
    String reactChildMenuName = childMenuName;
    switch (childMenuName) {
      case "Add Order to Route":
        reactChildMenuName = "Add order to route";
        break;
    }
    return reactChildMenuName;
  }

  private static String patchUrlToReact(String originalUrl) {
    // Check if the URL contains "#", replace it with "/react/#"
    int hashIndex = originalUrl.indexOf("#");
    if (hashIndex != -1) {
      String baseUrl = originalUrl.substring(0, hashIndex);
      String path = originalUrl.substring(hashIndex);
      String patchedUrl = baseUrl + "react/" + path;
      // Custom patch for react version of the url
      if (patchedUrl.contains("/order")) {
        patchedUrl = patchedUrl + "-v2";
      }
      return patchedUrl;
    } else {
      return originalUrl;
    }
  }
}
