package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.dp.DpDetailsResponse;
import co.nvqa.commons.model.dp.dp_database_checking.DatabaseCheckingNinjaCollectConfirmed;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.operator_v2.model.GlobalInboundParams;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdAutocomplete;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvAutocomplete;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.Color;
import org.openqa.selenium.support.FindBy;

/**
 * @author Daniel Joi Partogi Hutapea
 */
public class GlobalInboundPage extends OperatorV2SimplePage {

  @FindBy(xpath = "//div/*[self::h2]")
  public PageElement destinationHub;

  @FindBy(xpath = "//div/*[self::h1]")
  public PageElement rackInfo;

  @FindBy(css = "div.toast-bottom")
  public PageElement weightDiffInfo;

  @FindBy(css = "div[ng-if='ctrl.data.setAsideGroup']")
  public PageElement setAsideGroup;

  @FindBy(css = "div[ng-if='ctrl.data.setAsideRackSector']")
  public PageElement setAsideRackSector;

  @FindBy(css = "md-autocomplete[placeholder='Select Hub']")
  public MdAutocomplete selectHub;

  @FindBy(id = "container.global-inbound.device-id-optional")
  public TextBox deviceIdInput;

  @FindBy(name = "Continue")
  public NvApiTextButton continueButton;

  @FindBy(xpath = "//nv-tag")
  public PageElement dpTag;

  @FindBy(xpath = "//button[@aria-label='Use order tagging']")
  public Button useOrderTagging;

  @FindBy(xpath = ".//nv-autocomplete[@selected-options='ctrl.data.selectedTagOptions']")
  public NvAutocomplete selectTag;

  @FindBy(xpath = "//nv-icon-button/button[@aria-label='Settings']")
  public Button settings;

  @FindBy(xpath = "    //nv-icon-text-button[@name='Save changes']")
  public Button saveChanges;

  public static final String XPATH_ORDER_TAGS_ON_GLOBAL_INBOUND_PAGE = "//div[contains(@class,'order-tags-container')]//span";
  public static String XPATH_CONTAINER = "//div[contains(@class, 'rack-container')]";


  public GlobalInboundPage(WebDriver webDriver) {
    super(webDriver);
  }

  private void selectHubAndDeviceId(String hubName, String deviceId) {
    if (isElementExistFast("//h4[text()='Select the following to begin:']")) {
      pause1s();
      retryIfRuntimeExceptionOccurred(() -> selectHub.selectValue(hubName));
      if (StringUtils.isNotBlank(deviceId)) {
        deviceIdInput.setValue(deviceId);
      }
      continueButton.clickAndWaitUntilDone();
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
      if (isElementExistFast("//nv-icon-text-button[@name='container.global-inbound.manual']")) {
        clickNvIconTextButtonByName("container.global-inbound.manual");
      }
    } else {
      if (isElementExistFast("//nv-icon-text-button[@name='container.global-inbound.retain']")) {
        clickNvIconTextButtonByName("container.global-inbound.retain");
        clickf(".//md-select[starts-with(@id, 'size')]");
        pause1s();
        sendKeys("//input[@ng-model=\"searchTerm\"]", overrideSize);
        clickf(
            "//div[contains(@class, 'md-select-menu-container')][@aria-hidden='false']//md-option[contains(@value,\"%s\") or contains(./div/text(),\"%s\")]",
            overrideSize, overrideSize);
        pause50ms();
      }
    }
  }

  private void overrideWeight(Double overrideWeight) {
    setOverrideValue("input-weight", overrideWeight);
  }

  private void overrideDimHeight(Double overrideDimHeight) {
    setOverrideValue("input-height", overrideDimHeight);
  }

  private void overrideDimWidth(Double overrideDimWidth) {
    setOverrideValue("input-width", overrideDimWidth);
  }

  private void overrideDimLength(Double overrideDimLength) {
    setOverrideValue("input-length", overrideDimLength);
  }

  private void setOverrideValue(String inputId, Double value) {
    if (value == null) {
      clearf("//input[@id='%s']", inputId);
    } else {
      sendKeysById(inputId, NO_TRAILING_ZERO_DF.format(value));
    }
  }

  public void successfulGlobalInbound(GlobalInboundParams globalInboundParams) {
    globalInbound(globalInboundParams);
    String trackingId = globalInboundParams.getTrackingId();

    retryIfAssertionErrorOccurred(() ->
    {
      String lastScanned = getTextTrimmed("//div[contains(text(), 'Last Scanned')]");
      String lastScannedTrackingId = lastScanned.split(":")[1].trim();
      assertEquals("Last Scanned Tracking ID", trackingId, lastScannedTrackingId);
    }, "Checking Last Scanned Tracking ID");
  }

  @SuppressWarnings("WeakerAccess")
  public void globalInbound(GlobalInboundParams globalInboundParams) {
    selectHubAndDeviceId(globalInboundParams.getHubName(), globalInboundParams.getDeviceId());

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

    sendKeysAndEnterByAriaLabel("Scan a new parcel / Enter a tracking ID",
        globalInboundParams.getTrackingId());
    pause500ms();
  }

