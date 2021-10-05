package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.Waypoint;
import co.nvqa.commons.support.RandomUtil;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.commons.util.StandardTestConstants;
import co.nvqa.operator_v2.model.AddressDownloadFilteringType;
import co.nvqa.operator_v2.selenium.page.AddressingDownloadPage;
import co.nvqa.operator_v2.util.TestConstants;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;

import java.sql.Timestamp;
import java.time.Duration;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.Date;

import org.openqa.selenium.Keys;
import org.openqa.selenium.WebElement;

public class AddressingDownloadSteps extends AbstractSteps {

  private AddressingDownloadPage addressingDownloadPage;

  private static final String TIME_BRACKET_ALL_DAY = "ALL_DAY";
  private static final String TIME_BRACKET_DAY_SLOT = "DAY_SLOT";
  private static final String TIME_BRACKET_NIGHT_SLOT = "NIGHT_SLOT";

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
        "AUTO-" + StandardTestConstants.COUNTRY_CODE.toUpperCase() + "-" + RandomUtil
            .randomString(7);

    addressingDownloadPage.inputPresetName.sendKeys(presetName);

    retryIfAssertionErrorOccurred(() -> {
          addressingDownloadPage.filterButton.click();
          pause1s();
              addressingDownloadPage.selectPresetFilter(filterType);
              assertTrue(addressingDownloadPage.isElementExistFast(addressingDownloadPage.FILTER_SHOWN_XPATH));
        },
        "Clicking Filter for Preset");

