package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.LogoutPage;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

/**
 * @author Soewandi Wirjawan
 */
@ScenarioScoped
public class LogoutSteps extends AbstractSteps {

  private LogoutPage logoutPage;

  public LogoutSteps() {
  }

  @Override
  public void init() {
    logoutPage = new LogoutPage(getWebDriver());
  }

  @When("^Operator click logout button$")
  public void logout() {
    logoutPage.logout();
  }
}
