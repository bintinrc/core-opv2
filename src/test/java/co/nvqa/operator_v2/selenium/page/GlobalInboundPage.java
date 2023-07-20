package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.dp.DpDetailsResponse;
import co.nvqa.commons.model.dp.dp_database_checking.DatabaseCheckingNinjaCollectConfirmed;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.operator_v2.model.GlobalInboundParams;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect2;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.Color;
import org.openqa.selenium.support.FindBy;

/**
 * @author Daniel Joi Partogi Hutapea
 */
public class GlobalInboundPage extends SimpleReactPage {

  @FindBy(xpath = "//div/*[self::h2]")
  public PageElement destinationHub;

  @FindBy(xpath = "//div/*[self::h1]")
  public PageElement rackInfo;

  @FindBy(xpath = "//div[@class='ant-notification-notice-description']")
  public PageElement weightDiffInfo;

  @FindBy(css = "div[ng-if='ctrl.data.setAsideGroup']")
  public PageElement setAsideGroup;

  @FindBy(css = "div[ng-if='ctrl.data.setAsideRackSector']")
  public PageElement setAsideRackSector;

  @FindBy(xpath = "//div[@data-testid='hub-selection-select']")
  public AntSelect selectHub;

  @FindBy(xpath = "//div[@data-testid='parcel-type-selection-select']")
  public AntSelect selectParcelType;

  @FindBy(xpath = "//input[@data-testid='device-id-input']")
  public TextBox deviceIdInput;

  @FindBy(xpath = "//button[@data-testid='proceed-button']")
  public Button continueButton;

  @FindBy(xpath = "//input[@data-testid='scan-input-field']")
  public TextBox scan;

  @FindBy(xpath = "//button[@data-testid='sizing-state-auto-toogle-button']")
  public Button size;

  @FindBy(xpath = "//div[@data-testid='hub-selection-select']")
  public AntSelect sizeInput;

  @FindBy(xpath = "//input[@data-testid='weight-input']")
  public TextBox weightInput;

  @FindBy(xpath = "//input[@data-testid='width-input']")
  public TextBox dimWidthInput;

  @FindBy(xpath = "//input[@data-testid='height-input']")
  public TextBox dimHeightInput;

  @FindBy(xpath = "//input[@data-testid='length-input']")
  public TextBox dimLengthInput;

  @FindBy(xpath = "//span[@data-testid='priority-level']")
  public PageElement priorityLevel;

  @FindBy(xpath = "//div[@class='order-tag']")
  public PageElement dpTag;

  @FindBy(xpath = "//h5[@data-testid='prior-title']")
  public PageElement priorTag;

  @FindBy(xpath = "//h5[@data-testid='rts']")
  public PageElement rtsTag;

  @FindBy(xpath = "//button[@aria-label='Use order tagging']")
  public Button useOrderTagging;

  @FindBy(xpath = "//div[@data-testid='settings-tag-selection-select']")
  public AntSelect2 selectTag;

  @FindBy(xpath = "//button[@data-testid='settings-button']")
  public Button settings;

  @FindBy(xpath = "//span[@data-testid='save-text']")
  public Button saveChanges;

  @FindBy(xpath = "//div[@class='ant-notification-notice-message']")
  public PageElement antNotificationMessage;

  public static final String XPATH_ORDER_TAGS_ON_GLOBAL_INBOUND_PAGE = "//div[@class='order-tag']";
  public static String XPATH_CONTAINER = "//div[contains(@class, 'middle panel')]";


  public GlobalInboundPage(WebDriver webDriver) {
    super(webDriver);
  }

  private void selectHubAndDeviceId(String hubName, String deviceId, String parcelType) {
    if (isElementExistFast("//h4[text()='Select the following to begin:']")) {
      pause1s();
      doWithRetry(() -> {
        selectHub.selectValue(hubName);
        if(selectParcelType.isDisplayedFast()){
          selectParcelType.selectValue(parcelType);
        }

      }, "Select Hub and Parcel Type");

      if (StringUtils.isNotBlank(deviceId)) {
        deviceIdInput.setValue(deviceId);
      }
      continueButton.waitUntilClickable();
      continueButton.click();
    } else {
      clickNvIconButtonByNameAndWaitUntilEnabled("commons.settings");
      selectValueFromNvAutocomplete("ctrl.hubSearchText", hubName);

      if (deviceId != null) {
        sendKeysToMdInputContainerByModel("ctrl.data.deviceId", deviceId);
      }

      clickNvIconTextButtonByNameAndWaitUntilDone("Save changes");
    }
  }

