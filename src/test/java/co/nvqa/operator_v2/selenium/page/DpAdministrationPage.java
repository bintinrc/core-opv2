package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.dp.DpDetailsResponse;
import co.nvqa.commons.util.StandardTestConstants;
import co.nvqa.operator_v2.model.Dp;
import co.nvqa.operator_v2.model.DpPartner;
import co.nvqa.operator_v2.model.DpUser;
import com.google.common.collect.ImmutableMap;
import java.io.File;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static org.hamcrest.Matchers.greaterThanOrEqualTo;

/**
 * @author Sergey Mishanin
 */
@SuppressWarnings("WeakerAccess")
public class DpAdministrationPage extends OperatorV2SimplePage {

  private static final Logger LOGGER = LoggerFactory.getLogger(DpAdministrationPage.class);

  public static final String LOCATOR_SPINNER = "//md-progress-circular";
  private static final String CSV_FILENAME_PATTERN = "data-dp-users";
  private static final String CSV_DPS_FILENAME_PATTERN = "data-dps";
  private static final String CSV_DP_USERS_FILENAME_PATTERN = "data-dp-users";
  private static final String LOCATOR_BUTTON_ADD_PARTNER = "container.dp-administration.dp-partners.add-title";
  private static final String LOCATOR_BUTTON_ADD_DP = "container.dp-administration.dps.add-title";
  private static final String LOCATOR_BUTTON_ADD_DP_USER = "container.dp-administration.dp-users.add-title";
  private static final String LOCATOR_BUTTON_DOWNLOAD_CSV_FILE = "commons.download-csv";
  private static final String XPATH_PUDO_POINT_IFRAME = "//iframe[contains(@src,'pudo-point-form')]";
  private static final String XPATH_SAVE_SETTINGS = "//span[text()='Save Settings']/parent::button";
  private static final String XPATH_RETURN_TO_LIST = "//span[text()='Return to List']/parent::button";
  private static final String XPATH_POINT_NAME = "//input[@id='name']";
  private static final String XPATH_SHORT_NAME = "//input[@id='shortName']";
  private static final String XPATH_CONTACT_NUMBER = "//input[@id='contact']";
  private static final String XPATH_EXTERNAL_STORE_ID = "//input[@id='externalStoreId']";
  private static final String XPATH_SHIPPER_ACCOUNT_ID = "//div[@id='shipperId']";
  private static final String XPATH_INPUT_SHIPPER_ID = "//input[@id='shipperId']";
  private static final String XPATH_POSTAL_CODE = "//input[@id='postalCode']";
  private static final String XPATH_CITY = "//input[@id='city']";
  private static final String XPATH_HUB_ID = "//div[@id='hubId']";
  private static final String XPATH_INPUT_HUB_ID = "//input[@id='hubId']";
  private static final String XPATH_POINT_ADDRESS_1 = "//input[@id='address1']";
  private static final String XPATH_POINT_ADDRESS_2 = "//input[@id='address2']";
  private static final String XPATH_FLOOR_NUMBER = "//input[@id='floorNumber']";
  private static final String XPATH_UNIT_NUMBER = "//input[@id='unitNumber']";
  private static final String XPATH_LATITUDE = "//input[@id='latitude']";
  private static final String XPATH_LONGITUDE = "//input[@id='longitude']";
  private static final String XPATH_TYPE = "//div[@id='type']";
  private static final String XPATH_TYPE_OPTION = "//li[text()='%s']";
  private static final String XPATH_DIRECTIONS = "//input[@id='directions']";
  private static final String XPATH_ACTIVE_CHECKBOX = "//input[@id='isActive']";
  private static final String XPATH_PUBLIC_CHECKBOX = "//input[@id='isPublic']";
  private static final String XPATH_AUTO_RESERVATION_ENABLED = "//input[@id='autoReservationEnabled']";
  private static final String XPATH_SEND_CHECKBOX = "//input[@id='isSend']";
  private static final String XPATH_RETAIL_POINT_NETWORK = "//input[@value='RETAIL_POINT_NETWORK']";
  private static final String XPATH_COLLECT_CHECKBOX = "//input[@id='isCollect']";
  private static final String XPATH_MAXIMUM_CAPACITY = "//input[@id='actualMaxCapacity']";
  private static final String XPATH_INPUT_CUTOFF_TIME = "//input[contains(@class,'time-picker-panel-input')]";
  private static final String XPATH_CUTOFF_TIME = "//input[@id='deliveryTime']";
  private static final String XPATH_BUFFER_CAPACITY = "//input[@id='computedMaxCapacity']";
  private static final String XPATH_MAXIMUM_PARCEL_STAY = "//input[@id='maxParcelStayDuration']";
  private static final String XPATH_APPLY_ALL_DAYS = "(//span[text()='Apply first day slots to all days'])[%s]";
  private static final String XPATH_APPLY_ALL_DAYS_OPENING_HOURS = "//input[@id='all-days-reservation-slots']";
  private static final String XPATH_APPLY_ALL_DAYS_RESERVATION = "//input[@id='all-days-official-operating-hours']";
  private static final String XPATH_OFFICIAL_FROM_HOURS = "//div[@id='reservationSlots.allWeek.startHour']";
  private static final String XPATH_OFFICIAL_FROM_MINUTES = "//div[@id='reservationSlots.allWeek.startMinute']";
  private static final String XPATH_OFFICIAL_TO_HOURS = "//div[@id='reservationSlots.allWeek.endHour']";
  private static final String XPATH_OFFICIAL_TO_MINUTES = "//div[@id='reservationSlots.allWeek.endMinute']";
  private static final String XPATH_OPERATING_FROM_HOURS = "//div[@id='operatingHours.allWeek.startHour']";
  private static final String XPATH_OPERATING_FROM_MINUTES = "//div[@id='operatingHours.allWeek.startMinute']";
  private static final String XPATH_OPERATING_TO_HOURS = "//div[@id='operatingHours.allWeek.endHour']";
  private static final String XPATH_OPERATING_TO_MINUTES = "//div[@id='operatingHours.allWeek.endMinute']";
  private static final String XPATH_SELECT_TIME = "//div[contains(@class,'select-dropdown')]/../div[not(contains(@class,'hidden'))]//li[text()='%s']";
  private static final String XPATH_CONTENT_ERROR_MESSAGE_DP_CREATION = "//div[@class='ant-modal-confirm-content']";

  private static final String XPATH_UPLOAD_DP_IMAGE = "//input[@type='file']";
  private static final String XPATH_DELETE_DP_IMAGE = "//i[@title='Remove file']";
  private static final String XPATH_DELETE_PHOTO = "//span[text()='Delete Photo']/parent::button";
  private static final String XPATH_UPLOAD_INVALID_DP_IMAGE_ERROR_MESSAGE = "//div[contains(@class,'ant-message-error')]//span";
  private static final String XPATH_RESET_PASSWORD_BUTTON = "//button[@aria-label='Reset Password']";
  private static final String XPATH_INPUT_NEW_PASSWORD = "//input[@aria-label='New Password']";
  private static final String XPATH_CONFIRM_NEW_PASSWORD = "//input[@aria-label='Confirm New Password']";
  private static final String XPATH_SAVE_PASSWORD = "//button[@aria-label='Save Button']";
  private static final String XPATH_BACK_TO_USER_EDIT = "//button[@aria-label='Back to User Edit']";
  private static final String XPATH_SUCCESS_PASSWORD_MESSAGE = "//div[contains(text(),'New Password Saved')]";
  private static final String XPATH_ERROR_MISMATCH_PASSWORD_MESSAGE = "//div[contains(@class,'password-match')]";

