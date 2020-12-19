package co.nvqa.operator_v2.cucumber.glue;

import static co.nvqa.operator_v2.selenium.page.B2bManagementPage.ID_COLUMN_SUB_SHIPPER_LOCATOR_KEY;
import static co.nvqa.operator_v2.selenium.page.B2bManagementPage.MASTER_SHIPPER_VIEW_SUB_SHIPPER_ACTION_BUTTON_INDEX;
import static co.nvqa.operator_v2.selenium.page.B2bManagementPage.NAME_COLUMN_LOCATOR_KEY;
import static co.nvqa.operator_v2.selenium.page.B2bManagementPage.SUB_SHIPPER_EDIT_ACTION_BUTTON_INDEX;

import co.nvqa.commons.model.shipper.v2.Shipper;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.operator_v2.selenium.page.B2bManagementPage;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import java.util.List;

/**
 * @author Lanang Jati
 */
public class B2bManagementSteps extends AbstractSteps {

  private B2bManagementPage b2bManagementPage;

  @Override
  public void init() {
    b2bManagementPage = new B2bManagementPage(getWebDriver());
  }

  @Then("QA verify b2b management page is displayed")
  public void qaVerifyBBManagementPageIsDisplayed() {
    b2bManagementPage.onDisplay();
  }

  @And("QA verify correct master shippers are displayed on b2b management page")
  public void qaVerifyCorrectMasterShippersAreDisplayedOnBBManagementPage() {
    List<Shipper> masterShipper = get(KEY_LIST_OF_B2B_MASTER_SHIPPER);
    List<Shipper> actualMasterShipper = b2bManagementPage.getMasterShipperTable().readAllEntities();
    boolean isExist;

    for (Shipper shipper : actualMasterShipper) {
      isExist = masterShipper.stream().anyMatch(s -> s.getId().equals(shipper.getId()));
      assertTrue(f("Check shipper with id %d on API", shipper.getId()), isExist);
    }
  }

  @When("Operator fill name search field with {string} on master shipper table on b2b management page")
  public void operatorFillNameSearchFieldWithOnBBManagementPage(String searchValue) {
    b2bManagementPage.getMasterShipperTable().searchByName(searchValue);
    pause1s();
  }

  @When("Operator fill email search field with {string} on master shipper table on b2b management page")
  public void operatorFillEmailSearchFieldWithOnBBManagementPage(String searchValue) {
    b2bManagementPage.getMasterShipperTable().searchByEmail(searchValue);
    pause1s();
  }

  @Then("QA verify master shippers with name contains {string} is displayed on b2b management page")
  public void qaVerifyMasterShippersWithNameContainsIsDisplayedOnBBManagementPage(
      String shipperName) {
    List<Shipper> actualMasterShipper = b2bManagementPage.getMasterShipperTable().readAllEntities();
    boolean isExist = actualMasterShipper.stream().allMatch(s -> s.getName().contains(shipperName));
    assertTrue(f("Check shippers name contain %s", shipperName), isExist);
  }

  @Then("QA verify master shippers with email contains {string} is displayed on b2b management page")
  public void qaVerifyMasterShippersWithEmailContainsIsDisplayedOnBBManagementPage(
      String shipperEmail) {
    List<Shipper> actualMasterShipper = b2bManagementPage.getMasterShipperTable().readAllEntities();
    boolean isExist = actualMasterShipper.stream()
        .allMatch(s -> s.getEmail().contains(shipperEmail));
    assertTrue(f("Check shippers email contain %s", shipperEmail), isExist);
  }

  @When("Operator click view sub-shippers button for shipper {string} on b2b management page")
  public void operatorClickViewSubShippersButtonForShipperOnBBManagementPage(
      String masterHipperName) {
    b2bManagementPage.getMasterShipperTable()
        .clickActionButton(NAME_COLUMN_LOCATOR_KEY, masterHipperName,
            MASTER_SHIPPER_VIEW_SUB_SHIPPER_ACTION_BUTTON_INDEX);
  }

  @Then("QA verify correct sub shippers is displayed on b2b management page")
  public void qaVerifyCorrectSubShippersIsDisplayedOnBBManagementPage() {
    List<Shipper> subShipper = get(KEY_LIST_OF_B2B_SUB_SHIPPER);
    List<Shipper> actualSubShipper = b2bManagementPage.getSubShipperTable().readAllEntities();
    boolean isExist;

    for (Shipper shipper : actualSubShipper) {
      isExist = subShipper.stream()
          .anyMatch(s -> s.getExternalRef().equals(shipper.getExternalRef()));
      assertTrue(f("Check shipper with id %d on API", shipper.getId()), isExist);
    }
  }

  @When("Operator fill name search field with {string} on sub shipper table on b2b management page")
  public void operatorFillNameSearchFieldOnSubShipperBBManagementPage(String searchValue) {
    b2bManagementPage.getSubShipperTable().searchByName(searchValue);
    pause1s();
  }

  @When("Operator fill email search field with {string} on sub shipper table on b2b management page")
  public void operatorFillEmailSearchFieldOnSubShipperBBManagementPage(String searchValue) {
    b2bManagementPage.getSubShipperTable().searchByEmail(searchValue);
    pause1s();
  }

