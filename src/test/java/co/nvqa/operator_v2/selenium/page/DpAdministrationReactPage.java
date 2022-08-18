package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.dp.DpDetailsResponse;
import co.nvqa.commons.model.dp.Partner;
import co.nvqa.commons.model.dp.dp_user.User;
import co.nvqa.operator_v2.model.DpPartner;
import co.nvqa.operator_v2.model.DpUser;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import com.google.common.collect.ImmutableMap;
import org.apache.commons.lang3.RandomStringUtils;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebDriver;
import co.nvqa.operator_v2.selenium.elements.Button;
import org.openqa.selenium.support.FindBy;

/**
 * @author Diaz Ilyasa
 */
public class DpAdministrationReactPage extends SimpleReactPage<DpAdministrationReactPage> {

  @FindBy(xpath = "//button[@data-testid='button_download_csv']")
  public Button buttonDownloadCsv;

  @FindBy(xpath = "//button[@data-testid='button_add_partner']")
  public Button buttonAddPartner;

  @FindBy(xpath = "//button[@type='button'][@role='switch']")
  public Button buttonSendNotifications;

  @FindBy(xpath = "//button[@data-testId='button_submit_partner']")
  public Button buttonSubmitPartner;

  @FindBy(xpath = "//button[@data-testId='button_edit_partner']")
  public Button buttonEditPartner;

  @FindBy(xpath = "//button[@data-testId='button_submit_dp_changes']")
  public Button buttonSubmitPartnerChanges;

  @FindBy(xpath = "//button[@data-testId='button_view_dps']")
  public Button buttonViewDps;

  @FindBy(xpath = "//button[@data-testId='button_add_dp']")
  public Button buttonAddDp;

  @FindBy(xpath = "//button[@data-testId='button_dp_user']")
  public Button buttonDpUser;

  @FindBy(xpath = "//button[@data-testId='button_add_user']")
  public Button buttonAddUser;

  @FindBy(xpath = "//button[@data-testId='button_submit']")
  public TextBox buttonSubmitDpUser;

  @FindBy(xpath = "//input[@data-testId='virtual-table.field_partner_id']")
  public TextBox filterPartnerId;

  @FindBy(xpath = "//input[@data-testId='virtual-table.field_partner_name']")
  public TextBox filterPartnerName;

  @FindBy(xpath = "//div[@class='ant-modal-body']//input[@data-testId='field_partner_name']")
  public TextBox formPartnerName;

  @FindBy(xpath = "//input[@data-testId='virtual-table.field_poc_name']")
  public TextBox filterPocName;

  @FindBy(xpath = "//div[@class='ant-modal-body']//input[@data-testId='field_poc_name']")
  public TextBox formPocName;

  @FindBy(xpath = "//input[@data-testId='virtual-table.field_poc_no']")
  public TextBox filterPocNo;

  @FindBy(xpath = "//div[@class='ant-modal-body']//input[@data-testId='field_poc_tel']")
  public TextBox formPocNo;

  @FindBy(xpath = "//input[@data-testId='virtual-table.field_poc_email']")
  public TextBox filterPocEmail;

  @FindBy(xpath = "//div[@class='ant-modal-body']//input[@data-testId='field_poc_email']")
  public TextBox formPocEmail;

  @FindBy(xpath = "//input[@data-testId='virtual-table.field_restrictions']")
  public TextBox filterRestrictions;

  @FindBy(xpath = "//input[@data-testId='virtual-table.field_dp_id']")
  public TextBox filterDpId;

  @FindBy(xpath = "//input[@data-testId='virtual-table.field_dp_name']")
  public TextBox filterDpName;

  @FindBy(xpath = "//input[@data-testId='virtual-table.field_dp_shortname']")
  public TextBox filterDpShortName;

  @FindBy(xpath = "//input[@data-testId='virtual-table.field_dp_hub']")
  public TextBox filterDpHub;

