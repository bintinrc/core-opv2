package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.MainPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;


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

  @Given("^Operator go to menu \"([^\"]*)\" -> \"([^\"]*)\"$")
  public void operatorGoToMenu(String parentMenuName, String childMenuName) {
    mainPage.clickNavigation(parentMenuName, childMenuName);
  }

  @Given("^Operator go to menu ([^\"]*) -> ([^\"]*)$")
  public void operatorGoToMenuWithoutQuote(String parentMenuName, String childMenuName) {
    operatorGoToMenu(parentMenuName, childMenuName);
    takesScreenshot();
  }

  @Given("^Operator go to this URL \"([^\"]*)\"$")
  public void operatorGoToThisUrl(String url) {
    mainPage.goToUrl(url);
  }

  @Then("^Operator verify he is in main page$")
  public void operatorVerifyHeIsInMainPage() {
    mainPage.verifyTheMainPageIsLoaded();
  }

  @Given("^Operator refresh page v1$")
  public void operatorRefreshPage_v1() {
    mainPage.refreshPage_v1();
  }

  @Given("^Operator refresh page$")
  public void operatorRefreshPage() {
    mainPage.refreshPage();
  }

  @Then("^Toast \"(.+)\" is displayed$")
  public void toastIsDisplayed(String message) {
    mainPage.waitUntilInvisibilityOfToast(message, true);
  }
}
