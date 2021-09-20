package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.shipper.v2.Shipper;
import co.nvqa.operator_v2.selenium.page.LoyaltyCreationPage;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.List;

import static co.nvqa.operator_v2.util.KeyConstants.KEY_SHIPPER_NAME;

public class LoyaltyCreationSteps extends AbstractSteps{

  private LoyaltyCreationPage loyaltyCreationPage;
  private static final String SHIPPER_NAME = "SHIPPER_LOYALTY";
  private static final String SHIPPER_EMAIL = "shipper-loyalty@gmail.com";

  @Override
  public void init() {
    loyaltyCreationPage = new LoyaltyCreationPage(getWebDriver());
  }

  @When("Operator click Download template button for loyalty creation")
  public void downloadTemplate() {
    loyaltyCreationPage.inFrame(page -> page.downloadTemplateButton.click());
  }

  @When("Operator create csv file for loyalty creation header only")
  public void createHeaderOnlyLoyaltyCreationCsv() {
    loyaltyCreationPage.createLoyaltyCsvHeaderOnly();
  }

  @When("Operator add created shipper to new csv file for loyalty creation")
  public void addShipperToNewLoyaltyCreationCsv() {
    Shipper shipper = get(KEY_CREATED_SHIPPER);
    loyaltyCreationPage.createLoyaltyCsv(shipper, true, null);
  }

  @When("Operator add created shipper to csv file for loyalty creation")
  public void addShipperToLoyaltyCreationCsv() {
    Shipper shipper = get(KEY_CREATED_SHIPPER);
    loyaltyCreationPage.addDataToLoyaltyCsv(shipper, true, null);
  }

  @When("Operator add created sub shipper to csv file for loyalty creation")
  public void addSubShipperToLoyaltyCreationCsv() {
    List<Shipper> subShipperList = get(KEY_LIST_OF_B2B_SUB_SHIPPER);
    String masterShipperId = get(KEY_LEGACY_SHIPPER_ID);
    String expectedSubShipperName = get(KEY_SHIPPER_NAME);

    for (Shipper subShipper : subShipperList) {
      if (expectedSubShipperName.equalsIgnoreCase(subShipper.getName())) {
        loyaltyCreationPage.addDataToLoyaltyCsv(subShipper, true, masterShipperId);
        break;
      }
    }
  }

  @When("Operator add shipper with empty email to csv file for loyalty creation")
  public void addShipperWithEmptyEmail() {
    Shipper shipper = new Shipper();
    shipper.setLegacyId(1L);
    shipper.setName(SHIPPER_NAME);
    loyaltyCreationPage.addDataToLoyaltyCsv(shipper, true, null);
  }

  @When("Operator add shipper with empty phone number to csv file for loyalty creation")
  public void addShipperWithEmptyPhone() {
    Shipper shipper = new Shipper();
    shipper.setLegacyId(1L);
    shipper.setName(SHIPPER_NAME);
    shipper.setEmail(SHIPPER_EMAIL);
    loyaltyCreationPage.addDataToLoyaltyCsv(shipper, false, null);
  }

  @When("Operator add shipper with empty email and phone number to csv file for loyalty creation")
  public void addShipperWithEmptyEmailAndPhone() {
    Shipper shipper = new Shipper();
    shipper.setLegacyId(1L);
    loyaltyCreationPage.addDataToLoyaltyCsv(shipper, false, null);
  }

  @When("Operator upload csv file for loyalty creation")
  public void uploadLoyaltyCreationCsv() {
    loyaltyCreationPage.uploadLoyaltyShipper();
  }

  @When("Operator verifies loyalty creation csv template downloaded with data below:")
  public void verifiesCsvTemplate(List<String> csvData) {
    String expectedBody = String.join("\n", csvData);
    loyaltyCreationPage.verifyCsvFileDownloadedSuccessfully(expectedBody);
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