  @FindBy(xpath = "//input[@data-testId='virtual-table.field_dp_address']")
  public TextBox filterDpAddress;

  @FindBy(xpath = "//input[@data-testId='virtual-table.field_dp_direction']")
  public TextBox filterDpDirection;

  @FindBy(xpath = "//input[@data-testId='virtual-table.field_dp_activity']")
  public TextBox filterDpActivity;

  @FindBy(xpath = "//input[@data-testId='virtual-table.field_username']")
  public TextBox filterDpUserUsername;

  @FindBy(xpath = "//input[@data-testId='virtual-table.field_first_name']")
  public TextBox filterDpUserFirstName;

  @FindBy(xpath = "//input[@data-testId='virtual-table.field_last_name']")
  public TextBox filterDpUserLastName;

  @FindBy(xpath = "//input[@data-testId='virtual-table.field_email']")
  public TextBox filterDpUserEmail;

  @FindBy(xpath = "//input[@data-testId='virtual-table.field_contact']")
  public TextBox filterDpUserContact;

  @FindBy(xpath = "//div[@class='ant-modal-body']//input[@data-testId='field_restrictions']")
  public TextBox formRestrictions;

  @FindBy(xpath = "//div[@class='ant-modal-body']//input[@data-testId='field_first_name']")
  public TextBox formDpUserFirstName;

  @FindBy(xpath = "//div[@class='ant-modal-body']//input[@data-testId='field_last_name']")
  public TextBox formDpUserLastName;

  @FindBy(xpath = "//div[@class='ant-modal-body']//input[@data-testId='field_contact_no']")
  public TextBox formDpUserContact;

  @FindBy(xpath = "//div[@class='ant-modal-body']//input[@data-testId='field_email']")
  public TextBox formDpUserEmail;

  @FindBy(xpath = "//div[@class='ant-modal-body']//input[@data-testId='field_username']")
  public TextBox formDpUserUsername;

  @FindBy(xpath = "//div[@class='ant-modal-body']//input[@data-testId='field_password']")
  public TextBox formDpUserPassword;

  @FindBy(xpath = "//div[@data-testid='virtual-table.label_partner_id']/span")
  public PageElement labelPartnerId;

  @FindBy(xpath = "//div[@data-testid='virtual-table.label_partner_name']/span")
  public PageElement labelPartnerName;

  @FindBy(xpath = "//div[@data-testid='virtual-table.label_poc_name']/span")
  public PageElement labelPocName;

  @FindBy(xpath = "//div[@data-testid='virtual-table.label_poc_no']/span")
  public PageElement labelPocNo;

  @FindBy(xpath = "//div[@data-testid='virtual-table.label_poc_email']/span")
  public PageElement labelPocEmail;

  @FindBy(xpath = "//div[@data-testid='virtual-table.label_restrictions']/span")
  public PageElement labelRestrictions;

  @FindBy(xpath = "//div[@data-testid='virtual-table.label_username']/span")
  public PageElement labelUsername;

  @FindBy(xpath = "//div[@data-testid='virtual-table.label_first_name']/span")
  public PageElement labelUserFirstName;

  @FindBy(xpath = "//div[@data-testid='virtual-table.label_last_name']/span")
  public PageElement labelUserLastName;

  @FindBy(xpath = "//div[@data-testid='virtual-table.label_email']/span")
  public PageElement labelUserEmail;

  @FindBy(xpath = "//div[@data-testid='virtual-table.label_contact']/span")
  public PageElement labelUserContact;

  @FindBy(xpath = "//div[@data-headerkey='id']/div/div[1]/*[name()='svg']")
  public PageElement sortPartnerId;

  @FindBy(xpath = "//div[@data-headerkey='name']/div/div[1]/*[name()='svg']")
  public PageElement sortPartnerName;

  @FindBy(xpath = "//div[@data-headerkey='poc_name']/div/div[1]/*[name()='svg']")
  public PageElement sortPocName;

