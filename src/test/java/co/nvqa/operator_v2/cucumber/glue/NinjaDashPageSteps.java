package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.NinjaDashPage;
import cucumber.api.java.en.Then;
import cucumber.runtime.java.guice.ScenarioScoped;


@ScenarioScoped
public class NinjaDashPageSteps extends AbstractSteps {

  private NinjaDashPage ninjaDashPage;

  public NinjaDashPageSteps() {
  }

  @Override
  public void init() {
    ninjaDashPage = new NinjaDashPage(getWebDriver());
  }

  @Then("account name is {string} on Ninja Dash page")
  public void checkAccountName(String expected) {
    expected = resolveValue(expected);
    assertEquals("Account Name", expected, ninjaDashPage.accountName.getNormalizedText());
  }

}