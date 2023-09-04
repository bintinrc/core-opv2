package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.operator_v2.model.ThirdPartyShipper;
import co.nvqa.operator_v2.selenium.page.ThirdPartyShippersPage;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.guice.ScenarioScoped;
import org.apache.commons.lang3.StringUtils;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class ThirdPartyShippersSteps extends AbstractSteps {

  private static final String KEY_CREATED_THIRD_PARTY_SHIPPER = "KEY_CREATED_THIRD_PARTY_SHIPPER";
  private static final String KEY_CREATED_THIRD_PARTY_SHIPPER_EDITED = "KEY_CREATED_THIRD_PARTY_SHIPPER_EDITED";
  private ThirdPartyShippersPage thirdPartyShippersPage;

  public ThirdPartyShippersSteps() {
  }

  @Override
  public void init() {
    thirdPartyShippersPage = new ThirdPartyShippersPage(getWebDriver());
  }

  private String generateThirdPartyShipperCode() {
    return f("T-%s", StringUtils
        .left(String.valueOf(System.currentTimeMillis()), 8)); // Maximum character is 10.
  }

  @When("Operator create new Third Party Shippers")
  public void operatorCreateNewThirdPartyShippers() {
    String uniqueString = StandardTestUtils.generateDateUniqueString();
    String name = f("TPS-%s", uniqueString);
    String code = generateThirdPartyShipperCode();
    String url = f("https://www.tps%s.co", uniqueString);

    ThirdPartyShipper thirdPartyShipper = new ThirdPartyShipper();
    thirdPartyShipper.setName(name);
    thirdPartyShipper.setCode(code);
    thirdPartyShipper.setUrl(url);
    thirdPartyShippersPage.addThirdPartyShipper(thirdPartyShipper);

    put(KEY_CREATED_THIRD_PARTY_SHIPPER, thirdPartyShipper);
  }

  @Then("Operator verify the new Third Party Shipper is created successfully")
  public void operatorVerifyTheNewThirdPartyShipperIsCreatedSuccessfully() {
    ThirdPartyShipper thirdPartyShipper = get(KEY_CREATED_THIRD_PARTY_SHIPPER);
    thirdPartyShippersPage.verifyThirdPartyShipperIsCreatedSuccessfully(thirdPartyShipper);
  }

  @When("Operator update the new Third Party Shipper")
  public void operatorUpdateTheNewThirdPartyShipper() {
    ThirdPartyShipper thirdPartyShipper = get(KEY_CREATED_THIRD_PARTY_SHIPPER);

    ThirdPartyShipper thirdPartyShipperEdited = new ThirdPartyShipper();
    thirdPartyShipperEdited.setId(thirdPartyShipper.getId());
    thirdPartyShipperEdited.setName(thirdPartyShipper.getName() + " [EDITED]");
    thirdPartyShipperEdited.setCode(generateThirdPartyShipperCode());
    thirdPartyShipperEdited.setUrl(thirdPartyShipper.getUrl() + ".sg");

    thirdPartyShippersPage.editThirdPartyShipper(thirdPartyShipper, thirdPartyShipperEdited);
    put(KEY_CREATED_THIRD_PARTY_SHIPPER_EDITED, thirdPartyShipperEdited);
  }

  @Then("Operator verify the new Third Party Shipper is updated successfully")
  public void operatorVerifyTheNewThirdPartyShipperIsUpdatedSuccessfully() {
    ThirdPartyShipper thirdPartyShipperEdited = get(KEY_CREATED_THIRD_PARTY_SHIPPER_EDITED);
    thirdPartyShippersPage.verifyThirdPartyShipperIsUpdatedSuccessfully(thirdPartyShipperEdited);
  }

  @When("Operator delete the new Third Party Shipper")
  public void operatorDeleteTheNewThirdPartyShipper() {
    ThirdPartyShipper thirdPartyShipper = containsKey(KEY_CREATED_THIRD_PARTY_SHIPPER_EDITED) ? get(
        KEY_CREATED_THIRD_PARTY_SHIPPER_EDITED) : get(KEY_CREATED_THIRD_PARTY_SHIPPER);
    thirdPartyShippersPage.deleteThirdPartyShipper(thirdPartyShipper);
  }

  @Then("Operator verify the new Third Party Shipper is deleted successfully")
  public void operatorVerifyTheNewThirdPartyShipperIsDeletedSuccessfully() {
    ThirdPartyShipper thirdPartyShipper = containsKey(KEY_CREATED_THIRD_PARTY_SHIPPER_EDITED) ? get(
        KEY_CREATED_THIRD_PARTY_SHIPPER_EDITED) : get(KEY_CREATED_THIRD_PARTY_SHIPPER);
    thirdPartyShippersPage.verifyThirdPartyShipperIsDeletedSuccessfully(thirdPartyShipper);
  }

  @Then("Operator check all filters on Third Party Shippers page work fine")
  public void operatorCheckAllFiltersOnThirdPartyShippersPageWork() {
    ThirdPartyShipper thirdPartyShipper = get(KEY_CREATED_THIRD_PARTY_SHIPPER);
    thirdPartyShippersPage.verifyAllFiltersWorkFine(thirdPartyShipper);
  }

  @When("Operator download Third Party Shippers CSV file")
  public void operatorDownloadThirdPartyShippersCsvFile() {
    thirdPartyShippersPage.downloadCsvFile();
  }

  @When("Operator verify Third Party Shippers CSV file downloaded successfully")
  public void operatorVerifyThirdPartyShippersCsvFileDownloadedSuccessfully() {
    ThirdPartyShipper thirdPartyShipper = get(KEY_CREATED_THIRD_PARTY_SHIPPER);
    thirdPartyShippersPage.verifyCsvFileDownloadedSuccessfully(thirdPartyShipper);
  }
}