  private static final String XPATH_LOGIN_BUTTON_NINJA_POINT = "//button[@type='submit']";
  private static final String XPATH_USERNAME_NINJA_POINT = "//input[@id='username']";
  private static final String XPATH_PASSWORD_NINJA_POINT = "//input[@id='password']";
  private static final String XPATH_WELCOME_PAGE_NINJA_POINT = "//span[@data-key='welcome_back']";

  private final AddPartnerDialog addPartnerDialog;
  private final EditPartnerDialog editPartnerDialog;
  private final DpPartnersTable dpPartnersTable;
  private final DpTable dpTable;
  private final AddDpDialog addDpDialog;
  private final EditDpDialog editDpDialog;
  private final AddDpUserDialog addDpUserDialog;
  private final EditDpUserDialog editDpUserDialog;
  private final DpUsersTable dpUsersTable;

  public DpAdministrationPage(WebDriver webDriver) {
    super(webDriver);
    addPartnerDialog = new AddPartnerDialog(webDriver);
    dpPartnersTable = new DpPartnersTable(webDriver);
    editPartnerDialog = new EditPartnerDialog(webDriver);
    addDpDialog = new AddDpDialog(webDriver);
    dpTable = new DpTable(webDriver);
    editDpDialog = new EditDpDialog(webDriver);
    addDpUserDialog = new AddDpUserDialog(webDriver);
    editDpUserDialog = new EditDpUserDialog(webDriver);
    dpUsersTable = new DpUsersTable(webDriver);
  }

  public DpPartnersTable dpPartnersTable() {
    return dpPartnersTable;
  }

  public DpTable dpTable() {
    return dpTable;
  }

  public DpUsersTable dpUsersTable() {
    return dpUsersTable;
  }

  public void clickAddPartnerButton() {
    waitUntilInvisibilityOfElementLocated(LOCATOR_SPINNER);
    clickNvIconTextButtonByName(LOCATOR_BUTTON_ADD_PARTNER);
  }

  public void clickAddDpButton() {
    waitUntilInvisibilityOfElementLocated(LOCATOR_SPINNER);
    clickNvIconTextButtonByName(LOCATOR_BUTTON_ADD_DP);
  }

  public void clickAddDpUserButton() {
    waitUntilInvisibilityOfElementLocated(LOCATOR_SPINNER);
    clickNvIconTextButtonByName(LOCATOR_BUTTON_ADD_DP_USER);
  }

  public void downloadCsvFile() {
    clickNvIconTextButtonByName(LOCATOR_BUTTON_DOWNLOAD_CSV_FILE);
  }

  public void addPartner(DpPartner dpPartner) {
    clickAddPartnerButton();
    addPartnerDialog.fillForm(dpPartner);
  }

  public void editPartner(String dpPartnerName, DpPartner newDpPartnerParams) {
    dpPartnersTable.filterByColumn("name", dpPartnerName);
    dpPartnersTable.clickActionButton(1, "edit");
    editPartnerDialog.fillForm(newDpPartnerParams);
  }

  public void addDistributionPoint(String dpPartnerName, Dp dpParams, File file) {
    openViewDpsScreen(dpPartnerName);
    clickAddDpButton();
    fillCreateDpForm(dpParams, file);
  }

  public void setNameCreateDpForm(String name) {
    sendKeys(XPATH_POINT_NAME, name);
  }

  public void setShortNameCreateDpForm(String shortName) {
    sendKeys(XPATH_SHORT_NAME, shortName);
  }

  public void setContactNumberCreateDpForm(String contactNumber) {
    sendKeys(XPATH_CONTACT_NUMBER, contactNumber);
  }

  public void setExternalStoreIdCreateDpForm(String externalStoreId) {
    sendKeys(XPATH_EXTERNAL_STORE_ID, externalStoreId);
  }

  public void setShipperAccountCreateDpForm(String shipperAccount) {
    click(XPATH_SHIPPER_ACCOUNT_ID);
    sendKeysAndEnter(XPATH_INPUT_SHIPPER_ID, shipperAccount);
  }

  public void setPostcodeCreateDpForm(String postcode) {
    sendKeys(XPATH_POSTAL_CODE, postcode);
  }

  public void setCityCreateDpForm(String city) {
    sendKeys(XPATH_CITY, city);
  }

  public void setHubCreateDpForm(String hubId) {
    click(XPATH_HUB_ID);
    sendKeysAndEnter(XPATH_INPUT_HUB_ID, hubId);
  }

  public void setPointAddress1CreateDpForm(String address1) {
    sendKeys(XPATH_POINT_ADDRESS_1, address1);
  }

  public void setPointAddress2CreateDpForm(String address2) {
    sendKeys(XPATH_POINT_ADDRESS_2, address2);
  }

  public void setFloorNumberCreateDpForm(String floorNumber) {
    sendKeys(XPATH_FLOOR_NUMBER, floorNumber);
  }

  public void setUnitNumberCreateDpForm(String unitNumber) {
    sendKeys(XPATH_UNIT_NUMBER, unitNumber);
  }

  public void setLatitudeCreateDpForm(Double latitude) {
    String latitudeAsString = latitude.toString();
    sendKeys(XPATH_LATITUDE, latitudeAsString);
  }

  public void setLongitudeCreateDpForm(Double longitude) {
    String longitudeAsString = longitude.toString();
    sendKeys(XPATH_LONGITUDE, longitudeAsString);
  }

  public void setTypeCreateDpForm(String type) {
    click(XPATH_TYPE);
    clickf(XPATH_TYPE_OPTION, type);
  }

  public void setDirectionsCreateDpForm(String directions) {
    sendKeys(XPATH_DIRECTIONS, directions);
  }

  public void isActiveCreateDpForm() {
    click(XPATH_ACTIVE_CHECKBOX);
  }

  public void isPublicCreateDpForm() {
    click(XPATH_PUBLIC_CHECKBOX);
  }

  public void clickIsAutoReservation() {
    moveToElementWithXpath(XPATH_AUTO_RESERVATION_ENABLED);
    click(XPATH_AUTO_RESERVATION_ENABLED);
  }

  public void canShipperLodgeInCreateDpForm(Boolean canShipperLodgeIn) {
    if (canShipperLodgeIn) {
      click(XPATH_SEND_CHECKBOX);
    }
  }

  public void canCustomerCollectAndSetCapacityCreateDpForm(Boolean canCustomerCollect,
      String maxCapacity, String bufferCapacity, Long maxParcelStay) {
    if (canCustomerCollect) {
      click(XPATH_COLLECT_CHECKBOX);
      setCapacityAndParcelStayCreateDpForm(maxCapacity, bufferCapacity, maxParcelStay);
    }
  }

  public void setCapacityAndParcelStayCreateDpForm(String maxCapacity, String bufferCapacity,
      Long maxParcelStay) {
    final String maxParcelStayAsString = maxParcelStay.toString();
    sendKeys(XPATH_MAXIMUM_CAPACITY, maxCapacity);
    sendKeys(XPATH_BUFFER_CAPACITY, bufferCapacity);
    sendKeys(XPATH_MAXIMUM_PARCEL_STAY, maxParcelStayAsString);
  }

