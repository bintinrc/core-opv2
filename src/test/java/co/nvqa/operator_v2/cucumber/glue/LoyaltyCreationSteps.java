package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.shipper.v2.Shipper;
import co.nvqa.operator_v2.selenium.page.LoyaltyCreationPage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;

public class LoyaltyCreationSteps extends AbstractSteps{

  private LoyaltyCreationPage loyaltyCreationPage;
  @Override
  public void init() {
    loyaltyCreationPage = new LoyaltyCreationPage(getWebDriver());
  }

  @When("Operator upload file for loyalty creation contains created shipper")
  public void uploadLoyaltyCreation() {
    Shipper shipper = get(KEY_CREATED_SHIPPER);
    loyaltyCreationPage.uploadLoyaltyShipper(shipper, false);
  }

  @When("Operator upload existing file for loyalty creation")
  public void uploadLoyaltyCreationUsingExistingCsv() {
    loyaltyCreationPage.uploadLoyaltyShipper(null, true);
  }

  @When("Operator loyalty creation confirmation")
  public void clickConfirmation() {
    loyaltyCreationPage.clickUploadConfirmation();
  }

  @Then("Operator check result message {string} displayed")
  public void openSmsPanel(String msg) {
    assertTrue("Check result message", loyaltyCreationPage.isResultMessageDisplayed(msg));
  }
}