  public void globalInboundAndCheckAlert(GlobalInboundParams globalInboundParams, String toastText,
      String rackInfo,
      String rackColor, String weightWarning, String rackSector, String destinationHub) {
    globalInbound(globalInboundParams);

    if (StringUtils.isNotBlank(toastText)) {
      assertEquals("Toast text", toastText, getToastTopText());
      waitUntilInvisibilityOfToast(toastText);
    }

    retryIfAssertionErrorOrRuntimeExceptionOccurred(() ->
    {
      if (StringUtils.isNotBlank(weightWarning)) {
        assertEquals("Weight warning message", weightWarning, weightDiffInfo.getText());
      }

      if (StringUtils.isNotBlank(rackInfo)) {
        String xpath = String.format("//h1[normalize-space(text())='%s']", rackInfo);
        assertNotNull("rack info", waitUntilVisibilityOfElementLocated(xpath));
      }

      if (StringUtils.isNotBlank(rackColor)) {
        String xpath = "//div[contains(@class, 'rack-sector')]";
        String actualStyle = getAttribute(xpath, "style");
        NvLogger.infof("Actual Style: %s", actualStyle);
        String colorString = actualStyle.replace("background:", "").replaceAll(";", "").trim();
        NvLogger.infof("Color       : %s", colorString);
        Color color = Color.fromString(colorString);
        NvLogger.infof("Color as Hex: %s", color.asHex());
        assertThat("Unexpected Rack Sector color", color.asHex(), equalToIgnoringCase(rackColor));
      }
      if (StringUtils.isNotBlank(rackSector)) {
        String xpath = f(
            "//div[contains(@class, 'rack-container')]/descendant::*[normalize-space(text())='%s']",
            rackSector);
        assertNotNull("Rack Sector", waitUntilVisibilityOfElementLocated(xpath));
      }
      if (StringUtils.isNotBlank(destinationHub)) {
        String xpath = f(
            "//div[contains(@class, 'rack-container')]/descendant::*[normalize-space(text())='Hub: %s']",
            destinationHub);
        assertNotNull("Destination Hub", waitUntilVisibilityOfElementLocated(xpath));
      }
    }, "globalInboundAndCheckAlert", 500, 3);
  }

  public void verifiesPriorityLevelInfoIsCorrect(int expectedPriorityLevel,
      String expectedPriorityLevelColorAsHex) {
    String actualPriorityLevel = getText("//div[contains(@class,'priority-container')]//h5");
    actualPriorityLevel = actualPriorityLevel.split(" ")[1];
    Color actualPriorityLevelColor = getBackgroundColor(
        "//div[contains(@class,'priority-container')]");

    assertEquals("Priority Level", String.valueOf(expectedPriorityLevel), actualPriorityLevel);
    assertEquals("Priority Level Color", expectedPriorityLevelColorAsHex,
        actualPriorityLevelColor.asHex());
  }

  public void verifyPetsGlobalInbound(GlobalInboundParams globalInboundParams, String ticketType) {
    globalInbound(globalInboundParams);

    String actualWarningText = getText(
        "//p[@ng-if='!ctrl.data.setAsideRackSector']/following-sibling::h1");
    assertEquals("Warning Text is not the same : ", actualWarningText,
        "RECOVERY " + ticketType.toUpperCase());
  }

  public void verifiesDetailsAreRightForGlobalInbound(DatabaseCheckingNinjaCollectConfirmed result,
      DpDetailsResponse dpDetails, String barcode, String source) {
    assertEquals("Barcode is not the same : ", result.getBarcode(), barcode);
    assertEquals("DP ID is not the same : ", result.getDpId(), dpDetails.getId());
    assertEquals("Status is not the same : ", result.getStatus(), "CONFIRMED");
    if (source.equalsIgnoreCase("Fully Integrated")) {
      assertEquals("Source is not the same : ", result.getSource(),
          "FULLY_INTEGRATED_NINJA_COLLECT");
    } else if (source.equalsIgnoreCase("Semi Integrated")) {
      assertEquals("Source is not the same : ", result.getSource(),
          "SEMI_INTEGRATED_NINJA_COLLECT");
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
    assertEquals("Recovery Ticket Type rack sector is displayed",
        ("RECOVERY " + recoveryTicketType).toLowerCase(), rackSector.toLowerCase());
  }

  public void verifiesDpTag() {
    String actualTag = dpTag.getText();
    assertEquals("DP tag", "DP PARCEL", actualTag);
  }

  public void addTag(List<String> orderTags) {
    settings.click();
    for (String tag : orderTags) {
      selectTag.selectValue(tag);
    }
    saveChanges.click();
  }

  public void verifyFailedTaggingToast(String message) {
    waitUntilVisibilityOfToast(message);
  }
}
