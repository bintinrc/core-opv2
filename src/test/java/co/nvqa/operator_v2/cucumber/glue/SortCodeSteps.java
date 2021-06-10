package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.sort.sort_code.SortCode;
import co.nvqa.operator_v2.selenium.page.SortCodePage;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;

public class SortCodeSteps extends AbstractSteps {

  private static final String POSTCODE = "postcode";
  private static final String SORT_CODE = "sort_code";

  private SortCodePage sortCodePage;

  public SortCodeSteps() {
  }

  @Override
  public void init() {
    sortCodePage = new SortCodePage(getWebDriver());
  }

  @And("Sort App Page is fully loaded")
  public void sortAppPageIsFullyLoaded() {
    sortCodePage.switchToIframe();
    sortCodePage.checkPageIsFullyLoaded();
  }

  @Then("Operator verifies that all the components in Sort Code Page are complete")
  public void operatorVerifiesThatAllTheComponentsInSortCodePageAreComplete() {
    sortCodePage.checkPageComponents();
  }

  @When("Operator searches for Sort Code based on its {string}")
  public void operatorSearchesForSortCodeBasedOnIts(String key) {
    SortCode sortCode = get(KEY_CREATED_SORT_CODE);

    if (POSTCODE.equalsIgnoreCase(key)) {
      sortCodePage.postcodeInput.setValue(sortCode.getPostcode());
      return;
    }
    sortCodePage.sortCodeInput.setValue(sortCode.getSortCode());
  }

  @Then("Operator verifies that the sort code details are right")
  public void operatorVerifiesThatTheSortCodeDetailsAreRight() {
    SortCode sortCode = get(KEY_CREATED_SORT_CODE);
    sortCodePage.verifiesSortCodeDetailsAreRight(sortCode);
  }

  @When("Operator clicks on download button on the Sort Code Page")
  public void operatorClicksOnDownloadButtonOnTheSortCodePage() {
    sortCodePage.downloadCsvButton.click();
  }

  @Then("Operator verifies that the details in the downloaded csv are right")
  public void operatorVerifiesThatTheDetailsInTheDownloadedCsvAreRight() {
    SortCode sortCode = get(KEY_CREATED_SORT_CODE);
    sortCodePage.verifiesDownloadedCsvDetailsAreRight(sortCode);
  }
}
