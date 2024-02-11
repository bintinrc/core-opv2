package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.BlockedDatesPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;

/**
 * @author Soewandi Wirjawan
 * <p>
 * Modified by Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class BlockedDatesSteps extends AbstractSteps {

  private BlockedDatesPage blockedDatesPage;

  public BlockedDatesSteps() {
  }

  @Override
  public void init() {
    blockedDatesPage = new BlockedDatesPage(getWebDriver());
  }

  @When("Operator adds Blocked Date for {string}")
  public void operatorAddsBlockedDate(String date) {
    blockedDatesPage.inFrame(() -> {
//      blockedDatesPage.addBlockedDate());
      blockedDatesPage.addDate(resolveValue(date));
    });
  }

  @Then("Operator verifies new Blocked Date is added successfully")
  public void operatorVerifiesNewBlockedDateIsAddedSuccessfully() {
    blockedDatesPage.inFrame(() -> {
      blockedDatesPage.verifyBlockedDateAddedSuccessfully();
    });
  }

  @Then("Operator verifies success toast {string} is displayed")
  public void operatorVerifySuccessToast(String message) {
    blockedDatesPage.inFrame((page) -> {
      page.waitUntilVisibilityOfElementLocated(
          f("//div[@id='toast-container']//span[.='%s']", message));
    });
  }

  @When("Operator removes Blocked Date for {string}")
  public void operatorRemovesBlockedDate(String date) {
    blockedDatesPage.inFrame(() -> {
      blockedDatesPage.removeBlockedDate(resolveValue(date));
    });
  }

  @Then("Operator verifies Blocked Date is removed successfully")
  public void operatorVerifiesBlockedDateIsRemovedSuccessfully() {
    blockedDatesPage.inFrame(() -> {
      blockedDatesPage.verifyBlockedDateRemovedSuccessfully();
    });
  }
}