  @Then("QA verify sub shippers with name contains {string} is displayed on b2b management page")
  public void qaVerifySubShippersWithNameContainsIsDisplayedOnBBManagementPage(String shipperName) {
    List<Shipper> actualSubShipper = b2bManagementPage.getSubShipperTable().readAllEntities();
    boolean isExist = actualSubShipper.stream().allMatch(s -> s.getName().contains(shipperName));
    assertTrue(f("Check shippers name contain %s", shipperName), isExist);
  }

  @Then("QA verify sub shippers with email contains {string} is displayed on b2b management page")
  public void qaVerifySubShippersWithEmailContainsIsDisplayedOnBBManagementPage(
      String shipperEmail) {
    List<Shipper> actualSubShipper = b2bManagementPage.getSubShipperTable().readAllEntities();
    boolean isExist = actualSubShipper.stream().allMatch(s -> s.getEmail().contains(shipperEmail));
    assertTrue(f("Check shippers email contain %s", shipperEmail), isExist);
  }


  @When("Operator click add sub-shipper button on b2b management page")
  public void operatorClickAddSubShipperButtonOnBBManagementPage() {
    b2bManagementPage.clickAddSubShipperButton();
  }

  @And("Operator fill seller id field with {string} on b2b management page")
  public void operatorFillSellerIdFieldWithOnBBManagementPage(String sellerId) {
    String id = sellerId;
    if ("random".equalsIgnoreCase(sellerId)) {
      id = String.valueOf(System.currentTimeMillis()).substring(5, 11);
    }
    b2bManagementPage.fillSellerId(id);
    putInList(KEY_SUB_SHIPPER_SELLER_IDS, id);
  }

  @And("Operator fill name field with {string} on b2b management page")
  public void operatorFillNameFieldWithOnBBManagementPage(String name) {
    String fixedName = name;
    if ("random".equalsIgnoreCase(name)) {
      String random = String.valueOf(System.currentTimeMillis()).substring(5, 11);
      fixedName = f("sub shipper %s", random);
    }
    b2bManagementPage.fillName(fixedName);
  }

  @And("Operator fill email field with {string} on b2b management page")
  public void operatorFillEmailFieldWithOnBBManagementPage(String email) {
    String fixedEmail = email;
    if ("random".equalsIgnoreCase(email)) {
      String random = String.valueOf(System.currentTimeMillis()).substring(5, 11);
      fixedEmail = f("sub.shipper+%s@ninja.tes", random);
    }
    b2bManagementPage.fillEmail(fixedEmail);
  }

  @And("Operator click create sub-shipper account button on b2b management page")
  public void operatorClickCreateSubShipperAccountButtonOnBBManagementPage() {
    b2bManagementPage.clickCreateSubShipperButton();
  }

  @Then("QA verify sub shipper is created on b2b management page")
  public void qaVerifySubShipperWithSellerIdIsDisplayedOnBBManagementPage() {
    List<String> expectedSellerIds = get(KEY_SUB_SHIPPER_SELLER_IDS);

    expectedSellerIds.forEach(expectedSellerId ->
    {
      boolean isSubShipperExist;
      boolean isNextPageDisabled;
      List<Shipper> actualSubShipper;
      NvLogger.infof("Check seller id %s", expectedSellerId);

      goToFirstPage();
      do {
        actualSubShipper = b2bManagementPage.getSubShipperTable().readAllEntities();
        isSubShipperExist = actualSubShipper.stream()
            .anyMatch(subShipper -> subShipper.getExternalRef().equals(expectedSellerId));
        isNextPageDisabled = b2bManagementPage.isNextPageButtonDisable();
        if (!isNextPageDisabled) {
          b2bManagementPage.clickNextPageButton();
        }
      }
      while (!isSubShipperExist && !isNextPageDisabled);

      assertTrue(isSubShipperExist);

    });
  }

  private void goToFirstPage() {
    while (!b2bManagementPage.isPrevPageButtonDisable()) {
      b2bManagementPage.clickPrevPageButton();
    }
  }

  @When("Operator click edit action button for sub shipper with seller id contains {string} on b2b management page")
  public void operatorClickEditActionButtonForSubShipperOnBBManagementPage(String sellerId) {
    b2bManagementPage.getSubShipperTable()
        .clickActionButton(ID_COLUMN_SUB_SHIPPER_LOCATOR_KEY, sellerId,
            SUB_SHIPPER_EDIT_ACTION_BUTTON_INDEX);
  }

  @Then("QA verify shipper details page with id {string} is displayed")
  public void qaVerifyShipperDetailsPageWithIdIsDisplayed(String shipperId) {
    b2bManagementPage.shipperDetailsDisplayed(shipperId);
  }

  @Then("QA verify error message {string} is displayed on b2b management page")
  public void qaVerifyErrorMessageIsDisplayedOnBBManagementPage(String errorMsg) {
    String actualErrorMsg = b2bManagementPage.getErrorMessage();
    assertEquals(f("Check error message : %s", errorMsg), errorMsg, actualErrorMsg);
  }
}
