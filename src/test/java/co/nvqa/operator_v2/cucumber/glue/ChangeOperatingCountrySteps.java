package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.ProfilePage;
import cucumber.api.java.en.Then;

public class ChangeOperatingCountrySteps extends AbstractSteps {

  private ProfilePage profilePage;

  @Override
  public void init() {
    profilePage = new ProfilePage(getWebDriver());
  }

  @Then("Operator verify operating country is {string}")
  public void operatorVerifyOperatingCountryIsCorrect(String country) {
    profilePage.currentCountryIs(country);
  }


}
