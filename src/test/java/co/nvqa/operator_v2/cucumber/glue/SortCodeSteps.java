package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.cucumber.glue.AddressFactory;
import co.nvqa.commons.model.sort.sort_code.SortCode;
import co.nvqa.commons.support.RandomUtil;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.operator_v2.selenium.page.SortCodePage;
import co.nvqa.operator_v2.util.TestUtils;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import java.io.File;
import java.util.Objects;

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

  @When("Operator uploads the CSV file with name {string}")
  public void operatorUploadsTheCSVFileWithName(String resourcePath) {
    ClassLoader classLoader = getClass().getClassLoader();
    File file = getCreateOrderCSVFile(resourcePath, classLoader);
    sortCodePage.uploadFile(file);
  }

  @Then("Operator verifies that there will be success toast shown")
  public void operatorVerifiesThatThereWillBeSuccessToastShown() {
    sortCodePage.waitUntilVisibilityOfToastReact("Uploaded CSV successfully");
  }

  @Then("Operator verifies that there will be an error toast {string} shown")
  public void operatorVerifiesThatThereWillBeAnErrorToastShown(String errorMessage) {
    final String INVALID_POSTCODE = "invalid_postcode";
    final String INVALID_FORMAT = "invalid_format";

    if (INVALID_POSTCODE.equalsIgnoreCase(errorMessage)) {
      sortCodePage.waitUntilVisibilityOfToastReact("Postal code is not valid for this country");
    } else if (INVALID_FORMAT.equalsIgnoreCase(errorMessage)) {
      sortCodePage.waitUntilVisibilityOfToastReact("Unable to auto-detect delimiting character");
    }
  }

  @Then("Operator verifies that the sort code is not found")
  public void operatorVerifiesThatTheSortCodeIsNotFound() {
    sortCodePage.verifiiesSortCodeIsNotFound();
  }

  private File getCreateOrderCSVFile(String resourcePath, ClassLoader classLoader) {
    File file = new File(Objects.requireNonNull(classLoader.getResource(resourcePath)).getFile());
    String content = TestUtils.readFromFile(file);
    String postcodeValue;
    String sortCodeValue;
    SortCode sortCode = get(KEY_CREATED_SORT_CODE);
    NvLogger.infof("content of original file for upload : \n%s", content);

    //Replacing existed postcode
    if (content.contains("existed-postcode")) {
      postcodeValue = sortCode.getPostcode();
      content = content.replaceAll("existed-postcode", postcodeValue);
      NvLogger.info(postcodeValue);
    }

    //Replacing existed sort code
    if (content.contains("existed-sort-code")) {
      sortCodeValue = sortCode.getSortCode();
      content = content.replaceAll("existed-sort-code", sortCodeValue);
      NvLogger.info(sortCodeValue);
    }

    //Replacing new postcode
    if (content.contains("new-postcode")) {
      postcodeValue = AddressFactory.getRandomAddress().getPostcode();
      content = content.replaceAll("new-postcode", postcodeValue);
      NvLogger.info(postcodeValue);
      sortCode.setPostcode(postcodeValue);
    }

    //Replacing new sort code
    if (content.contains("new-sort-code")) {
      sortCodeValue = "SA" + randomInt(0, 999) + RandomUtil.randomString(5);
      content = content.replaceAll("new-sort-code", sortCodeValue);
      NvLogger.info(sortCodeValue);
      sortCode.setSortCode(sortCodeValue);
    }

    NvLogger.infof("content of generated file for upload : \n%s", content);

    String fileName = file.getName();
    file = TestUtils.createFile(fileName, content);
    put(KEY_CREATED_SORT_CODE, sortCode);
    return file;
  }
}