  public void setCutOffTime(String time) {
    click(XPATH_CUTOFF_TIME);
    waitUntilVisibilityOfElementLocated(XPATH_INPUT_CUTOFF_TIME);
    sendKeys(XPATH_INPUT_CUTOFF_TIME, time);
  }

  public void setOfficialTimingCreateDpForm() {
    click(XPATH_APPLY_ALL_DAYS_OPENING_HOURS);
    click(XPATH_OFFICIAL_FROM_HOURS);
    clickf(XPATH_SELECT_TIME, "10");
    click(XPATH_OFFICIAL_FROM_MINUTES);
    clickf(XPATH_SELECT_TIME, "00");
    click(XPATH_OFFICIAL_TO_HOURS);
    clickf(XPATH_SELECT_TIME, "20");
    click(XPATH_OFFICIAL_TO_MINUTES);
    clickf(XPATH_SELECT_TIME, "00");
  }

  public void setOperatingTimingCreateDpForm() {
    click(XPATH_APPLY_ALL_DAYS_RESERVATION);
    click(XPATH_OPERATING_FROM_HOURS);
    clickf(XPATH_SELECT_TIME, "10");
    click(XPATH_OPERATING_FROM_MINUTES);
    clickf(XPATH_SELECT_TIME, "00");
    click(XPATH_OPERATING_TO_HOURS);
    clickf(XPATH_SELECT_TIME, "20");
    click(XPATH_OPERATING_TO_MINUTES);
    clickf(XPATH_SELECT_TIME, "00");
  }

  public void clickSaveSettingsCreateDpForm() {
    click(XPATH_SAVE_SETTINGS);
  }

  public void clickReturnToList() {
    click(XPATH_RETURN_TO_LIST);
  }

  public void fillCreateDpForm(Dp dpParams, File file) {
    final WebElement frame = findElementByXpath(XPATH_PUDO_POINT_IFRAME);
    getWebDriver().switchTo().frame(frame);
    waitUntilVisibilityOfElementLocated(XPATH_POINT_NAME);

    setNameCreateDpForm(dpParams.getName());
    setShortNameCreateDpForm(dpParams.getShortName());
    setContactNumberCreateDpForm(dpParams.getContactNo());
    setExternalStoreIdCreateDpForm(dpParams.getExternalStoreId());
    setShipperAccountCreateDpForm(dpParams.getShipperId());
    setPostcodeCreateDpForm(dpParams.getPostcode());
    setCityCreateDpForm(dpParams.getCity());
    setHubCreateDpForm(dpParams.getHub());
    setPointAddress1CreateDpForm(dpParams.getAddress1());
    setPointAddress2CreateDpForm(dpParams.getAddress2());
    setFloorNumberCreateDpForm(dpParams.getFloorNo());
    setUnitNumberCreateDpForm(dpParams.getUnitNo());
    setLatitudeCreateDpForm(dpParams.getLatitude());
    setLongitudeCreateDpForm(dpParams.getLongitude());
    setTypeCreateDpForm(dpParams.getType());
    setDirectionsCreateDpForm(dpParams.getDirections());
    setRetailPointNetwork();
    if (file != null) {
      uploadDpPhoto(file);
      if (file.getName().toLowerCase().contains("invalid")) {
        assertInvalidImageErrorMessage();
      }
    }
    isActiveCreateDpForm();
    isPublicCreateDpForm();
    if (dpParams.getIsAutoReservation() != null) {
      if (dpParams.getIsAutoReservation()) {
        clickIsAutoReservation();
      }
    }
    setCapacityAndParcelStayCreateDpForm(dpParams.getMaxCap(), dpParams.getCapBuffer(),
        dpParams.getMaxParcelStayDuration());
    if (dpParams.getCutOffTime() != null) {
      setCutOffTime(dpParams.getCutOffTime());
    }
    clickSaveSettingsCreateDpForm();
    getWebDriver().switchTo().defaultContent();
  }

  public void assertInvalidImageErrorMessage() {
    Assertions.assertThat(getErrorMessageForUploadInvalidDpImage().toLowerCase())
        .as("Error Message is displayed correctly")
        .isEqualToIgnoringCase("Unable to upload photo as it exceeds 2MB limit");
  }

  public String getErrorMessageForUploadInvalidDpImage() {
    waitUntilVisibilityOfElementLocated(XPATH_UPLOAD_INVALID_DP_IMAGE_ERROR_MESSAGE);
    return getText(XPATH_UPLOAD_INVALID_DP_IMAGE_ERROR_MESSAGE);
  }

  public void uploadDpPhoto(File file) {
    sendKeysWithoutClear(XPATH_UPLOAD_DP_IMAGE, file.getPath());
  }

  public void setRetailPointNetwork() {
    click(XPATH_RETAIL_POINT_NETWORK);
  }

  public void openViewDpsScreen(String dpPartnerName) {
    dpPartnersTable.filterByColumn("name", dpPartnerName);
    dpPartnersTable.clickActionButton(1, "View DPs");
  }

  public void openViewUsersScreen(String dpName) {
    dpTable.filterByColumn("name", dpName);
    dpTable.clickActionButton(1, "View DPs");
  }

  public void addDpUser(String dpName, DpUser dpUserParams) {
    openViewUsersScreen(dpName);
    clickAddDpUserButton();
    addDpUserDialog.fillForm(dpUserParams);
  }

  public void editDpUser(String username, DpUser newDpuserParams) {
    dpUsersTable.filterByColumn(DpUsersTable.COLUMN_USERNAME, username);
    dpUsersTable.clickActionButton(1, DpUsersTable.ACTION_EDIT);
    editDpUserDialog.fillForm(newDpuserParams);
  }

  public void editDistributionPoint(String dpName, Dp newDpParams) {
    dpTable.filterByColumn("name", dpName);
    dpTable.clickActionButton(1, "edit");
    fillEditDpForm(newDpParams);
  }

  public void fillEditDpForm(Dp dpParams) {
    final WebElement frame = findElementByXpath(XPATH_PUDO_POINT_IFRAME);
    getWebDriver().switchTo().frame(frame);
    waitUntilVisibilityOfElementLocated(XPATH_POINT_NAME);
    if (dpParams.getExternalStoreId() != null) {
      if ("".equalsIgnoreCase(dpParams.getExternalStoreId())) {
        setExternalStoreIdCreateDpForm(" ");
      } else {
        setExternalStoreIdCreateDpForm(dpParams.getExternalStoreId());
      }
    }
    setContactNumberCreateDpForm(dpParams.getContactNo());
    setPostcodeCreateDpForm(dpParams.getPostcode());
    setPointAddress1CreateDpForm(dpParams.getAddress1());
    setPointAddress2CreateDpForm(dpParams.getAddress2());
    setFloorNumberCreateDpForm(dpParams.getFloorNo());
    setUnitNumberCreateDpForm(dpParams.getUnitNo());
    setTypeCreateDpForm(dpParams.getType());
    setDirectionsCreateDpForm(dpParams.getDirections());
    canShipperLodgeInCreateDpForm(dpParams.getCanShipperLodgeIn());
    if (dpParams.getIsAutoReservation() != null) {
      final boolean value = Boolean.parseBoolean(getValue(XPATH_AUTO_RESERVATION_ENABLED));
      if (!dpParams.getIsAutoReservation() && value) {
        clickIsAutoReservation();
      }
    }
    //assert PUDO Type is disabled while Editing
    Assertions.assertThat(isElementEnabled(XPATH_RETAIL_POINT_NETWORK)).as("PUDO Type is disabled")
        .isFalse();
    if (dpParams.getCutOffTime() != null) {
      setCutOffTime(dpParams.getCutOffTime());
    }
    clickSaveSettingsCreateDpForm();
    getWebDriver().switchTo().defaultContent();
  }

