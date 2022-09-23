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

  @FindBy(xpath = "//button[@data-testid='virtual-table.button_download_csv']")
  public Button buttonDownloadCsv;

  @FindBy(xpath = "//button[@data-testid='button_add_partner']")
  public Button buttonAddPartner;

  @FindBy(xpath = "//button[@type='button'][@role='switch']")
  public Button buttonSendNotifications;

  @FindBy(xpath = "//button[@data-testId='button_submit_partner']")
  public Button buttonSubmitPartner;

  @FindBy(xpath = "//button[@data-testId='button_edit_partner']")
  public Button buttonEditPartner;

  @FindBy(xpath = "//button[@data-testId='button_edit_user']")
  public Button buttonEditUser;

  @FindBy(xpath = "//button[@data-testId='button_submit_dp_changes']")
  public Button buttonSubmitPartnerChanges;

  @FindBy(xpath = "//button[@data-testId='button_view_dps']")
  public Button buttonViewDps;

  @FindBy(xpath = "//button[@data-testId='button_dp_edit']")
  public Button buttonDpEdit;

  @FindBy(xpath = "//button[@data-testId='button_add_dp']")
  public Button buttonAddDp;

  @FindBy(xpath = "//button[@data-testId='button_dp_user']")
  public Button buttonDpUser;

  @FindBy(xpath = "//button[@data-testId='button_add_user']")
  public Button buttonAddUser;

  @FindBy(xpath = "//button[@data-testId='button_return_to_list']")
  public Button buttonReturnToList;

  @FindBy(xpath = "//button[@data-testId='button_save_settings']")
  public Button buttonSaveSettings;

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

  @FindBy(xpath = "//input[@data-testid='field_point_name']")
  public TextBox fieldPointName;

  @FindBy(xpath = "//input[@data-testid='field_short_name']")
  public TextBox fieldShortName;

  @FindBy(xpath = "//input[@data-testid='field_contact_number']")
  public TextBox fieldContactNumber;

  @FindBy(xpath = "//input[@data-testid='field_external_store_id']")
  public TextBox fieldExternalStoreId;

  @FindBy(xpath = "//div[@data-testid='field_shipper_account_no']/div/span/input")
  public TextBox fieldShipperAccountNo;

  @FindBy(xpath = "//input[@data-testid='field_postcode']")
  public TextBox fieldPostcode;

  @FindBy(xpath = "//input[@data-testid='field_city']")
  public TextBox fieldCity;

  @FindBy(xpath = "//div[@data-testid='field_assigned_hub']/div/span/input")
  public TextBox fieldAssignedHub;

  @FindBy(xpath = "//input[@data-testid='field_point_address_1']")
  public TextBox fieldPointAddress1;

  @FindBy(xpath = "//input[@data-testid='field_point_address_2']")
  public TextBox fieldPointAddress2;

  @FindBy(xpath = "//input[@data-testid='field_floor_no']")
  public TextBox fieldFloorNo;

  @FindBy(xpath = "//input[@data-testid='field_unit_no']")
  public TextBox fieldUnitNo;

  @FindBy(xpath = "//input[@data-testid='field_latitude']")
  public TextBox fieldLatitude;

  @FindBy(xpath = "//input[@data-testid='field_longitude']")
  public TextBox fieldLongitude;

  @FindBy(xpath = "//input[@data-testid='field_maximum_parcel_capacity_for_collect']")
  public TextBox fieldMaximumParcelCapacityForCollect;

  @FindBy(xpath = "//input[@data-testid='field_buffer_capacity']")
  public TextBox fieldBufferCapacity;

  @FindBy(xpath = "//input[@data-testid='field_maximum_parcel_stay']")
  public TextBox fieldMaximumParcelStay;


  @FindBy(xpath = "//div[@data-testid='field_pudo_point_type']")
  public PageElement fieldPudoPointType;

  @FindBy(xpath = "//div[@data-testid='option_pudo_point_type']/div[text()='Ninja Box']")
  public PageElement ninjaBoxPudoPointType;

  @FindBy(xpath = "//div[@data-testid='option_pudo_point_type']/div[text()='Ninja Point']")
  public PageElement ninjaPointPudoPointType;

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

  @FindBy(xpath = "//input[@value='RETAIL_POINT_NETWORK']")
  public PageElement checkBoxRetailPointNetwork;

  @FindBy(xpath = "//*[@value='RETAIL_POINT_NETWORK'][not(@disabled)]")
  public Button buttonRetailPointNetwork;

  @FindBy(xpath = "//*[@data-testid='checkbox_service_offered_post'][not(@enabled)]")
  public Button checkBoxServiceOfferedPostDisabled;

  @FindBy(xpath = "//*[@value='FRANCHISEE'][not(@enabled)]")
  public Button checkBoxFranchiseeDisabled;

  @FindBy(xpath = "//input[@data-testid='checkbox_publicly_point_displayed']")
  public PageElement checkBoxPublicityPointDisplayed;

  @FindBy(xpath = "//input[@data-testid='checkbox_hyperlocal']")
  public PageElement checkBoxHyperLocal;

  @FindBy(xpath = "//input[@data-testid='checkbox_auto_reservation_enabled']")
  public PageElement checkBoxAutoReservationEnabled;

  @FindBy(xpath = "//input[@data-testid='checkbox_active_point']")
  public PageElement checkBoxActivePoint;

  @FindBy(xpath = "//span[contains(@class,'checked')]/input[@data-testid='checkbox_service_offered_return']")
  public Button checkBoxReturnServiceChecked;

  @FindBy(xpath = "//span[contains(@class,'checked')]/input[@data-testid='checkbox_service_offered_send']")
  public Button checkBoxAllowShipperSendChecked;

  @FindBy(xpath = "//span[contains(@class,'checked')]/input[@data-testid='checkbox_service_offered_customer_collect']")
  public Button checkBoxAllowCustomerCollectChecked;

  @FindBy(xpath = "//span[contains(@class,'checked')]/input[@data-testid='checkbox_sell_packs_at_point']")
  public Button checkBoxSellsPackAtPointChecked;

  public static final String ERROR_MSG_NOT_PHONE_NUM = "That doesn't look like a phone number.";
  public static final String ERROR_MSG_NOT_EMAIL_FORMAT = "That doesn't look like an email.";
  public static final String ERROR_MSG_DUPLICATE_USERNAME = "Username '%s' not available, please specify another username";
  public static final String ERROR_MSG_FIELD_REQUIRED = "This field is required";
  public static final String ERROR_MSG_FIELD_WRONG_FORMAT = "Invalid field. Please use only alphabets, characters, numbers (0-9), periods (.), hyphens (-), underscores (_) and spaces ( )";

  public static final String ERROR_MSG_ALERT_XPATH = "//div[@role='alert'][text()='%s']";
  public static final String CHOOSE_SHIPPER_ACCOUNT_XPATH = "//div[@data-testid='option_shipper_account_no']/div[contains(text(),'%s')]";
  public static final String CHOOSE_ASSIGNED_HUB_XPATH = "//div[@data-testid='option_assigned_hub']/div[text()='%s']";

  public static final String RETAIL_POINT_NETWORK_ENABLED = "RETAIL_POINT_NETWORK_ENABLED";
  public static final String FRANCHISEE_DISABLED = "FRANCHISEE_DISABLED";
  public static final String SEND_CHECK = "SEND_CHECK";
  public static final String PACK_CHECK = "PACK_CHECK";
  public static final String RETURN_CHECK = "RETURN_CHECK";
  public static final String CUSTOMER_COLLECT_CHECK = "CUSTOMER_COLLECT_CHECK";
  public static final String SELL_PACK_AT_POINT_CHECK = "SELL_PACK_AT_POINT_CHECK";
  public static final String POST_DISABLED = "POST_DISABLED";

  public static final String POINT_NAME = "Point Name";
  public static final String SHORT_NAME = "Short Name";
  public static final String CONTACT_NUMBER = "Contact Number";
  public static final String POSTCODE = "Postcode";
  public static final String CITY = "City";
  public static final String POINT_ADDRESS_1 = "Point Address 1";
  public static final String FLOOR_NO = "Floor No";
  public static final String UNIT_NO = "Unit No";
  public static final String LATITUDE = "Latitude";
  public static final String LONGITUDE = "Longitude";
  public static final String PUDO_POINT_TYPE = "Pudo Point Type";
  public static final String SERVICE_TYPE = "Service Type";
  public static final String MAXIMUM_PARCEL_CAPACITY = "Maximum Parcel Capacity";
  public static final String BUFFER_CAPACITY = "Buffer Capacity";
  public static final String EXTERNAL_STORE_ID = "External Store Id";
  public static final String MAXIMUM_PARCEL_STAY = "Maximum Parcel Stay";


  public ImmutableMap<String, String> errorMandatoryField = ImmutableMap.<String, String>builder()
      .put(POINT_NAME, "Name is required")
      .put(SHORT_NAME, "Short Name is required")
      .put(CONTACT_NUMBER, "Contact Number is required")
      .put(POSTCODE, "Postal Code is required")
      .put(CITY, "City is required")
      .put(POINT_ADDRESS_1, "Address is required")
      .put(FLOOR_NO, "Floor No. is required")
      .put(UNIT_NO, "Unit No. is required")
      .put(LATITUDE, "Latitude is required")
      .put(LONGITUDE, "Longitude is required")
      .put(PUDO_POINT_TYPE, "type is required")
      .put(SERVICE_TYPE, "Service Type is required")
      .put(MAXIMUM_PARCEL_CAPACITY, "Actual Max Capacity is required")
      .put(BUFFER_CAPACITY, "Buffer Capacity is required")
      .build();

  public ImmutableMap<String, String> errorField = ImmutableMap.<String, String>builder()
      .put(POINT_NAME, "Invalid field. Please use only alphabets, characters, numbers (0-9), periods (.), hyphens (-), underscores (_) and spaces ( )")
      .put(SHORT_NAME, "Invalid field. Please use only alphabets, characters, numbers (0-9), periods (.), hyphens (-), underscores (_) and spaces ( )")
      .put(CITY, "Invalid field. Please use only alphabets, characters, numbers (0-9), periods (.), hyphens (-), underscores (_) and spaces ( )")
      .put(EXTERNAL_STORE_ID, "Invalid field. Please use only alphabets, characters, numbers (0-9), periods (.), hyphens (-), underscores (_) and spaces ( )")
      .put(POSTCODE, "Please enter a valid number.")
      .put(FLOOR_NO, "Please enter a valid number.")
      .put(UNIT_NO, "Please enter a valid number.")
      .put(LATITUDE, "please enter valid number.")
      .put(LONGITUDE, "please enter valid number.")
      .put(MAXIMUM_PARCEL_CAPACITY, "Please enter a valid number.")
      .put(BUFFER_CAPACITY, "Please enter a valid number.")
      .put(MAXIMUM_PARCEL_STAY, "Please enter a valid number.")
      .build();


  public ImmutableMap<String, Button> checkBoxValidationCheck = ImmutableMap.<String, Button>builder()
      .put(RETAIL_POINT_NETWORK_ENABLED, buttonRetailPointNetwork)
      .put(FRANCHISEE_DISABLED, checkBoxFranchiseeDisabled)
      .put(SEND_CHECK, checkBoxAllowShipperSendChecked)
      .put(PACK_CHECK, checkBoxSellsPackAtPointChecked)
      .put(RETURN_CHECK, checkBoxReturnServiceChecked)
      .put(POST_DISABLED, checkBoxServiceOfferedPostDisabled)
      .put(CUSTOMER_COLLECT_CHECK, checkBoxAllowCustomerCollectChecked)
      .put(SELL_PACK_AT_POINT_CHECK, checkBoxSellsPackAtPointChecked)
      .build();

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

  public void mandatoryFieldError(String field) {
    Assertions.assertThat(isElementExist(f(ERROR_MSG_ALERT_XPATH, errorMandatoryField.get(field))))
        .as(String.format("Error message from %s is exist: %s", field, errorMandatoryField.get(field)))
        .isTrue();
  }

  public void fieldErrorMsg(String field) {
    Assertions.assertThat(isElementExist(f(ERROR_MSG_ALERT_XPATH, errorField.get(field))))
        .as(String.format("Error message from %s is exist: %s", field, errorField.get(field)))
        .isTrue();
  }

  public void chooseShipperAccountDp(Long shipperId) {
    waitUntilVisibilityOfElementLocated(f(CHOOSE_SHIPPER_ACCOUNT_XPATH,shipperId));
    click(f(CHOOSE_SHIPPER_ACCOUNT_XPATH,shipperId));
  }

  public void chooseShipperAssignedHub(String hubName) {
    waitUntilVisibilityOfElementLocated(f(CHOOSE_ASSIGNED_HUB_XPATH,hubName));
    click(f(CHOOSE_ASSIGNED_HUB_XPATH,hubName));
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

  public void errorCheckDpUser(String value, String errorKey) {
    switch (errorKey) {
      case "!USFIRNME":
        formDpUserFirstName.forceClear();
        formDpUserFirstName.setValue(value);
        break;
      case "!USLANME":
        formDpUserLastName.forceClear();
        formDpUserLastName.setValue(value);
        break;
      case "!USEMAIL":
        formDpUserEmail.forceClear();
        formDpUserEmail.setValue(value);
        break;

    }
  }


  public void errorCheckDpPartner(Partner dpPartner, String errorKey) {
    switch (errorKey) {
      case "NAME":
        formPartnerName.forceClear();
        formPartnerName.setValue(dpPartner.getName());
        formPartnerName.forceClear();
        break;
      case "!NAME":
        formPartnerName.forceClear();
        formPartnerName.setValue(dpPartner.getName());
        Assertions.assertThat(errorMsg.getText())
            .as(f("Error Message Exist after fill Form Partner Name with wrong format : %s",
                ERROR_MSG_FIELD_WRONG_FORMAT))
            .isEqualTo(ERROR_MSG_FIELD_WRONG_FORMAT);
        break;
      case "POCNME":
        formPocName.forceClear();
        formPocName.setValue(dpPartner.getPocName());
        formPocName.forceClear();
        break;
      case "!POCNME":
        formPocName.forceClear();
        formPocName.setValue(dpPartner.getPocName());
        Assertions.assertThat(errorMsg.getText())
            .as(f("Error Message Exist after fill Form POC Name with wrong format : %s",
                ERROR_MSG_FIELD_WRONG_FORMAT))
            .isEqualTo(ERROR_MSG_FIELD_WRONG_FORMAT);
        break;
      case "!POCNUM":
        formPocNo.forceClear();
        formPocNo.setValue(dpPartner.getPocTel());
        Assertions.assertThat(errorMsg.getText())
            .as(f("Error Message Exist after fill Form POC NO with wrong format (Not Number) : %s",
                ERROR_MSG_NOT_PHONE_NUM))
            .isEqualTo(ERROR_MSG_NOT_PHONE_NUM);
        break;
      case "POCNUM":
        formPocNo.forceClear();
        formPocNo.setValue(dpPartner.getPocTel());
        formPocNo.forceClear();
        break;
      case "RESTRICTION":
        formRestrictions.forceClear();
        formRestrictions.setValue(dpPartner.getRestrictions());
        formRestrictions.forceClear();
        break;
      case "!RESTRICTION":
        formRestrictions.forceClear();
        formRestrictions.setValue(dpPartner.getRestrictions());
        Assertions.assertThat(errorMsg.getText())
            .as(f("Error Message Exist after fill Form Restrictions with wrong format : %s",
                ERROR_MSG_FIELD_WRONG_FORMAT))
            .isEqualTo(ERROR_MSG_FIELD_WRONG_FORMAT);
        break;
      case "POCMAIL":
        formPocEmail.forceClear();
        formPocEmail.setValue(dpPartner.getPocEmail());
        Assertions.assertThat(errorMsg.getText())
            .as(f("Error Message Exist after fill Form POC Email with wrong format (Letters): %s",
                ERROR_MSG_NOT_EMAIL_FORMAT))
            .isEqualTo(ERROR_MSG_NOT_EMAIL_FORMAT);
        break;
    }
  }

  public void clearDpPartnerForm(String errorKey) {
    switch (errorKey) {
      case "NAME":
      case "!NAME":
        formPartnerName.forceClear();
        break;
      case "POCNME":
      case "!POCNME":
        formPocName.forceClear();
        break;
      case "!POCNUM":
      case "POCNUM":
        formPocNo.forceClear();
        break;
      case "RESTRICTION":
      case "!RESTRICTION":
        formRestrictions.forceClear();
        break;
      case "POCMAIL":
        formPocEmail.forceClear();
        break;
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
