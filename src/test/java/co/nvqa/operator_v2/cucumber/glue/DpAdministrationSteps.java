package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.utils.JsonUtils;
import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.commons.model.dp.DpDetailsResponse;
import co.nvqa.commons.model.dp.Partner;
import co.nvqa.commons.model.dp.dp_user.User;
import co.nvqa.commons.model.dp.persisted_classes.AuditMetadata;
import co.nvqa.commons.model.dp.persisted_classes.DpOpeningHour;
import co.nvqa.commons.model.dp.persisted_classes.DpOperatingHour;
import co.nvqa.commons.model.dp.persisted_classes.DpSetting;
import co.nvqa.common.utils.StandardTestConstants;
import co.nvqa.operator_v2.model.Dp;
import co.nvqa.operator_v2.model.DpPartner;
import co.nvqa.operator_v2.model.DpUser;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.page.DpAdministrationPage;
import co.nvqa.operator_v2.selenium.page.DpAdministrationReactPage;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.common.collect.ImmutableMap;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.guice.ScenarioScoped;
import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import org.assertj.core.api.Assertions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class DpAdministrationSteps extends AbstractSteps {

  private static final String NINJA_POINT_URL = StandardTestConstants.API_BASE_URL
      .replace("api", "point");
  private DpAdministrationPage dpAdminPage;
  private DpAdministrationReactPage dpAdminReactPage;

  private static final String DP_PARTNER_LABEL = "label_page_details";
  private static final String DP_LABEL = "label_distribution_points";
  private static final String DP_USER_LIST = "DP_USER_LIST";
  private static final String CHECK_DP_SEARCH_LAT_LONG = "CHECK_DP_SEARCH_LAT_LONG";
  private static final String CHECK_DP_RESERVATION_DATA = "CHECK_DP_RESERVATION_DATA";
  private static final String CHECK_DP_RESERVATION_DATA_DEFAULT = "CHECK_DP_RESERVATION_DATA_DEFAULT";
  private static final String CHECK_DP_RESERVATION_DATA_DISABLED = "CHECK_DP_RESERVATION_DATA_DISABLED";
  private static final String CHECK_DP_OPENING_OPERATING_HOURS = "CHECK_DP_OPENING_OPERATING_HOURS";
  private static final String CHECK_DP_PHOTO = "CHECK_DP_PHOTO";
  private static final String CHECK_ALTERNATE_DP_DATA = "CHECK_ALTERNATE_DP_DATA";
  private static final String CHECK_DP_SEARCH_ADDRESS = "CHECK_DP_SEARCH_ADDRESS";
  public static final String OPENING_HOURS = "OPENING_HOURS";
  public static final String OPERATING_HOURS = "OPERATING_HOURS";
  public static final String SINGLE = "SINGLE";
  public static final String NEXT = "NEXT";
  public static final String COPY_PASTE = "COPY_PASTE";
  private static final Logger LOGGER = LoggerFactory.getLogger(DpAdministrationSteps.class);

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

  @When("Operator click on Download CSV File button on React page")
  public void operatorClickOnDownloadCsvFileButtonOnReactPage() {
    dpAdminReactPage.inFrame(() -> {
      dpAdminReactPage.buttonDownloadCsv.click();
      pause5s();
    });
  }

  @When("Operator click on the distribution points Download CSV File button")
  public void operatorClickOnDistributionPointDownloadCsvFileButton() {
    dpAdminReactPage.inFrame(() -> {
      dpAdminReactPage.DpButtonDownloadCsv.click();
    });
  }

  @Then("Downloaded CSV file contains correct DP Partners data")
  public void downloadedCsvFileContainsCorrectDpPartnersData() {
    List<DpPartner> dpPartnersParams = get(KEY_LIST_OF_DP_PARTNERS);
    dpAdminPage.verifyDownloadedFileContent(dpPartnersParams);
  }

  @Then("Downloaded CSV file contains correct DP Partners data in new react page")
  public void downloadedCsvFileContainsCorrectDpPartnersDataInNewReactPage() {
    List<DpPartner> dpPartnersParams = get(KEY_LIST_OF_DP_PARTNERS);
    dpAdminPage.verifyDownloadedFileContentNewReactPage(dpPartnersParams);
  }

  @Then("Downloaded CSV file contains correct DP Users data in new react page")
  public void downloadedCsvFileContainsCorrectDpUsersDataInNewReactPage(
      Map<String, String> detailsAsMap) {
    List<User> user = get(detailsAsMap.get("userList"));
    DpDetailsResponse dp = get(detailsAsMap.get("dp"));
    dpAdminPage.verifyDownloadedFileContentNewReactPageDpUsers(user, dp);
  }

  @Then("Downloaded CSV file contains correct DP data in new react page")
  public void downloadedCsvFileContainsCorrectDpDataInNewReactPage() {
    final List<Dp> dpParams = get(KEY_LIST_OF_DISTRIBUTION_POINTS);
    dpAdminPage.verifyDownloadedDpFileContent(dpParams);
  }


  @When("^Operator get first (\\d+) DP Partners params on DP Administration page$")
  public void operatorGetFirstDpPartnersParamsOnDpAdministrationPage(int count) {
    List<DpPartner> dpPartnersParams = dpAdminPage.dpPartnersTable().readFirstEntities(count);
    put(KEY_LIST_OF_DP_PARTNERS, dpPartnersParams);
  }

  @When("Operator get DP Partners Data on DP Administration page")
  public void operatorGetFirstDpPartnersDataOnDpAdministrationPage(
      Map<String, String> detailsAsMap) {
    co.nvqa.commons.model.dp.DpPartner dpPartner = resolveValue(detailsAsMap.get("dpPartnerList"));
    int countValue = Integer.parseInt(resolveValue(detailsAsMap.get("count")));
    List<DpPartner> dpPartners = new ArrayList<>();
    for (int i = 0; i < countValue; i++) {
      Partner partner = dpPartner.getPartners().get(i);
      dpPartners.add(dpAdminReactPage.convertPartnerToDpPartner(partner));
    }
    put(KEY_LIST_OF_DP_PARTNERS, dpPartners);
  }

  @When("Operator get DP Users Data on DP Administration page")
  public void operatorGetFirstDpUsersDataOnDpAdministrationPage(Map<String, String> detailsAsMap) {
    co.nvqa.commons.model.dp.dp_user.DpUser dpUser = resolveValue(detailsAsMap.get("dpUsers"));
    int countValue = Integer.parseInt(resolveValue(detailsAsMap.get("count")));
    List<User> userList = new ArrayList<>();
    for (int i = 0; i < countValue; i++) {
      User user = dpUser.getUsers().get(i);
      userList.add(user);
    }
    put(DP_USER_LIST, userList);
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
  public void operatorVerifyDpPartnerDetails(Map<String, String> searchSDetailsAsMap) {
    Partner partner = get(KEY_DP_MANAGEMENT_PARTNER);
    DpPartner expected = dpAdminReactPage.convertPartnerToDpPartner(partner);

    searchSDetailsAsMap = resolveKeyValues(searchSDetailsAsMap);
    String searchDetailsData = StandardTestUtils.replaceTokens(
        searchSDetailsAsMap.get("searchDetails"),
        StandardTestUtils.createDefaultTokens());
    String[] extractDetails = searchDetailsData.split(",");

    dpAdminReactPage.inFrame(() -> {
      for (String extractDetail : extractDetails) {
        String valueDetails = dpAdminReactPage.getDpPartnerElementByMap(extractDetail, expected);
        dpAdminReactPage.fillFilterDpPartner(extractDetail, valueDetails);
        pause2s();
        dpAdminReactPage.readDpPartnerEntity(expected);
        dpAdminReactPage.clearDpPartnerFilter(extractDetail);
      }
    });
  }

  @And("Operator Search with Some DP Details :")
  public void operatorVerifyDpDetails(Map<String, String> searchSDetailsAsMap) {
    DpDetailsResponse dp = get(KEY_CREATE_DP_MANAGEMENT_RESPONSE);
    if (get(KEY_CREATE_DP_MANAGEMENT_HUB_NAME) != null) {
      dp.setHubName(get(KEY_CREATE_DP_MANAGEMENT_HUB_NAME).toString());
    }

    searchSDetailsAsMap = resolveKeyValues(searchSDetailsAsMap);
    String searchDetailsData = StandardTestUtils.replaceTokens(
        searchSDetailsAsMap.get("searchDetails"),
        StandardTestUtils.createDefaultTokens());
    String[] extractDetails = searchDetailsData.split(",");

    dpAdminReactPage.inFrame(() -> {
      for (String extractDetail : extractDetails) {
        String valueDetails = dpAdminReactPage.getDpElementByMap(extractDetail, dp);
        dpAdminReactPage.textBoxDpFilter.get(extractDetail).setValue(valueDetails);
        pause2s();
        dpAdminReactPage.readDpEntity(dp, extractDetail);
        dpAdminReactPage.clearDpFilter(extractDetail);
      }
    });
  }

  @And("Operator Search with Some DP User Details :")
  public void operatorVerifyDpUserDetails(Map<String, String> searchDetailsAsMap) {
    User user = resolveValue(searchDetailsAsMap.get("dpUser"));
    DpUser dpUser = dpAdminReactPage.convertUserToDpUser(user);

    searchDetailsAsMap = resolveKeyValues(searchDetailsAsMap);
    String searchDetailsData = StandardTestUtils.replaceTokens(
        searchDetailsAsMap.get("searchDetails"),
        StandardTestUtils.createDefaultTokens());
    String[] extractDetails = searchDetailsData.split(",");

    dpAdminReactPage.inFrame(() -> {
      for (String extractDetail : extractDetails) {
        String valueDetails = dpAdminReactPage.getDpUserElementByMap(extractDetail, dpUser);
        dpAdminReactPage.fillFilterDpUser(extractDetail, valueDetails);
        pause2s();
        dpAdminReactPage.readDpUserEntity(dpUser);
        dpAdminReactPage.clearDpUserFilter(extractDetail);
      }
    });
  }

  @And("Operator click on Add Partner button on DP Administration React page")
  public void operatorPressAddDpButton() {
    dpAdminReactPage.inFrame(() -> {
      dpAdminReactPage.buttonAddPartner.click();
      pause3s();
    });
  }

  @And("Operator define the DP Partner value {string} for key {string}")
  public void defineDpParnerValue(String value, String key) {
    put(key, value);
  }

  @And("Operator define the DP User value {string} for key {string}")
  public void defineDpUserValue(String value, String key) {
    put(key, value);
  }

  @And("Operator check the email for newly created CIF user from data below:")
  public void checkCifUserEmail(Map<String, String> dataTableAsMap) {
    String emailBody = resolveValue(dataTableAsMap.get("email"));
    String key = resolveValue(dataTableAsMap.get("key"));
    String value = null;
    String[] emailBodyCheck = emailBody.split("\\r?\\n");
    int index = 0;
    for (String checkKey : emailBodyCheck){
      if (checkKey.equalsIgnoreCase(key)){
        value = emailBodyCheck[index + 1];
        break;
      } else {
        index++;
      }
    }

    Assertions.assertThat(value).as(f("%s: %s",key,value)).isNotNull();

  }

  @Then("Operator Fill Dp User Details below :")
  public void operatorFillDpUserDetails(DataTable dt) {
    List<DpUser> dpUsers = convertDataTableToList(dt, DpUser.class);
    DpUser dpUser = dpUsers.get(0);
    dpAdminReactPage.inFrame(() -> {
      if (dpUser.getFirstName() != null && dpUser.getFirstName().contains("ERROR_CHECK")) {
        dpAdminReactPage.errorCheckDpUser(dpUser);
      } else {
        if (dpUser.getFirstName() != null) {
          dpAdminReactPage.formDpUserFirstName.forceClear();
          dpAdminReactPage.formDpUserFirstName.setValue(dpUser.getFirstName());
        }
        if (dpUser.getLastName() != null) {
          dpAdminReactPage.formDpUserLastName.forceClear();
          dpAdminReactPage.formDpUserLastName.setValue(dpUser.getLastName());
        }
        if (dpUser.getContactNo() != null) {
          String number = resolveValue(dpUser.getContactNo());
          dpUser.setContactNo(number);
          dpAdminReactPage.formDpUserContact.forceClear();
          dpAdminReactPage.formDpUserContact.setValue(dpUser.getContactNo());
        }
        if (dpUser.getEmailId() != null) {
          dpAdminReactPage.formDpUserEmail.forceClear();
          dpAdminReactPage.formDpUserEmail.setValue(dpUser.getEmailId());
        }
        if (dpUser.getUsername() != null) {
          dpAdminReactPage.formDpUserUsername.forceClear();
          dpAdminReactPage.formDpUserUsername.setValue(dpUser.getUsername());
          put(KEY_DP_USER_USERNAME, dpUser.getUsername());
        }
        if (dpUser.getPassword() != null) {
          dpAdminReactPage.formDpUserPassword.forceClear();
          dpAdminReactPage.formDpUserPassword.setValue(dpUser.getPassword());
        }

        put(KEY_DP_USER, dpUser);
      }
    });
  }

  @Then("Operator press submit user button")
  public void operatorPressSubmitUserButton() {
    dpAdminReactPage.inFrame(() -> dpAdminReactPage.buttonSubmitDpUser.click());
  }

  @Then("Operator press submit edit user button")
  public void operatorPressSubmitEditUserButton() {
    dpAdminReactPage.inFrame(() -> dpAdminReactPage.buttonSubmitEditDpUser.click());
  }

  @Then("Operator will get the error message that the username is duplicate")
  public void checkUsernameIsDuplicate() {
    DpUser dpUser = get(KEY_DP_USER);
    dpAdminReactPage.inFrame(() -> {
      dpAdminReactPage.errorNotification.waitUntilVisible();
      dpAdminReactPage.duplicateUsernameExist(dpUser);
    });
  }

  @Then("Operator Fill Dp Partner Details below :")
  public void operatorFillDpPartnerDetails(DataTable dt) {
    List<Partner> partners = convertDataTableToList(dt, Partner.class);
    Partner partner = partners.get(0);

    dpAdminReactPage.inFrame(() -> {
      if (partner.getName() != null) {
        dpAdminReactPage.formPartnerName.setValue(partner.getName());
      }
      if (partner.getPocName() != null) {
        if (!dpAdminReactPage.formPocName.getValue().equals("")) {
          dpAdminReactPage.formPocName.forceClear();
        }
        dpAdminReactPage.formPocName.setValue(partner.getPocName());
      }

      if (partner.getPocTel() != null) {

        if (!dpAdminReactPage.formPocNo.getValue().equals("")) {
          dpAdminReactPage.formPocNo.forceClear();
        }

        if (partner.getPocTel().equals("VALID")) {
          partner.setPocTel(TestUtils.generatePhoneNumber());
          dpAdminReactPage.formPocNo.setValue(partner.getPocTel());
        } else {
          dpAdminReactPage.formPocNo.setValue(partner.getPocTel());
        }
      }

      if (partner.getPocEmail() != null) {
        dpAdminReactPage.formPocEmail.setValue(partner.getPocEmail());
      }
      if (partner.getRestrictions() != null) {
        dpAdminReactPage.formRestrictions.setValue(partner.getRestrictions());
      }
      if (partner.getSendNotificationsToCustomer() != null
          && partner.getSendNotificationsToCustomer()) {
        dpAdminReactPage.buttonSendNotifications.click();
      }

      if (get(KEY_DP_MANAGEMENT_PARTNER) != null) {
        partner.setId(Long.valueOf(get(KEY_DP_PARTNER_ID)));
      }

      put(KEY_DP_MANAGEMENT_PARTNER, partner);
    });
  }

  @Then("Operator Fill Dp Partner Details to Check The Error Status with key {string}")
  public void operatorFillDpPartnerDetailsForErrorChecking(String errorCheckKey) {
    Partner partner = errorValueInitialize(errorCheckKey);

    dpAdminReactPage.inFrame(() -> dpAdminReactPage.errorCheckDpPartner(partner, errorCheckKey));
  }

  @Then("Operator Fill Dp User Details to Check The Error Status with key {string}")
  public void operatorFillDpUserDetailsForErrorChecking(String errorCheckKey) {

    dpAdminReactPage.inFrame(
        () -> dpAdminReactPage.errorCheckDpUser(get(errorCheckKey), errorCheckKey));
  }

  @Then("Operator clear the {string} from DP Partner form")
  public void clearCertainForm(String errorCheckKey) {
    dpAdminReactPage.inFrame(() -> dpAdminReactPage.clearDpPartnerForm(errorCheckKey));
  }

  public Partner errorValueInitialize(String errorKey) {
    Partner partner;
    if (get(KEY_DP_MANAGEMENT_PARTNER) != null) {
      partner = get(KEY_DP_MANAGEMENT_PARTNER);
    } else {
      partner = new Partner();
    }

    switch (errorKey) {
      case "!NAME":
      case "NAME":
        partner.setName(get(errorKey));
        break;
      case "POCNME":
      case "!POCNME":
        partner.setPocName(get(errorKey));
        break;
      case "!POCNUM":
      case "POCNUM":
        partner.setPocTel(get(errorKey));
        break;
      case "POCMAIL":
        partner.setPocEmail(get(errorKey));
        break;
      case "RESTRICTION":
      case "!RESTRICTION":
        partner.setRestrictions(get(errorKey));
        break;
    }
    return partner;
  }


  @Then("Operator will check the error message is equal {string}")
  public void checkErrorMessageFromDpPartner(String errorMsg) {
    dpAdminReactPage.inFrame(() -> {
      dpAdminReactPage.checkErrorMsg(errorMsg);
      pause3s();
      takesScreenshot();
    });
  }

  @Then("Operator press submit button")
  public void submitDpPartnerButton() {
    dpAdminReactPage.inFrame(() -> dpAdminReactPage.buttonSubmitPartner.click());
  }

  @Then("Operator press edit partner button")
  public void editDpPartnerButton() {
    dpAdminReactPage.inFrame(() -> dpAdminReactPage.buttonEditPartner.click());
  }

  @Then("Operator press submit partner changes button")
  public void submitDpPartnerChangesButton() {
    dpAdminReactPage.inFrame(() -> dpAdminReactPage.buttonSubmitPartnerChanges.click());
  }

  @Then("The Dp Administration page is displayed")
  public void dpAdminIsDisplayed() {
    dpAdminReactPage.inFrame(() -> dpAdminReactPage.dpAdminHeader.waitUntilVisible());
  }

  @Then("The Dp page is displayed")
  public void dpPageIsDisplayed() {
    dpAdminReactPage.inFrame(() -> dpAdminReactPage.distributionPointHeader.waitUntilVisible());
  }

  @Then("The Create and Edit Dp page is displayed")
  public void createEditDpPageIsDisplayed() {
    dpAdminReactPage.inFrame(() -> {
      dpAdminReactPage.buttonReturnToList.waitUntilVisible();
      dpAdminReactPage.buttonSaveSettings.waitUntilVisible();
    });
  }

  @Then("Operator press return to list button")
  public void pressReturnToList() {
    dpAdminReactPage.inFrame(() -> dpAdminReactPage.buttonReturnToList.click());
  }


  @Then("Operator press leave the page button")
  public void pressLeaveThepage() {
    dpAdminReactPage.inFrame(() -> dpAdminReactPage.buttonLeaveThePage.click());
  }

  @Then("Operator press save setting button")
  public void pressSaveSetting() {
    dpAdminReactPage.inFrame(() -> dpAdminReactPage.buttonSaveSettings.click());
  }

  @Then("Operator will receiving error message pop-up {string}")
  public void duplicateDpError(String popUpMsg) {
    dpAdminReactPage.inFrame(
        () -> Assertions.assertThat(dpAdminReactPage.elementErrorCreatingDP.getText())
            .as(f("Distribution point is Error because of %s", popUpMsg))
            .containsIgnoringCase(popUpMsg));
  }


  @Then("Operator fill the partner filter by {string}")
  public void operatorFillThePartnerFilter(String element) {
    Partner newlyCreatedPartner = get(KEY_DP_MANAGEMENT_PARTNER);
    DpPartner newlyCreatedDpPartner = dpAdminReactPage.convertPartnerToDpPartner(
        newlyCreatedPartner);
    dpAdminReactPage.inFrame(() -> {
      dpAdminReactPage.textBoxDpPartnerFilter.get(element).waitUntilVisible();
      String fillInValue = dpAdminReactPage.getDpPartnerElementByMap(element,
          newlyCreatedDpPartner);
      dpAdminReactPage.textBoxDpPartnerFilter.get(element).setValue(fillInValue);
    });
  }

  @Then("Operator fill the partner filter by {value} with value {value}")
  public void operatorFillThePartnerFilterWithValue(String element, String value) {
    String fillInValue = resolveValue(value);
    dpAdminReactPage.inFrame(() -> {
      dpAdminReactPage.textBoxDpPartnerFilter.get(element).waitUntilVisible();
      dpAdminReactPage.textBoxDpPartnerFilter.get(element).setValue(fillInValue);
    });
  }

  @Then("Operator fill the Dp list filter by {string}")
  public void operatorFillTheDpListFilter(String element) {
    DpDetailsResponse newlyCreatedDpDetails = get(KEY_CREATE_DP_MANAGEMENT_RESPONSE);
    dpAdminReactPage.inFrame(() -> {
      String fillInValue = dpAdminReactPage.getDpElementByMap(element, newlyCreatedDpDetails);
      dpAdminReactPage.textBoxDpFilter.get(element).setValue(fillInValue);
    });
  }

  @Then("Operator fill the Dp list filter by {string} with value {string}")
  public void operatorFillTheDpListFilterWithValue(String element,String value) {
    String fillInValue = resolveValue(value);
    dpAdminReactPage.inFrame(() -> {
      dpAdminReactPage.textBoxDpFilter.get(element).waitUntilVisible();
      dpAdminReactPage.textBoxDpFilter.get(element).setValue(fillInValue);
    });
  }

  @When("Operator press clear alternate DP number {string}")
  public void operatorPressClearAlternateDPNumber(String numberOfDp) {
    ImmutableMap<String, PageElement> clearNumberOfDp = ImmutableMap.<String, PageElement>builder()
        .put("1", dpAdminReactPage.buttonClearAlternateDp1)
        .put("2", dpAdminReactPage.buttonClearAlternateDp2)
        .put("3", dpAdminReactPage.buttonClearAlternateDp3)
        .build();

    dpAdminReactPage.inFrame(() -> {
      clearNumberOfDp.get(numberOfDp).click();
    });
  }

  @When("Operator will get the popup message for alternate DP number {string}")
  public void operatorWillGetPopupMsg(String numberOfDp) {
    dpAdminReactPage.inFrame(() -> dpAdminReactPage.popupMsgAlternateDP(numberOfDp));
  }

  @When("Operator press update DP Alternate Button")
  public void operatorPressUpdateDPAlternateButton() {
    dpAdminReactPage.inFrame(() -> dpAdminReactPage.elementUpdateDPAlternate.click());
  }

  @When("Operator press Select Another DP Alternate Button")
  public void operatorPressSelectAnotherDPAlternateButton() {
    dpAdminReactPage.inFrame(() -> dpAdminReactPage.elementSelectAnotherDPAlternate.click());
  }

  @When("Operator press cancel choose DP Alternate Button")
  public void operatorPressCancelChooseDPAlternateButton() {
    dpAdminReactPage.inFrame(() -> dpAdminReactPage.elementCancelDPAlternate.click());
  }

  @Then("Operator get the value of DP ID")
  public void operatorGetDpIdValue() {
    dpAdminReactPage.inFrame(() -> {
      put(KEY_CREATE_DP_USER_MANAGEMENT_RESPONSE_ID, dpAdminReactPage.labelDpId.getText());
    });
  }

  @Then("Operator press edit DP button")
  public void operatorPressEditDpButton() {
    dpAdminReactPage.inFrame(() -> dpAdminReactPage.buttonDpEdit.click());
  }

  @Then("Operator check the alternate DP is shown in DP Edit page")
  public void alternateDPShownInDPEdit(Map<String, String> dataTableAsMap) {
    String alternateDPList = dataTableAsMap.get("dpList");
    DpDetailsResponse dpDetailsResponse = get(dataTableAsMap.get("dpDetails"));
    String[] dpList = alternateDPList.split(",");
    List<String> dpListFromDisplay = new ArrayList<>();

    dpAdminReactPage.inFrame(() -> {
      for (String dp : dpList) {
        dpListFromDisplay.add(dpAdminReactPage.getAlternateDpText.get(dp).getText());
      }

      for (String dp : dpListFromDisplay) {
        if (dpDetailsResponse.getAlternateDpId1() != null && dp.contains(
            dpDetailsResponse.getAlternateDpId1().toString())) {

          Assertions.assertThat(dp)
              .as(f("Alternate DP 1 Field is %s on Display", dp))
              .containsIgnoringCase(dpDetailsResponse.getAlternateDpId1().toString());

        } else if (dpDetailsResponse.getAlternateDpId2() != null && dp.contains(
            dpDetailsResponse.getAlternateDpId2().toString())) {

          Assertions.assertThat(dp)
              .as(f("Alternate DP 2 Field is %s on Display", dp))
              .containsIgnoringCase(dpDetailsResponse.getAlternateDpId2().toString());

        } else if (dpDetailsResponse.getAlternateDpId3() != null && dp.contains(
            dpDetailsResponse.getAlternateDpId3().toString())) {

          Assertions.assertThat(dp)
              .as(f("Alternate DP 3 Field is %s on Display", dp))
              .containsIgnoringCase(dpDetailsResponse.getAlternateDpId3().toString());

        }
      }

    });
  }

  @Then("Operator fill the Dp User filter by {string}")
  public void operatorFillTheDpUserFilter(String element) {
    DpUser dpUser = get(KEY_DP_USER);
    dpAdminReactPage.inFrame(() -> {
      dpAdminReactPage.textBoxDpUserFilter.get(element).waitUntilVisible();
      String fillInValue = dpAdminReactPage.getDpUserElementByMap(element, dpUser);
      dpAdminReactPage.textBoxDpUserFilter.get(element).setValue(fillInValue);
    });
  }

  @Then("Operator fill newly created Dp User filter:")
  public void operatorFillNewDpUserFilter(Map<String, String> dataTableAsMap) {
    DpUser dpUser = dpUserConverter(resolveValue(dataTableAsMap.get("dpUser")));
    dpAdminReactPage.inFrame(() -> {
      String element = dataTableAsMap.get("element");
      dpAdminReactPage.textBoxDpUserFilter.get(element).waitUntilVisible();
      String fillInValue = dpAdminReactPage.getDpUserElementByMap(element, dpUser);
      dpAdminReactPage.textBoxDpUserFilter.get(element).setValue(fillInValue);
    });
  }

  @And("Operator check the submitted data in the table")
  public void checkSubmittedDataInTable() {
    Partner partner = get(KEY_DP_MANAGEMENT_PARTNER);
    dpAdminReactPage.inFrame(
        page -> dpAdminReactPage.fillFilterDpPartner("name", partner.getName()));
  }

  @And("Operator Search Dp Partners by Id")
  public void operatorSearchDpPartnersById() {
    Partner partner = get(KEY_DP_MANAGEMENT_PARTNER);
    dpAdminReactPage.inFrame(() -> {
      dpAdminReactPage.waitUntilVisibilityOfElementLocated(
          f("//h2[@data-testid='%s']", DP_PARTNER_LABEL));
      dpAdminReactPage.filterPartnerId.setValue(partner.getId());
    });
  }


  @And("Operator press view DP Button")
  public void operatorPressViewDpButton() {
    dpAdminReactPage.inFrame(() -> dpAdminReactPage.buttonViewDps.click());
  }

  @And("Operator press add user Button")
  public void operatorPressAddUserButton() {
    dpAdminReactPage.inFrame(() -> dpAdminReactPage.buttonAddUser.click());
  }

  @And("Operator press edit user Button")
  public void operatorPressEditUserButton() {
    dpAdminReactPage.inFrame(() -> dpAdminReactPage.buttonEditUser.click());
  }


  @And("Operator press view DP User Button")
  public void operatorPressViewDpUserButton() {
    dpAdminReactPage.inFrame(() -> {
      dpAdminReactPage.buttonDpUser.click();
    });
  }

  @When("Operator press Add DP")
  public void operatorPressAddDp() {
    dpAdminReactPage.inFrame(() -> {
      dpAdminReactPage.waitUntilVisibilityOfElementLocated(
          f("//h2[@data-testid='%s']", DP_LABEL));
      dpAdminReactPage.buttonAddDp.click();
    });
  }

  @When("Operator check the form that all the checkbox element is exist base on the country setup")
  public void checkFormCheckboxExistance(Map<String, String> dataTableAsMap) {
    String elementListCheck = dataTableAsMap.get("elements");
    String[] elementLists = elementListCheck.split(",");
    dpAdminReactPage.inFrame(() -> {
      for (String element : elementLists) {
        dpAdminReactPage.checkBoxValidationCheck.get(element).isDisplayed();
        LOGGER.info(element + " is existed");
      }
    });
  }

  @When("Operator will get the error from some mandatory field")
  public void errorMandatoryField(Map<String, String> dataTableAsMap) {
    String elementListCheck = dataTableAsMap.get("field");
    String[] elementLists = elementListCheck.split(",");
    dpAdminReactPage.inFrame(() -> {
      for (String element : elementLists) {
        dpAdminReactPage.mandatoryFieldError(element);
      }
    });
  }

  @When("Operator check disabled alternate DP form")
  public void checkDisabledAlternateDPForm(Map<String, String> dataTableAsMap) {
    Map<String, String> map = resolveKeyValues(dataTableAsMap);
    boolean alternateDp1 = map.get("alternateDp1").equalsIgnoreCase("ENABLED");
    boolean alternateDp2 = map.get("alternateDp2").equalsIgnoreCase("ENABLED");
    boolean alternateDp3 = map.get("alternateDp3").equalsIgnoreCase("ENABLED");

    dpAdminReactPage.inFrame(() -> {
      if (alternateDp1) {
        Assertions.assertThat(dpAdminReactPage.fieldAlternateDp1.isDisplayed())
            .as("Alternate DP 1 Field is Enabled").isTrue();
      } else {
        Assertions.assertThat(dpAdminReactPage.fieldAlternateDp1Disabled.isDisplayed())
            .as("Alternate DP 1 Field is Disabled").isTrue();
      }

      if (alternateDp2) {
        Assertions.assertThat(dpAdminReactPage.fieldAlternateDp2.isDisplayed())
            .as("Alternate DP 2 Field is Enabled").isTrue();
      } else {
        Assertions.assertThat(dpAdminReactPage.fieldAlternateDp2Disabled.isDisplayed())
            .as("Alternate DP 2 Field is Disabled").isTrue();
      }

      if (alternateDp3) {
        Assertions.assertThat(dpAdminReactPage.fieldAlternateDp3.isDisplayed())
            .as("Alternate DP 3 Field is Enabled").isTrue();
      } else {
        Assertions.assertThat(dpAdminReactPage.fieldAlternateDp3Disabled.isDisplayed())
            .as("Alternate DP 3 Field is Disabled").isTrue();
      }
    });

  }

  @When("Operator fill the alternate DP details")
  public void fillAlternateDP(Map<String, String> dataTableAsMap) {
    Long alternateDP1 = getDpIdValue(dataTableAsMap.get("alternateDp1"));
    Long alternateDP2 = getDpIdValue(dataTableAsMap.get("alternateDp2"));
    Long alternateDP3 = getDpIdValue(dataTableAsMap.get("alternateDp3"));
    boolean validationStatus = dataTableAsMap.get("validationStatus").equalsIgnoreCase("VALID");

    dpAdminReactPage.inFrame(() -> {
      if (validationStatus) {
        if (alternateDP1 != null) {
          dpAdminReactPage.fieldAlternateDp1.setValue(alternateDP1);
          dpAdminReactPage.chooseAlternateDp(alternateDP1);
        }
        if (alternateDP2 != null) {
          dpAdminReactPage.fieldAlternateDp2.setValue(alternateDP2);
          dpAdminReactPage.chooseAlternateDp(alternateDP2);
        }
        if (alternateDP3 != null) {
          dpAdminReactPage.fieldAlternateDp3.setValue(alternateDP3);
          dpAdminReactPage.chooseAlternateDp(alternateDP3);
        }
      } else {
        if (alternateDP1 != null) {
          dpAdminReactPage.fieldAlternateDp1.setValue(alternateDP1);
          dpAdminReactPage.chooseInvalidAlternateDp(alternateDP1);
        }
        if (alternateDP2 != null) {
          dpAdminReactPage.fieldAlternateDp2.setValue(alternateDP2);
          dpAdminReactPage.chooseInvalidAlternateDp(alternateDP2);
        }
        if (alternateDP3 != null) {
          dpAdminReactPage.fieldAlternateDp3.setValue(alternateDP3);
          dpAdminReactPage.chooseInvalidAlternateDp(alternateDP3);
        }
      }

    });
  }

  private Long getDpIdValue(String dpId) {
    Long dpIdValue;
    if (dpId != null) {
      if (get(dpId) != null) {
        dpIdValue = get(dpId);
      } else {
        dpIdValue = Long.parseLong(dpId);
      }
    } else {
      dpIdValue = null;
    }
    return dpIdValue;
  }

  @When("Operator delete the opening and operating hours {string}")
  public void operatorDeleteTheOpeningAndOperatingHours(String hourKey) {
    dpAdminReactPage.inFrame(() -> {
      if ("opening_hours".equalsIgnoreCase(hourKey)) {
        dpAdminReactPage.removeOpeningHoursDay();
      } else if ("operating_hours".equalsIgnoreCase(hourKey)) {
        dpAdminReactPage.removeOperatingHoursDay();
      }
    });
  }

  @When("Operator fill the DP details")
  public void operatorFillDpDetails(Map<String, String> dataTableAsMap) {
    DpDetailsResponse dpDetailsResponse = resolveValue(dataTableAsMap.get("distributionPoint"));
    dpAdminReactPage.inFrame(() -> {
      if (dpDetailsResponse.getName() != null) {
        dpAdminReactPage.fieldPointName.forceClear();
        dpAdminReactPage.fieldPointName.setValue(dpDetailsResponse.getName());
      }
      if (dpDetailsResponse.getShortName() != null) {
        dpAdminReactPage.fieldShortName.forceClear();
        dpAdminReactPage.fieldShortName.setValue(dpDetailsResponse.getShortName());
      }
      if (dpDetailsResponse.getContact() != null) {
        dpAdminReactPage.fieldContactNumber.forceClear();
        dpAdminReactPage.fieldContactNumber.setValue(dpDetailsResponse.getContact());
      }
      if (dpDetailsResponse.getExternalStoreId() != null) {
        if ("space".equalsIgnoreCase(dpDetailsResponse.getExternalStoreId())) {
          dpAdminReactPage.fieldExternalStoreId.forceClear();
          dpAdminReactPage.fieldExternalStoreId.setValue(" ");
        } else {
          dpAdminReactPage.fieldExternalStoreId.forceClear();
          dpAdminReactPage.fieldExternalStoreId.setValue(dpDetailsResponse.getExternalStoreId());
        }
      }
      if (dpDetailsResponse.getShipperId() != null) {
        dpAdminReactPage.fieldShipperAccountNo.setValue(dpDetailsResponse.getShipperId());
        dpAdminReactPage.chooseShipperAccountDp(dpDetailsResponse.getShipperId());
      }
      if (dpDetailsResponse.getAlternateDpId1() != null) {
        dpAdminReactPage.fieldAlternateDp1.setValue(dpDetailsResponse.getAlternateDpId1());
        dpAdminReactPage.chooseAlternateDp(dpDetailsResponse.getAlternateDpId1());
      }
      if (dpDetailsResponse.getAlternateDpId2() != null) {
        dpAdminReactPage.fieldAlternateDp2.setValue(dpDetailsResponse.getAlternateDpId2());
        dpAdminReactPage.chooseAlternateDp(dpDetailsResponse.getAlternateDpId2());
      }
      if (dpDetailsResponse.getAlternateDpId3() != null) {
        dpAdminReactPage.fieldAlternateDp3.setValue(dpDetailsResponse.getAlternateDpId3());
        dpAdminReactPage.chooseAlternateDp(dpDetailsResponse.getAlternateDpId3());
      }

      if (dpDetailsResponse.getLatLongSearch() != null
          && dpDetailsResponse.getLatLongSearchName() != null) {
        dpAdminReactPage.fieldLatLongSearch.setValue(dpDetailsResponse.getLatLongSearch());
        dpAdminReactPage.chooseFromSearch(dpDetailsResponse.getLatLongSearchName());
      } else if (dpDetailsResponse.getAddressSearch() != null
          && dpDetailsResponse.getAddressSearchName() != null) {
        dpAdminReactPage.fieldAddressSearch.setValue(dpDetailsResponse.getAddressSearch());
        dpAdminReactPage.chooseFromSearch(dpDetailsResponse.getAddressSearchName());
      } else {
        if (dpDetailsResponse.getPostalCode() != null) {
          dpAdminReactPage.fieldPostcode.forceClear();
          dpAdminReactPage.fieldPostcode.setValue(dpDetailsResponse.getPostalCode());
        }
        if (dpDetailsResponse.getCity() != null) {
          dpAdminReactPage.fieldCity.forceClear();
          dpAdminReactPage.fieldCity.setValue(dpDetailsResponse.getCity());
        }
        if (dpDetailsResponse.getAddress1() != null) {
          dpAdminReactPage.fieldPointAddress1.forceClear();
          dpAdminReactPage.fieldPointAddress1.setValue(dpDetailsResponse.getAddress1());
        }
        if (dpDetailsResponse.getLatitude() != null) {
          dpAdminReactPage.fieldLatitude.forceClear();
          dpAdminReactPage.fieldLatitude.setValue(dpDetailsResponse.getLatitude());
        }
        if (dpDetailsResponse.getLongitude() != null) {
          dpAdminReactPage.fieldLongitude.forceClear();
          dpAdminReactPage.fieldLongitude.setValue(dpDetailsResponse.getLongitude());
        }
      }

      if (dpDetailsResponse.getHubName() != null) {
        dpAdminReactPage.fieldAssignedHub.setValue(dpDetailsResponse.getHubName());
        dpAdminReactPage.chooseShipperAssignedHub(dpDetailsResponse.getHubName());
      }

      if (dpDetailsResponse.getAddress2() != null) {
        dpAdminReactPage.fieldPointAddress2.forceClear();
        dpAdminReactPage.fieldPointAddress2.setValue(dpDetailsResponse.getAddress2());
      }
      if (dpDetailsResponse.getFloorNumber() != null) {
        dpAdminReactPage.fieldFloorNo.forceClear();
        dpAdminReactPage.fieldFloorNo.setValue(dpDetailsResponse.getFloorNumber());
      }
      if (dpDetailsResponse.getUnitNumber() != null) {
        dpAdminReactPage.fieldUnitNo.forceClear();
        dpAdminReactPage.fieldUnitNo.setValue(dpDetailsResponse.getUnitNumber());
      }

      if (dpDetailsResponse.getType() != null) {
        dpAdminReactPage.fieldPudoPointType.click();
        if (dpDetailsResponse.getType().equals("Ninja Box")) {
          dpAdminReactPage.ninjaBoxPudoPointType.click();
        } else if (dpDetailsResponse.getType().equals("Ninja Point")) {
          dpAdminReactPage.ninjaPointPudoPointType.click();
        }
      }
      if (dpDetailsResponse.getDpServiceType() != null) {
        if (dpDetailsResponse.getDpServiceType().equals("RETAIL_POINT_NETWORK")) {
          dpAdminReactPage.checkBoxRetailPointNetwork.click();
        }
      }
      if (dpDetailsResponse.getComputedMaxCapacity() != null) {
        dpAdminReactPage.fieldMaximumParcelCapacityForCollect.forceClear();
        dpAdminReactPage.fieldMaximumParcelCapacityForCollect.setValue(
            dpDetailsResponse.getComputedMaxCapacity());
      }
      if (dpDetailsResponse.getActualMaxCapacity() != null) {
        dpAdminReactPage.fieldBufferCapacity.forceClear();
        dpAdminReactPage.fieldBufferCapacity.setValue(
            dpDetailsResponse.getActualMaxCapacity());
      }
      if (dpDetailsResponse.getMaxParcelStayDuration() != null) {
        dpAdminReactPage.fieldMaximumParcelStay.forceClear();
        dpAdminReactPage.fieldMaximumParcelStay.setValue(
            dpDetailsResponse.getMaxParcelStayDuration());
      }
      if (dpDetailsResponse.getDpPhoto() != null) {
        if (dpDetailsResponse.getDpPhoto().equalsIgnoreCase("clear")
            || dpDetailsResponse.getDpPhoto().equalsIgnoreCase("notSaveClear")) {
          dpAdminReactPage.removeExistingPicture();
        } else {
          dpAdminReactPage.fieldPhotoOfPudoPoint.setValue(
              dpDetailsResponse.getDpPhotoFile());
        }
      }
      if (dpDetailsResponse.getIsActive() != null && dpDetailsResponse.getIsActive()) {
        dpAdminReactPage.checkBoxActivePoint.click();
      }
      if (dpDetailsResponse.getIsPublic() != null && dpDetailsResponse.getIsPublic()) {
        dpAdminReactPage.checkBoxPublicityPointDisplayed.click();
      }
      if (dpDetailsResponse.getIsHyperlocal() != null && dpDetailsResponse.getIsHyperlocal()) {
        dpAdminReactPage.checkBoxHyperLocal.click();
      }
      if (dpDetailsResponse.getAutoReservationEnabled() != null
          && dpDetailsResponse.getAutoReservationEnabled()) {
        dpAdminReactPage.checkBoxAutoReservationEnabled.click();
      }
      if (dpDetailsResponse.getAutoReservationCutOffTime() != null) {
        dpAdminReactPage.fillAutoReservationCutoffTime(
            dpDetailsResponse.getAutoReservationCutOffTime());
      }
      if (dpDetailsResponse.getEditDaysIndividuallyOpeningHours() != null
          && !dpDetailsResponse.getEditDaysIndividuallyOpeningHours()) {
        dpAdminReactPage.buttonEditDaysIndividuallyOpeningHours.click();
      }
      if (dpDetailsResponse.getEditDaysIndividuallyOperatingHours() != null
          && !dpDetailsResponse.getEditDaysIndividuallyOperatingHours()) {
        dpAdminReactPage.buttonEditDaysIndividuallyOperatingHours.click();
      }
      if (canFillOpeningOperatingHour(dpDetailsResponse)) {

        String[] days = dpDetailsResponse.getOperatingHoursDay().split(",");

        for (String day : days) {
          for (int i = 0; i < dpDetailsResponse.getOpeningHours().get(day).size(); i++) {
            if (i == 0) {
              dpAdminReactPage.fillOpeningOperatingHour(day,
                  dpDetailsResponse.getOpeningHours().get(day).get(i), SINGLE, OPENING_HOURS);
            } else if (i == 1) {
              dpAdminReactPage.buttonAddTimeSlotOpeningHour.get(day).click();
              dpAdminReactPage.fillOpeningOperatingHour(day,
                  dpDetailsResponse.getOpeningHours().get(day).get(i), NEXT, OPENING_HOURS);
            }

          }
        }

        for (String day : days) {
          for (int i = 0; i < dpDetailsResponse.getOperatingHours().get(day).size(); i++) {
            if (i == 0) {
              dpAdminReactPage.fillOpeningOperatingHour(day,
                  dpDetailsResponse.getOperatingHours().get(day).get(i), SINGLE, OPERATING_HOURS);
            } else if (i == 1) {
              dpAdminReactPage.buttonAddTimeSlotOperatingHour.get(day).click();
              dpAdminReactPage.fillOpeningOperatingHour(day,
                  dpDetailsResponse.getOperatingHours().get(day).get(i), NEXT, OPERATING_HOURS);
            }

          }
        }

      }
      if (dpDetailsResponse.getCutOffDay() != null) {
        String[] cutOffDay = dpDetailsResponse.getCutOffDay().split(",");

        for (String day : cutOffDay) {
          dpAdminReactPage.cutOffOpeningHour.get(day).click();
        }
        for (String day : cutOffDay) {
          dpAdminReactPage.cutOffOperatingHour.get(day).click();
        }

      }
      if (dpDetailsResponse.getApplyFirstDayOpeningHours() != null
          && dpDetailsResponse.getApplyFirstDayOpeningHours()) {
        dpAdminReactPage.buttonApplyFirstDaySlotsOpeningHours.click();
      }
      if (dpDetailsResponse.getApplyFirstDayOperatingHours() != null
          && dpDetailsResponse.getApplyFirstDayOperatingHours()) {
        dpAdminReactPage.buttonApplyFirstDaySlotsOperatingHours.click();
      }
    });
  }

  public boolean canFillOpeningOperatingHour(DpDetailsResponse dpDetailsResponse) {
    return dpDetailsResponse.getIsOperatingHours() != null
        && dpDetailsResponse.getIsOperatingHours()
        && dpDetailsResponse.getOperatingHoursDay() != null
        && (dpDetailsResponse.getEditDaysIndividuallyOpeningHours() == null
        || dpDetailsResponse.getEditDaysIndividuallyOpeningHours())
        && (dpDetailsResponse.getEditDaysIndividuallyOperatingHours() == null
        || dpDetailsResponse.getEditDaysIndividuallyOperatingHours());
  }


  @When("Operator will get the error from some field")
  public void errorFieldMessage(Map<String, String> dataTableAsMap) {
    DpDetailsResponse dp = resolveValue(dataTableAsMap.get("distributionPoint"));
    String pointName = dataTableAsMap.get("pName");
    String shortName = dataTableAsMap.get("sName");
    String city = dataTableAsMap.get("city");
    String externalStoreId = dataTableAsMap.get("esId");
    String postCode = dataTableAsMap.get("poCode");
    String floorNo = dataTableAsMap.get("floorNo");
    String unitNo = dataTableAsMap.get("unitNo");
    String latitude = dataTableAsMap.get("latitude");
    String longitude = dataTableAsMap.get("longitude");
    String maximumParcelCapacity = dataTableAsMap.get("mcapacity");
    String bufferCapacity = dataTableAsMap.get("bCapacity");
    String maximumParcelStay = dataTableAsMap.get("mpStay");
    dpAdminReactPage.inFrame(() -> {
      String[] splitElement;
      if (pointName != null) {
        splitElement = pointName.split(",");
        dpAdminReactPage.fieldPointName.forceClear();
        dpAdminReactPage.fieldPointName.setValue(splitElement[0]);
        dpAdminReactPage.fieldErrorMsg(splitElement[1]);
        dpAdminReactPage.fieldPointName.forceClear();
        dpAdminReactPage.fieldPointName.setValue(dp.getName());
      }
      if (shortName != null) {
        splitElement = shortName.split(",");
        dpAdminReactPage.fieldShortName.forceClear();
        dpAdminReactPage.fieldShortName.setValue(splitElement[0]);
        dpAdminReactPage.fieldErrorMsg(splitElement[1]);
        dpAdminReactPage.fieldShortName.forceClear();
        dpAdminReactPage.fieldShortName.setValue(dp.getShortName());
      }
      if (city != null) {
        splitElement = city.split(",");
        dpAdminReactPage.fieldCity.forceClear();
        dpAdminReactPage.fieldCity.setValue(splitElement[0]);
        dpAdminReactPage.fieldErrorMsg(splitElement[1]);
        dpAdminReactPage.fieldCity.forceClear();
        dpAdminReactPage.fieldCity.setValue(dp.getCity());
      }
      if (externalStoreId != null) {
        splitElement = externalStoreId.split(",");
        dpAdminReactPage.fieldExternalStoreId.forceClear();
        dpAdminReactPage.fieldExternalStoreId.setValue(splitElement[0]);
        dpAdminReactPage.fieldErrorMsg(splitElement[1]);
        dpAdminReactPage.fieldExternalStoreId.forceClear();
        dpAdminReactPage.fieldExternalStoreId.setValue(dp.getExternalStoreId());
      }
      if (postCode != null) {
        splitElement = postCode.split(",");
        dpAdminReactPage.fieldPostcode.forceClear();
        dpAdminReactPage.fieldPostcode.setValue(splitElement[0]);
        dpAdminReactPage.fieldErrorMsg(splitElement[1]);
        dpAdminReactPage.fieldPostcode.forceClear();
        dpAdminReactPage.fieldPostcode.setValue(dp.getPostalCode());
      }
      if (floorNo != null) {
        splitElement = floorNo.split(",");
        dpAdminReactPage.fieldFloorNo.forceClear();
        dpAdminReactPage.fieldFloorNo.setValue(splitElement[0]);
        dpAdminReactPage.fieldErrorMsg(splitElement[1]);
        dpAdminReactPage.fieldFloorNo.forceClear();
        dpAdminReactPage.fieldFloorNo.setValue(dp.getFloorNumber());
      }
      if (unitNo != null) {
        splitElement = unitNo.split(",");
        dpAdminReactPage.fieldUnitNo.forceClear();
        dpAdminReactPage.fieldUnitNo.setValue(splitElement[0]);
        dpAdminReactPage.fieldUnitNo.forceClear();
        dpAdminReactPage.fieldErrorMsg(splitElement[1]);
        dpAdminReactPage.fieldUnitNo.setValue(splitElement[0]);
      }
      if (latitude != null) {
        splitElement = latitude.split(",");
        dpAdminReactPage.fieldLatitude.forceClear();
        dpAdminReactPage.fieldLatitude.setValue(splitElement[0]);
        dpAdminReactPage.fieldLatitude.forceClear();
        dpAdminReactPage.fieldErrorMsg(splitElement[1]);
        dpAdminReactPage.fieldLatitude.setValue(splitElement[0]);
      }
      if (longitude != null) {
        splitElement = longitude.split(",");
        dpAdminReactPage.fieldLongitude.forceClear();
        dpAdminReactPage.fieldLongitude.setValue(splitElement[0]);
        dpAdminReactPage.fieldErrorMsg(splitElement[1]);
        dpAdminReactPage.fieldLongitude.forceClear();
        dpAdminReactPage.fieldLongitude.setValue(dp.getLongitude());
      }
      if (maximumParcelCapacity != null) {
        splitElement = maximumParcelCapacity.split(",");
        dpAdminReactPage.fieldMaximumParcelCapacityForCollect.forceClear();
        dpAdminReactPage.fieldMaximumParcelCapacityForCollect.setValue(splitElement[0]);
        dpAdminReactPage.fieldErrorMsg(splitElement[1]);
        dpAdminReactPage.fieldMaximumParcelCapacityForCollect.forceClear();
        dpAdminReactPage.fieldMaximumParcelCapacityForCollect.setValue(dp.getComputedMaxCapacity());
      }
      if (bufferCapacity != null) {
        splitElement = bufferCapacity.split(",");
        dpAdminReactPage.fieldBufferCapacity.forceClear();
        dpAdminReactPage.fieldBufferCapacity.setValue(splitElement[0]);
        dpAdminReactPage.fieldErrorMsg(splitElement[1]);
        dpAdminReactPage.fieldBufferCapacity.forceClear();
        dpAdminReactPage.fieldBufferCapacity.setValue(dp.getActualMaxCapacity());
      }
      if (maximumParcelStay != null) {
        splitElement = maximumParcelStay.split(",");
        dpAdminReactPage.fieldMaximumParcelStay.forceClear();
        dpAdminReactPage.fieldMaximumParcelStay.setValue(splitElement[0]);
        dpAdminReactPage.fieldErrorMsg(splitElement[1]);
        dpAdminReactPage.fieldMaximumParcelStay.forceClear();
        dpAdminReactPage.fieldMaximumParcelStay.setValue(dp.getMaxParcelStayDuration());
      }
    });
  }


  @Then("Operator get partner id")
  public void operatorGetPartnerId() {
    dpAdminReactPage.inFrame(page -> {
      String partnerId = dpAdminReactPage.labelPartnerId.getText();
      put(KEY_DP_PARTNER_ID, partnerId);
      Partner partner = get(KEY_DP_MANAGEMENT_PARTNER);
      partner.setId(Long.parseLong(partnerId));
      put(KEY_DP_MANAGEMENT_PARTNER, partner);
    });
  }

  @Then("Operator need to make sure that the id and dpms partner id from newly created dp partner is same")
  public void dpPartnerIdDpmsIdChecking() {
    Partner partner = get(KEY_DP_PARTNER);
    dpAdminReactPage.inFrame(() -> dpAdminReactPage.checkingIdAndDpmsId(partner));
  }

  @Then("Operator press reset password button")
  public void pressResetPasswordButton() {
    dpAdminReactPage.inFrame(() -> dpAdminReactPage.buttonResetPassword.click());
  }

  @Then("Operator press back to user edit button")
  public void pressBackToUserEditButton() {
    dpAdminReactPage.inFrame(() -> dpAdminReactPage.buttonBackToUserEdit.click());
  }

  @Then("The Edit Dp User popup is Displayed")
  public void editDpUserIsDisplayed() {
    dpAdminReactPage.inFrame(() -> dpAdminReactPage.labelEditUserTitle.isDisplayed());
  }

  @Then("Operator press save reset password button")
  public void pressSaveResetPasswordButton() {
    dpAdminReactPage.inFrame(() -> dpAdminReactPage.buttonSaveResetPassword.click());
  }

  @Then("Operator will get the error message {string}")
  public void pressSaveResetPasswordButton(String errorMessage) {
    dpAdminReactPage.inFrame(
        () -> Assertions.assertThat(dpAdminReactPage.labelPasswordNotMatch.getText())
            .as(f("error message '%s' appeared", errorMessage)).isEqualTo(errorMessage));
  }


  @Then("Operator fill the password changes")
  public void fillResetPasswordChanges(Map<String, String> dataTableAsMap) {
    String password = dataTableAsMap.get("password");
    String confirmPassword = dataTableAsMap.get("confirmPassword");
    dpAdminReactPage.inFrame(() -> {
      if (password != null) {
        dpAdminReactPage.fieldPassword.setValue(password);
      }
      if (confirmPassword != null) {
        dpAdminReactPage.fieldConfirmPassword.setValue(confirmPassword);
      }
    });
  }

  @Then("Operator verifies that the cut off time for {string} is {string}")
  public void operatorVerifiesTheCutOffTime(String dpDetails, String expectedCutOffTime) {
    DpDetailsResponse dpDetailsResponse = resolveValue(dpDetails);
    dpAdminPage.verifyCutOffTime(expectedCutOffTime, dpDetailsResponse.getCutoffHour());
    takesScreenshot();
  }

  @When("Operator verifies auto reservation for dp {string} is {string}")
  public void dbOperatorFetchesAutoReservationForDp(String dpDetails, String status) {
    DpDetailsResponse dpDetailsResponse = resolveValue(dpDetails);

    if ("Enabled".equalsIgnoreCase(status)) {
      Assertions.assertThat(dpDetailsResponse.getAutoReservationEnabled())
          .as("DP has auto reservation enabled").isTrue();
    } else {
      Assertions.assertThat(dpDetailsResponse.getAutoReservationEnabled())
          .as("DP has auto reservation disabled").isFalse();
    }
  }

  @Then("Operator verifies the image for {string} is {string}")
  public void operatorVerifiesTheImageIs(String dpDetails, String status) {
    DpDetailsResponse dpDetailsResponse = resolveValue(dpDetails);
    if ("present".equalsIgnoreCase(status)) {
      Assertions.assertThat(dpDetailsResponse.getDpPhotoFile()).as("dp image status is incorrect")
          .isNotNull();
    } else {
      Assertions.assertThat(dpDetailsResponse.getDpPhoto()).as("dp image status is incorrect")
          .isNull();
    }

  }

  @Then("Operator Check the Data from created DP is Right")
  public void checkCreatedDPData(Map<String, String> dataTableAsMap) {
    String condition = dataTableAsMap.get("condition");
    co.nvqa.commons.model.dp.persisted_classes.Dp dp = null;
    DpDetailsResponse dpDetailsResponse = null;
    AuditMetadata auditMetadata = null;

    if (dataTableAsMap.get("dp") != null) {
      dp = resolveValue(dataTableAsMap.get("dp"));
    }
    if (dataTableAsMap.get("dpDetails") != null) {
      dpDetailsResponse = resolveValue(dataTableAsMap.get("dpDetails"));
    }
    if (dataTableAsMap.get("auditMetadata") != null) {
      auditMetadata = resolveValue(dataTableAsMap.get("auditMetadata"));
    }

    if (auditMetadata != null) {
      dpAdminReactPage.checkNewlyCreatedDpAndAuditMetadata(dp, auditMetadata);
    } else if (condition != null) {
      if ((condition.equals(CHECK_DP_SEARCH_LAT_LONG) || condition.equals(CHECK_DP_SEARCH_ADDRESS))
          && dpDetailsResponse != null) {
        dpAdminReactPage.checkNewlyCreatedDpBySearchAddressLatLong(dp, dpDetailsResponse);
      } else if (condition.equals(CHECK_DP_OPENING_OPERATING_HOURS) && dpDetailsResponse != null) {
        String[] days = dpDetailsResponse.getOperatingHoursDay().split(",");
        List<DpOpeningHour> dpOpeningHours = resolveValue(dataTableAsMap.get("dpOpeningHours"));
        List<DpOperatingHour> dpOperatingHours = resolveValue(
            dataTableAsMap.get("dpOperatingHours"));
        ImmutableMap<String, Integer> dayNumberMap = ImmutableMap.<String, Integer>builder()
            .put("monday", 1)
            .put("tuesday", 2)
            .put("wednesday", 3)
            .put("thursday", 4)
            .put("friday", 5)
            .put("saturday", 6)
            .put("sunday", 7)
            .build();

        for (String day : days) {
          for (int i = 0; i < dpDetailsResponse.getOpeningHours().get(day).size(); i++) {
            dpAdminReactPage.checkOpeningTime(day, dayNumberMap.get(day), dpOpeningHours,
                dpDetailsResponse.getOpeningHours().get(day).get(i));
          }
        }

        for (String day : days) {
          for (int i = 0; i < dpDetailsResponse.getOperatingHours().get(day).size(); i++) {
            dpAdminReactPage.checkOperatingTime(day, dayNumberMap.get(day), dpOperatingHours,
                dpDetailsResponse.getOperatingHours().get(day).get(i));
          }
        }
      } else if (condition.equals(CHECK_ALTERNATE_DP_DATA)) {
        DpSetting dpSetting = resolveValue(dataTableAsMap.get("dpSetting"));
        String[] dpsToRedirect;
        if (dpSetting.getDpsToRedirect() != null) {
          dpsToRedirect = dpSetting.getDpsToRedirect().split(",");
        } else {
          dpsToRedirect = null;
        }

        if (dpDetailsResponse != null && dpsToRedirect != null) {
          for (String altDp : dpsToRedirect) {
            if (dpDetailsResponse.getAlternateDpId1() != null
                && dpDetailsResponse.getAlternateDpId1()
                .toString().equals(altDp)) {
              Assertions.assertThat(dpDetailsResponse.getAlternateDpId1().toString())
                  .as(f("Alternate DP ID 1 is %s", altDp)).isEqualTo(altDp);
            }
            if (dpDetailsResponse.getAlternateDpId2() != null
                && dpDetailsResponse.getAlternateDpId2()
                .toString().equals(altDp)) {
              Assertions.assertThat(dpDetailsResponse.getAlternateDpId2().toString())
                  .as(f("Alternate DP ID 2 is %s", altDp)).isEqualTo(altDp);
            }
            if (dpDetailsResponse.getAlternateDpId3() != null
                && dpDetailsResponse.getAlternateDpId3()
                .toString().equals(altDp)) {
              Assertions.assertThat(dpDetailsResponse.getAlternateDpId3().toString())
                  .as(f("Alternate DP ID 3 is %s", altDp)).isEqualTo(altDp);
            }
          }
        } else {
          LOGGER.info("DP Has No Alternate DP");
        }
      } else if (condition.equals(CHECK_DP_RESERVATION_DATA)) {
        DpSetting dpSetting = get(KEY_DP_SETTINGS);
        if (dpDetailsResponse != null && dpSetting != null) {
          Assertions.assertThat(dpSetting.getCutOffTime())
              .as(f("Dp Auto Reservation Cut-Off Time Is %s", dpSetting.getCutOffTime()))
              .contains(dpDetailsResponse.getAutoReservationCutOffTime());

          Assertions.assertThat(dpDetailsResponse.getAutoReservationEnabled())
              .as(f("Dp Auto Reservation Enabled Is %s", dpSetting.getAutoReservationEnabled()))
              .isEqualTo(dpSetting.getAutoReservationEnabled());
        }
      } else if (condition.equals(CHECK_DP_RESERVATION_DATA_DEFAULT)) {
        DpSetting dpSetting = get(KEY_DP_SETTINGS);
        if (dpDetailsResponse != null && dpSetting != null) {
          Assertions.assertThat(dpSetting.getCutOffTime())
              .as(f("Dp Auto Reservation Cut-Off Time Is %s", "23:59:59"))
              .contains("23:59:59");

          Assertions.assertThat(dpDetailsResponse.getAutoReservationEnabled())
              .as(f("Dp Auto Reservation Enabled Is %s", dpSetting.getAutoReservationEnabled()))
              .isEqualTo(dpSetting.getAutoReservationEnabled());
        }
      } else if (condition.equals(CHECK_DP_RESERVATION_DATA_DISABLED)) {
        DpSetting dpSetting = get(KEY_DP_SETTINGS);
        if (dpDetailsResponse != null && dpSetting != null) {
          Assertions.assertThat(dpDetailsResponse.getAutoReservationEnabled())
              .as(f("Dp Auto Reservation Enabled Is %s", dpSetting.getAutoReservationEnabled()))
              .isEqualTo(dpSetting.getAutoReservationEnabled());
        }
      } else if (condition.equals(CHECK_DP_PHOTO)) {
        DpSetting dpSetting = get(KEY_DP_SETTINGS);
        if (dpDetailsResponse != null && dpSetting != null) {
          if (dpDetailsResponse.getDpPhoto().equalsIgnoreCase("valid")
              || dpDetailsResponse.getDpPhoto().equalsIgnoreCase("notSaveClear")) {
            Assertions.assertThat(dpSetting.getImages())
                .as("Dp Images is Existed Is Valid")
                .isNotNull();
          } else if (dpDetailsResponse.getDpPhoto().equalsIgnoreCase("clear")
              || dpDetailsResponse.getDpPhoto().equalsIgnoreCase("invalid")) {
            Assertions.assertThat(dpSetting.getImages())
                .as("Dp Images is Existed Is Invalid")
                .isEqualTo("[]");
          }
        }
      }
    }
  }

  @And("Operator check the data again with pressing ascending and descending order :")
  public void ascendingDataCheck(Map<String, String> searchSDetailsAsMap) {
    Partner partner = get(KEY_DP_MANAGEMENT_PARTNER);
    DpPartner expected = dpAdminReactPage.convertPartnerToDpPartner(partner);

    searchSDetailsAsMap = resolveKeyValues(searchSDetailsAsMap);
    String searchDetailsData = StandardTestUtils.replaceTokens(
        searchSDetailsAsMap.get("searchDetails"),
        StandardTestUtils.createDefaultTokens());
    String[] extractDetails = searchDetailsData.split(",");

    dpAdminReactPage.inFrame(() -> {
      String valueDetails = dpAdminReactPage.getDpPartnerElementByMap(extractDetails[0], expected);
      dpAdminReactPage.fillFilterDpPartner(extractDetails[0], valueDetails);
      for (String extractDetail : extractDetails) {
        dpAdminReactPage.sortFilter(extractDetail);
        pause2s();
        dpAdminReactPage.readDpPartnerEntity(expected);
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
    put(KEY_DISTRIBUTION_POINT_ID, dpParams.getId());
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
    pause5s();
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

  @And("Operator verifies the newly created DP user data is right")
  public void verifyNewlyCreatedDpUser(Map<String, String> dataTableAsMap) {
    DpUser dpUser;
    if (get(dataTableAsMap.get("dpUser")) != null) {
      dpUser = get(dataTableAsMap.get("dpUser"), DpUser.class);
    } else {
      dpUser = dpUserConverter(resolveValue(dataTableAsMap.get("dpUser")));
    }
    co.nvqa.commons.model.dp.DpUser dpUserDb = get(dataTableAsMap.get("dpUserDb"));
    dpAdminPage.verifyNewlyCreatedDpUser(dpUser, dpUserDb);
  }

  @And("Operator verifies the newly created DP user data is deleted")
  public void verifyNewlyCreatedDpUserDeleted(Map<String, String> dataTableAsMap) {
    co.nvqa.commons.model.dp.DpUser dpUserDb = get(dataTableAsMap.get("dpUserDb"));
    String status = dataTableAsMap.get("status");
    dpAdminPage.verifyNewlyCreatedDpUserDeleted(dpUserDb, status);
  }

  public DpUser dpUserConverter(co.nvqa.common.dp.model.beans.DpUser dpUser){
    DpUser dpUserOld = JsonUtils.fromJsonSnakeCase(JsonUtils.toJsonSnakeCase(dpUser), DpUser.class);
    dpUserOld.setEmailId(dpUser.getEmail());
    dpUserOld.setContactNo(dpUser.getContactNo());
    return dpUserOld;
  }

  @Given("Operator generate prefix for dp creation")
  public void operatorGeneratePrefixForDpCreation()
  {
    put(KEY_DP_GENERATED_PREFIX, co.nvqa.common.utils.RandomUtil.randomString(5));
  }

  @When("Operator fill the Dp User filter by {value} with value {value}")
  public void operatorFillTheDpUserFilterByValue(String element, String value) {
    dpAdminReactPage.inFrame(() -> {
      dpAdminReactPage.textBoxDpUserFilter.get(element).waitUntilVisible();
      dpAdminReactPage.textBoxDpUserFilter.get(element).setValue(value);
    });
  }

  @When("Operator Edit Dp User Details with the data below :")
  public void operatorEditDpUserDetails(DataTable dt) {
    List<DpUser> dpUsers = convertDataTableToList(dt, DpUser.class);
    dpAdminReactPage.inFrame(() -> {
      dpAdminReactPage.formDpUserFirstName.forceClear();
      dpAdminReactPage.formDpUserFirstName.setValue(dpUsers.get(0).getFirstName());

      dpAdminReactPage.formDpUserLastName.forceClear();
      dpAdminReactPage.formDpUserLastName.setValue(dpUsers.get(0).getLastName());

      dpAdminReactPage.formDpUserContact.forceClear();
      dpAdminReactPage.formDpUserContact.setValue(dpUsers.get(0).getContactNo());

      dpAdminReactPage.formDpUserEmail.forceClear();
      dpAdminReactPage.formDpUserEmail.setValue(dpUsers.get(0).getEmailId());

      put(KEY_DP_USER, dpUsers.get(0));
    });
  }

  @Then("Operator verify data on dp user creation same with data of dp user on table :")
  public void newOperatorVerifyDpUserDetails(Map<String, String> searchDetailsAsMap) {
    DpUser dpUser = resolveValue(searchDetailsAsMap.get("dpUser"));

    searchDetailsAsMap = resolveKeyValues(searchDetailsAsMap);
    String searchDetailsData = StandardTestUtils.replaceTokens(
        searchDetailsAsMap.get("searchDetails"),
        StandardTestUtils.createDefaultTokens());
    String[] extractDetails = searchDetailsData.split(",");

    dpAdminReactPage.inFrame(() -> {
      for (String extractDetail : extractDetails) {
        String valueDetails = dpAdminReactPage.getDpUserElementByMap(extractDetail, dpUser);
        dpAdminReactPage.fillFilterDpUser(extractDetail, valueDetails);
        pause2s();
        dpAdminReactPage.readDpUserEntity(dpUser);
        dpAdminReactPage.clearDpUserFilter(extractDetail);
      }
    });
  }

  @Then("Operator verify values on dp user table updated")
  public void operatorVerifyValuesOnDpUserTableUpdated()
  {
    doWithRetry(() -> {
      DpUser dpUser = get(KEY_DP_USER);
      dpAdminReactPage.refreshPage();
      dpAdminReactPage.inFrame(() -> dpAdminReactPage.readDpUserEntity(dpUser));
    }, "verify values on dp user table");
  }

  @Then("Operator verify dp user username value trimmed to only 100 characters")
  public void operatorVerifyDpUserUsernameValueTrimmedToOnlyHundred()
  {
    dpAdminReactPage.inFrame(() -> {
      String valueOfUsername = dpAdminReactPage.formDpUserUsername.getValue();
      Assertions.assertThat(valueOfUsername.length())
          .as("Username trimmed to 100 chars")
          .isEqualTo(100);
    });
  }

  @When("Operator fill dp user username field with more than 100 characters by {string}")
  public void operatorFillDpUserUsernameMoreThanHundredByTypingIn(String inputMethod)
  {
    String username = co.nvqa.common.utils.RandomUtil.randomString(102);
    dpAdminReactPage.inFrame(() -> {
      dpAdminReactPage.formDpUserUsername.forceClear();
      if(COPY_PASTE.equals(inputMethod))
      {
        dpAdminReactPage.formDpUserUsername.setValue(username);
      }
      else {
        dpAdminReactPage.formDpUserUsername.setValueByTyping(username);
      }
    });
  }

}