  public void verifyDpPartnerParams(DpPartner expectedDpPartnerParams) {
    dpPartnersTable.filterByColumn("name", expectedDpPartnerParams.getName());
    DpPartner actualDpPartner = dpPartnersTable.readEntity(1);
    assertThatIfExpectedValueNotNull("DP Partner ID is correct", expectedDpPartnerParams.getId(),
        actualDpPartner.getId(), equalTo(expectedDpPartnerParams.getId()));
    assertThatIfExpectedValueNotNull("DP Partner name is correct", expectedDpPartnerParams.getName(),
        actualDpPartner.getName(), equalTo(expectedDpPartnerParams.getName()));
    assertThatIfExpectedValueNotNull("DP Partner POC name is correct", expectedDpPartnerParams.getPocName(),
        actualDpPartner.getPocName(), equalTo(expectedDpPartnerParams.getPocName()));
    assertThatIfExpectedValueNotNull("DP Partner POC No. is correct", expectedDpPartnerParams.getPocTel(),
        actualDpPartner.getPocTel(), equalTo(expectedDpPartnerParams.getPocTel()));
    assertThatIfExpectedValueNotNull("DP Partner POC email is correct", expectedDpPartnerParams.getPocEmail(),
        actualDpPartner.getPocEmail(), equalTo(expectedDpPartnerParams.getPocEmail()));
    assertThatIfExpectedValueNotNull("DP Partner POC restrictions is correct",
        expectedDpPartnerParams.getRestrictions(), actualDpPartner.getRestrictions(),
        equalTo(expectedDpPartnerParams.getRestrictions()));
    expectedDpPartnerParams.setId(actualDpPartner.getId());
  }

  public void verifyDpParams(Dp expectedDpParams) {
    pause5s();
    dpTable.filterByColumn("name", expectedDpParams.getName());
    final Dp actualDpParams = dpTable.readEntity(1);
    Assertions.assertThat(actualDpParams.getId()).as("DP ID is not null").isNotNull();
    Assertions.assertThat(actualDpParams.getName()).as("DP name is the same")
        .isEqualToIgnoringCase(expectedDpParams.getName());

    if (Objects.nonNull(expectedDpParams.getShortName())) {
      Assertions.assertThat(actualDpParams.getShortName()).as("DP Short Name is the same")
          .containsIgnoringCase(expectedDpParams.getShortName());
    }

    if (Objects.nonNull(expectedDpParams.getHub())) {
      Assertions.assertThat(actualDpParams.getHub()).as("DP Hub is the same")
          .containsIgnoringCase(expectedDpParams.getHub());
    }

    if (Objects.nonNull(expectedDpParams.getDirections())) {
      Assertions.assertThat(actualDpParams.getDirections()).as("DP Directions is the same")
          .containsIgnoringCase(expectedDpParams.getDirections());
    }

    if (Objects.nonNull(expectedDpParams.getActivity())) {
      Assertions.assertThat(actualDpParams.getActivity()).as("DP Activity is the same")
          .containsIgnoringCase(expectedDpParams.getActivity());
    }

    expectedDpParams.setId(actualDpParams.getId());
  }

  public void verifyDpUserParams(DpUser expectedDpUserParams) {
    pause5s();
    dpUsersTable.filterByColumn(DpUsersTable.COLUMN_USERNAME, expectedDpUserParams.getClientId());
    final DpUser actualDpUserParams = dpUsersTable.readEntity(1);

    Assertions.assertThat(actualDpUserParams.getClientId()).as("DP user username is the same")
        .containsIgnoringCase(expectedDpUserParams.getClientId());
    Assertions.assertThat(actualDpUserParams.getFirstName()).as("DP user first name is the same")
        .containsIgnoringCase(expectedDpUserParams.getFirstName());
    Assertions.assertThat(actualDpUserParams.getLastName()).as("DP user last name is the same")
        .containsIgnoringCase(expectedDpUserParams.getLastName());
    Assertions.assertThat(actualDpUserParams.getEmailId()).as("DP user email is the same")
        .containsIgnoringCase(expectedDpUserParams.getEmailId());
    Assertions.assertThat(actualDpUserParams.getContactNo()).as("DP user contact no is the same")
        .containsIgnoringCase(expectedDpUserParams.getContactNo());
  }

  public void verifyDownloadedFileContent(List<DpPartner> expectedDpPartners) {
    final String fileName = getLatestDownloadedFilename(CSV_FILENAME_PATTERN);
    verifyFileDownloadedSuccessfully(fileName);
    final String pathName = StandardTestConstants.TEMP_DIR + fileName;
    final List<DpPartner> actualDpPartners = DpPartner.fromCsvFile(DpPartner.class, pathName, true);

    Assertions.assertThat(actualDpPartners).as("Unexpected number of lines in CSV file")
        .hasSizeGreaterThanOrEqualTo(expectedDpPartners.size());

    final Map<Long, DpPartner> actualMap = actualDpPartners.stream().collect(Collectors.toMap(
        DpPartner::getId,
        params -> params,
        (params1, params2) -> params1
    ));

    for (DpPartner expectedDpPartner : expectedDpPartners) {
      DpPartner actualDpPartner = actualMap.get(expectedDpPartner.getId());
      Assertions.assertThat(actualDpPartner.getId()).as("DP ID is null").isNotNull();
      Assertions.assertThat(actualDpPartner.getName()).as("DP Partner Name is correct")
          .isEqualTo(expectedDpPartner.getName());
      Assertions.assertThat(actualDpPartner.getPocName()).as("POC Name")
          .isEqualTo(expectedDpPartner.getPocName());
      Assertions.assertThat(actualDpPartner.getPocTel()).as("POC No. is correct")
          .isEqualTo(expectedDpPartner.getPocTel());
      assertEquals("POC Email is correct", Optional.ofNullable(expectedDpPartner.getPocEmail()).orElse("-"),
          actualDpPartner.getPocEmail());
      assertEquals("Restrictions is correct",
          Optional.ofNullable(expectedDpPartner.getRestrictions()).orElse("-"),
          actualDpPartner.getRestrictions());
    }
  }