  @FindBy(xpath = "//div[@data-headerkey='poc_tel']/div/div[1]/*[name()='svg']")
  public PageElement sortPocNo;

  @FindBy(xpath = "//div[@data-headerkey='poc_email']/div/div[1]/*[name()='svg']")
  public PageElement sortPocEmail;

  @FindBy(xpath = "//div[@data-headerkey='restrictions']/div/div[1]/*[name()='svg']")
  public PageElement sortRestrictions;

  @FindBy(xpath = "//h2[@data-testid='label_page_details']")
  public PageElement dpAdminHeader;

  @FindBy(xpath = "//h2[@data-testid='label_distribution_points']")
  public PageElement distributionPointHeader;

  @FindBy(xpath = "//div[contains(@class,'nv-input-field-error')]/div[3]")
  public PageElement errorMsg;

  @FindBy(xpath = "//div[@class='ant-notification-notice-description']")
  public PageElement errorNotification;

  @FindBy(xpath = "//div[@class='ant-notification-notice-description']/div/div[3]/span")
  public PageElement errorMsgUsernameDuplicate;

  public static final String ERROR_MSG_NOT_PHONE_NUM = "That doesn't look like a phone number.";
  public static final String ERROR_MSG_NOT_EMAIL_FORMAT = "That doesn't look like an email.";
  public static final String ERROR_MSG_DUPLICATE_USERNAME = "Username '%s' not available, please specify another username";
  public static final String ERROR_MSG_FIELD_REQUIRED = "This field is required";

  public ImmutableMap<String, TextBox> textBoxDpPartnerFilter = ImmutableMap.<String, TextBox>builder()
      .put("id", filterPartnerId)
      .put("name", filterPartnerName)
      .put("pocName", filterPocName)
      .put("pocTel", filterPocNo)
      .put("pocEmail", filterPocEmail)
      .put("restrictions", filterRestrictions)
      .build();

  public ImmutableMap<String, TextBox> textBoxDpFilter = ImmutableMap.<String, TextBox>builder()
      .put("id", filterDpId)
      .put("name", filterDpName)
      .put("shortName", filterDpShortName)
      .put("hub", filterDpHub)
      .put("address", filterDpAddress)
      .put("direction", filterDpDirection)
      .put("activity", filterDpActivity)
      .build();

  public ImmutableMap<String, TextBox> textBoxDpUserFilter = ImmutableMap.<String, TextBox>builder()
      .put("username", filterDpUserUsername)
      .put("firstName", filterDpUserFirstName)
      .put("lastName", filterDpUserLastName)
      .put("email", filterDpUserEmail)
      .put("contact", filterDpUserContact)
      .build();


  public DpAdministrationReactPage(WebDriver webDriver) {
    super(webDriver);
  }

  public DpPartner convertPartnerToDpPartner(Partner partner) {
    DpPartner dpPartner = new DpPartner();
    dpPartner.setId(partner.getId());
    dpPartner.setDpmsPartnerId(partner.getDpmsPartnerId());
    dpPartner.setName(partner.getName());
    dpPartner.setPocName(partner.getPocName());
    dpPartner.setPocEmail(partner.getPocEmail());
    dpPartner.setPocTel(partner.getPocTel());
    dpPartner.setRestrictions(partner.getRestrictions());
    return dpPartner;
  }

  public DpUser convertUserToDpUser(User user) {
    DpUser dpUser = new DpUser();
    dpUser.setId(user.getId());
    dpUser.setUsername(user.getUsername());
    dpUser.setContactNo(user.getContactNo());
    dpUser.setFirstName(user.getFirstName());
    dpUser.setLastName(user.getLastName());
    dpUser.setEmailId(user.getEmail());
    return dpUser;
  }

