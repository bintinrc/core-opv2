package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.dp.DpDetailsResponse;
import co.nvqa.commons.model.dp.Partner;
import co.nvqa.commons.util.StandardTestConstants;
import co.nvqa.operator_v2.model.Dp;
import co.nvqa.operator_v2.model.DpPartner;
import co.nvqa.operator_v2.model.DpUser;
import co.nvqa.operator_v2.selenium.page.DpAdministrationPage;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import java.io.File;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class DpAdministrationSteps extends AbstractSteps {

  private static final String NINJA_POINT_URL = StandardTestConstants.API_BASE_URL
      .replace("api", "point");
  private DpAdministrationPage dpAdminPage;

  public DpAdministrationSteps() {
  }

  @Override
  public void init() {
    dpAdminPage = new DpAdministrationPage(getWebDriver());
  }

  @Given("^Operator add new DP Partner on DP Administration page with the following attributes:$")
  public void operatorAddNewDpPartnerOnDpAdministrationPageWithTheFollowingAttributes(
      Map<String, String> data) {
    DpPartner dpPartner = new DpPartner(data);
    dpAdminPage.addPartner(dpPartner);
    put(KEY_DP_PARTNER, dpPartner);
  }

  @Then("^Operator verify new DP Partner params$")
  public void operatorVerifyNewDpPartnerParams() {
    DpPartner dpPartner = get(KEY_DP_PARTNER);
    dpAdminPage.verifyDpPartnerParams(dpPartner);
  }

  @When("^Operator get all DP Partners params on DP Administration page$")
  public void operatorGetAllDpPartnersParamsOnDriverTypeManagementPage() {
    List<DpPartner> dpPartnersParams = dpAdminPage.dpPartnersTable().readAllEntities();
    put(KEY_LIST_OF_DP_PARTNERS, dpPartnersParams);
  }

  @When("^Operator click on Download CSV File button on DP Administration page$")
  public void operatorClickOnDownloadCsvFileButtonOnDpAdministrationPage() {
    dpAdminPage.downloadCsvFile();
  }

  @Then("^Downloaded CSV file contains correct DP Partners data$")
  public void downloadedCsvFileContainsCorrectDpPartnersData() {
    List<DpPartner> dpPartnersParams = get(KEY_LIST_OF_DP_PARTNERS);
    dpAdminPage.verifyDownloadedFileContent(dpPartnersParams);
  }

  @When("^Operator get first (\\d+) DP Partners params on DP Administration page$")
  public void operatorGetFirstDpPartnersParamsOnDpAdministrationPage(int count) {
    List<DpPartner> dpPartnersParams = dpAdminPage.dpPartnersTable().readFirstEntities(count);
    put(KEY_LIST_OF_DP_PARTNERS, dpPartnersParams);
  }

  @When("^Operator update created DP Partner on DP Administration page with the following attributes:$")
  public void operatorUpdateCreatedDpPartnerOnDpAdministrationPageWithTheFollowingAttributes(
      Map<String, String> data) {
    DpPartner dpPartner = get(KEY_DP_PARTNER);
    String partnerName = dpPartner.getName();
    dpPartner.fromMap(data);
    dpAdminPage.editPartner(partnerName, dpPartner);
  }

  @When("^Operator add new DP for the DP Partner on DP Administration page with the following attributes:$")
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
    Partner dpPartner = get(KEY_DP_PARTNER);
    File file = null;
    if (data.get("dpPhoto") != null) {
      file = getDpPhoto(getResourcePath(data.get("dpPhoto")));
    }
    Dp dp = new Dp(data);
    dpAdminPage.addDistributionPoint(dpPartner.getName(), dp, file);
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

  private File getDpPhoto(String resourcePath) {
    ClassLoader classLoader = getClass().getClassLoader();
    File file = new File(Objects.requireNonNull(classLoader.getResource(resourcePath)).getFile());
    return file;
  }

  @Then("^Operator verify new DP params$")
  public void operatorVerifyNewDpParams() {
    Dp expectedDpParams = get(KEY_DISTRIBUTION_POINT);
    dpAdminPage.verifyDpParams(expectedDpParams);
    put(KEY_DISTRIBUTION_POINT_ID, expectedDpParams.getId());
  }

  @When("^Operator update created DP for the DP Partner on DP Administration page with the following attributes:$")
  public void operatorUpdateCreatedDpForTheDpPartnerOnDpAdministrationPageWithTheFollowingAttributes(
      Map<String, String> data) {
    Dp dpParams = get(KEY_DISTRIBUTION_POINT);
    String currentDpName = dpParams.getName();
    dpParams.fromMap(data);
    dpAdminPage.editDistributionPoint(currentDpName, dpParams);
    put(KEY_DISTRIBUTION_POINT, dpParams);
  }

  @When("^Operator get all DP params on DP Administration page$")
  public void operatorGetAllDpParamsOnDpAdministrationPage() {
    List<Dp> dpParams = dpAdminPage.dpTable().readAllEntities();
    put(KEY_LIST_OF_DISTRIBUTION_POINTS, dpParams);
  }

  @Then("^Downloaded CSV file contains correct DP data$")
  public void downloadedCsvFileContainsCorrectDpData() {
    List<Dp> dpParams = get(KEY_LIST_OF_DISTRIBUTION_POINTS);
    dpAdminPage.verifyDownloadedDpFileContent(dpParams);
  }

  @When("^Operator add DP User for the created DP on DP Administration page with the following attributes:$")
  public void operatorAddDpUserForTheCreatedDpOnDpAdministrationPageWithTheFollowingAttributes(
      Map<String, String> data) {
    Dp dpParams = get(KEY_DISTRIBUTION_POINT);
    DpUser dpUser = new DpUser();
    dpUser.fromMap(data);
    dpAdminPage.addDpUser(dpParams.getName(), dpUser);
    put(KEY_DP_USER, dpUser);
  }

  @When("^Operator update created DP User for the created DP on DP Administration page with the following attributes:$")
  public void operatorUpdateDpUserForTheCreatedDpOnDpAdministrationPageWithTheFollowingAttributes(
      Map<String, String> data) {
    DpUser dpUser = get(KEY_DP_USER);
    String username = dpUser.getClientId();
    DpUser newPdUserParams = new DpUser(data);
    dpUser.merge(newPdUserParams);
    dpAdminPage.editDpUser(username, newPdUserParams);
  }

  @Then("^Operator verify new DP User params$")
  public void operatorVerifyNewDpUserParams() {
    DpUser dpUser = get(KEY_DP_USER);
    dpAdminPage.verifyDpUserParams(dpUser);
  }

  @When("^Operator get all DP Users params on DP Administration page$")
  public void operatorGetAllDpUsersParamsOnDpAdministrationPage() {
    List<DpUser> dpUsers = dpAdminPage.dpUsersTable().readAllEntities();
    put(KEY_LIST_OF_DP_USERS, dpUsers);
  }

  @Then("^Downloaded CSV file contains correct DP Users data$")
  public void downloadedCsvFileContainsCorrectDpUsersData() {
    List<DpUser> dpUsers = get(KEY_LIST_OF_DP_USERS);
    dpAdminPage.verifyDownloadedDpUsersFileContent(dpUsers);
  }

  @And("^Operator select View DPs action for created DP partner on DP Administration page$")
  public void operatorSelectViewDpsForCreatedDpPartnerOnDpAdministrationPage() {
    Partner dpPartner = get(KEY_DP_PARTNER);
    dpAdminPage.openViewDpsScreen(dpPartner.getName());
  }

  @And("^Operator select View Users action for created DP on DP Administration page$")
  public void operatorSelectViewUsersForCreatedDpOnDpAdministrationPage() {
    Dp dp = get(KEY_DISTRIBUTION_POINT);
    dpAdminPage.openViewUsersScreen(dp.getName());
  }

  @Then("^Operator verifies dp Params with database")
  public void operatorVerifiesDpParamsWithDatabase() {
    DpDetailsResponse dbDpParams = get(KEY_DP_DB_DETAILS);
    DpDetailsResponse apiDpParams = get(KEY_DP_DETAILS);
    dpAdminPage.verifyDpParamsWithDB(dbDpParams, apiDpParams);
  }

  @Then("Operator verifies the cut off time is {string}")
  public void operatorVerifiesTheCutOffTimeIs(String expectedCutOffTime) {
    String actualCutOffTime = get(KEY_DP_SETTING_DP_CUT_OFF_TIME);
    dpAdminPage.verifyCutOffTime(expectedCutOffTime, actualCutOffTime);
  }

  @Then("Operator verifies the error message for duplicate {string}")
  public void operatorVerifiesTheErrorMessageForDuplicate(String field) {
    dpAdminPage.verifyErrorMessageForDpCreation(field);
  }

  @Then("Operator verifies the image is {string}")
  public void operatorVerifiesTheImageIs(String status) {
    String image = get(KEY_DP_SETTING_DP_IMAGE);
    dpAdminPage.verifyImageIsPresent(image, status);
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