  public void verifyDownloadedDpFileContent(List<Dp> expectedDpParams) {
    String fileName = getLatestDownloadedFilename(CSV_DPS_FILENAME_PATTERN);
    verifyFileDownloadedSuccessfully(fileName);
    String pathName = StandardTestConstants.TEMP_DIR + fileName;
    List<Dp> actualDpParams = Dp.fromCsvFile(Dp.class, pathName, true);

    Assertions.assertThat(actualDpParams)
        .as(f("Number of lines in CSV file is equal or greater than %d", expectedDpParams.size()))
        .hasSizeGreaterThanOrEqualTo(expectedDpParams.size());

    final Map<Long, Dp> actualMap = actualDpParams.stream().collect(Collectors.toMap(
        Dp::getId,
        params -> params,
        (params1, params2) -> params1
    ));

    for (Dp expectedDp : expectedDpParams) {
      final Dp actualDp = actualMap.get(expectedDp.getId());

      Assertions.assertThat(actualDp.getId()).as("DP ID is correct").isEqualTo(expectedDp.getId());
      Assertions.assertThat(actualDp.getName()).as("DP Name is correct")
          .isEqualTo(expectedDp.getName());

      if (Objects.nonNull(expectedDp.getShortName())) {
        Assertions.assertThat(actualDp.getShortName()).as("DP Short Name is the same")
            .containsIgnoringCase(expectedDp.getShortName());
      }

      if (Objects.nonNull(expectedDp.getHub())) {
        Assertions.assertThat(actualDp.getHub()).as("DP hub is correct")
            .isEqualToIgnoringCase(Optional.ofNullable(expectedDp.getHub()).orElse(""));
      }

      if (Objects.nonNull(expectedDp.getAddress())) {
        Assertions.assertThat(actualDp.getAddress()).as("DP Address is correct")
            .isEqualTo(expectedDp.getAddress());
      }

      if (Objects.nonNull(expectedDp.getDirections())) {
        Assertions.assertThat(actualDp.getDirections()).as("DP Directions is correct")
            .isEqualTo(expectedDp.getDirections());
      }

      if (Objects.nonNull(expectedDp.getActivity())) {
        Assertions.assertThat(actualDp.getActivity()).as("DP Activity is correct")
            .isEqualTo(expectedDp.getActivity());
      }
    }
  }

  public void verifyDownloadedDpUsersFileContent(List<DpUser> expectedDpUsersParams) {
    final String fileName = getLatestDownloadedFilename(CSV_DP_USERS_FILENAME_PATTERN);
    verifyFileDownloadedSuccessfully(fileName);
    final String pathName = StandardTestConstants.TEMP_DIR + fileName;
    final List<DpUser> actualDpUsersParams = DpUser.fromCsvFile(DpUser.class, pathName, true);

    assertThat("Unexpected number of lines in CSV file", actualDpUsersParams.size(),
        greaterThanOrEqualTo(expectedDpUsersParams.size()));

    Map<String, DpUser> actualMap = actualDpUsersParams.stream().collect(Collectors.toMap(
        DpUser::getClientId,
        params -> params
    ));

    for (DpUser expectedDpUserParams : expectedDpUsersParams) {
      DpUser actualDpUser = actualMap.get(expectedDpUserParams.getClientId());

      Assertions.assertThat(actualDpUser.getClientId())
          .as(f("DP username is %s", expectedDpUserParams.getClientId()))
          .isEqualTo(expectedDpUserParams.getClientId());
      Assertions.assertThat(actualDpUser.getFirstName()).as("DP User first name is correct")
          .isEqualTo(expectedDpUserParams.getFirstName());
      Assertions.assertThat(actualDpUser.getLastName()).as("DP User last name is correct")
          .isEqualTo(expectedDpUserParams.getLastName());
      Assertions.assertThat(actualDpUser.getEmailId()).as("DP user email is correct")
          .isEqualTo(expectedDpUserParams.getEmailId());
      Assertions.assertThat(actualDpUser.getContactNo()).as("DP User contact no. is correct")
          .isEqualTo(expectedDpUserParams.getContactNo());
    }
  }

  public void verifyDpParamsWithDB(DpDetailsResponse dbParams, DpDetailsResponse apiParams) {
    Assertions.assertThat(apiParams.getId()).as("DP ID is correct").isEqualTo(dbParams.getId());
    Assertions.assertThat(apiParams.getName()).as("DP name is correct")
        .isEqualTo(dbParams.getName());
    Assertions.assertThat(apiParams.getDpmsId()).as("DPMS ID is correct")
        .isEqualTo(dbParams.getDpmsId());
    Assertions.assertThat(apiParams.getCountry()).as("DP country is correct")
        .isEqualTo(dbParams.getCountry());
    Assertions.assertThat(apiParams.getCity()).as("DP city is correct")
        .isEqualTo(dbParams.getCity());
    Assertions.assertThat(apiParams.getAddress1()).as("DP address 1 is correct")
        .isEqualTo(dbParams.getAddress1());
    Assertions.assertThat(apiParams.getAddress2()).as("DP address 2 is correct")
        .isEqualTo(dbParams.getAddress2());
    Assertions.assertThat(apiParams.getDpServiceType()).as("Service Type is correct")
        .isEqualTo(dbParams.getDpServiceType());
  }

  public void verifyCutOffTime(String expectedCutOffTime, String actualCutOffTime) {
    assertEquals("Cut off time is not correct", expectedCutOffTime, actualCutOffTime);
  }

  public void verifyErrorMessageForDpCreation(String field) {
    if ("".equalsIgnoreCase(field)) {
      Assertions.assertThat(getErrorMessage().toLowerCase()).as("Error Message is correct")
          .containsIgnoringCase("Dp with external_store_id TESTING-NewDP already exists");
      Assertions.assertThat(getErrorMessage().toLowerCase()).as("Error Message is correct")
          .containsIgnoringCase("Dp with short_name TEST-DP already exists");
    } else {
      Assertions.assertThat(getErrorMessage().toLowerCase()).as("Error Message is correct")
          .containsIgnoringCase(f("Dp with %s already exists", field).toLowerCase());
    }
  }

  public String getErrorMessage() {
    waitUntilVisibilityOfElementLocated(XPATH_PUDO_POINT_IFRAME);
    final WebElement frame = findElementByXpath(XPATH_PUDO_POINT_IFRAME);
    getWebDriver().switchTo().frame(frame);
    waitUntilVisibilityOfElementLocated(XPATH_CONTENT_ERROR_MESSAGE_DP_CREATION);
    final String errorMessage = getText(XPATH_CONTENT_ERROR_MESSAGE_DP_CREATION);
    getWebDriver().switchTo().defaultContent();
    return errorMessage;
  }

  public void verifyImageIsPresent(String image, String status) {
    if ("Present".equalsIgnoreCase(status)) {
      Assertions.assertThat(image).as("image is present").containsIgnoringCase("png");
    } else {
      Assertions.assertThat(image).as("image is not present").doesNotContainIgnoringCase("png");
    }
  }

  public void deleteDpImageAndSaveSettings(String currentDpName, String action) {
    dpTable.filterByColumn("name", currentDpName);
    dpTable.clickActionButton(1, "edit");
    final WebElement frame = findElementByXpath(XPATH_PUDO_POINT_IFRAME);
    getWebDriver().switchTo().frame(frame);
    waitUntilVisibilityOfElementLocated(XPATH_POINT_NAME);
    deleteDpImage();
    if ("Save Settings".equalsIgnoreCase(action)) {
      clickSaveSettingsCreateDpForm();
      pause3s();
    } else {
      clickReturnToList();
    }
    getWebDriver().switchTo().defaultContent();
  }

  public void deleteDpImage() {
    moveToElementWithXpath(XPATH_DELETE_DP_IMAGE);
    click(XPATH_DELETE_DP_IMAGE);
    pause1s();
    click(XPATH_DELETE_PHOTO);
    pause2s();
  }