  public void sortFilter(String field) {
    ImmutableMap<String, PageElement> sortElement = ImmutableMap.<String, PageElement>builder()
        .put("id", sortPartnerId)
        .put("name", sortPartnerName)
        .put("pocName", sortPocName)
        .put("pocTel", sortPocNo)
        .put("pocEmail", sortPocEmail)
        .put("restrictions", sortRestrictions)
        .build();

    sortElement.get(field).click();
  }

  public void fillFilterDpPartner(String field, String value) {
    textBoxDpPartnerFilter.get(field).waitUntilVisible(2);
    textBoxDpPartnerFilter.get(field).setValue(value);
  }

  public void fillFilterDpUser(String field, String value) {
    textBoxDpUserFilter.get(field).waitUntilVisible(2);
    textBoxDpUserFilter.get(field).setValue(value);
  }

  public void clearDpPartnerFilter(String field) {
    textBoxDpPartnerFilter.get(field).forceClear();
  }

  public void clearDpUserFilter(String field) {
    textBoxDpUserFilter.get(field).forceClear();
  }

  public void duplicateUsernameExist(DpUser dpUser) {
    Assertions.assertThat(errorMsgUsernameDuplicate.getText())
        .as(f("Error Message exist: %s", errorMsgUsernameDuplicate.getText()))
        .isEqualTo(f(ERROR_MSG_DUPLICATE_USERNAME, dpUser.getUsername()));
  }

  public void errorCheckDpUser(DpUser dpUser) {
    formDpUserFirstName.setValue(dpUser.getFirstName());
    formDpUserFirstName.forceClear();
    Assertions.assertThat(errorMsg.getText())
        .as(f("Error Message if First Name Empty: %s", ERROR_MSG_FIELD_REQUIRED))
        .isEqualTo(ERROR_MSG_FIELD_REQUIRED);
    formDpUserFirstName.setValue(dpUser.getFirstName());

    formDpUserLastName.setValue(dpUser.getLastName());
    formDpUserLastName.forceClear();
    Assertions.assertThat(errorMsg.getText())
        .as(f("Error Message if Last Name Empty: %s", ERROR_MSG_FIELD_REQUIRED))
        .isEqualTo(ERROR_MSG_FIELD_REQUIRED);
    formDpUserLastName.setValue(dpUser.getLastName());

    formDpUserContact.setValue(dpUser.getContactNo());
    formDpUserContact.forceClear();
    Assertions.assertThat(errorMsg.getText())
        .as(f("Error Message if Contact is Empty: %s", ERROR_MSG_FIELD_REQUIRED))
        .isEqualTo(ERROR_MSG_FIELD_REQUIRED);
    formDpUserContact.setValue(RandomStringUtils.random(10, true, false));
    Assertions.assertThat(errorMsg.getText())
        .as(f("Error Message if Contact is filled with random character: %s",
            ERROR_MSG_NOT_PHONE_NUM))
        .isEqualTo(ERROR_MSG_NOT_PHONE_NUM);
    formDpUserContact.forceClear();
    formDpUserContact.setValue(dpUser.getContactNo());

    formDpUserEmail.setValue(dpUser.getEmailId());
    formDpUserEmail.forceClear();
    Assertions.assertThat(errorMsg.getText())
        .as(f("Error Message if Email is Empty: %s", ERROR_MSG_FIELD_REQUIRED))
        .isEqualTo(ERROR_MSG_FIELD_REQUIRED);
    formDpUserEmail.setValue(RandomStringUtils.random(10, true, false));
    Assertions.assertThat(errorMsg.getText())
        .as(f("Error Message if Email is filled with wrong format (All Letter): %s",
            ERROR_MSG_NOT_EMAIL_FORMAT))
        .isEqualTo(ERROR_MSG_NOT_EMAIL_FORMAT);
    formDpUserEmail.forceClear();
    formDpUserEmail.setValue(RandomStringUtils.random(10, false, true));
    Assertions.assertThat(errorMsg.getText())
        .as(f("Error Message if Email is filled with wrong format (All Number): %s",
            ERROR_MSG_NOT_EMAIL_FORMAT))
        .isEqualTo(ERROR_MSG_NOT_EMAIL_FORMAT);
    formDpUserEmail.forceClear();
    formDpUserEmail.setValue(dpUser.getEmailId());

    formDpUserUsername.setValue(dpUser.getUsername());
    formDpUserUsername.forceClear();
    Assertions.assertThat(errorMsg.getText())
        .as(f("Error Message if Last Name Empty: %s", ERROR_MSG_FIELD_REQUIRED))
        .isEqualTo(ERROR_MSG_FIELD_REQUIRED);
    formDpUserUsername.setValue(dpUser.getUsername());

    formDpUserPassword.setValue(dpUser.getPassword());
    formDpUserPassword.forceClear();
    Assertions.assertThat(errorMsg.getText())
        .as(f("Error Message if Last Name Empty: %s", ERROR_MSG_FIELD_REQUIRED))
        .isEqualTo(ERROR_MSG_FIELD_REQUIRED);
    formDpUserPassword.setValue(dpUser.getPassword());
  }

