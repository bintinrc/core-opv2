package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.Waypoint;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.util.NvCountry;
import co.nvqa.commons.util.NvLogger;
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class AddressingDownloadPage extends OperatorV2SimplePage {

  @FindBy(xpath = "//iframe[contains(@src,'address-download')]")
  private PageElement pageFrame;

  @FindBy(xpath = "//button[contains(@class,'dropdown-trigger')]")
  public PageElement ellipses;

  @FindBy(xpath = "//*[local-name()='svg' and @data-icon='plus']")
  public PageElement createNewPreset;

  @FindBy(xpath = "//*[local-name()='svg' and @data-icon='pen']")
  public PageElement editPreset;

  @FindBy(xpath = "//label[text()='Name']/following-sibling::input")
  public PageElement inputPresetName;

  @FindBy(xpath = "//button[@data-testid='add-filter-button']")
  public PageElement filterButton;

  @FindBy(xpath = "//div[contains(@class,'select-filters-holder')]//div[contains(@class,'select-show')]")
  public PageElement filterDropDown;

  @FindBy(xpath = "//div[@label='Verified']")
  public PageElement verifiedOption;

  @FindBy(xpath = "//div[@label='Unverified']")
  public PageElement unverifiedOption;

  @FindBy(xpath = "//div[@label='Yes']")
  public PageElement yesRtsOption;

  @FindBy(xpath = "//div[@label='No']")
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
  @FindBy(xpath = "//button[@class='ant-btn']")
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

  private static final String EXISTED_PRESET_SELECTION_XPATH = "//div[contains(@class,'address')]//input[contains(@id,'rc_select')]";
  private static final String DROP_DOWN_PRESET_XPATH = "//ul[contains(@class,'dropdown-menu-root')]";
  private static final String DIALOG_XPATH = "//div[contains(@id,'rcDialogTitle')]";
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

  private static final String CREATION_TIME_FILTER_DATEPICKER_FIELD = "//div[contains(@class, 'ant-picker-range')]//input[@placeholder='%s date']";
  private static final String CREATION_TIME_FILTER_DROPDOWN = "//div[contains(@class, 'ant-picker-dropdown')]";
  private static final String CREATION_TIME_FILTER_DATEPICKER_YEAR = "//td[contains(@class, 'ant-picker-cell') and @title='%s']";
  private static final String CREATION_TIME_FILTER_DATEPICKER_MONTH = "//td[contains(@class, 'ant-picker-cell') and @title='%s-%s']";
  private static final String CREATION_TIME_FILTER_DATEPICKER_DAY = "//td[contains(@class, 'ant-picker-cell') and @title='%s-%s-%s']";
  private static final String CREATION_TIME_FILTER_TIMEPICKER_HOUR = "//ul[position()=1]//div[contains(@class, 'ant-picker-time-panel-cell-inner') and contains(text(), '%s')]";
  private static final String CREATION_TIME_FILTER_TIMEPICKER_MINUTE = "//ul[position()=2]//div[contains(@class, 'ant-picker-time-panel-cell-inner') and contains(text(), '%s')]";
  private static final String CREATION_TIME_FILTER_OK = "//li[@class='ant-picker-ok']/button";
  private static final String ORDER_DATA_CELL_XPATH = "//td[@class='%s']";

  private static final DateTimeFormatter DATE_FORMAT = DateTimeFormatter
      .ofPattern("yyyy-MM-dd_HH-mm");
  // zone id should be depend on the machine, by far. Tested locally using ID, hopefully bamboo machine is in SG
  // issue is addressed in https://jira.ninjavan.co/browse/SORT-965
  private static final ZonedDateTime ZONED_DATE_TIME = DateUtil.getDate(ZoneId.of(NvCountry.SG
      .getTimezone()));
  private static final String DATE_TIME = ZONED_DATE_TIME.format(DATE_FORMAT);
  private static final String CSV_FILENAME_FORMAT = TestConstants.ADDRESSING_PRESET_NAME + "_";

  private static final DateTimeFormatter ADDRESS_DOWNLOAD_DATE_FORMAT = DateTimeFormatter.ofPattern("yyyy/MM/dd hh:mm");

  public AddressingDownloadPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void switchToIframe() {
    getWebDriver().switchTo().frame(pageFrame.getWebElement());
  }

  public void verifiesPageIsFullyLoaded() {
    isElementExist(EXISTED_PRESET_SELECTION_XPATH);
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

      default:
        NvLogger.warn("Invalid Address Download Filter Type");
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
        filterDropDown.click();
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
        filterDropDown.click();
        yesRtsOption.click();
        break;

      case RTS_YES:
        filterDropDown.click();
        noRtsOption.click();
        break;

      default:
        NvLogger.warn("Invalid Address Download Filter Type");
    }
    click(RANDOM_CLICK_XPATH);
    pause1s();
  }

  public void verifiesPresetIsExisted(String presetName) {
    getWebDriver().navigate().refresh();
    switchToIframe();
    click(EXISTED_PRESET_SELECTION_XPATH);
    sendKeys(EXISTED_PRESET_SELECTION_XPATH, presetName);
    waitUntilVisibilityOfElementLocated(f(PRESET_TO_BE_SELECTED_XPATH, presetName));
    assertTrue("Preset is Existed", isElementExist(f(PRESET_TO_BE_SELECTED_XPATH, presetName)));
  }

  public void verifiesPresetIsNotExisted(String presetName) {
    getWebDriver().navigate().refresh();
    switchToIframe();
    click(EXISTED_PRESET_SELECTION_XPATH);
    sendKeys(EXISTED_PRESET_SELECTION_XPATH, presetName);
    waitUntilVisibilityOfElementLocated(PRESET_NOT_FOUND_XPATH);
    assertTrue("Preset is Deleted", isElementExist(PRESET_NOT_FOUND_XPATH));
  }

  public void csvDownloadSuccessfullyAndContainsTrackingId(List<Order> orders) {
    String csvContainedFileName = CSV_FILENAME_FORMAT + DATE_TIME;
    NvLogger.infof("Looking for CSV with Name contained %s", csvContainedFileName);
    String csvFileName = retryIfAssertionErrorOccurred(() ->
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
    assertTrue(f("Tracking ID %s is found", trackingId), isTrackingIdFound);
  }

  public void addressUiChecking(String address1, String address2) {
    List<WebElement> address1Element;
    List<WebElement> address2Element;
    boolean isAddress1Found = false;
    boolean isAddress2Found = false;
    address1Element = webDriver.findElements(By.xpath(TO_ADDRESS_1_COLUMN_XPATH));
    address2Element = webDriver.findElements(By.xpath(TO_ADDRESS_2_COLUMN_XPATH));

    for (WebElement weAdd1 : address1Element) {
      if (address1.equalsIgnoreCase(weAdd1.getText())) {
        isAddress1Found = true;
        break;
      }
    }

    for (WebElement weAdd2 : address2Element) {
      if (address2.equalsIgnoreCase(weAdd2.getText())) {
        isAddress2Found = true;
        break;
      }
    }

    assertTrue(f("Address 1 %s is found", address1), isAddress1Found);
    assertTrue(f("Address 2 %s is found", address2), isAddress2Found);
  }

  public void rtsOrderIsIdentified() {
    List<WebElement> isRtsWebElement;
    final String YES = "Yes";
    boolean isRtsFound = false;
    isRtsWebElement = webDriver.findElements(By.xpath(IS_RTS_COLUMN_XPATH));

    for (WebElement we : isRtsWebElement) {
      if (YES.equalsIgnoreCase(we.getText())) {
        isRtsFound = true;
        break;
      }
    }
    assertTrue("RTS Order Identified", isRtsFound);
  }

  public Map<String, String> generateDateTimeRange(LocalDateTime orderCreationLocalDateTime) {
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
    int currentHour = (orderCreationLocalDateTime.minus(Duration.of(1, ChronoUnit.HOURS))).getHour();

    int currentMinuteFloored = ((int) Math.floor((float) currentMinute / 30)) * 30; // Return 00 or 30
    String currentMinuteFlooredAsString = currentMinuteFloored == 0 ? f("0%d", currentMinuteFloored) : f("%d", currentMinuteFloored);
    String currentHourAsString = currentHour < 10 ? f("0%d", currentHour) : f("%d", currentHour);

    LocalTime startTime = LocalTime.parse(f("%s:%s", currentHourAsString, currentMinuteFlooredAsString), timeFormatter);
    LocalTime endTime = startTime.plus(Duration.of(30, ChronoUnit.MINUTES));

    Map<String, String> dateTimeRange = new HashMap<>();

    dateTimeRange.put("start_decade", f("%d-%d", currentDecadeStart, currentDecadeEnd));
    dateTimeRange.put("start_year", String.valueOf(currentYear));
    dateTimeRange.put("start_month", monthFormatter.format(orderCreationLocalDateTime));
    dateTimeRange.put("start_day", dayFormatter.format(orderCreationLocalDateTime));

    dateTimeRange.put("start_hour", hourFormatter.format(startTime));
    dateTimeRange.put("start_minute", minuteFormatter.format(startTime));

    dateTimeRange.put("end_hour", hourFormatter.format(endTime));
    dateTimeRange.put("end_minute", minuteFormatter.format(endTime));

    NvLogger.infof("Set time range to creation time filter to %s:%s - %s:%s", dateTimeRange.get("start_hour"), dateTimeRange.get("start_minute"), dateTimeRange.get("end_hour"), dateTimeRange.get("end_minute"));

    return dateTimeRange;
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

    String startYearPickerXpath = f(CREATION_TIME_FILTER_DATEPICKER_YEAR, startYearVal);
    String startMonthPickerXpath = f(CREATION_TIME_FILTER_DATEPICKER_MONTH, startYearVal, startMonthVal);
    String startDayPickerXpath = f(CREATION_TIME_FILTER_DATEPICKER_DAY, startYearVal, startMonthVal, startDayVal);
    String startHourPickerXpath = f(CREATION_TIME_FILTER_TIMEPICKER_HOUR, startHourVal);
    String startMinutePickerXpath = f(CREATION_TIME_FILTER_TIMEPICKER_MINUTE, startMinuteVal);
    String endHourPickerXpath = f(CREATION_TIME_FILTER_TIMEPICKER_HOUR, endHourVal);
    String endMinutePickerXpath = f(CREATION_TIME_FILTER_TIMEPICKER_MINUTE, endMinuteVal);

    click(startDatepickerFieldXpath);
    waitUntilVisibilityOfElementLocated(CREATION_TIME_FILTER_DROPDOWN);

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

    click(endDatepickerFieldXpath);
    waitUntilVisibilityOfElementLocated(CREATION_TIME_FILTER_DROPDOWN);

    // Select end day (same as start day)
    click(startDayPickerXpath);

    // Select end hour
    click(endHourPickerXpath);

    // Select end minute
    click(endMinutePickerXpath);

    // Click ok only when submitting end datetime
    click(CREATION_TIME_FILTER_OK);

    waitUntilInvisibilityOfElementLocated(CREATION_TIME_FILTER_DROPDOWN);
  }

  public void basicOrderDataUIChecking(Order order, Waypoint waypoint) {
    List<WebElement> trackingIDEl= webDriver.findElements(By.xpath(f(ORDER_DATA_CELL_XPATH, "tracking_number")));
    List<WebElement> addressOneEl= webDriver.findElements(By.xpath(f(ORDER_DATA_CELL_XPATH, "address_one")));
    List<WebElement> addressTwoEl= webDriver.findElements(By.xpath(f(ORDER_DATA_CELL_XPATH, "address_two")));
    List<WebElement> createdAtEl = webDriver.findElements(By.xpath(f(ORDER_DATA_CELL_XPATH, "created_at")));
    List<WebElement> postcodeEl= webDriver.findElements(By.xpath(f(ORDER_DATA_CELL_XPATH, "postcode")));
    List<WebElement> waypointIDEl= webDriver.findElements(By.xpath(f(ORDER_DATA_CELL_XPATH, "waypoint_id")));
    List<WebElement> latitudeEl= webDriver.findElements(By.xpath(f(ORDER_DATA_CELL_XPATH, "latitude")));
    List<WebElement> longitudeEl= webDriver.findElements(By.xpath(f(ORDER_DATA_CELL_XPATH, "longitude")));

    Map<String, Boolean> verifyChecklist = new HashMap<>();
    verifyChecklist.put("isTrackingIDFound", false);
    verifyChecklist.put("isAddressOneFound", false);
    verifyChecklist.put("isAddressTwoFound", false);
    verifyChecklist.put("isCreatedAtFound", false);
    verifyChecklist.put("isPostcodeFound", false);
    verifyChecklist.put("isWaypointIDFound", false);
    verifyChecklist.put("isLatitudeFound", false);
    verifyChecklist.put("isLongitudeFound", false);

    WebElement resultsTextEl = webDriver.findElement(By.xpath("//div[contains(@class, 'ant-card-body')]/span/span[contains(text(), 'Showing')]"));
    String resultText = resultsTextEl.getText();
    int resultsCount = Integer.parseInt(resultText.substring(8,9));
    int verificationsPassed = 0;

    LocalDateTime orderCreationTimestamp = order.getCreatedAt().toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime().minus(
        Duration.of(1, ChronoUnit.HOURS));

    for (int i = 0; i < resultsCount; i++) {
      if (order.getTrackingId().equalsIgnoreCase(trackingIDEl.get(i).getText())) {
        verifyChecklist.put("isTrackingIDFound", true);
      }

      if (order.getToAddress1().equalsIgnoreCase(addressOneEl.get(i).getText())) {
        verifyChecklist.put("isAddressOneFound", true);
      }

      if (order.getToAddress2().equalsIgnoreCase(addressTwoEl.get(i).getText())) {
        verifyChecklist.put("isAddressTwoFound", true);
      }

      if (ADDRESS_DOWNLOAD_DATE_FORMAT.format(orderCreationTimestamp).equals(createdAtEl.get(i).getText())) {
        verifyChecklist.put("isCreatedAtFound", true);
      }

      if (order.getToPostcode().equalsIgnoreCase(postcodeEl.get(i).getText())) {
        verifyChecklist.put("isPostcodeFound", true);
      }

      if (waypoint.getId() == Long.parseLong(waypointIDEl.get(i).getText())) {
        verifyChecklist.put("isWaypointIDFound", true);
      }

      if (waypoint.getLatitude() == Double.parseDouble(latitudeEl.get(i).getText())) {
        verifyChecklist.put("isLatitudeFound", true);
      }

      if (waypoint.getLongitude() == Double.parseDouble(longitudeEl.get(i).getText())) {
        verifyChecklist.put("isLongitudeFound", true);
      }

      verificationsPassed = verifyChecklist.entrySet()
          .stream()
          .filter(map -> map.getValue())
          .collect(Collectors.toMap(map -> map.getKey(), map -> true)).size();

      if (verificationsPassed >= verifyChecklist.size()) break;
    }

    if (verificationsPassed < verifyChecklist.size()) {
      Map<String, Boolean> verificationFailed = verifyChecklist.entrySet()
          .stream()
          .filter(map -> !map.getValue())
          .collect(Collectors.toMap(map -> map.getKey(), map -> false));

      for (String key : verificationFailed.keySet()) {
        NvLogger.infof("%s checking result is FAILED", key);
      }
    }

    assertTrue("All data are correct", verificationsPassed == verifyChecklist.size());
  }

  public void csvDownloadSuccessfullyAndContainsBasicData(Order order, Waypoint waypoint) {
    String csvContainedFileName = CSV_FILENAME_FORMAT;
    NvLogger.infof("Looking for CSV with Name contained %s", csvContainedFileName);
    String csvFileName = retryIfAssertionErrorOccurred(() ->
            getContainedFileNameDownloadedSuccessfully(csvContainedFileName),
        "Getting Exact File Name");

    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy/MM/dd hh:mm");
    LocalDateTime orderCreationTimestamp = order.getCreatedAt().toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime().minus(
        Duration.of(1, ChronoUnit.HOURS));

    verifyFileDownloadedSuccessfully(csvFileName, order.getTrackingId());
    verifyFileDownloadedSuccessfully(csvFileName, order.getToAddress1());
    verifyFileDownloadedSuccessfully(csvFileName, order.getToAddress2());
    verifyFileDownloadedSuccessfully(csvFileName, dtf.format(orderCreationTimestamp));
    verifyFileDownloadedSuccessfully(csvFileName, order.getToPostcode());
    verifyFileDownloadedSuccessfully(csvFileName, waypoint.getId().toString());
    verifyFileDownloadedSuccessfully(csvFileName, waypoint.getLatitude().toString());
    verifyFileDownloadedSuccessfully(csvFileName, waypoint.getLongitude().toString());
  }
}