  public void editDpImageAndSaveSettings(String currentDpName, File file, String status) {
    dpTable.filterByColumn("name", currentDpName);
    dpTable.clickActionButton(1, "edit");
    final WebElement frame = findElementByXpath(XPATH_PUDO_POINT_IFRAME);
    getWebDriver().switchTo().frame(frame);
    waitUntilVisibilityOfElementLocated(XPATH_POINT_NAME);
    editDpImage(file, status);
    clickSaveSettingsCreateDpForm();
    getWebDriver().switchTo().defaultContent();
  }

  public void editDpImage(File file, String status) {
    uploadDpPhoto(file);
    if ("invalid".equalsIgnoreCase(status)) {
      assertInvalidImageErrorMessage();
    }
    pause2s();
  }

  public void resetUserPassword(String username, String password, String status) {
    dpUsersTable.filterByColumn(DpUsersTable.COLUMN_USERNAME, username);
    dpUsersTable.clickActionButton(1, DpUsersTable.ACTION_EDIT);
    resetPassword(password, status);
  }

  public void resetPassword(String password, String status) {
    clickResetPassword();
    if ("successfully".equalsIgnoreCase(status)) {
      setNewPassword(password);
      setConfirmPassword(password);
      clickSavePassword();
      verifySuccessPasswordChangeMessage();
    } else if ("unsuccessfully".equalsIgnoreCase(status)) {
      setNewPassword(password);
      setConfirmPassword("Latika");
      verifyMisMatchPasswordErrorMessage();
      clickBackToUserEdit();
    } else {
      clickBackToUserEdit();
    }
  }

  public void clickBackToUserEdit() {
    //Commenting till DP-4694 is not in QA
    /*waitUntilVisibilityOfElementLocated(XPATH_BACK_TO_USER_EDIT);
    click(XPATH_BACK_TO_USER_EDIT);
    assertFalse(isElementVisible(XPATH_BACK_TO_USER_EDIT));
     */
  }

  public void verifyMisMatchPasswordErrorMessage() {
    String expectedMessage = "Password does not match!";
    String actualMessage = getText(XPATH_ERROR_MISMATCH_PASSWORD_MESSAGE);
    assertTrue("Error message is not correct: ", expectedMessage.equalsIgnoreCase(actualMessage));
  }

  public void clickResetPassword() {
    waitUntilVisibilityOfElementLocated(XPATH_RESET_PASSWORD_BUTTON);
    moveToElementWithXpath(XPATH_RESET_PASSWORD_BUTTON);
    click(XPATH_RESET_PASSWORD_BUTTON);
  }

  public void setNewPassword(String newPassword) {
    waitUntilVisibilityOfElementLocated(XPATH_INPUT_NEW_PASSWORD);
    sendKeys(XPATH_INPUT_NEW_PASSWORD, newPassword);
  }

  public void setConfirmPassword(String confirmPassword) {
    waitUntilVisibilityOfElementLocated(XPATH_CONFIRM_NEW_PASSWORD);
    sendKeys(XPATH_CONFIRM_NEW_PASSWORD, confirmPassword);
  }

  public void clickSavePassword() {
    click(XPATH_SAVE_PASSWORD);
    pause1s();
  }

  public void verifySuccessPasswordChangeMessage() {
    String expectedText = "New Password Saved!";
    String actualText = getText(XPATH_SUCCESS_PASSWORD_MESSAGE);
    Assertions.assertThat(actualText.toLowerCase()).as("New password is saved: ")
        .isEqualTo(expectedText.toLowerCase());
  }

  public void loginNinjaPoint(String username, String password) {
    waitUntilVisibilityOfElementLocated(XPATH_LOGIN_BUTTON_NINJA_POINT);
    fillUsername(username);
    fillPassword(password);
    clickLoginNinjaPoint();
  }

  public void fillUsername(String username) {
    moveToElementWithXpath(XPATH_USERNAME_NINJA_POINT);
    sendKeys(XPATH_USERNAME_NINJA_POINT, username);
  }

  public void fillPassword(String password) {
    moveToElementWithXpath(XPATH_PASSWORD_NINJA_POINT);
    sendKeys(XPATH_PASSWORD_NINJA_POINT, password);
  }

  public void clickLoginNinjaPoint() {
    click(XPATH_LOGIN_BUTTON_NINJA_POINT);
  }

  public void welcomePageDisplayed() {
    Assertions.assertThat(isElementVisible(XPATH_WELCOME_PAGE_NINJA_POINT))
        .as("welcome page is displayed").isTrue();
  }

  /**
   * Accessor for Add Partner dialog
   */
  @SuppressWarnings("UnusedReturnValue")
  public static class AddPartnerDialog extends OperatorV2SimplePage {

    static final String DIALOG_TITLE = "Add Partner";
    static final String LOCATOR_FIELD_PARTNER_NAME = "Partner Name";
    static final String LOCATOR_FIELD_POC_NAME = "POC Name";
    static final String LOCATOR_FIELD_POC_NO = "POC No.";
    static final String LOCATOR_FIELD_POC_EMAIL = "POC Email";
    static final String LOCATOR_FIELD_RESTRICTIONS = "Restrictions";
    static final String LOCATOR_BUTTON_SUBMIT = "Submit";
    protected String dialogTittle;
    protected String locatorButtonSubmit;

    public AddPartnerDialog(WebDriver webDriver) {
      super(webDriver);
      dialogTittle = DIALOG_TITLE;
      locatorButtonSubmit = LOCATOR_BUTTON_SUBMIT;
    }

    public AddPartnerDialog waitUntilVisible() {
      waitUntilVisibilityOfMdDialogByTitle(dialogTittle);
      return this;
    }

    public AddPartnerDialog setPartnerName(String value) {
      sendKeysByAriaLabel(LOCATOR_FIELD_PARTNER_NAME, value);
      return this;
    }

    public AddPartnerDialog setPocName(String value) {
      sendKeysByAriaLabel(LOCATOR_FIELD_POC_NAME, value);
      return this;
    }

    public AddPartnerDialog setPocNo(String value) {
      sendKeysByAriaLabel(LOCATOR_FIELD_POC_NO, value);
      return this;
    }

    public AddPartnerDialog setPocEmail(String value) {
      sendKeysByAriaLabel(LOCATOR_FIELD_POC_EMAIL, value);
      return this;
    }

    public AddPartnerDialog setRestrictions(String value) {
      sendKeysByAriaLabel(LOCATOR_FIELD_RESTRICTIONS, value);
      return this;
    }

    public void submitForm() {
      clickNvButtonSaveByNameAndWaitUntilDone(locatorButtonSubmit);
      waitUntilInvisibilityOfMdDialogByTitle(dialogTittle);
    }

    public void fillForm(DpPartner dpPartner) {
      waitUntilVisible();
      String value = dpPartner.getName();
      if (StringUtils.isNotBlank(value)) {
        setPartnerName(value);
      }
      value = dpPartner.getPocName();
      if (StringUtils.isNotBlank(value)) {
        setPocName(value);
      }
      value = dpPartner.getPocTel();
      if (StringUtils.isNotBlank(value)) {
        setPocNo(value);
      }
      value = dpPartner.getPocEmail();
      if (StringUtils.isNotBlank(value)) {
        setPocEmail(value);
      }
      value = dpPartner.getRestrictions();
      if (StringUtils.isNotBlank(value)) {
        setRestrictions(value);
      }
      submitForm();
    }
  }