  public void errorCheckDpPartner(Partner dpPartner) {

    if (dpPartner.getName().contains("NAME")) {
      formPartnerName.forceClear();
      formPartnerName.setValue(dpPartner.getName());
      formPartnerName.forceClear();
    } else if (dpPartner.getName().contains("POCNME")) {
      formPocName.forceClear();
      formPocName.setValue(dpPartner.getPocName());
      formPocName.forceClear();
    } else if (dpPartner.getName().contains("!POCNUM")) {
      if (dpPartner.getPocTel().equals("VALID")) {
        formPocNo.forceClear();
        formPocNo.setValue(RandomStringUtils.random(10, true, false));
        Assertions.assertThat(errorMsg.getText())
            .as(f("Error Message Exist after fill Form POC NO with wrong format (Not Number) : %s",
                ERROR_MSG_NOT_PHONE_NUM))
            .isEqualTo(ERROR_MSG_NOT_PHONE_NUM);
      }
    }else if (dpPartner.getName().contains("POCNUM")) {
      if (dpPartner.getPocTel().equals("VALID")) {
        formPocNo.forceClear();
        formPocNo.setValue(RandomStringUtils.random(10, true, false));
        Assertions.assertThat(errorMsg.getText())
            .as(f("Error Message Exist after fill Form POC NO with wrong format (Not Number) : %s",
                ERROR_MSG_NOT_PHONE_NUM))
            .isEqualTo(ERROR_MSG_NOT_PHONE_NUM);
        formPocNo.forceClear();

        formPocNo.setValue(RandomStringUtils.random(10, false, true));
        formPocNo.forceClear();
      }
    } else if (dpPartner.getName().contains("POCMAIL")) {
      formPocEmail.forceClear();
      formPocEmail.setValue(RandomStringUtils.random(10, true, false));
      Assertions.assertThat(errorMsg.getText())
          .as(f("Error Message Exist after fill Form POC Email with wrong format (Letters): %s",
              ERROR_MSG_NOT_EMAIL_FORMAT))
          .isEqualTo(ERROR_MSG_NOT_EMAIL_FORMAT);
      formPocEmail.forceClear();

      formPocEmail.setValue(RandomStringUtils.random(10, false, true));
      Assertions.assertThat(errorMsg.getText())
          .as(f("Error Message Exist after fill Form POC Email with wrong format (Number): %s",
              ERROR_MSG_NOT_EMAIL_FORMAT))
          .isEqualTo(ERROR_MSG_NOT_EMAIL_FORMAT);

    } else if (dpPartner.getName().contains("RESTRICTION")) {
      formRestrictions.forceClear();
      formRestrictions.setValue(dpPartner.getRestrictions());
      formRestrictions.forceClear();
    }

  }


  public void checkErrorMsg(String errMessage) {
    Assertions.assertThat(errorMsg.getText())
        .as(f("Error Message: %s", errMessage))
        .isEqualTo(errMessage);
  }

