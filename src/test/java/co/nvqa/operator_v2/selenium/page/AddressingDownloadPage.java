package co.nvqa.operator_v2.selenium.page;

import co.nvqa.common.core.model.order.Order;
import co.nvqa.common.utils.DateUtil;
import co.nvqa.common.utils.NvCountry;
import co.nvqa.operator_v2.model.AddressDownloadFilteringType;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.util.TestConstants;
import java.time.Duration;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class AddressingDownloadPage extends OperatorV2SimplePage {

  @FindBy(xpath = "//iframe[contains(@src,'address-download')]")
  private PageElement pageFrame;

  @FindBy(xpath = "//div[contains(@class, 'select-preset-holder')]/button[contains(@data-testid, 'menu-button')]")
  public PageElement ellipses;

  @FindBy(xpath = "//button[@class='ant-picker-header-next-btn']")
  public PageElement nextMonthButton;

  @FindBy(xpath = "//li[contains(@data-testid, 'create-new-preset')]")
  public PageElement createNewPreset;

  @FindBy(xpath = "//li[contains(@data-testid, 'edit-preset')]")
  public PageElement editPreset;

  @FindBy(xpath = "//label[text()='Name']/following-sibling::input")
  public PageElement inputPresetName;

  @FindBy(xpath = "//button[@data-testid='add-filter-button']")
  public PageElement filterButton;

  @FindBy(xpath = "//div[contains(@class,'select-filters-holder')]//div[contains(@class,'select-show')]")
  public PageElement filterDropDown;

  @FindBy(xpath = "//div[contains(@class,'select-filters-holder')]//div[contains(@class,'select-show')]/preceding-sibling::label[contains(text(), 'Shipper')]/following-sibling::div")
  public PageElement filterDropDownShipper;

  @FindBy(xpath = "//div[contains(@class,'select-filters-holder')]//div[contains(@class,'select-show')]/preceding-sibling::label[contains(text(), 'RTS')]/following-sibling::div")
  public PageElement filterDropDownRTS;

  @FindBy(xpath = "//div[contains(@class,'select-filters-holder')]//div[contains(@class,'select-show')]/preceding-sibling::label[contains(text(), 'Source')]/following-sibling::div")
  public PageElement filterDropDownSource;

  @FindBy(xpath = "//div[@title='Verified']")
  public PageElement verifiedOption;

  @FindBy(xpath = "//div[@title='Unverified']")
  public PageElement unverifiedOption;

  @FindBy(xpath = "//div[@title='Yes']")
  public PageElement yesRtsOption;

  @FindBy(xpath = "//div[@title='Auto AV']")
  public PageElement autoAvOption;

  @FindBy(xpath = "//div[@title='No']")
  public PageElement noRtsOption;

  @FindBy(xpath = "//div[contains(@class,'select-filter')]//input[contains(@id,'rc_select')]")
  public PageElement filterInput;

  @FindBy(xpath = "//*[local-name()='svg' and @data-icon='check']/parent::button")
  public PageElement mainPresetButtonInModal;

  @FindBy(xpath = "//div[contains(@class,'content')]//input[contains(@id,'rc_select')]")
  public PageElement selectPresetEditModal;

  @FindBy(xpath = "//*[local-name()='svg' and @data-icon='trash']/parent::button")
  public PageElement deletePresetButton;

  // Searching by Tracking IDs
  @FindBy(xpath = "//button[@data-testid='load-tracking-ids-button']")
  public Button loadTrackingIds;

  @FindBy(xpath = "//span[contains(@class,'affix')]/textarea")
  public PageElement trackingIdtextArea;

  @FindBy(xpath = "//div[contains(@class,'modal-content')]//button[contains(@class,'btn-primary')]")
  public Button nextButtonLoadTrackingId;

  @FindBy(xpath = "//div[contains(@class,'nv-table')]")
  public PageElement addressDownloadTableResult;

  @FindBy(xpath = "//div[@class='download-csv-holder']/button")
  public Button downloadCsv;

  @FindBy(xpath = "//*[local-name()='svg' and @data-icon='times-circle']")
  public PageElement trackingIdNotFound;

  @FindBy(xpath = "//div[@class='select-preset']//input[contains(@id,'rc_select')]")
  public PageElement selectPresetLoadAddresses;

  @FindBy(xpath = "//div[@class='select-preset-holder']/button[contains(@class, 'ant-btn-primary')]")
  public Button loadAddresses;

  public  String TRACKING_NUMBER_TABLE_XPATH="//td[@class='tracking_number']//span[contains(text(),'%s')]";
  private static final String EXISTED_PRESET_SELECTION_XPATH = "//div[contains(@class,'select-preset')]//input[contains(@id,'rc_select')]";
  private static final String DROP_DOWN_PRESET_XPATH = "//ul[contains(@class,'dropdown-menu-root')]";
  private static final String DIALOG_XPATH = "//div[@class='ant-modal-title' and contains(@id,'rc_unique')]";
  private static final String PRESET_SELECTION_XPATH = "//li[contains(@data-testid,'%s')]";
  private static final String RANDOM_CLICK_XPATH = "//div[contains(@class,'select-filters-holder')]/div[@class='section-header']";
  private static final String PRESET_TO_BE_SELECTED_XPATH = "//div[@title='%s']";
  private static final String PRESET_NOT_FOUND_XPATH = "//*[local-name()='svg' and contains(@class,'empty-img')]";
  private static final String FILTERING_RESULT_XPATH = "//div[contains(text(),'%s')]";
  private static final String TRACKING_ID_COLUMN_XPATH = "//td[@class='tracking_number']";
  private static final String TO_ADDRESS_1_COLUMN_XPATH = "//td[@class='address_one']";
  private static final String TO_ADDRESS_2_COLUMN_XPATH = "//td[@class='address_two']";
  private static final String IS_RTS_COLUMN_XPATH = "//td[@class='is_rts']";

  private static final String ADDRESS_STATUS_DATA_TESTID = "av_statuses";
  private static final String SHIPPER_IDS_DATA_TESTID = "shipper_ids";
  private static final String MARKETPLACE_IDS_DATA_TESTID = "marketplace_ids";
  private static final String ZONE_IDS_DATA_TESTID = "zone_ids";
  private static final String HUB_IDS_DATA_TESTID = "hub_ids";
  private static final String RTS_DATA_TESTID = "rts";
  private static final String CREATED_AT_TESTID = "created_at";
  private static final String SOURCE_TESTID = "av_sources";

  private static final String CREATION_TIME_PRESET_FILTER_TIMEPICKER_FIELD = "(//div[contains(text(), 'Creation Time')]/following-sibling::span//input)[%d]";
  private static final String CREATION_TIME_FILTER_DATEPICKER_FIELD = "//div[contains(@class, 'ant-picker-range')]//input[@placeholder='%s date']";
  private static final String CREATION_TIME_FILTER_DROPDOWN = "//div[contains(@class, 'ant-picker-dropdown')]";
  private static final String CREATION_TIME_FILTER_DATEPICKER_YEAR = "//td[contains(@class, 'ant-picker-cell') and @title='%s']";
  private static final String CREATION_TIME_FILTER_DATEPICKER_MONTH = "//td[contains(@class, 'ant-picker-cell') and @title='%s-%s']";
  private static final String CREATION_TIME_FILTER_DATEPICKER_DAY = "//td[contains(@class, 'ant-picker-cell') and @title='%s-%s-%s']";
  private static final String CREATION_TIME_FILTER_TIMEPICKER_HOUR = "//ul[position()=1]//div[contains(@class, 'ant-picker-time-panel-cell-inner') and contains(text(), '%s')]";
  private static final String CREATION_TIME_FILTER_TIMEPICKER_MINUTE = "//ul[position()=2]//div[contains(@class, 'ant-picker-time-panel-cell-inner') and contains(text(), '%s')]";
  private static final String CREATION_TIME_FILTER_OK = "//li[@class='ant-picker-ok']/button";
  private static final String ORDER_DATA_CELL_XPATH = "//td[@class='%s']";

  private static final String ORDER_TRACKING_ID_EXISTS = "isTrackingIDFound";
  private static final String ORDER_ADDRESS_ONE_EXISTS = "isAddressOneFound";
  private static final String ORDER_ADDRESS_TWO_EXISTS = "isAddressTwoFound";
  private static final String ORDER_CREATED_AT_EXISTS = "isCreatedAtFound";
  private static final String ORDER_POSTCODE_EXISTS = "isPostcodeFound";
  private static final String ORDER_WAYPOINT_ID_EXISTS = "isWaypointIDFound";
  private static final String ORDER_LATITUDE_EXISTS = "isLatitudeFound";
  private static final String ORDER_LONGITUDE_EXISTS = "isLongitudeFound";

  private static final String PRESET_DIALOG_MULTISELECT_FILTER_ITEM = "//div[@class='multi-select']//label[contains(text(), '%s')]/following-sibling::div//span[@class='ant-select-selection-item']";
  private static final String PRESET_DIALOG_MULTISELECT_FILTER_DELETE = "//div[@class='multi-select']//label[contains(text(), '%s')]/following-sibling::div//span[contains(@class, 'anticon-close')]";

  public static final DateTimeFormatter DATE_FORMAT = DateTimeFormatter
      .ofPattern("yyyy-MM-dd_HH-mm");
  // zone id should be depend on the machine, by far. Tested locally using ID, hopefully bamboo machine is in SG
  // issue is addressed in https://jira.ninjavan.co/browse/SORT-965
  private static final ZonedDateTime ZONED_DATE_TIME = DateUtil.getDate(ZoneId.of(NvCountry.SG
      .getTimezone()));
  private static final String DATE_TIME = ZONED_DATE_TIME.format(DATE_FORMAT);
  private static final String CSV_FILENAME_FORMAT = "av-addresses_";

  private static final DateTimeFormatter ADDRESS_DOWNLOAD_DATE_FORMAT = DateTimeFormatter.ofPattern(
      "yyyy/MM/dd HH:mm");

  public final String LOAD_ADDRESS_BUTTON_LOADING_ICON = "//button[@data-testid='load-addresses-button']/span[@class='ant-btn-loading-icon']";
  public final String ADDRESS_DOWNLOAD_STATS = "//div[@class='download-csv-holder']/div[@class='download-stats']";
  public final String FILTER_SHOWN_XPATH = "//div[contains(@class,'select-filters-holder')]//div[contains(@class,'select-show') or contains(@class, 'ant-picker-range')]";
  public final String SYS_ID = "UTC"; // UTC, Asia/Jakarta

  private static final Logger LOGGER = LoggerFactory.getLogger(AddressingDownloadPage.class);

  public AddressingDownloadPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void switchToIframe() {
    getWebDriver().switchTo().frame(pageFrame.getWebElement());
  }

  public void verifiesPageIsFullyLoaded() {
    isElementExistWait5Seconds(EXISTED_PRESET_SELECTION_XPATH);
  }

  public void verifiesOptionIsShown() {
    isElementExist(DROP_DOWN_PRESET_XPATH);
  }

  public void verifiesModalIsShown() {
    waitUntilVisibilityOfElementLocated(DIALOG_XPATH);
  }

  public void selectPresetFilter(AddressDownloadFilteringType addressDownloadFilteringType) {
    switch (addressDownloadFilteringType) {
      case ADDRESS_STATUS_VERIFIED:
        click(f(PRESET_SELECTION_XPATH, ADDRESS_STATUS_DATA_TESTID));
        break;

      case ADDRESS_STATUS_UNVERIFIED:
        click(f(PRESET_SELECTION_XPATH, ADDRESS_STATUS_DATA_TESTID));
        break;

      case SHIPPER_IDS:
        click(f(PRESET_SELECTION_XPATH, SHIPPER_IDS_DATA_TESTID));
        break;

      case MARKETPLACE_IDS:
        click(f(PRESET_SELECTION_XPATH, MARKETPLACE_IDS_DATA_TESTID));
        break;

      case ZONE_IDS:
        click(f(PRESET_SELECTION_XPATH, ZONE_IDS_DATA_TESTID));
        break;

      case HUB_IDS:
        click(f(PRESET_SELECTION_XPATH, HUB_IDS_DATA_TESTID));
        break;

      case RTS_NO:
        click(f(PRESET_SELECTION_XPATH, RTS_DATA_TESTID));
        break;

      case RTS_YES:
        click(f(PRESET_SELECTION_XPATH, RTS_DATA_TESTID));
        break;

      case CREATED_AT:
        click(f(PRESET_SELECTION_XPATH, CREATED_AT_TESTID));
        break;

      case SOURCE:
        click(f(PRESET_SELECTION_XPATH, SOURCE_TESTID));
        break;

      default:
        LOGGER.warn("Invalid Address Download Filter Type");
    }
  }

  public void setPresetFilter(AddressDownloadFilteringType addressDownloadFilteringType) {
    String shipperName = TestConstants.SHIPPER_V4_NAME;
    final String marketplaceName = "Niko Ninja fixed marketplace";
    final String zoneName = "ZZZ-All Zones";
    String hubName = TestConstants.HUB_NAME;

    switch (addressDownloadFilteringType) {
      case ADDRESS_STATUS_VERIFIED:
        filterDropDown.click();
        verifiedOption.click();
        break;

      case ADDRESS_STATUS_UNVERIFIED:
        filterDropDown.click();
        unverifiedOption.click();
        break;

      case SHIPPER_IDS:
        filterDropDownShipper.click();
        filterInput.sendKeys(shipperName);
        waitUntilVisibilityOfElementLocated(f(FILTERING_RESULT_XPATH, shipperName));
        click(f(FILTERING_RESULT_XPATH, shipperName));
        break;

      case MARKETPLACE_IDS:
        filterDropDown.click();
        filterInput.sendKeys(marketplaceName);
        waitUntilVisibilityOfElementLocated(f(FILTERING_RESULT_XPATH, marketplaceName));
        click(f(FILTERING_RESULT_XPATH, marketplaceName));
        break;

      case ZONE_IDS:
        filterDropDown.click();
        filterInput.sendKeys(zoneName);
        waitUntilVisibilityOfElementLocated(f(FILTERING_RESULT_XPATH, zoneName));
        click(f(FILTERING_RESULT_XPATH, zoneName));
        break;

      case HUB_IDS:
        filterDropDown.click();
        filterInput.sendKeys(hubName);
        waitUntilVisibilityOfElementLocated(f(FILTERING_RESULT_XPATH, hubName));
        click(f(FILTERING_RESULT_XPATH, hubName));
        break;

      case RTS_NO:
        filterDropDownRTS.click();
        noRtsOption.click();
        break;

      case RTS_YES:
        filterDropDownRTS.click();
        yesRtsOption.click();
        break;

      case CREATED_AT:
        setCreatedAtFilter();
        break;

      case SOURCE:
        filterDropDownSource.click();
        autoAvOption.click();
        break;

      default:
        LOGGER.warn("Invalid Address Download Filter Type");
    }
    click(RANDOM_CLICK_XPATH);
    pause1s();
  }

  public void verifiesPresetIsExisted(String presetName) {
    doWithRetry(() -> {
      getWebDriver().navigate().refresh();
      switchToIframe();
      verifiesPageIsFullyLoaded();
      waitUntilVisibilityOfElementLocated(EXISTED_PRESET_SELECTION_XPATH);
    }, "Reloading page until contents appear.");
    click(EXISTED_PRESET_SELECTION_XPATH);
    sendKeys(EXISTED_PRESET_SELECTION_XPATH, presetName);
    waitUntilVisibilityOfElementLocated(f(PRESET_TO_BE_SELECTED_XPATH, presetName));
    Assertions.assertThat(isElementExist(f(PRESET_TO_BE_SELECTED_XPATH, presetName)))
        .as("Preset is Existed").isTrue();
  }

  public void verifiesPresetIsNotExisted(String presetName) {
    doWithRetry(()->{getWebDriver().navigate().refresh();
      switchToIframe();
      verifiesPageIsFullyLoaded();
      waitUntilVisibilityOfElementLocated(EXISTED_PRESET_SELECTION_XPATH);
      click(EXISTED_PRESET_SELECTION_XPATH);
      sendKeys(EXISTED_PRESET_SELECTION_XPATH, presetName);
      waitUntilVisibilityOfElementLocated(PRESET_NOT_FOUND_XPATH);
      Assertions.assertThat(isElementExist(PRESET_NOT_FOUND_XPATH)).as("Preset is Deleted").isTrue();},"Verifies Preset is Deleted");

  }

  public void csvDownloadSuccessfullyAndContainsTrackingId(List<Order> orders,
      String csvTimestamp) {
    String csvContainedFileName = CSV_FILENAME_FORMAT + csvTimestamp;
    LOGGER.debug("Looking for CSV with Name contained {}", csvContainedFileName);
    String csvFileName = doWithRetry(() ->
            getContainedFileNameDownloadedSuccessfully(csvContainedFileName),
        "Getting Exact File Name");

    for (int i = 0; i < orders.size(); i++) {
      verifyFileDownloadedSuccessfully(csvFileName, orders.get(i).getTrackingId());
      verifyFileDownloadedSuccessfully(csvFileName, orders.get(i).getToAddress1());
      verifyFileDownloadedSuccessfully(csvFileName, orders.get(i).getToAddress2());
    }
  }

  public void trackingIdUiChecking(String trackingId) {
    List<WebElement> trackingIdsElement;
    boolean isTrackingIdFound = false;
    trackingIdsElement = webDriver.findElements(By.xpath(TRACKING_ID_COLUMN_XPATH));

    for (WebElement we : trackingIdsElement) {
      if (trackingId.equalsIgnoreCase(we.getText())) {
        isTrackingIdFound = true;
        break;
      }
    }

    Assertions.assertThat(isTrackingIdFound).as(f("Tracking ID %s is found", trackingId)).isTrue();
  }

  public void addressUiChecking(String address1, String address2) {
    List<WebElement> address1Element;
    List<WebElement> address2Element;
    boolean isAddress1Found = false;
    boolean isAddress2Found = false;
    address1Element = webDriver.findElements(By.xpath(TO_ADDRESS_1_COLUMN_XPATH));
    address2Element = webDriver.findElements(By.xpath(TO_ADDRESS_2_COLUMN_XPATH));

    for (WebElement weAdd1 : address1Element) {
      LOGGER.debug("Checking Address 1 for we == addr: {} == {} ?", weAdd1.getText(), address1);
      if (address1.equalsIgnoreCase(weAdd1.getText())) {
        isAddress1Found = true;
        break;
      }
    }

    for (WebElement weAdd2 : address2Element) {
      LOGGER.debug("Checking Address 2 for we == addr: {} == {} ?", weAdd2.getText(), address2);
      if (address2.equalsIgnoreCase(weAdd2.getText())) {
        isAddress2Found = true;
        break;
      }
    }

    Assertions.assertThat(isAddress1Found).as(f("Address 1 %s is found", address1)).isTrue();
    Assertions.assertThat(isAddress2Found).as(f("Address 2 %s is found", address2)).isTrue();
  }

  public void rtsOrderIsIdentified() {
    List<WebElement> isRtsWebElement;
    final String YES = "Yes";
    boolean isRtsFound = false;
    isRtsWebElement = webDriver.findElements(By.xpath(IS_RTS_COLUMN_XPATH));

    for (WebElement we : isRtsWebElement) {
      scrollIntoView(we);
      if (YES.equalsIgnoreCase(we.getText())) {
        isRtsFound = true;
        break;
      }
    }

    Assertions.assertThat(isRtsFound).as("RTS Order Identified").isTrue();
  }

  public void setCreatedAtFilter() {
    LocalDateTime currentDateTimeInLocale = new Date().toInstant().atZone(ZoneId.of(SYS_ID))
        .toLocalDateTime();
    Map<String, String> currentTimeRange = generateDateTimeRange(currentDateTimeInLocale, 30);

    LOGGER.debug("Preset creation set time to: {}", currentDateTimeInLocale);
    LOGGER.debug("Preset creation map time to: {}", currentTimeRange);

    setPresetCreationTimeDatepicker(currentTimeRange);
  }

  public LocalDateTime resolveLocalDateTime(Date date, String timezone) {
    // Only accepts UTC date
    int offsetInMinutes =
        TimeZone.getTimeZone(timezone).getOffset(new Date().getTime()) / 1000 / 60;
    return date.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime()
        .plus(Duration.of(offsetInMinutes, ChronoUnit.MINUTES));
  }

  public Map<String, String> generateDateTimeRange(LocalDateTime orderCreationLocalDateTime,
      int rangeInMinutes) {
    /*
     * Returns:
     * - The same value for start date and end date
     * - Floored value of start time by 30 minutes
     * - End time = start time + 30 minutes
     * */

    // Creation time input: DATEPICKER
    DateTimeFormatter dayFormatter = DateTimeFormatter.ofPattern("dd");
    DateTimeFormatter monthFormatter = DateTimeFormatter.ofPattern("MM");

    int currentYear = orderCreationLocalDateTime.getYear();
    int currentDecadeStart = currentYear - (currentYear % 10);
    int currentDecadeEnd = currentDecadeStart + 9;

    // Creation time input: TIMEPICKER
    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
    DateTimeFormatter hourFormatter = DateTimeFormatter.ofPattern("HH");
    DateTimeFormatter minuteFormatter = DateTimeFormatter.ofPattern("mm");

    int currentMinute = orderCreationLocalDateTime.getMinute();
    int currentHour = orderCreationLocalDateTime.getHour();

    int currentMinuteFloored =
        ((int) Math.floor((float) currentMinute / 30)) * 30; // Return 00 or 30
    String currentMinuteFlooredAsString =
        currentMinuteFloored == 0 ? f("0%d", currentMinuteFloored) : f("%d", currentMinuteFloored);
    String currentHourAsString = currentHour < 10 ? f("0%d", currentHour) : f("%d", currentHour);

    LocalTime startTime = LocalTime.parse(
        f("%s:%s", currentHourAsString, currentMinuteFlooredAsString), timeFormatter);
    LocalTime endTime = startTime.plus(Duration.of(rangeInMinutes, ChronoUnit.MINUTES));

    Map<String, String> dateTimeRange = new HashMap<>();

    dateTimeRange.put("start_decade", f("%d-%d", currentDecadeStart, currentDecadeEnd));
    dateTimeRange.put("start_year", String.valueOf(currentYear));
    dateTimeRange.put("start_month", monthFormatter.format(orderCreationLocalDateTime));
    dateTimeRange.put("start_day", dayFormatter.format(orderCreationLocalDateTime));

    dateTimeRange.put("start_hour", hourFormatter.format(startTime));
    dateTimeRange.put("start_minute", minuteFormatter.format(startTime));

    dateTimeRange.put("end_hour", hourFormatter.format(endTime));
    dateTimeRange.put("end_minute", minuteFormatter.format(endTime));

    LOGGER.debug("Set time range to creation time filter to {}:{} - {}:{}",
        dateTimeRange.get("start_hour"), dateTimeRange.get("start_minute"),
        dateTimeRange.get("end_hour"), dateTimeRange.get("end_minute"));

    return dateTimeRange;
  }

  public void setPresetCreationTimeDatepicker(Map<String, String> selectedTime) {
    String startTimepickerFieldXpath = f(CREATION_TIME_PRESET_FILTER_TIMEPICKER_FIELD, 1);
    String endTimepickerFieldXpath = f(CREATION_TIME_PRESET_FILTER_TIMEPICKER_FIELD, 2);

    String startHourVal = selectedTime.get("start_hour");
    String startMinuteVal = selectedTime.get("start_minute");
    String endHourVal = selectedTime.get("end_hour");
    String endMinuteVal = selectedTime.get("end_minute");

    String startHourPickerXpath = f(CREATION_TIME_FILTER_TIMEPICKER_HOUR, startHourVal);
    String startMinutePickerXpath = f(CREATION_TIME_FILTER_TIMEPICKER_MINUTE, startMinuteVal);
    String endHourPickerXpath = f(CREATION_TIME_FILTER_TIMEPICKER_HOUR, endHourVal);
    String endMinutePickerXpath = f(CREATION_TIME_FILTER_TIMEPICKER_MINUTE, endMinuteVal);

    doWithRetry(() -> {
      click(startTimepickerFieldXpath);
      Assertions.assertThat(isElementExist(CREATION_TIME_FILTER_DROPDOWN))
          .as("Start timepicker is displayed")
          .isTrue();
    }, "Clicking timepicker field until it's showing...");

    // Select start hour
    click(startHourPickerXpath);

    // Select start minute
    click(startMinutePickerXpath);

    doWithRetry(() -> {
      click(endTimepickerFieldXpath);
      Assertions.assertThat(isElementExist(CREATION_TIME_FILTER_DROPDOWN))
          .as("End timepicker is displayed")
          .isTrue();
    }, "Clicking timepicker field until it's showing...");
    pause400ms(); // wait for the focus change

    // Select end hour
    click(endHourPickerXpath);

    // Select end minute
    click(endMinutePickerXpath);

    // Click Ok
    click(CREATION_TIME_FILTER_OK);

    // Wait until timepicker disappear
    waitUntilInvisibilityOfElementLocated(CREATION_TIME_FILTER_DROPDOWN);
  }

  public void setCreationTimeDatepicker(Map<String, String> selectedDate) {
    String selectYearButtonXpath = "//div[contains(@class, 'ant-picker-header-view')]//button[contains(@class, 'year')]";
    String selectMonthButtonXpath = "//div[contains(@class, 'ant-picker-header-view')]//button[contains(@class, 'month')]";

    String startDatepickerFieldXpath = f(CREATION_TIME_FILTER_DATEPICKER_FIELD, "Start");
    String endDatepickerFieldXpath = f(CREATION_TIME_FILTER_DATEPICKER_FIELD, "End");

    String startYearVal = selectedDate.get("start_year");
    String startMonthVal = selectedDate.get("start_month");
    String startDayVal = selectedDate.get("start_day");
    String startHourVal = selectedDate.get("start_hour");
    String startMinuteVal = selectedDate.get("start_minute");
    String endHourVal = selectedDate.get("end_hour");
    String endMinuteVal = selectedDate.get("end_minute");
    LOGGER.debug("Submitting mapped time to datepicker: {}:{} - {}:{}", startHourVal,
        startMinuteVal, endHourVal, endMinuteVal);

    String startYearPickerXpath = f(CREATION_TIME_FILTER_DATEPICKER_YEAR, startYearVal);
    String startMonthPickerXpath = f(CREATION_TIME_FILTER_DATEPICKER_MONTH, startYearVal,
        startMonthVal);
    String startDayPickerXpath = f(CREATION_TIME_FILTER_DATEPICKER_DAY, startYearVal, startMonthVal,
        startDayVal);
    String startHourPickerXpath = f(CREATION_TIME_FILTER_TIMEPICKER_HOUR, startHourVal);
    String startMinutePickerXpath = f(CREATION_TIME_FILTER_TIMEPICKER_MINUTE, startMinuteVal);
    String endHourPickerXpath = f(CREATION_TIME_FILTER_TIMEPICKER_HOUR, endHourVal);
    String endMinutePickerXpath = f(CREATION_TIME_FILTER_TIMEPICKER_MINUTE, endMinuteVal);
    // Wait until datepicker field shows up
    waitUntilVisibilityOfElementLocated(startDatepickerFieldXpath);

    // Click on datepicker field
    doWithRetry(() -> {
      do {
        click(startDatepickerFieldXpath);
        Assertions.assertThat(isElementExist(CREATION_TIME_FILTER_DROPDOWN))
            .as("Start datepicker is displayed")
            .isTrue();
      }
      while (!waitUntilVisibilityOfElementLocated(selectYearButtonXpath).isDisplayed());
    }, "Clicking datepicker field until it's showing...");

    // Select start year
    click(selectYearButtonXpath);
    waitUntilVisibilityOfElementLocated(startYearPickerXpath);
    click(startYearPickerXpath);
    waitUntilInvisibilityOfElementLocated(startYearPickerXpath);

    // Select start month
    click(selectMonthButtonXpath);
    waitUntilVisibilityOfElementLocated(startMonthPickerXpath);
    click(startMonthPickerXpath);
    waitUntilInvisibilityOfElementLocated(startMonthPickerXpath);

    // Select start day
    click(startDayPickerXpath);

    // Select start hour
    click(startHourPickerXpath);

    // Select start minute
    click(startMinutePickerXpath);

    doWithRetry(() -> {
      click(endDatepickerFieldXpath);
      Assertions.assertThat(isElementExist(CREATION_TIME_FILTER_DROPDOWN))
          .as("End datepicker is displayed")
          .isTrue();
    }, "Clicking datepicker field until it's showing...");
    pause400ms(); // wait for the focus change

    // Select end day (same as start day)
    if(!isElementVisible(startDayPickerXpath)){
      nextMonthButton.click();
    }
    click(startDayPickerXpath);

    // Select end hour
    click(endHourPickerXpath);

    // Select end minute
    click(endMinutePickerXpath);

    // Click ok only when submitting end datetime
    click(CREATION_TIME_FILTER_OK);

    // Wait until datepicker disappear
    waitUntilInvisibilityOfElementLocated(CREATION_TIME_FILTER_DROPDOWN);
  }

  public int getAddressDownloadResultCount() {
    WebElement resultsTextEl = webDriver.findElement(By.xpath(
        "//div[contains(@class, 'ant-card-body')]/span/span[contains(text(), 'Showing')]"));
    String resultText = resultsTextEl.getText();

    return Integer.parseInt(resultText.split(" ")[1]);
  }

  public boolean expandTimeRangeAndReloadAddress(LocalDateTime time) {
    LocalDateTime shiftedTime = time.plus(Duration.of(-10, ChronoUnit.MINUTES));
    Map<String, String> expandedTimeRange = generateDateTimeRange(shiftedTime, 60);
    LOGGER.debug("Time is temporarily set from {} to {}", time, shiftedTime);
    LOGGER.debug("Mapped expanded time range: {}", expandedTimeRange);
    setCreationTimeDatepicker(expandedTimeRange);
    waitUntilInvisibilityOfElementLocated(LOAD_ADDRESS_BUTTON_LOADING_ICON);
    loadAddresses.click();

    return getAddressDownloadResultCount() > 0;
  }

  public String resolveLatLongStringValue(Double latLong) {
    String stringifiedLatLong = latLong.toString();
    return (stringifiedLatLong.endsWith(".0")) ? String.valueOf(Math.round(latLong))
        : stringifiedLatLong;
  }

  public void setNewShipperOnShipperFilter(String newShipper) {
    String shipperFilterItem = f(PRESET_DIALOG_MULTISELECT_FILTER_ITEM, "Shipper");
    String shipperFilterItemDelete = f(PRESET_DIALOG_MULTISELECT_FILTER_DELETE, "Shipper");

    // Delete current shipper if exists
    if (isElementExist(shipperFilterItem)) {
      pause300ms(); // wait for filter item to be fully loaded
      click(shipperFilterItemDelete);
      waitUntilInvisibilityOfElementLocated(shipperFilterItem);
    }

    // Set a new shipper
    filterDropDown.click();
    filterInput.sendKeys(newShipper);
    waitUntilVisibilityOfElementLocated(f(FILTERING_RESULT_XPATH, newShipper));
    click(f(FILTERING_RESULT_XPATH, newShipper));
    click(RANDOM_CLICK_XPATH);
  }

  public boolean compareUpdatedCreationTimeValue(String newValue) {
    WebElement startDateField = findElementByXpath(
        f(CREATION_TIME_FILTER_DATEPICKER_FIELD, "Start"));
    WebElement endDateField = findElementByXpath(f(CREATION_TIME_FILTER_DATEPICKER_FIELD, "End"));

    String startTimeValue = startDateField.getAttribute("value").split(" ")[1];
    String endTimeValue = endDateField.getAttribute("value").split(" ")[1];

    return newValue.equals(startTimeValue + "-" + endTimeValue);
  }

  public void scrollDownAddressTable() {
    while (!isElementExist(
        "//div[contains(@class, 'table-container')]/div[contains(text(), 'End of Table')]")) {
      scrollIntoView("(//tr)[last()]");
    }
  }
}