  /**
   * Accessor for Edit Partner dialog
   */
  public static class EditPartnerDialog extends AddPartnerDialog {

    static final String DIALOG_TITLE = "Edit Partner";
    static final String LOCATOR_BUTTON_SUBMIT = "Submit Changes";

    public EditPartnerDialog(WebDriver webDriver) {
      super(webDriver);
      dialogTittle = DIALOG_TITLE;
      locatorButtonSubmit = LOCATOR_BUTTON_SUBMIT;
    }
  }

  /**
   * Accessor for DP Partners table
   */
  public static class DpPartnersTable extends MdVirtualRepeatTable<DpPartner> {

    public DpPartnersTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put("id", "id")
          .put("name", "name")
          .put("pocName", "poc_name")
          .put("pocTel", "poc_tel")
          .put("pocEmail", "poc_email")
          .put("restrictions", "restrictions")
          .build()
      );
      setActionButtonsLocators(ImmutableMap.of("edit", "Edit", "View DPs", "View DPs"));
      setEntityClass(DpPartner.class);
    }
  }

  /**
   * Accessor for DP table
   */
  public static class DpTable extends MdVirtualRepeatTable<Dp> {

    public DpTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put("id", "id")
          .put("name", "name")
          .put("shortName", "short_name")
          .put("hub", "hub")
          .put("address", "address")
          .put("directions", "directions")
          .put("activity", "activity")
          .build()
      );
      setActionButtonsLocators(ImmutableMap.of("edit", "Edit", "View DPs", "View DPs"));
      setEntityClass(Dp.class);
    }
  }

  /**
   * Accessor for Add Distribution Point dialog
   */
  @SuppressWarnings("UnusedReturnValue")
  public static class AddDpDialog extends OperatorV2SimplePage {

    static final String DIALOG_TITLE = "Add Distribution Point";
    static final String LOCATOR_FIELD_NAME = "Name";
    static final String LOCATOR_FIELD_SHORT_NAME = "Shortname";
    static final String LOCATOR_FIELD_TYPE = "type";
    static final String LOCATOR_FIELD_SERVICE = "service";
    static final String LOCATOR_FIELD_CAN_SHIPPER_LODGE_IN = "can-shipper-lodge-in?";
    static final String LOCATOR_FIELD_CAN_CUSTOMER_COLLECT = "can-customer-collect?";
    static final String LOCATOR_FIELD_MAX_CAP = "Max Cap";
    static final String LOCATOR_FIELD_CAP_BUFFER = "Cap Buffer";
    static final String LOCATOR_FIELD_CONTACT_NO = "Contact No.";
    static final String LOCATOR_FIELD_ADDRESS_LINE_1 = "Address Line 1";
    static final String LOCATOR_FIELD_ADDRESS_LINE_2 = "Address Line 2";
    static final String LOCATOR_FIELD_UNIT_NO = "Unit No.";
    static final String LOCATOR_FIELD_FLOOR_NO = "Floor No.";
    static final String LOCATOR_FIELD_CITY = "City";
    static final String LOCATOR_FIELD_COUNTRY = "Country";
    static final String LOCATOR_FIELD_POSTCODE = "Postcode";
    static final String LOCATOR_FIELD_LATITUDE = "Latitude";
    static final String LOCATOR_FIELD_LONGITUDE = "Longitude";
    static final String LOCATOR_FIELD_DIRECTIONS = "Directions";
    static final String LOCATOR_BUTTON_SUBMIT = "Submit";
    protected String dialogTittle;
    protected String locatorButtonSubmit;

    public AddDpDialog(WebDriver webDriver) {
      super(webDriver);
      dialogTittle = DIALOG_TITLE;
      locatorButtonSubmit = LOCATOR_BUTTON_SUBMIT;
    }

    public AddDpDialog waitUntilVisible() {
      waitUntilVisibilityOfMdDialogByTitle(dialogTittle);
      return this;
    }

    public AddDpDialog setName(String value) {
      if (StringUtils.isNotBlank(value)) {
        sendKeysByAriaLabel(LOCATOR_FIELD_NAME, value);
      }
      return this;
    }

    public AddDpDialog setShortName(String value) {
      if (StringUtils.isNotBlank(value)) {
        sendKeysByAriaLabel(LOCATOR_FIELD_SHORT_NAME, value);
      }
      return this;
    }

    public AddDpDialog setType(String value) {
      if (StringUtils.isNotBlank(value)) {
        selectValueFromMdSelectById(LOCATOR_FIELD_TYPE, value);
      }
      return this;
    }

    public AddDpDialog setService(String value) {
      if (StringUtils.isNotBlank(value)) {
        selectValueFromMdSelectById(LOCATOR_FIELD_SERVICE, value);
      }
      return this;
    }

    public AddDpDialog setCanShipperLodgeIn(Boolean value) {
      if (value != null) {
        toggleMdSwitchById(LOCATOR_FIELD_CAN_SHIPPER_LODGE_IN, value);
      }
      return this;
    }

    public AddDpDialog setCanCustomerCollect(Boolean value) {
      if (value != null) {
        toggleMdSwitchById(LOCATOR_FIELD_CAN_CUSTOMER_COLLECT, value);
      }
      return this;
    }

    public AddDpDialog setMaxCap(String value) {
      if (StringUtils.isNotBlank(value)) {
        sendKeysByAriaLabel(LOCATOR_FIELD_MAX_CAP, value);
      }
      return this;
    }

    public AddDpDialog setCapBuffer(String value) {
      if (StringUtils.isNotBlank(value)) {
        sendKeysByAriaLabel(LOCATOR_FIELD_CAP_BUFFER, value);
      }
      return this;
    }

    public AddDpDialog setContactNo(String value) {
      if (StringUtils.isNotBlank(value)) {
        sendKeysByAriaLabel(LOCATOR_FIELD_CONTACT_NO, value);
      }
      return this;
    }

    public AddDpDialog setAddressLine1(String value) {
      if (StringUtils.isNotBlank(value)) {
        sendKeysByAriaLabel(LOCATOR_FIELD_ADDRESS_LINE_1, value);
      }
      return this;
    }

    public AddDpDialog setAddressLine2(String value) {
      if (StringUtils.isNotBlank(value)) {
        sendKeysByAriaLabel(LOCATOR_FIELD_ADDRESS_LINE_2, value);
      }
      return this;
    }

    public AddDpDialog setUnitNo(String value) {
      if (StringUtils.isNotBlank(value)) {
        sendKeysByAriaLabel(LOCATOR_FIELD_UNIT_NO, value);
      }
      return this;
    }

    public AddDpDialog setFloorNo(String value) {
      if (StringUtils.isNotBlank(value)) {
        sendKeysByAriaLabel(LOCATOR_FIELD_FLOOR_NO, value);
      }
      return this;
    }

    public AddDpDialog setCity(String value) {
      if (StringUtils.isNotBlank(value)) {
        sendKeysByAriaLabel(LOCATOR_FIELD_CITY, value);
      }
      return this;
    }

    public AddDpDialog setCountry(String value) {
      if (StringUtils.isNotBlank(value)) {
        sendKeysByAriaLabel(LOCATOR_FIELD_COUNTRY, value);
      }
      return this;
    }

    public AddDpDialog setPostcode(String value) {
      if (StringUtils.isNotBlank(value)) {
        sendKeysByAriaLabel(LOCATOR_FIELD_POSTCODE, value);
      }
      return this;
    }

    public AddDpDialog setLatitude(Double value) {
      if (value != null) {
        sendKeysByAriaLabel(LOCATOR_FIELD_LATITUDE, String.valueOf(value));
      }
      return this;
    }

    public AddDpDialog setLongitude(Double value) {
      if (value != null) {
        sendKeysByAriaLabel(LOCATOR_FIELD_LONGITUDE, String.valueOf(value));
      }
      return this;
    }

    public AddDpDialog setDirections(String value) {
      sendKeysByAriaLabel(LOCATOR_FIELD_DIRECTIONS, value);
      return this;
    }

    public void fillForm(Dp dpParams) {
      waitUntilVisible();
      setName(dpParams.getName());
      setShortName(dpParams.getShortName());
      setType(dpParams.getType());
      setService(dpParams.getService());
      setCanShipperLodgeIn(dpParams.getCanShipperLodgeIn());
      setCanCustomerCollect(dpParams.getCanCustomerCollect());
      setMaxCap(dpParams.getMaxCap());
      setCapBuffer(dpParams.getCapBuffer());
      setContactNo(dpParams.getContactNo());
      setAddressLine1(dpParams.getAddress1());
      setAddressLine2(dpParams.getAddress2());
      setUnitNo(dpParams.getUnitNo());
      setFloorNo(dpParams.getFloorNo());
      setCity(dpParams.getCity());
      //setCountry(dpParams.getCountry());
      setPostcode(dpParams.getPostcode());
      setLatitude(dpParams.getLatitude());
      setLongitude(dpParams.getLongitude());
      setDirections(dpParams.getDirections());
      submitForm();
    }

    public void submitForm() {
      clickNvButtonSaveByNameAndWaitUntilDone(locatorButtonSubmit);
      waitUntilInvisibilityOfMdDialogByTitle(dialogTittle);
    }
  }

  /**
   * Accessor for Edit Distribution Point dialog
   */
  public static class EditDpDialog extends AddDpDialog {

    static final String DIALOG_TITLE = "Edit Distribution Point";
    static final String LOCATOR_BUTTON_SUBMIT = "Submit Changes";

    public EditDpDialog(WebDriver webDriver) {
      super(webDriver);
      dialogTittle = DIALOG_TITLE;
      locatorButtonSubmit = LOCATOR_BUTTON_SUBMIT;
    }
  }

  /**
   * Accessor for Add User dialog
   */
  @SuppressWarnings("UnusedReturnValue")
  public static class AddDpUserDialog extends OperatorV2SimplePage {

    static final String DIALOG_TITLE = "Add User";
    static final String LOCATOR_FIELD_FIRST_NAME = "First Name";
    static final String LOCATOR_FIELD_LAST_NAME = "Last Name";
    static final String LOCATOR_FIELD_CONTACT_NO = "Contact No.";
    static final String LOCATOR_FIELD_EMAIL = "Email";
    static final String LOCATOR_FIELD_USERNAME = "Username";
    static final String LOCATOR_FIELD_PASSWORD = "Password";
    static final String LOCATOR_BUTTON_SUBMIT = "Submit";
    protected String dialogTittle;
    protected String locatorButtonSubmit;

    public AddDpUserDialog(WebDriver webDriver) {
      super(webDriver);
      dialogTittle = DIALOG_TITLE;
      locatorButtonSubmit = LOCATOR_BUTTON_SUBMIT;
    }

    public AddDpUserDialog waitUntilVisible() {
      waitUntilVisibilityOfMdDialogByTitle(dialogTittle);
      return this;
    }

    public AddDpUserDialog setFirstName(String value) {
      sendKeysByAriaLabel(LOCATOR_FIELD_FIRST_NAME, value);
      return this;
    }

    public AddDpUserDialog setLastName(String value) {
      sendKeysByAriaLabel(LOCATOR_FIELD_LAST_NAME, value);
      return this;
    }

    public AddDpUserDialog setContactNo(String value) {
      sendKeysByAriaLabel(LOCATOR_FIELD_CONTACT_NO, value);
      return this;
    }

    public AddDpUserDialog setEmail(String value) {
      sendKeysByAriaLabel(LOCATOR_FIELD_EMAIL, value);
      return this;
    }

    public AddDpUserDialog setUsername(String value) {
      sendKeysByAriaLabel(LOCATOR_FIELD_USERNAME, value);
      return this;
    }

    public AddDpUserDialog setPassword(String value) {
      sendKeysByAriaLabel(LOCATOR_FIELD_PASSWORD, value);
      return this;
    }

    public void submitForm() {
      clickNvButtonSaveByNameAndWaitUntilDone(locatorButtonSubmit);
      waitUntilInvisibilityOfMdDialogByTitle(dialogTittle);
    }

    public void fillForm(DpUser dpUser) {
      waitUntilVisible();
      String value = dpUser.getFirstName();
      if (StringUtils.isNotBlank(value)) {
        setFirstName(value);
      }
      value = dpUser.getLastName();
      if (StringUtils.isNotBlank(value)) {
        setLastName(value);
      }
      value = dpUser.getContactNo();
      if (StringUtils.isNotBlank(value)) {
        setContactNo(value);
      }
      value = dpUser.getEmailId();
      if (StringUtils.isNotBlank(value)) {
        setEmail(value);
      }
      value = dpUser.getClientId();
      if (StringUtils.isNotBlank(value)) {
        setUsername(value);
      }
      value = dpUser.getClientSecret();
      if (StringUtils.isNotBlank(value)) {
        setPassword(value);
      }
      submitForm();
    }
  }

  /**
   * Accessor for Edit User dialog
   */
  public static class EditDpUserDialog extends AddDpUserDialog {

    static final String DIALOG_TITLE = "Edit User";
    static final String LOCATOR_BUTTON_SUBMIT = "Submit";

    public EditDpUserDialog(WebDriver webDriver) {
      super(webDriver);
      dialogTittle = DIALOG_TITLE;
      locatorButtonSubmit = LOCATOR_BUTTON_SUBMIT;
    }
  }

  /**
   * Accessor for DP Users table
   */
  public static class DpUsersTable extends MdVirtualRepeatTable<DpUser> {

    public static final String COLUMN_USERNAME = "clientId";
    public static final String COLUMN_FIRST_NAME = "firstName";
    public static final String COLUMN_LAST_NAME = "lastName";
    public static final String COLUMN_EMAIL = "emailId";
    public static final String COLUMN_CONTACT_NO = "contactNo";
    public static final String ACTION_EDIT = "edit";

    public DpUsersTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.of(
          COLUMN_USERNAME, "username",
          COLUMN_FIRST_NAME, "first_name",
          COLUMN_LAST_NAME, "last_name",
          COLUMN_EMAIL, "email",
          COLUMN_CONTACT_NO, "contact_no"
      ));
      setActionButtonsLocators(ImmutableMap.of(ACTION_EDIT, "Edit"));
      setEntityClass(DpUser.class);
    }
  }
}
