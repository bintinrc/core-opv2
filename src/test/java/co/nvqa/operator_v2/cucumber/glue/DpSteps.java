package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.DpPage;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.guice.ScenarioScoped;

/**
 * @author Soewandi Wirjawan
 */
@ScenarioScoped
public class DpSteps extends AbstractSteps {

  private DpPage dpPage;

  public DpSteps() {
  }

  @Override
  public void init() {
    dpPage = new DpPage(getWebDriver());
  }

  @When("download button in {string} is clicked")
  public void downloadFile(String type) {
    dpPage.downloadFile(type);
  }

  @Then("file {string} should exist")
  public void verifyDownloadedFile(String type) {
    dpPage.verifyDownloadedFile(type);
  }

  @When("searching for {string}")
  public void search(String type) {
    dpPage.search(type);
  }

  @When("add {string} button is clicked")
  public void clickAddBtn(String type) {
    dpPage.clickAddBtn(type);
  }

  @When("enter default value of {string}")
  public void enterDefaultValue(String type) {
    dpPage.enterDefaultValue(type);
  }

  @Then("verify result {string}")
  public void verifyResult(String type) {
    dpPage.verifyResult(type);
  }

  @When("edit {string} button is clicked")
  public void clickEditBtn(String type) {
    dpPage.clickEditBtn(type);
  }

  @When("view {string} button is clicked")
  public void clickViewBtn(String type) {
    dpPage.clickViewBtn(type);
  }

  @Then("verify page {string}")
  public void verifyPage(String type) {
    dpPage.verifyPage(type);
  }
}