  public void readDpPartnerEntity(DpPartner dpPartner) {
    Assertions.assertThat(Long.toString(dpPartner.getId()))
        .as(f("Partner ID Is %s", dpPartner.getId())).isEqualTo(labelPartnerId.getText());
    Assertions.assertThat(dpPartner.getName()).as(f("Partner Name Is %s", dpPartner.getName()))
        .isEqualTo(labelPartnerName.getText());
    Assertions.assertThat(dpPartner.getPocName()).as(f("POC Name Is %s", dpPartner.getPocName()))
        .isEqualTo(labelPocName.getText());
    Assertions.assertThat(dpPartner.getPocTel()).as(f("POC No Is %s", dpPartner.getPocTel()))
        .isEqualTo(labelPocNo.getText());
    Assertions.assertThat(dpPartner.getPocEmail()).as(f("POC Email Is %s", dpPartner.getPocEmail()))
        .isEqualTo(labelPocEmail.getText());
    Assertions.assertThat(dpPartner.getRestrictions())
        .as(f("Restrictions Is %s", dpPartner.getRestrictions()))
        .isEqualTo(labelRestrictions.getText());
  }

  public void readDpUserEntity(DpUser dpUser) {
    Assertions.assertThat(dpUser.getUsername()).as(f("username Is %s", dpUser.getUsername()))
        .isEqualTo(labelUsername.getText());
    Assertions.assertThat(dpUser.getFirstName()).as(f("First Name Is %s", dpUser.getFirstName()))
        .isEqualTo(labelUserFirstName.getText());
    Assertions.assertThat(dpUser.getLastName()).as(f("Last Name Is %s", dpUser.getLastName()))
        .isEqualTo(labelUserLastName.getText());
    Assertions.assertThat(dpUser.getEmailId()).as(f("Email Is %s", dpUser.getEmailId()))
        .isEqualTo(labelUserEmail.getText());
    Assertions.assertThat(dpUser.getContactNo())
        .as(f("Contact No Is %s", dpUser.getContactNo()))
        .isEqualTo(labelUserContact.getText());
  }

  public void checkingIdAndDpmsId(Partner partner) {
    Assertions.assertThat(partner.getId()).as("DP ID and DPMS ID is Same")
        .isEqualTo(partner.getDpmsPartnerId());
  }

  public String getDpPartnerElementByMap(String map, DpPartner dpPartner) {
    ImmutableMap<String, String> partnerElement = ImmutableMap.<String, String>builder()
        .put("id", Long.toString(dpPartner.getId()))
        .put("name", dpPartner.getName())
        .put("pocName", dpPartner.getPocName())
        .put("pocTel", dpPartner.getPocTel())
        .put("pocEmail", dpPartner.getPocEmail())
        .put("restrictions", dpPartner.getRestrictions())
        .build();

    return partnerElement.get(map);
  }

  public String getDpUserElementByMap(String map, DpUser dpUser) {
    ImmutableMap<String, String> partnerElement = ImmutableMap.<String, String>builder()
        .put("username", dpUser.getUsername())
        .put("firstName", dpUser.getFirstName())
        .put("lastName", dpUser.getLastName())
        .put("email", dpUser.getEmailId())
        .put("contact", dpUser.getContactNo())
        .build();

    return partnerElement.get(map);
  }

  public String getDpElementByMap(String map, DpDetailsResponse dp) {
    ImmutableMap<String, String> dpElement = ImmutableMap.<String, String>builder()
        .put("id", Long.toString(dp.getId()))
        .put("name", dp.getName())
        .put("shortName", dp.getShortName())
        .put("hub", Long.toString(dp.getHubId()))
        .put("address", dp.getAddress1())
        .put("direction", dp.getDirections())
        .put("activity", dp.getIsActive() ? "Active" : "Inactive")
        .build();

    return dpElement.get(map);
  }

}
