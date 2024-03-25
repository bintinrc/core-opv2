package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.MainPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Given;


/**
 * @author Soewandi Wirjawan
 */
@ScenarioScoped
public class MainSteps extends AbstractSteps {

  private MainPage mainPage;

  public MainSteps() {
  }

  @Override
  public void init() {
    mainPage = new MainPage(getWebDriver());
  }

  @Given("Operator go to menu {} -> {}")
  public void operatorGoToMenu(String parentMenuName, String childMenuName) {
    mainPage.clickNavigation(parentMenuName, childMenuName);
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
}