  private void overrideSize(String overrideSize) {
    if (overrideSize == null) {
      if (size.getText().equalsIgnoreCase("Manual")) {
        size.click();
      }
    } else {
      if (size.isDisplayedFast()) {
        size.click();
        sizeInput.selectValue(overrideSize);
        pause50ms();
      }
    }
  }

  private void overrideWeight(Double overrideWeight) {
    weightInput.sendKeys(overrideWeight);
  }

  private void overrideDimHeight(Double overrideDimHeight) {
    dimHeightInput.sendKeys(overrideDimHeight);
  }

  private void overrideDimWidth(Double overrideDimWidth) {
    dimWidthInput.sendKeys(overrideDimWidth);
  }

  private void overrideDimLength(Double overrideDimLength) {
    dimLengthInput.sendKeys(overrideDimLength);
  }

  public void successfulGlobalInbound(GlobalInboundParams globalInboundParams) {
    globalInbound(globalInboundParams);
    String trackingId = globalInboundParams.getTrackingId();

    doWithRetry(() ->
    {
      String lastScannedTrackingId = getText("//h5[@class= 'last-scanned-tracking-id']");
      Assertions.assertThat(lastScannedTrackingId).as("Last Scanned Tracking ID")
          .isEqualTo(trackingId);
    }, "Checking Last Scanned Tracking ID");
  }

  @SuppressWarnings("WeakerAccess")
  public void globalInbound(GlobalInboundParams globalInboundParams) {
    selectHubAndDeviceId(globalInboundParams.getHubName(), globalInboundParams.getDeviceId(),
        globalInboundParams.getParcelType());

    String size = globalInboundParams.getOverrideSize();
    Double weigh = globalInboundParams.getOverrideWeight();
    Double height = globalInboundParams.getOverrideDimHeight();
    Double width = globalInboundParams.getOverrideDimWidth();
    Double length = globalInboundParams.getOverrideDimLength();
    String tags = globalInboundParams.getTags();

    if (Optional.ofNullable(size).isPresent()) {
      overrideSize(size);
    }

    if (Optional.ofNullable(weigh).isPresent()) {
      overrideWeight(weigh);
    }

    if (Optional.ofNullable(height).isPresent()) {
      overrideDimHeight(height);
    }

    if (Optional.ofNullable(width).isPresent()) {
      overrideDimWidth(width);
    }

    if (Optional.ofNullable(length).isPresent()) {
      overrideDimLength(length);
    }

    if (Optional.ofNullable(tags).isPresent()) {
      List<String> items = Arrays.asList(tags.split("\\s*,\\s*"));
      addTag(items);
    }

    scan.sendKeys(globalInboundParams.getTrackingId() + Keys.ENTER);
    pause500ms();
  }

  public void globalInboundAndCheckAlert(GlobalInboundParams globalInboundParams, String toastText,
      String rackInfo,
      String rackColor, String weightWarning, String rackSector, String destinationHub) {
    globalInbound(globalInboundParams);

    if (StringUtils.isNotBlank(toastText)) {
      Assertions.assertThat(getToastTopText()).as("Toast text").isEqualTo(toastText);
      waitUntilInvisibilityOfToast(toastText);
    }

    retryIfAssertionErrorOrRuntimeExceptionOccurred(() ->
    {
      if (StringUtils.isNotBlank(weightWarning)) {
        Assertions.assertThat(weightDiffInfo.getText()).as("Weight warning message")
            .isEqualTo(weightWarning);
      }

      if (StringUtils.isNotBlank(rackInfo)) {
        String xpath = String.format("//h1[normalize-space(text())='%s']", rackInfo);
        Assertions.assertThat(waitUntilVisibilityOfElementLocated(xpath)).as("rack info")
            .isNotNull();
      }

      if (StringUtils.isNotBlank(rackColor)) {
        String xpath = "//div[contains(@class, 'rack-sector')]";
        String actualStyle = getAttribute(xpath, "style");
        NvLogger.infof("Actual Style: %s", actualStyle);
        String colorString = actualStyle.replace("background:", "").replaceAll(";", "").trim();
        NvLogger.infof("Color       : %s", colorString);
        Color color = Color.fromString(colorString);
        NvLogger.infof("Color as Hex: %s", color.asHex());
        Assertions.assertThat(color.asHex()).as("Unexpected Rack Sector color")
            .isEqualToIgnoringCase(rackColor);
      }
      if (StringUtils.isNotBlank(rackSector)) {
        String xpath = f(
            "//div[contains(@class, 'rack-container')]/descendant::*[normalize-space(text())='%s']",
            rackSector);
        Assertions.assertThat(waitUntilVisibilityOfElementLocated(xpath)).as("Rack Sector")
            .isNotNull();
      }
      if (StringUtils.isNotBlank(destinationHub)) {
        String xpath = f(
            "//div[contains(@class, 'rack-container')]/descendant::*[normalize-space(text())='Hub: %s']",
            destinationHub);
        Assertions.assertThat(waitUntilVisibilityOfElementLocated(xpath)).as("Destination Hub")
            .isNotNull();
      }
    }, "globalInboundAndCheckAlert", 500, 3);
  }

