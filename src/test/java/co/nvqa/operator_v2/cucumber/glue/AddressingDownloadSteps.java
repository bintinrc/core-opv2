package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.core.model.order.Order;
import co.nvqa.common.utils.RandomUtil;
import co.nvqa.common.utils.StandardTestConstants;
import co.nvqa.operator_v2.model.AddressDownloadFilteringType;
import co.nvqa.operator_v2.selenium.page.AddressingDownloadPage;
import co.nvqa.operator_v2.util.TestConstants;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.Keys;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class AddressingDownloadSteps extends AbstractSteps {

  private AddressingDownloadPage addressingDownloadPage;

  private static final String TIME_BRACKET_ALL_DAY = "ALL_DAY";
  private static final String TIME_BRACKET_DAY_SLOT = "DAY_SLOT";
  private static final String TIME_BRACKET_NIGHT_SLOT = "NIGHT_SLOT";
  private static final Logger LOGGER = LoggerFactory.getLogger(AddressingDownloadSteps.class);

  public AddressingDownloadSteps() {
  }

  @Override
  public void init() {
    addressingDownloadPage = new AddressingDownloadPage(getWebDriver());
  }

  @Then("Operator verifies that the page is fully loaded")
  public void operatorVerifiesThatThePageIsFullyLoaded() {
    addressingDownloadPage.switchToIframe();
    addressingDownloadPage.verifiesPageIsFullyLoaded();
  }

  @When("Operator clicks on the ellipses")
  public void operatorClicksOnTheEllipses() {
    addressingDownloadPage.ellipses.waitUntilVisible();
    addressingDownloadPage.ellipses.click();
    addressingDownloadPage.verifiesOptionIsShown();
  }

  @And("Operator clicks on {string} Preset Option on the Address Download Page")
  public void clicksOnOptionOnTheAddressDownloadPage(String option) {
    final String CREATE = "create";
    final String EDIT = "edit";

    if (CREATE.equalsIgnoreCase(option)) {
      addressingDownloadPage.createNewPreset.click();
    } else if (EDIT.equalsIgnoreCase(option)) {
      addressingDownloadPage.editPreset.click();
    }
    addressingDownloadPage.verifiesModalIsShown();
  }

  @And("Operator creates a preset using {string} filter")
  public void operatorCreatesAPresetUsingFilter(String filter) {
    AddressDownloadFilteringType filterType = AddressDownloadFilteringType.fromString(filter);
    String presetName =
        "AUTO-" + StandardTestConstants.NV_SYSTEM_ID.toUpperCase() + "-" + RandomUtil.randomString(
            7);

    addressingDownloadPage.inputPresetName.sendKeys(presetName);

    doWithRetry(() -> {
      addressingDownloadPage.filterButton.click();
      pause1s();
      addressingDownloadPage.selectPresetFilter(filterType);
      Assertions.assertThat(
              addressingDownloadPage.isElementExistFast(addressingDownloadPage.FILTER_SHOWN_XPATH))
          .isTrue();
    }, "Clicking Filter for Preset");

    addressingDownloadPage.waitUntilInvisibilityOfElementLocated(
        addressingDownloadPage.LOAD_ADDRESS_BUTTON_LOADING_ICON);
    addressingDownloadPage.setPresetFilter(filterType);
    addressingDownloadPage.mainPresetButtonInModal.click();
    put(KEY_CREATED_ADDRESS_PRESET_NAME, presetName);
  }

  @Then("Operator verifies that there will be success preset creation toast shown")
  public void operatorVerifiesThatThereWillBeSuccessPresetCreationToastShown() {
    addressingDownloadPage.waitUntilVisibilityOfToastReact("Preset Created");
  }

  @And("Operator verifies that the created preset is existed")
  public void operatorVerifiesThatTheCreatedPresetIsExisted(Map<String,String>dataTableAsMap) {
    String presetName = resolveValue(dataTableAsMap.get("preset"));
    addressingDownloadPage.verifiesPresetIsExisted(presetName);
  }

  @When("Operator deletes the created preset")
  public void operatorDeletesTheCreatedPreset(Map<String,String>dataTableAsMap) {
    String presetName = resolveValue(dataTableAsMap.get("preset"));
    addressingDownloadPage.ellipses.click();
    addressingDownloadPage.verifiesOptionIsShown();
    addressingDownloadPage.editPreset.click();
    addressingDownloadPage.verifiesModalIsShown();
    addressingDownloadPage.selectPresetEditModal.click();
    addressingDownloadPage.selectPresetEditModal.sendKeys(presetName);
    addressingDownloadPage.selectPresetEditModal.sendKeys(Keys.ENTER);
    addressingDownloadPage.deletePresetButton.click();
    addressingDownloadPage.mainPresetButtonInModal.click();
  }

  @Then("Operator verifies that there will be success preset deletion toast shown")
  public void operatorVerifiesThatThereWillBeSuccessPresetDeletionToastShown() {
    addressingDownloadPage.waitUntilVisibilityOfToastReact("Preset Deleted");
  }

  @And("Operator verifies that the created preset is deleted")
  public void operatorVerifiesThatTheCreatedPresetIsDeleted(Map<String,String>dataTableAsMap) {
    String presetName = resolveValue(dataTableAsMap.get("preset"));
    doWithRetry(() -> {
      if (!addressingDownloadPage.loadAddresses.isDisplayed()) {
        addressingDownloadPage.refreshPage();
      }
    }, "refresh page until element is shown");

    addressingDownloadPage.verifiesPresetIsNotExisted(presetName);
  }

  @And("Operator edits the created preset")
  public void operatorEditsTheCreatedPreset() {
    String presetName = get(KEY_CREATED_ADDRESS_PRESET_NAME);
    addressingDownloadPage.selectPresetEditModal.click();
    addressingDownloadPage.selectPresetEditModal.sendKeys(presetName);
    addressingDownloadPage.selectPresetEditModal.sendKeys(Keys.ENTER);

    String newPresetName =
        "AUTO-" + StandardTestConstants.NV_SYSTEM_ID.toUpperCase() + "-" + RandomUtil.randomString(
            7);
    pause2s();
    addressingDownloadPage.inputPresetName.sendKeys(newPresetName);
    addressingDownloadPage.mainPresetButtonInModal.click();
    put(KEY_CREATED_ADDRESS_PRESET_NAME, presetName + newPresetName);
  }

  @Then("Operator verifies that there will be success preset edit toast shown")
  public void operatorVerifiesThatThereWillBeSuccessPresetEditToastShown() {
    addressingDownloadPage.waitUntilVisibilityOfToastReact("Preset Edited");
  }

  @When("Operator clicks on Load Tracking IDs Button")
  public void operatorClicksOnLoadTrackingIDsButton() {
    pause5s();
    addressingDownloadPage.loadTrackingIds.click();
    addressingDownloadPage.verifiesModalIsShown();
  }

  @And("Operator fills the {string} Tracking ID textbox with {string} separation")
  public void operatorFillsTheTrackingIDTextboxWithSeparation(String trackingIdType,
      String separation,List<String>trackingIds) {
  List<String> trackingId =resolveValues(trackingIds);
    // Tracking ID type
    final String VALID = "valid";
    final String HALF = "half";

    // Separation
    final String COMMA = "comma";
    final String SPACE = "space";
    final String NEW_LINE = "new_line";
    final String MIXED = "mixed";

    pause5s();

    if (VALID.equalsIgnoreCase(trackingIdType)) {
      if (COMMA.equalsIgnoreCase(separation)) {
        addressingDownloadPage.trackingIdtextArea.sendKeys(String.join(",", trackingId).replaceAll("[\\[\\]]", ""));
      } else if (SPACE.equalsIgnoreCase(separation)) {
        addressingDownloadPage.trackingIdtextArea.sendKeys(String.join(" ", trackingId).replaceAll("[\\[\\]]", ""));
      } else if (NEW_LINE.equalsIgnoreCase(separation)) {
        addressingDownloadPage.trackingIdtextArea.sendKeys(String.join("\n",trackingId).replaceAll("[\\[\\]]", ""));
      } else if (MIXED.equalsIgnoreCase(separation)) {
        for (int i = 0; i < trackingIds.size(); i++) {
          if (i == 0) {
            addressingDownloadPage.trackingIdtextArea.sendKeys(trackingId.get(i).replaceAll("[\\[\\]]", "") + ",");
          } else if (i > 0 && i % 2 == 0) {
            addressingDownloadPage.trackingIdtextArea.sendKeys(trackingId.get(i).replaceAll("[\\[\\]]", "") + " ");
          } else {
            addressingDownloadPage.trackingIdtextArea.sendKeys(trackingId.get(i).replaceAll("[\\[\\]]", "")+ "\n");
          }
        }
      } else {
        LOGGER.warn("Separation is not found!");
      }
    } else if (HALF.equalsIgnoreCase(trackingIdType)) {
      final String invalidTrackingId = "AUTOTEST" + RandomUtil.randomString(5);
      trackingId.add(invalidTrackingId);
      addressingDownloadPage.trackingIdtextArea.sendKeys(String.join(",", trackingId).replaceAll("[\\[\\]]", ""));
    } else {
      LOGGER.warn("Automation only covered VALID and HALF VALID HALF INVALID types");
    }
  }

  @And("Operator clicks on Next Button on Address Download Load Tracking ID modal")
  public void operatorClicksOnNextButtonOnAddressDownloadLoadTrackingIDModal() {
    pause1s();
    addressingDownloadPage.nextButtonLoadTrackingId.click();
  }

  @Then("Operator verifies that the Address Download Table Result is shown up")
  public void operatorVerifiesThatTheAddressDownloadTableResultIsShownUp(
      Map<String, String> dataTableAsMap) {
    addressingDownloadPage.addressDownloadTableResult.isDisplayed();
    addressingDownloadPage.scrollDownAddressTable();
    List<String> trackingIds = get(dataTableAsMap.get("trackingId"));
    for (String trackingId : trackingIds) {
      addressingDownloadPage.trackingIdUiChecking(trackingId.replaceAll("[\\[\\]]", ""));
    }
  }

  @Then("Operator verifies that the Address Download Table Result for bulk tracking ids is shown up")
  public void operatorVerifiesThatTheAddressDownloadTableResultForBulkTrackingIdsIsShownUp() {
    if (addressingDownloadPage.trackingIdNotFound.isDisplayed()) {
      addressingDownloadPage.nextButtonLoadTrackingId.click();
    }
  }

  @When("Operator clicks on download csv button on Address Download Page")
  public void operatorClicksOnDownloadCsvButtonOnAddressDownloadPage() {
    String addressDownloadStats = addressingDownloadPage.ADDRESS_DOWNLOAD_STATS;

    addressingDownloadPage.downloadCsv.click();

    LocalDateTime formattedDateTime = Instant.now().atZone(ZoneId.of(addressingDownloadPage.SYS_ID))
        .toLocalDateTime();
    String csvTimestamp = AddressingDownloadPage.DATE_FORMAT.format(formattedDateTime);

    // Get the file timestamp ASAP to reduce time latency
    put(KEY_DOWNLOADED_CSV_TIMESTAMP, csvTimestamp);

    addressingDownloadPage.waitUntilVisibilityOfElementLocated(addressDownloadStats);
    addressingDownloadPage.waitUntilInvisibilityOfElementLocated(addressDownloadStats);

    // Wait 1 seconds at most to complete the downloads to avoid .crdownload files
    pause1s();
  }

  @Then("Operator verifies that the downloaded csv file details of Address Download is right")
  public void operatorVerifiesThatTheDownloadedCsvFileDetailsOfAddressDownloadIsRight(
      Map<String, String> dataTableAsMap) {

    List<Order> orders = get(dataTableAsMap.get("order"));
    String csvTimestamp = get(dataTableAsMap.get("csvTime"));

    addressingDownloadPage.csvDownloadSuccessfullyAndContainsTrackingId(orders, csvTimestamp);
  }

  @Then("Operator verifies there will be error dialog shown and clicks on next button")
  public void operatorVerifiesThereWillBeErrorDialogShownAndClicksOnNextButton() {
    addressingDownloadPage.verifiesModalIsShown();
    addressingDownloadPage.trackingIdNotFound.isDisplayed();
    addressingDownloadPage.nextButtonLoadTrackingId.click();
  }

  @And("Operator verifies that the RTS order is identified")
  public void operatorVerifiesThatTheRTSOrderIsIdentified() {
    addressingDownloadPage.rtsOrderIsIdentified();
  }

  @Then("Operator verifies that newly created order is not written in the textbox")
  public void operatorVerifiesThatNewlyCreatedOrderIsNotWrittenInTheTextbox(Map<String, String> data) {
    String trackingId = data.get("trackingId");
    addressingDownloadPage.trackingIdtextArea.sendKeys("," + trackingId);
    String trackingIdsListed = addressingDownloadPage.trackingIdtextArea.getText();
    Assertions.assertThat(!(trackingIdsListed.contains("," + trackingId))).isTrue();
  }

  @When("Operator clicks on Load Address button")
  public void operatorClicksOnLoadAddressButton() {
    doWithRetry(() -> {
      addressingDownloadPage.waitUntilInvisibilityOfElementLocated(
          addressingDownloadPage.LOAD_ADDRESS_BUTTON_LOADING_ICON);
      addressingDownloadPage.loadAddresses.click();
      Assertions.assertThat(addressingDownloadPage.addressDownloadTableResult.isDisplayed())
          .as("Result table is displayed.").isTrue();
    }, "Clicking Load Addresses button until table is showing...");
  }

  @When("Operator selects preset {string}")
  public void operatorSelectsPresetName(String preset) {
    pause5s();
    String presetName = "";

    if (preset.equals("DEFAULT")) {
      presetName = TestConstants.ADDRESSING_PRESET_NAME;
    } else if (preset.equals("CREATED")) {
      presetName = get(KEY_CREATED_ADDRESS_PRESET_NAME);
    } else {
      presetName = preset;
    }

    addressingDownloadPage.selectPresetLoadAddresses.waitUntilVisible();
    String presetNameFieldValue = addressingDownloadPage.selectPresetLoadAddresses.getValue();

    if (presetNameFieldValue.equals("")) {
      addressingDownloadPage.selectPresetLoadAddresses.click();
      addressingDownloadPage.selectPresetLoadAddresses.sendKeys(presetName);
    }

    addressingDownloadPage.selectPresetLoadAddresses.sendKeys(Keys.ENTER);
    put(KEY_SELECTED_PRESET_NAME, presetName);
  }

  @And("Operator input the created order's creation time")
  public void operatorInputTheCreatedOrderSCreationTime(Map<String, String> dataTableAsMap) {
    doWithRetry(() -> {
      String trackingId = resolveValue(dataTableAsMap.get("trackingId"));
      String createdAt =resolveValue(dataTableAsMap.get("createdAt")).toString() ;
      // Define the format of the input string
      DateTimeFormatter formatter = DateTimeFormatter.ofPattern("EEE MMM dd HH:mm:ss zzz yyyy");

      // Parse the string to ZonedDateTime using the formatter and set the time zone to SGT
      ZonedDateTime zoneDateTime = ZonedDateTime.parse(createdAt, formatter.withZone(ZoneId.of(addressingDownloadPage.SYS_ID)));
      // Convert to local date and time
      LocalDateTime localDateTime = zoneDateTime.withZoneSameInstant(ZoneId.of(addressingDownloadPage.SYS_ID)).toLocalDateTime();
      Map<String, String> dateTimeRange = addressingDownloadPage.generateDateTimeRange(
          localDateTime, 30);

      LOGGER.debug("Order Tracking ID: {}",trackingId);
      LOGGER.debug("Mapped Order Creation Time: {}", dateTimeRange);

      addressingDownloadPage.setCreationTimeDatepicker(dateTimeRange);
    }, "Input Order Creation Time");


  }

  @Then("Operator verifies that the downloaded csv file contains all correct data")
  public void operatorVerifiesThatTheDownloadedCsvFileContainsAllCorrectData(
      Map<String, String> dataTableAsMap) {
    Map<String, String> data = resolveKeyValues(dataTableAsMap);
    String trackingId = resolveValue(data.get("trackingId"));
    Double latitude = Double.parseDouble(resolveValue(data.get("latitude")));
    Double longitude = Double.parseDouble(resolveValue(data.get("latitude")));
    String toAddress1 = resolveValue(data.get("toAddress1"));
    String toAddress2 = resolveValue(data.get("toAddress2"));
    String preset = resolveValue(data.get("preset"));
    LOGGER.debug("Looking for CSV with Name containing {}", preset);
    String csvFileName = doWithRetry(() ->
            addressingDownloadPage.getContainedFileNameDownloadedSuccessfully(preset),
        "Getting Exact File Name");
    addressingDownloadPage.verifyFileDownloadedSuccessfully(csvFileName, trackingId);
    addressingDownloadPage.verifyFileDownloadedSuccessfully(csvFileName,toAddress1 );
    addressingDownloadPage.verifyFileDownloadedSuccessfully(csvFileName, toAddress2);
    addressingDownloadPage.verifyFileDownloadedSuccessfully(csvFileName,
        addressingDownloadPage.resolveLatLongStringValue(longitude));
    addressingDownloadPage.verifyFileDownloadedSuccessfully(csvFileName,
        addressingDownloadPage.resolveLatLongStringValue(longitude));
  }

  @And("Operator edits selected preset")
  public void operatorEditsSelectedPreset() {
    String presetName = get(KEY_SELECTED_PRESET_NAME);
    addressingDownloadPage.selectPresetEditModal.click();
    addressingDownloadPage.selectPresetEditModal.sendKeys(presetName);
    addressingDownloadPage.selectPresetEditModal.sendKeys(Keys.ENTER);
  }

  @And("Operator sets new shipper to selected preset as {string}")
  public void operatorSetsNewShipperToSelectedPresetAs(String shipper) {
    String newShipper = "";

    if (shipper.equals("DEFAULT")) {
      newShipper = TestConstants.ADDRESSING_SHIPPER_NAME;
    } else {
      newShipper = shipper;
    }

    addressingDownloadPage.setNewShipperOnShipperFilter(newShipper);
  }

  @And("Operator adds {string} filter to selected preset")
  public void operatorAddsFilterToSelectedPreset(String filter) {
    AddressDownloadFilteringType filterType = AddressDownloadFilteringType.fromString(filter);

    doWithRetry(() -> {
      addressingDownloadPage.filterButton.click();
      pause1s();
      addressingDownloadPage.selectPresetFilter(filterType);
      Assertions.assertThat(
              addressingDownloadPage.isElementExistFast(addressingDownloadPage.FILTER_SHOWN_XPATH))
          .isTrue();
    }, "Clicking Filter for Preset");

    addressingDownloadPage.setPresetFilter(filterType);
  }

  @And("Operator save the new preset data")
  public void operatorSaveTheNewPresetData() {
    addressingDownloadPage.mainPresetButtonInModal.click();
  }

  @And("Operator input the new preset name")
  public void operatorInputTheNewPresetName() {
    String presetName =
        "AUTO-" + StandardTestConstants.NV_SYSTEM_ID.toUpperCase() + "-" + RandomUtil.randomString(
            7);

    addressingDownloadPage.inputPresetName.sendKeys(presetName);
    put(KEY_CREATED_ADDRESS_PRESET_NAME, presetName);
  }

  @And("Operator sets creation time filter to selected preset as {string}")
  public void operatorSetsCreationTimeFilterToSelectedPresetAs(String bracket) {
    /*
     * Possible time brackets: ALL_DAY (9-22), DAY_SLOT (9-18), NIGHT_SLOT (18-22)
     * */

    String timeRange = "";

    switch (bracket) {
      case TIME_BRACKET_ALL_DAY:
        timeRange = "09:00-22:00";
        break;

      case TIME_BRACKET_DAY_SLOT:
        timeRange = "09:00-18:00";
        break;

      case TIME_BRACKET_NIGHT_SLOT:
        timeRange = "18:00-22:00";
        break;

      default:
        Assertions.assertThat(true).as("Invalid time bracket given.").isFalse();
    }

    String[] timeRangePoints = timeRange.split("-");
    String startTimeString = timeRangePoints[0];
    String endTimeString = timeRangePoints[1];

    Map<String, String> timeRangeMap = new HashMap<>();

    String[] startTimes = startTimeString.split(":");
    timeRangeMap.put("start_hour", startTimes[0]);
    timeRangeMap.put("start_minute", startTimes[1]);

    String[] endTimes = endTimeString.split(":");
    timeRangeMap.put("end_hour", endTimes[0]);
    timeRangeMap.put("end_minute", endTimes[1]);

    LOGGER.debug("Mapped Time Range: {}", timeRangeMap);

    addressingDownloadPage.setPresetCreationTimeDatepicker(timeRangeMap);
    put(KEY_ADDRESSING_CREATION_TIME_FILTER, timeRange);
  }

  @And("Operator verifies that the creation time filter is updated")
  public void operatorVerifiesThatTheCreationTimeFilterIsUpdated() {
    String newCreationTime = get(KEY_ADDRESSING_CREATION_TIME_FILTER);

    boolean isTimeMatch = addressingDownloadPage.compareUpdatedCreationTimeValue(newCreationTime);

    Assertions.assertThat(isTimeMatch).as("The creation time value is updated.").isTrue();
  }

  @Then("Operator verifies that the Address Download Table Result contains {string}")
  public void operatorVerifiesThatTheAddressDownloadTableResultContainsString(String tracking) {
    String trackingId = resolveValue(tracking);
    String tableTrackingId = String.format(addressingDownloadPage.TRACKING_NUMBER_TABLE_XPATH, trackingId);
    Assertions.assertThat(addressingDownloadPage.isElementExist(tableTrackingId)).isTrue();
  }
}
