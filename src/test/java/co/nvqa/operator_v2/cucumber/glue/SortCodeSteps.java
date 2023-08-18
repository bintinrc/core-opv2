package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.ordercreate.model.SortCode;
import co.nvqa.operator_v2.selenium.page.SortCodePage;
import co.nvqa.operator_v2.util.TestUtils;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.io.File;
import java.util.Map;
import java.util.Objects;
import org.junit.platform.commons.util.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
public class SortCodeSteps extends AbstractSteps {

  private static final Logger LOGGER = LoggerFactory.getLogger(SortCodeSteps.class);

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
  public void operatorSearchesForSortCodeBasedOnIts(String key, Map<String, String> data) {
    SortCode sortCodes = new SortCode();
    data = resolveKeyValues(data);
    if (StringUtils.isNotBlank(data.get("postcode"))) {
      String postCode = data.get("postcode");
      sortCodes.setPostcode(postCode);
    }
    if (StringUtils.isNotBlank(data.get("sortCode"))) {
      String sortCode = data.get("sortCode");
      sortCodes.setSortCode(sortCode);
    }

//    SortCode sortCode = get(KEY_CREATED_SORT_CODE);
    doWithRetry(() -> {
      if (POSTCODE.equalsIgnoreCase(key)) {
        sortCodePage.postcodeInput.setValue(sortCodes.getPostcode());
        return;
      }
      sortCodePage.sortCodeInput.setValue(sortCodes.getSortCode());
    }, "Searching for Sort Codes");
  }

  @Then("Operator verifies that the sort code details are right")
  public void operatorVerifiesThatTheSortCodeDetailsAreRight(Map<String, String> data) {
    data = resolveKeyValues(data);
    SortCode sortCodes = new SortCode();
    String postcode = data.get("postcode");
    String sortCode = data.get("sortCode");
    String id = data.get("id");
    sortCodes.setSortCode(sortCode);
    sortCodes.setPostcode(postcode);
    sortCodes.setId(Long.valueOf(id));
    sortCodePage.verifiesSortCodeDetailsAreRight(sortCodes);
  }

  @When("Operator clicks on download button on the Sort Code Page")
  public void operatorClicksOnDownloadButtonOnTheSortCodePage() {
    sortCodePage.downloadCsvButton.click();
  }

  @Then("Operator verifies that the details in the downloaded csv are right")
  public void operatorVerifiesThatTheDetailsInTheDownloadedCsvAreRight(Map<String, String> data) {
    SortCode sortCodes = new SortCode();
    data = resolveKeyValues(data);
    String postcode = data.get("postcode");
    String sortCode = data.get("sortCode");
    String id = data.get("id");
    sortCodes.setSortCode(sortCode);
    sortCodes.setPostcode(postcode);
    sortCodes.setId(Long.valueOf(id));
    sortCodePage.verifiesDownloadedCsvDetailsAreRight(sortCodes);
  }

  @When("Operator uploads the CSV file with name {string}")
  public void operatorUploadsTheCSVFileWithName(String resourcePath, Map<String, String> data) {
    ClassLoader classLoader = getClass().getClassLoader();
    data = resolveKeyValues(data);
    SortCode sortCodes = new SortCode();
    if (StringUtils.isNotBlank(data.get("postcode"))) {
      String postcode = data.get("postcode");
      sortCodes.setPostcode(postcode);
    }
    if (StringUtils.isNotBlank(data.get("sortCode"))) {
      String sortCode = data.get("sortCode");
      sortCodes.setSortCode(sortCode);
    }
    if (StringUtils.isNotBlank(data.get("id"))) {
      String id = data.get("id");
      sortCodes.setId(Long.valueOf(id));
    }
    File file = getCreateOrderCSVFile(resourcePath, classLoader, sortCodes);
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

  private File getCreateOrderCSVFile(String resourcePath, ClassLoader classLoader,
      SortCode sortCode) {
    File file = new File(Objects.requireNonNull(classLoader.getResource(resourcePath)).getFile());
    String content = TestUtils.readFromFile(file);
    String postcodeValue;
    String sortCodeValue;
    LOGGER.info("content of original file for upload : \n{}", content);

    //Replacing existed postcode
    if (content.contains("existed-postcode")) {
      postcodeValue = sortCode.getPostcode();
      content = content.replaceAll("existed-postcode", postcodeValue);
      LOGGER.info(postcodeValue);
    }

    //Replacing existed sort code
    if (content.contains("existed-sort-code")) {
      sortCodeValue = sortCode.getSortCode();
      content = content.replaceAll("existed-sort-code", sortCodeValue);
      LOGGER.info(sortCodeValue);
    }

    //Replacing new postcode
    if (content.contains("new-postcode")) {
      postcodeValue = sortCode.getPostcode();
      content = content.replaceAll("new-postcode", postcodeValue);
      LOGGER.info(postcodeValue);
      sortCode.setPostcode(postcodeValue);
    }

    //Replacing new sort code
    if (content.contains("new-sort-code")) {
      sortCodeValue = sortCode.getSortCode();
      content = content.replaceAll("new-sort-code", sortCodeValue);
      LOGGER.info(sortCodeValue);
      sortCode.setSortCode(sortCodeValue);
    }

    LOGGER.info("content of generated file for upload : \n{}", content);

    String fileName = file.getName();
    file = TestUtils.createFile(fileName, content);
    put("KEY_OF_UPLOADED_SORT_CODE", sortCode);
    return file;
  }
}
