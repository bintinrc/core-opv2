package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.core.utils.CoreScenarioStorageKeys;
import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.common.core.model.ThirdPartyShippers;
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

    ThirdPartyShippers thirdPartyShipper = new ThirdPartyShippers();
    thirdPartyShipper.setName(name);
    thirdPartyShipper.setCode(code);
    thirdPartyShipper.setUrl(url);
    thirdPartyShippersPage.addThirdPartyShipper(thirdPartyShipper);

    put(CoreScenarioStorageKeys.KEY_CORE_CREATED_THIRD_PARTY_SHIPPER, thirdPartyShipper);
  }

  @Then("Operator verify the new Third Party Shipper is created successfully")
  public void operatorVerifyTheNewThirdPartyShipperIsCreatedSuccessfully() {
    ThirdPartyShippers thirdPartyShipper = get(CoreScenarioStorageKeys.KEY_CORE_CREATED_THIRD_PARTY_SHIPPER);
    thirdPartyShippersPage.verifyThirdPartyShipperIsCreatedSuccessfully(thirdPartyShipper);
  }

  @When("Operator update the new Third Party Shipper")
  public void operatorUpdateTheNewThirdPartyShipper() {
    ThirdPartyShippers thirdPartyShipper = get(CoreScenarioStorageKeys.KEY_CORE_CREATED_THIRD_PARTY_SHIPPER);

    ThirdPartyShippers thirdPartyShipperEdited = new ThirdPartyShippers();
    thirdPartyShipperEdited.setId(thirdPartyShipper.getId());
    thirdPartyShipperEdited.setName(thirdPartyShipper.getName() + " [EDITED]");
    thirdPartyShipperEdited.setCode(generateThirdPartyShipperCode());
    thirdPartyShipperEdited.setUrl(thirdPartyShipper.getUrl() + ".sg");

    thirdPartyShippersPage.editThirdPartyShipper(thirdPartyShipper, thirdPartyShipperEdited);
    put(CoreScenarioStorageKeys.KEY_CORE_CREATED_THIRD_PARTY_SHIPPER_EDITED, thirdPartyShipperEdited);
  }

  @Then("Operator verify the new Third Party Shipper is updated successfully")
  public void operatorVerifyTheNewThirdPartyShipperIsUpdatedSuccessfully() {
    ThirdPartyShippers thirdPartyShipperEdited = get(CoreScenarioStorageKeys.KEY_CORE_CREATED_THIRD_PARTY_SHIPPER_EDITED);
    thirdPartyShippersPage.verifyThirdPartyShipperIsUpdatedSuccessfully(thirdPartyShipperEdited);
  }

  @When("Operator delete the new Third Party Shipper")
  public void operatorDeleteTheNewThirdPartyShipper() {
    ThirdPartyShippers thirdPartyShipper = containsKey(CoreScenarioStorageKeys.KEY_CORE_CREATED_THIRD_PARTY_SHIPPER_EDITED) ? get(
        CoreScenarioStorageKeys.KEY_CORE_CREATED_THIRD_PARTY_SHIPPER_EDITED) : get(CoreScenarioStorageKeys.KEY_CORE_CREATED_THIRD_PARTY_SHIPPER);
    thirdPartyShippersPage.deleteThirdPartyShipper(thirdPartyShipper);
  }

  @Then("Operator verify the new Third Party Shipper is deleted successfully")
  public void operatorVerifyTheNewThirdPartyShipperIsDeletedSuccessfully() {
    ThirdPartyShippers thirdPartyShipper = containsKey(CoreScenarioStorageKeys.KEY_CORE_CREATED_THIRD_PARTY_SHIPPER_EDITED) ? get(
        CoreScenarioStorageKeys.KEY_CORE_CREATED_THIRD_PARTY_SHIPPER_EDITED) : get(CoreScenarioStorageKeys.KEY_CORE_CREATED_THIRD_PARTY_SHIPPER);
    thirdPartyShippersPage.verifyThirdPartyShipperIsDeletedSuccessfully(thirdPartyShipper);
  }

  @Then("Operator check all filters on Third Party Shippers page work fine")
  public void operatorCheckAllFiltersOnThirdPartyShippersPageWork() {
    ThirdPartyShippers thirdPartyShipper = get(CoreScenarioStorageKeys.KEY_CORE_CREATED_THIRD_PARTY_SHIPPER);
    thirdPartyShippersPage.verifyAllFiltersWorkFine(thirdPartyShipper);
  }

  @When("Operator download Third Party Shippers CSV file")
  public void operatorDownloadThirdPartyShippersCsvFile() {
    thirdPartyShippersPage.downloadCsvFile();
  }

  @When("Operator verify Third Party Shippers CSV file downloaded successfully")
  public void operatorVerifyThirdPartyShippersCsvFileDownloadedSuccessfully() {
    ThirdPartyShippers thirdPartyShipper = get(CoreScenarioStorageKeys.KEY_CORE_CREATED_THIRD_PARTY_SHIPPER);
    thirdPartyShippersPage.verifyCsvFileDownloadedSuccessfully(thirdPartyShipper);
  }
}