  public void verifiesPriorityLevelInfoIsCorrect(int expectedPriorityLevel,
      String expectedPriorityLevelColorAsHex) {
    Color actualPriorityLevelColor = getBackgroundColor(
        "//div[contains(@class,'priority-container')]");

    Assertions.assertThat(priorityLevel.getText()).as("Priority Level")
        .isEqualTo(String.valueOf(expectedPriorityLevel));
    Assertions.assertThat(actualPriorityLevelColor.asHex()).as("Priority Level Color")
        .isEqualTo(expectedPriorityLevelColorAsHex);
  }

  public void verifyPetsGlobalInbound(GlobalInboundParams globalInboundParams, String ticketType) {
    globalInbound(globalInboundParams);

    String actualWarningText = getText(
        "//p[@ng-if='!ctrl.data.setAsideRackSector']/following-sibling::h1");
    Assertions.assertThat("RECOVERY " + ticketType.toUpperCase())
        .as("Warning Text is not the same : ").isEqualTo(actualWarningText);
  }

  public void verifiesDetailsAreRightForGlobalInbound(DatabaseCheckingNinjaCollectConfirmed result,
      DpDetailsResponse dpDetails, String barcode, String source) {
    Assertions.assertThat(barcode).as("Barcode is not the same : ").isEqualTo(result.getBarcode());
    Assertions.assertThat(dpDetails.getId()).as("DP ID is not the same : ")
        .isEqualTo(result.getDpId());
    Assertions.assertThat("CONFIRMED").as("Status is not the same : ")
        .isEqualTo(result.getStatus());
    if (source.equalsIgnoreCase("Fully Integrated")) {
      Assertions.assertThat("FULLY_INTEGRATED_NINJA_COLLECT").as("Source is not the same : ")
          .isEqualTo(result.getSource());
    } else if (source.equalsIgnoreCase("Semi Integrated")) {
      Assertions.assertThat("SEMI_INTEGRATED_NINJA_COLLECT").as("Source is not the same : ")
          .isEqualTo(result.getSource());
    }
  }

  public void verifiesTagsOnOrder(List<String> expectedOrderTags) {
    List<String> tags = new ArrayList<>();
    List<WebElement> listOfTags = findElementsByXpath(XPATH_ORDER_TAGS_ON_GLOBAL_INBOUND_PAGE);
    for (WebElement we : listOfTags) {
      tags.add(we.getText());
    }
    assertEquals(
        "Order tags is not equal to tags set on Order Tag Management page for order Id - %s",
        expectedOrderTags.stream().map(String::toLowerCase).sorted().collect(Collectors.toList()),
        tags.stream().map(String::toLowerCase).sorted().collect(Collectors.toList()));
  }

  public void unSuccessfulGlobalInbound(String recoveryTicketType,
      GlobalInboundParams globalInboundParams) {
    globalInbound(globalInboundParams);
    String xpathRackSector = "//div[contains(@class,'rack-sector')]/h1";
    String rackSector = getText(xpathRackSector);
    Assertions.assertThat(rackSector.toLowerCase())
        .as("Recovery Ticket Type rack sector is displayed")
        .isEqualTo(("RECOVERY " + recoveryTicketType).toLowerCase());
  }

  public void verifiesDpTag() {
    String actualTag = dpTag.getText();
    Assertions.assertThat(actualTag).as("DP tag").isEqualTo("DP Parcel");
  }

  public void verifiesPriorTag() {
    String actualTag = priorTag.getText();
    Assertions.assertThat(actualTag).as("Prior tag").isEqualTo("Prior.");
  }

  public void verifiesRtsTag() {
    String actualTag = rtsTag.getText();
    Assertions.assertThat(actualTag).as("RTS tag").isEqualTo("RTS");
  }

  public void addTag(List<String> orderTags) {
    settings.click();
    selectTag.click();
    for (String tag : orderTags) {
      selectTag.selectValue(tag);
    }
    saveChanges.click();
  }

  public void verifyFailedTaggingToast(String message) {
    antNotificationMessage.waitUntilVisible();
    String actualNotificationMessage = antNotificationMessage.getText();
    Assertions.assertThat(actualNotificationMessage)
        .as("Notification message is the same")
        .isEqualTo(message);
  }
}
