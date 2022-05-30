package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.dp.DpDetailsResponse;
import co.nvqa.commons.model.dp.Partner;
import co.nvqa.commons.util.StandardTestConstants;
import co.nvqa.operator_v2.model.Dp;
import co.nvqa.operator_v2.model.DpPartner;
import co.nvqa.operator_v2.model.DpUser;
import co.nvqa.operator_v2.model.RouteLogsParams;
import co.nvqa.operator_v2.selenium.page.DpAdministrationPage;
import co.nvqa.operator_v2.selenium.page.DpAdministrationReactPage;
import co.nvqa.operator_v2.util.TestUtils;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.guice.ScenarioScoped;
import java.io.File;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import javax.mail.Part;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class DpAdministrationSteps extends AbstractSteps {

  private static final String NINJA_POINT_URL = StandardTestConstants.API_BASE_URL
      .replace("api", "point");
  private DpAdministrationPage dpAdminPage;
  private DpAdministrationReactPage dpAdminReactPage;

  private static final String KEY_DP_PARTNER_NAME = "KEY_DP_PARTNER_NAME";

  public DpAdministrationSteps() {
  }

  @Override
  public void init() {
    dpAdminPage = new DpAdministrationPage(getWebDriver());
    dpAdminReactPage = new DpAdministrationReactPage(getWebDriver());
  }

  @Given("Operator add new DP Partner on DP Administration page with the following attributes:")
  public void operatorAddNewDpPartnerOnDpAdministrationPageWithTheFollowingAttributes(
      Map<String, String> data) {
    DpPartner dpPartner = new DpPartner(data);
    dpAdminPage.addPartner(dpPartner);
    put(KEY_DP_PARTNER, dpPartner);
  }

  @Then("Operator verify new DP Partner params")
  public void operatorVerifyNewDpPartnerParams() {
    DpPartner dpPartner = get(KEY_DP_PARTNER);
    dpAdminPage.verifyDpPartnerParams(dpPartner);
    takesScreenshot();
  }

  @When("Operator get all DP Partners params on DP Administration page")
  public void operatorGetAllDpPartnersParamsOnDriverTypeManagementPage() {
    List<DpPartner> dpPartnersParams = dpAdminPage.dpPartnersTable().readAllEntities();
    put(KEY_LIST_OF_DP_PARTNERS, dpPartnersParams);
  }

  @When("Operator click on Download CSV File button on DP Administration page")
  public void operatorClickOnDownloadCsvFileButtonOnDpAdministrationPage() {
    dpAdminPage.downloadCsvFile();
  }

  @When("Operator click on Download CSV File button on DP Administration React page")
  public void operatorClickOnDownloadCsvFileButtonOnDpAdministrationReactPage() {
    dpAdminReactPage.inFrame(() -> {
      dpAdminReactPage.buttonDownloadCsv.click();
      pause5s();
    });
  }

  @Then("Downloaded CSV file contains correct DP Partners data")
  public void downloadedCsvFileContainsCorrectDpPartnersData() {
    List<DpPartner> dpPartnersParams = get(KEY_LIST_OF_DP_PARTNERS);
    dpAdminPage.verifyDownloadedFileContent(dpPartnersParams);
  }

  @When("^Operator get first (\\d+) DP Partners params on DP Administration page$")
  public void operatorGetFirstDpPartnersParamsOnDpAdministrationPage(int count) {
    List<DpPartner> dpPartnersParams = dpAdminPage.dpPartnersTable().readFirstEntities(count);
    put(KEY_LIST_OF_DP_PARTNERS, dpPartnersParams);
  }

  @When("Operator update created DP Partner on DP Administration page with the following attributes:")
  public void operatorUpdateCreatedDpPartnerOnDpAdministrationPageWithTheFollowingAttributes(
      Map<String, String> data) {
    DpPartner dpPartner = get(KEY_DP_PARTNER);
    String partnerName = dpPartner.getName();
    dpPartner.fromMap(data);
    dpAdminPage.editPartner(partnerName, dpPartner);
    takesScreenshot();
  }

  @When("Operator add new DP for the DP Partner on DP Administration page with the following attributes:")
  public void operatorAddNewDpForTheDpPartnerOnDpAdministrationPageWithTheFollowingAttributes(
      Map<String, String> data) {
    DpPartner dpPartner = get(KEY_DP_PARTNER);
    File file = null;
    if (data.get("dpPhoto") != null) {
      file = getDpPhoto(getResourcePath(data.get("dpPhoto")));
    }
    Dp dp = new Dp(data);
    dpAdminPage.addDistributionPoint(dpPartner.getName(), dp, file);
    put(KEY_DISTRIBUTION_POINT, dp);
  }

  @When("Operator add new DP for the DP Partner on DP Administration page using existed partner with the following attributes:")
  public void operatorAddNewDpForTheDpPartnerOnDpAdministrationPageUsingExistedPartnerWithTheFollowingAttributes(
      Map<String, String> data) {
    final Partner dpPartner = get(KEY_DP_PARTNER);
    File file = null;
    if (data.get("dpPhoto") != null) {
      file = getDpPhoto(getResourcePath(data.get("dpPhoto")));
    }
    final Dp dp = new Dp(data);
    dpAdminPage.addDistributionPoint(dpPartner.getName(), dp, file);
    takesScreenshot();
    put(KEY_DISTRIBUTION_POINT, dp);
    put(KEY_NEWLY_CREATED_DP_ID, dp.getId());
  }

  private String getResourcePath(String status) {
    String resourcePath;
    if ("valid".equalsIgnoreCase(status)) {
      resourcePath = "images/dpPhotoValidSize.png";
    } else {
      resourcePath = "images/dpPhotoInvalidSize.png";
    }
    return resourcePath;
  }

  @And("Operator Search with Some DP Partner Details :")
  public void operatorVerifyRouteDetails(Map<String, String> searchSDetailsAsMap) {
    Partner partner = get(KEY_DP_MANAGEMENT_PARTNER);
    DpPartner expected = dpAdminReactPage.convertPartnerToDpPartner(partner);

    searchSDetailsAsMap = resolveKeyValues(searchSDetailsAsMap);
    String searchDetailsData = replaceTokens(searchSDetailsAsMap.get("searchDetails"),
        createDefaultTokens());
    String [] extractDetails = searchDetailsData.split(",");

    dpAdminReactPage.inFrame(() -> {
      for(String extractDetail : extractDetails){
        String valueDetails = dpAdminReactPage.getDpPartnerElementByMap(extractDetail,expected);
        dpAdminReactPage.fillFilter(extractDetail,valueDetails);
        pause2s();
        dpAdminReactPage.readEntity(expected);
        dpAdminReactPage.clearFilter(extractDetail);
      }
    });
  }

  @And("Operator click on Add Partner button on DP Administration React page")
  public void operatorPressAddDpButton(){
    dpAdminReactPage.inFrame(() -> {
      dpAdminReactPage.buttonAddPartner.click();
      pause3s();
    });
  }

  @Then("Operator Fill Dp Partner Details below :")
  public void operatorFillDpPartnerDetails(DataTable dt){
    List<Partner> partners = convertDataTableToList(dt, Partner.class);
    Partner partner = partners.get(0);

    dpAdminReactPage.inFrame(() -> {
      if (partner.getName() != null){
        dpAdminReactPage.formPartnerName.setValue(partner.getName());
        put(KEY_DP_PARTNER_NAME,partner.getName());
      }
      if (partner.getPocName() != null){
        if(!dpAdminReactPage.formPocName.getValue().equals("")){
          dpAdminReactPage.formPocName.forceClear();
        }
        dpAdminReactPage.formPocName.setValue(partner.getPocName());
      }

      if (partner.getPocTel() != null){

        if(!dpAdminReactPage.formPocNo.getValue().equals("")){
          dpAdminReactPage.formPocNo.forceClear();
        }

        if (partner.getPocTel().equals("VALID")){
          partner.setPocTel(TestUtils.generatePhoneNumber());
          dpAdminReactPage.formPocNo.setValue(partner.getPocTel());
        } else {
          dpAdminReactPage.formPocNo.setValue(partner.getPocTel());
        }
      }

      if (partner.getPocEmail() != null){
        dpAdminReactPage.formPocEmail.setValue(partner.getPocEmail());
      }
      if (partner.getRestrictions() != null){
        dpAdminReactPage.formRestrictions.setValue(partner.getRestrictions());
      }
      if (partner.getSendNotificationsToCustomer() != null && partner.getSendNotificationsToCustomer()){
        dpAdminReactPage.buttonSendNotifications.click();
      }
    });
  }

  @Then("Operator press submit button")
  public void submitDpPartnerButton(){
    dpAdminReactPage.inFrame(() -> {
      dpAdminReactPage.buttonSubmitPartner.click();
    });
  }

  @Then("Operator press edit partner button")
  public void editDpPartnerButton(){
    dpAdminReactPage.inFrame(() -> {
      dpAdminReactPage.buttonEditPartner.click();
    });
  }

  @Then("Operator press submit partner changes button")
  public void submitDpPartnerChangesButton(){
    dpAdminReactPage.inFrame(() -> {
      dpAdminReactPage.buttonSubmitPartnerChanges.click();
    });
  }

  @And("Operator check the submitted data in the table")
  public void checkSubmittedDataInTable() {
    String partnerName = get(KEY_DP_PARTNER_NAME);
    dpAdminReactPage.inFrame(() -> {
      dpAdminReactPage.fillFilter("name",partnerName);
    });
  }

  @Then("Operator get partner id")
  public void operatorGetPartnerId(){
    dpAdminReactPage.inFrame(() -> {
      String partnerId = dpAdminReactPage.labelPartnerId.getText();
      put(KEY_DP_PARTNER_ID,partnerId);
    });
  }

  @Then("Operator need to make sure that the id and dpms partner id from newly created dp partner is same")
  public void dpPartnerIdDpmsIdChecking(){
    Partner partner = get(KEY_DP_PARTNER);
    dpAdminReactPage.inFrame(() -> {
      dpAdminReactPage.checkingIdAndDpmsId(partner);
    });
  }

  @And("Operator check the data again with pressing ascending and descending order :")
  public void ascendingDataCheck(Map<String, String> searchSDetailsAsMap) {
    Partner partner = get(KEY_DP_MANAGEMENT_PARTNER);
    DpPartner expected = dpAdminReactPage.convertPartnerToDpPartner(partner);

    searchSDetailsAsMap = resolveKeyValues(searchSDetailsAsMap);
    String searchDetailsData = replaceTokens(searchSDetailsAsMap.get("searchDetails"),
        createDefaultTokens());
    String [] extractDetails = searchDetailsData.split(",");

    dpAdminReactPage.inFrame(() -> {
      String valueDetails = dpAdminReactPage.getDpPartnerElementByMap(extractDetails[0],expected);
      dpAdminReactPage.fillFilter(extractDetails[0],valueDetails);
      for(String extractDetail : extractDetails){
        dpAdminReactPage.sortFilter(extractDetail);
        pause2s();
        dpAdminReactPage.readEntity(expected);
      }
    });
  }

  private File getDpPhoto(String resourcePath) {
    final ClassLoader classLoader = getClass().getClassLoader();
    return new File(Objects.requireNonNull(classLoader.getResource(resourcePath)).getFile());
  }

  @Then("Operator verify new DP params")
  public void operatorVerifyNewDpParams() {
    final Dp expectedDpParams = get(KEY_DISTRIBUTION_POINT);
    takesScreenshot();
    dpAdminPage.verifyDpParams(expectedDpParams);
    put(KEY_DISTRIBUTION_POINT_ID, expectedDpParams.getId());
  }

  @When("Operator update created DP for the DP Partner on DP Administration page with the following attributes:")
  public void operatorUpdateCreatedDpForTheDpPartnerOnDpAdministrationPageWithTheFollowingAttributes(
      Map<String, String> data) {
    final Dp dpParams = get(KEY_DISTRIBUTION_POINT);
    final String currentDpName = dpParams.getName();
    dpParams.fromMap(data);
    dpAdminPage.editDistributionPoint(currentDpName, dpParams);
    put(KEY_DISTRIBUTION_POINT, dpParams);
  }

  @When("Operator get all DP params on DP Administration page")
  public void operatorGetAllDpParamsOnDpAdministrationPage() {
    final List<Dp> dpParams = dpAdminPage.dpTable().readAllEntities();
    put(KEY_LIST_OF_DISTRIBUTION_POINTS, dpParams);
  }

  @Then("Downloaded CSV file contains correct DP data")
  public void downloadedCsvFileContainsCorrectDpData() {
    final List<Dp> dpParams = get(KEY_LIST_OF_DISTRIBUTION_POINTS);
    dpAdminPage.verifyDownloadedDpFileContent(dpParams);
    takesScreenshot();
  }

  @When("Operator add DP User for the created DP on DP Administration page with the following attributes:")
  public void operatorAddDpUserForTheCreatedDpOnDpAdministrationPageWithTheFollowingAttributes(
      Map<String, String> data) {
    Dp dpParams = get(KEY_DISTRIBUTION_POINT);
    DpUser dpUser = new DpUser();
    dpUser.fromMap(data);
    dpAdminPage.addDpUser(dpParams.getName(), dpUser);
    takesScreenshot();
    put(KEY_DP_USER, dpUser);
  }

  @When("Operator update created DP User for the created DP on DP Administration page with the following attributes:")
  public void operatorUpdateDpUserForTheCreatedDpOnDpAdministrationPageWithTheFollowingAttributes(
      Map<String, String> data) {
    DpUser dpUser = get(KEY_DP_USER);
    String username = dpUser.getClientId();
    DpUser newPdUserParams = new DpUser(data);
    dpUser.merge(newPdUserParams);
    dpAdminPage.editDpUser(username, newPdUserParams);
    takesScreenshot();
  }

  @Then("Operator verify new DP User params")
  public void operatorVerifyNewDpUserParams() {
    DpUser dpUser = get(KEY_DP_USER);
    dpAdminPage.verifyDpUserParams(dpUser);
    takesScreenshot();
  }

  @When("Operator get all DP Users params on DP Administration page")
  public void operatorGetAllDpUsersParamsOnDpAdministrationPage() {
    final List<DpUser> dpUsers = dpAdminPage.dpUsersTable().readAllEntities();
    put(KEY_LIST_OF_DP_USERS, dpUsers);
  }

  @Then("Downloaded CSV file contains correct DP Users data")
  public void downloadedCsvFileContainsCorrectDpUsersData() {
    List<DpUser> dpUsers = get(KEY_LIST_OF_DP_USERS);
    dpAdminPage.verifyDownloadedDpUsersFileContent(dpUsers);
    takesScreenshot();
  }

  @And("Operator select View DPs action for created DP partner on DP Administration page")
  public void operatorSelectViewDpsForCreatedDpPartnerOnDpAdministrationPage() {
    Partner dpPartner = get(KEY_DP_PARTNER);
    dpAdminPage.openViewDpsScreen(dpPartner.getName());
    takesScreenshot();
  }

  @And("Operator select View Users action for created DP on DP Administration page")
  public void operatorSelectViewUsersForCreatedDpOnDpAdministrationPage() {
    final Dp dp = get(KEY_DISTRIBUTION_POINT);
    dpAdminPage.openViewUsersScreen(dp.getName());
  }

  @Then("Operator verifies dp Params with database")
  public void operatorVerifiesDpParamsWithDatabase() {
    DpDetailsResponse dbDpParams = get(KEY_DP_DB_DETAILS);
    DpDetailsResponse apiDpParams = get(KEY_DP_DETAILS);
    dpAdminPage.verifyDpParamsWithDB(dbDpParams, apiDpParams);
  }

  @Then("Operator verifies the cut off time is {string}")
  public void operatorVerifiesTheCutOffTimeIs(String expectedCutOffTime) {
    String actualCutOffTime = get(KEY_DP_SETTING_DP_CUT_OFF_TIME);
    dpAdminPage.verifyCutOffTime(expectedCutOffTime, actualCutOffTime);
    takesScreenshot();
  }

  @Then("Operator verifies the error message for duplicate {string}")
  public void operatorVerifiesTheErrorMessageForDuplicate(String field) {
    dpAdminPage.verifyErrorMessageForDpCreation(field);
    takesScreenshot();
  }

  @Then("Operator verifies the image is {string}")
  public void operatorVerifiesTheImageIs(String status) {
    String image = get(KEY_DP_SETTING_DP_IMAGE);
    dpAdminPage.verifyImageIsPresent(image, status);
    takesScreenshot();
  }

  @When("Operator deletes the dp image and {string}")
  public void operatorDeletesTheDpImageAnd(String action) {
    Dp dpParams = get(KEY_DISTRIBUTION_POINT);
    String currentDpName = dpParams.getName();
    dpAdminPage.deleteDpImageAndSaveSettings(currentDpName, action);
  }

  @When("Operator edits the dp {string} image and save settings")
  public void operatorEditsTheDpImageAndSaveSettings(String status) {
    Dp dpParams = get(KEY_DISTRIBUTION_POINT);
    String currentDpName = dpParams.getName();
    File file = getDpPhoto(getResourcePath(status));
    dpAdminPage.editDpImageAndSaveSettings(currentDpName, file, status);
    takesScreenshot();
  }

  @When("Operator Reset password {string}")
  public void operatorResetPassword(String status) {
    DpUser dpUser = get(KEY_DP_USER);
    String username = dpUser.getClientId();
    String password = "password";
    dpUser.setClientSecret(password);
    dpAdminPage.resetUserPassword(username, password, status);
    put(KEY_DP_USER, dpUser);
  }

  @Given("Open Ninja Point V3 Web Page")
  public void openNinjaPointVWebPage() {
    getWebDriver().get(NINJA_POINT_URL);
  }

  @When("User Login with username and new password")
  public void userLoginWithUsernameAndNewPassword() {
    DpUser dpUser = get(KEY_DP_USER);
    String username = dpUser.getClientId();
    String password = dpUser.getClientSecret();
    dpAdminPage.loginNinjaPoint(username, password);
  }

  @Then("Ninja Point V3 Welcome Page displayed")
  public void ninjaPointVWelcomePageDisplayed() {
    dpAdminPage.welcomePageDisplayed();
  }

  @Given("Operator convert the Partner to DP Partner Modal")
  public void operatorConvertThePartnerToDPPartnerModal() {
    Partner partner = get(KEY_DP_PARTNER);
    DpPartner dpPartner = new DpPartner();
    dpPartner.setId(partner.getId());
    dpPartner.setDpmsPartnerId(partner.getDpmsPartnerId());
    dpPartner.setName(partner.getName());
    dpPartner.setPocEmail(partner.getPocEmail());
    dpPartner.setPocName(partner.getPocName());
    dpPartner.setPocTel(partner.getPocTel());
    dpPartner.setRestrictions(partner.getRestrictions());

    put(KEY_DP_PARTNER, dpPartner);
  }
}