    addressingDownloadPage.setPresetFilter(filterType);
    addressingDownloadPage.mainPresetButtonInModal.click();
    put(KEY_CREATED_ADDRESS_PRESET_NAME, presetName);
  }

  @Then("Operator verifies that there will be success preset creation toast shown")
  public void operatorVerifiesThatThereWillBeSuccessPresetCreationToastShown() {
    addressingDownloadPage.waitUntilVisibilityOfToastReact("Preset Created");
  }

  @And("Operator verifies that the created preset is existed")
  public void operatorVerifiesThatTheCreatedPresetIsExisted() {
    String presetName = get(KEY_CREATED_ADDRESS_PRESET_NAME);
    addressingDownloadPage.verifiesPresetIsExisted(presetName);
  }

  @When("Operator deletes the created preset")
  public void operatorDeletesTheCreatedPreset() {
    String presetName = get(KEY_CREATED_ADDRESS_PRESET_NAME);
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
  public void operatorVerifiesThatTheCreatedPresetIsDeleted() {
    String presetName = get(KEY_CREATED_ADDRESS_PRESET_NAME);
    addressingDownloadPage.verifiesPresetIsNotExisted(presetName);
  }

  @And("Operator edits the created preset")
  public void operatorEditsTheCreatedPreset() {
    String presetName = get(KEY_CREATED_ADDRESS_PRESET_NAME);
    addressingDownloadPage.selectPresetEditModal.click();
    addressingDownloadPage.selectPresetEditModal.sendKeys(presetName);
    addressingDownloadPage.selectPresetEditModal.sendKeys(Keys.ENTER);

    String newPresetName =
        "AUTO-" + StandardTestConstants.COUNTRY_CODE.toUpperCase() + "-" + RandomUtil
            .randomString(7);
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
      String separation) {
    // Tracking ID type
    final String VALID = "valid";
    final String HALF = "half";

    // Separation
    final String COMMA = "comma";
    final String SPACE = "space";
    final String NEW_LINE = "new_line";
    final String MIXED = "mixed";

    pause5s();

    List<String> trackingIds = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);

    if (VALID.equalsIgnoreCase(trackingIdType)) {
      if (COMMA.equalsIgnoreCase(separation)) {
        addressingDownloadPage.trackingIdtextArea.sendKeys(String.join(",", trackingIds));
      } else if (SPACE.equalsIgnoreCase(separation)) {
        addressingDownloadPage.trackingIdtextArea.sendKeys(String.join(" ", trackingIds));
      } else if (NEW_LINE.equalsIgnoreCase(separation)) {
        addressingDownloadPage.trackingIdtextArea.sendKeys(String.join("\n", trackingIds));
      } else if (MIXED.equalsIgnoreCase(separation)) {
        for (int i = 0; i < trackingIds.size(); i++) {
          if (i == 0) {
            addressingDownloadPage.trackingIdtextArea.sendKeys(trackingIds.get(i) + ",");
          } else if (i > 0 && i % 2 == 0) {
            addressingDownloadPage.trackingIdtextArea.sendKeys(trackingIds.get(i) + " ");
          } else {
            addressingDownloadPage.trackingIdtextArea.sendKeys(trackingIds.get(i) + "\n");
          }
        }
      } else {
        NvLogger.warn("Separation is not found!");
      }
    } else if (HALF.equalsIgnoreCase(trackingIdType)) {
      final String invalidTrackingId = "AUTOTEST" + RandomUtil.randomString(5);
      trackingIds.add(invalidTrackingId);
      addressingDownloadPage.trackingIdtextArea.sendKeys(String.join(",", trackingIds));
    } else {
      NvLogger.warn("Automation only covered VALID and HALF VALID HALF INVALID types");
    }
  }

  @And("Operator clicks on Next Button on Address Download Load Tracking ID modal")
  public void operatorClicksOnNextButtonOnAddressDownloadLoadTrackingIDModal() {
    pause1s();
    addressingDownloadPage.nextButtonLoadTrackingId.click();
  }

  @Then("Operator verifies that the Address Download Table Result is shown up")
  public void operatorVerifiesThatTheAddressDownloadTableResultIsShownUp() {
    addressingDownloadPage.addressDownloadTableResult.isDisplayed();
    addressingDownloadPage.scrollDownAddressTable();
    if (get(KEY_LIST_OF_CREATED_ORDER) != null) {
      List<Order> orders = get(KEY_LIST_OF_CREATED_ORDER);
      for (Order order : orders) {
        addressingDownloadPage.trackingIdUiChecking(order.getTrackingId());
        addressingDownloadPage.addressUiChecking(order.getToAddress1(), order.getToAddress2());
      }
    } else {
      List<String> trackingIds = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);
      for (String trackingId : trackingIds) {
        addressingDownloadPage.trackingIdUiChecking(trackingId);
      }
    }
  }

  @Then("Operator verifies that the Address Download Table Result for bulk tracking ids is shown up")
  public void operatorVerifiesThatTheAddressDownloadTableResultForBulkTrackingIdsIsShownUp() {
    if (addressingDownloadPage.trackingIdNotFound.isDisplayed()) {
      addressingDownloadPage.nextButtonLoadTrackingId.click();
    }
    operatorVerifiesThatTheAddressDownloadTableResultIsShownUp();
  }

  @When("Operator clicks on download csv button on Address Download Page")
  public void operatorClicksOnDownloadCsvButtonOnAddressDownloadPage() {
    String addressDownloadStats = addressingDownloadPage.ADDRESS_DOWNLOAD_STATS;

    addressingDownloadPage.downloadCsv.click();

    LocalDateTime formattedDateTime = LocalDateTime.now().atZone(ZoneId.systemDefault()).toLocalDateTime().minus(Duration.of(8, ChronoUnit.HOURS));
    String csvTimestamp = AddressingDownloadPage.DATE_FORMAT.format(formattedDateTime);

    // Get the file timestamp ASAP to reduce time latency
    put(KEY_DOWNLOADED_CSV_TIMESTAMP, csvTimestamp);

    addressingDownloadPage.waitUntilVisibilityOfElementLocated(addressDownloadStats);
    addressingDownloadPage.waitUntilInvisibilityOfElementLocated(addressDownloadStats);

    // Wait 1 seconds at most to complete the downloads to avoid .crdownload files
    pause1s();
  }

  @Then("Operator verifies that the downloaded csv file details of Address Download is right")
  public void operatorVerifiesThatTheDownloadedCsvFileDetailsOfAddressDownloadIsRight() {
    List<Order> orders = get(KEY_LIST_OF_CREATED_ORDER);
    String csvTimestamp = get(KEY_DOWNLOADED_CSV_TIMESTAMP);

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
  public void operatorVerifiesThatNewlyCreatedOrderIsNotWrittenInTheTextbox() {
    String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
    addressingDownloadPage.trackingIdtextArea.sendKeys("," + trackingId);
    String trackingIdsListed = addressingDownloadPage.trackingIdtextArea.getText();
    assertTrue(!(trackingIdsListed.contains("," + trackingId)));
  }

  @When("Operator clicks on Load Address button")
  public void operatorClicksOnLoadAddressButton() {
    addressingDownloadPage.loadAddresses.click();
  }

  @When("Operator selects preset {string}")
  public void operatorSelectsPresetName(String preset) {
    String presetName = "";

    if (preset.equals("DEFAULT")) {
      presetName = TestConstants.ADDRESSING_PRESET_NAME;
    } else if (preset.equals("CREATED")) {
      presetName = get(KEY_CREATED_ADDRESS_PRESET_NAME);
    } else {
      presetName = preset;
    }

    String presetNameFieldValue = addressingDownloadPage.selectPresetLoadAddresses.getValue();

    if (presetNameFieldValue.equals("")) {
      addressingDownloadPage.selectPresetLoadAddresses.click();
      addressingDownloadPage.selectPresetLoadAddresses.sendKeys(presetName);
    }

    addressingDownloadPage.selectPresetLoadAddresses.sendKeys(Keys.ENTER);
    put(KEY_SELECTED_PRESET_NAME, presetName);
  }

  @And("Operator input the created order's creation time")
  public void operatorInputTheCreatedOrderSCreationTime() {
    Order createdOrder = get(KEY_ORDER_DETAILS);

    if (createdOrder == null) {
      assertTrue(f("Order hasn't been created"), true);
      return;
    }

    LocalDateTime orderCreationTimestamp = addressingDownloadPage.getUTC(createdOrder.getCreatedAt());
    NvLogger.infof("Order tracking ID: %s", createdOrder.getTrackingId());
    NvLogger.infof("Order creation time: %s", orderCreationTimestamp);

    Map<String, String> dateTimeRange = addressingDownloadPage.generateDateTimeRange(orderCreationTimestamp);

    addressingDownloadPage.setCreationTimeDatepicker(dateTimeRange);
  }

  @Then("Operator verifies that the Address Download Table Result contains all basic data")
  public void operatorVerifiesThatTheAddressDownloadTableResultContainsAllBasicData() {
      WebElement addressDownloadTableResult = addressingDownloadPage.addressDownloadTableResult.getWebElement();
      addressingDownloadPage.waitUntilVisibilityOfElementLocated(addressDownloadTableResult);

      Order createdOrder = get(KEY_ORDER_DETAILS);
      Waypoint waypoint = get(KEY_WAYPOINT_DETAILS);

      boolean latencyExists = addressingDownloadPage.basicOrderDataUICheckingAndCheckForTimeLatency(createdOrder, waypoint);

      if (latencyExists) {
          LocalDateTime adjustedOCCreatedAt = createdOrder.getCreatedAt().toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime().plus(Duration.of(1, ChronoUnit.MINUTES));
          Date newCreatedAt = Timestamp.valueOf(adjustedOCCreatedAt);
        NvLogger.info("There had been creation time latency");
        NvLogger.infof("Initial crated at: %s", createdOrder.getCreatedAt().toString());
          createdOrder.setCreatedAt(newCreatedAt);
        put(KEY_ORDER_DETAILS, createdOrder);
        NvLogger.infof("Creation time is adjusted to: %s", createdOrder.getCreatedAt().toString());
      }
  }

  @Then("Operator verifies that the downloaded csv file contains all correct data")
  public void operatorVerifiesThatTheDownloadedCsvFileContainsAllCorrectData() {
    Order order = get(KEY_ORDER_DETAILS);
    Waypoint waypoint = get(KEY_WAYPOINT_DETAILS);
    String preset = get(KEY_SELECTED_PRESET_NAME);

    addressingDownloadPage.csvDownloadSuccessfullyAndContainsBasicData(order, waypoint, preset);
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

    retryIfAssertionErrorOccurred(() -> {
              addressingDownloadPage.filterButton.click();
              pause1s();
              addressingDownloadPage.selectPresetFilter(filterType);
              assertTrue(addressingDownloadPage.isElementExistFast(addressingDownloadPage.FILTER_SHOWN_XPATH));
            },
            "Clicking Filter for Preset");

    addressingDownloadPage.setPresetFilter(filterType);
  }

  @And("Operator save the new preset data")
  public void operatorSaveTheNewPresetData() {
    addressingDownloadPage.mainPresetButtonInModal.click();
  }

  @And("Operator input the new preset name")
  public void operatorInputTheNewPresetName() {
    String presetName =
            "AUTO-" + StandardTestConstants.COUNTRY_CODE.toUpperCase() + "-" + RandomUtil
                    .randomString(7);

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
        assertFalse("Invalid time bracket given.", true);
    }

    NvLogger.infof("timeRange: %s", timeRange);

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

    NvLogger.infof("start_hour: %s", timeRangeMap.get("start_hour"));
    NvLogger.infof("start_minute: %s", timeRangeMap.get("start_minute"));
    NvLogger.infof("end_hour: %s", timeRangeMap.get("end_hour"));
    NvLogger.infof("end_minute: %s", timeRangeMap.get("end_minute"));
    addressingDownloadPage.setPresetCreationTimeDatepicker(timeRangeMap);
    put(KEY_ADDRESSING_CREATION_TIME_FILTER, timeRange);
  }

  @And("Operator verifies that the creation time filter is updated")
  public void operatorVerifiesThatTheCreationTimeFilterIsUpdated() {
    String newCreationTime = get(KEY_ADDRESSING_CREATION_TIME_FILTER);

    boolean isTimeMatch = addressingDownloadPage.compareUpdatedCreationTimeValue(newCreationTime);

    assertTrue("The creation time value is updated.", isTimeMatch);
  }
}
