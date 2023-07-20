package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.Color;
import org.openqa.selenium.support.FindBy;

public class ParcelSweeperLivePage extends OperatorV2SimplePage {

  private static final String IFRAME_XPATH = "//iframe[contains(@src,'parcel-sweeper-live')]";
  private static final String ROUTE_ID_DIV_XPATH = "//div[contains(@class, 'route-info-container')]";
  private static final String ROUTE_ID_DIV_TEXT_XPATH = "/div[contains(@class,'inbound-data-info')]";
  private static final String ZONE_DIV_XPATH = "//div[contains(@class, 'zone-info-container')]";
  private static final String ZONE_DIV_TEXT_XPATH = "//div[contains(@class,'inbound-data-info')]";
  private static final String DESTINATION_HUB_DIV_XPATH = "//div[contains(@class, 'destination-hub-container')]";
  private static final String DESTINATION_HUB_DIV_TEXT_XPATH = "//div[contains(@class,'destination-hub')]";
  private static final String SCAN_ERROR_CLASS_XPATH = "[contains(@ng-class,'scan-error')]";
  private static final String PRIORITY_LEVEL_XPATH = "//span[@data-testid='priority-level']";
  private static final String PRIORITY_LEVEL_COLOR_XPATH = "//div[contains(@class,'priority-container')]";
  private static final String LOCATOR_RTS_INFO = "//h5[@data-testid='rts']";
  private static final String XPATH_ORDER_TAGS = "//div[contains(@class,'panel tags-info-container')]//div[@class='order-tag']";
  private static final String HUB_DROPDOWN_XPATH = "//span[contains(text(),'Search or select hub')]//preceding::input[@type='search']";
  private static final String PARCEL_TYPE_DROPDOWN_XPATH = "//div[@data-testid='parcel-type-selection-select']";
  private static final String PARCEL_TYPE_SELECTION_XPATH = "//div[@class='ant-select-item-option-content'][text()='%s']";
  private static final String CHOSEN_VALUE_SELECTION_XPATH = "//div[@label='%s']";
  private static final String SORT_TASK_DROPDOWN_XPATH = "//span[contains(text(),'Search or select task')]//preceding::input[@type='search'][1]";
  private static final String MASTER_VIEW_SORT_TASK_OPTION = "Master View";
  private static final String MODAL_HEADER_TITLE_XPATH = "//div[@class='ant-modal-title']";
  private static final String MODAL_BODY_CONTENT_XPATH = "//div[@class='ant-modal-body']";

  @FindBy(xpath = "//button[text()='Proceed']")
  public Button proceedButton;

  @FindBy(xpath = "//h5[@data-testid='prior-title']")
  public PageElement priorTag;

  @FindBy(xpath = "//input[@data-testid='scan-input-field']")
  public PageElement trackingIdBox;


  public ParcelSweeperLivePage(WebDriver webDriver) {
    super(webDriver);
  }

  public void selectHubToBegin(String hubName) {
    selectHubToBeginWithTask(hubName, hubName);
  }

  public void scanTrackingId(String trackingId) {
    trackingIdBox.sendKeys(trackingId);
    trackingIdBox.sendKeys(Keys.ENTER);
    pause1s();
  }

  public void verifyRoute(String value, String color) {
    String[] textInRouteIdExpected = value.split(";");
    waitUntilVisibilityOfElementLocated(ROUTE_ID_DIV_XPATH + SCAN_ERROR_CLASS_XPATH);
    String textInRouteIdActual = getText(ROUTE_ID_DIV_XPATH + ROUTE_ID_DIV_TEXT_XPATH);
    Assertions.assertThat(textInRouteIdActual).as("Expected another value for Route ID")
        .contains(textInRouteIdExpected[0]);
    Assertions.assertThat(textInRouteIdActual).as("Expected another value for Route ID")
        .contains(textInRouteIdExpected[0]);
    Color actualColor = Color.fromString(getCssValue(ROUTE_ID_DIV_XPATH, "background-color"));
    Assertions.assertThat(actualColor.asHex()).as("Expected another color for Route ID background")
        .isEqualTo(color);
  }

  public void verifyZone(String value, String color) {
    waitUntilVisibilityOfElementLocated(ZONE_DIV_XPATH + SCAN_ERROR_CLASS_XPATH);
    String textInZone = getText(ZONE_DIV_XPATH + ZONE_DIV_TEXT_XPATH);
    Assertions.assertThat(textInZone).as("Expected another value for Zone").contains(value);
    Color actualColor = Color.fromString(getCssValue(ZONE_DIV_XPATH, "background-color"));
    Assertions.assertThat(actualColor.asHex()).as("Expected another color for Route ID background")
        .isEqualTo(color);
  }

  public void verifyDestinationHub(String value, String color) {
    waitUntilVisibilityOfElementLocated(DESTINATION_HUB_DIV_XPATH + SCAN_ERROR_CLASS_XPATH);
    String textInZone = getText(DESTINATION_HUB_DIV_XPATH + DESTINATION_HUB_DIV_TEXT_XPATH);
    Assertions.assertThat(textInZone).as("Expected another value for Destination Hub")
        .contains(value);
    Color actualColor = Color
        .fromString(getCssValue(DESTINATION_HUB_DIV_XPATH, "background-color"));
    Assertions.assertThat(actualColor.asHex()).as("Expected another color for Route ID background")
        .isEqualTo(color);
  }

  public void verifiesPriorityLevel(int expectedPriorityLevel,
      String expectedPriorityLevelColorAsHex) {
    String actualPriorityLevel = getText(PRIORITY_LEVEL_XPATH);
    Color actualPriorityLevelColor = getBackgroundColor(PRIORITY_LEVEL_COLOR_XPATH);

    Assertions.assertThat(actualPriorityLevel).as("Priority Level")
        .isEqualTo(String.valueOf(expectedPriorityLevel));
    Assertions.assertThat(actualPriorityLevelColor.asHex()).as("Priority Level Color")
        .isEqualTo(expectedPriorityLevelColorAsHex);
  }

  public void verifyRTSInfo(boolean isRTSed) {
    if (isRTSed) {
      pause2s();
      Assertions.assertThat(isElementVisible(LOCATOR_RTS_INFO)).as("RTS Label is not displayed")
          .isTrue();
      Assertions.assertThat(getText(LOCATOR_RTS_INFO)).as("Unexpected text of RTS Label")
          .isEqualToIgnoringCase("RTS");
    } else {
      Assertions.assertThat(isElementVisible(LOCATOR_RTS_INFO))
          .as("RTS Label is displayed, but must not").isFalse();
    }
  }

  public void verifiesTags(List<String> expectedOrderTags) {
    List<String> tags = new ArrayList<>();
    List<WebElement> listOfTags = findElementsByXpath(XPATH_ORDER_TAGS);
    for (WebElement we : listOfTags) {
      tags.add(we.getText());
    }
    assertEquals(
        "Order tags is not equal to tags set on Order Tag Management page for order Id - %s",
        expectedOrderTags.stream().map(String::toLowerCase).sorted().collect(Collectors.toList()),
        tags.stream().map(String::toLowerCase).sorted().collect(Collectors.toList()));
  }

  public void verifyPriorTag() {
    String actualTag = priorTag.getText();
    Assertions.assertThat(actualTag).as("Prior tag").isEqualTo("Prior.");
  }

  public void selectHub(String hubName) {
    pause2s();
    // Select Hub
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
    click(HUB_DROPDOWN_XPATH);
    waitUntilVisibilityOfElementLocated(HUB_DROPDOWN_XPATH);
    sendKeys(HUB_DROPDOWN_XPATH, hubName, Keys.ENTER);
  }

  public void selectHubToBeginWithTask(String hubName, String task) {
    pause2s();

    // Select Hub
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
    click(HUB_DROPDOWN_XPATH);
    waitUntilVisibilityOfElementLocated(HUB_DROPDOWN_XPATH);
    sendKeys(HUB_DROPDOWN_XPATH, hubName, Keys.ENTER);
    pause2s();
//    click(PARCEL_TYPE_DROPDOWN_XPATH);
//    String parcelTypeSelection =String.format(PARCEL_TYPE_SELECTION_XPATH,parcelType);
//    click(parcelTypeSelection);
    pause2s();

    //Select Sort Task
    if (isElementExistFast(SORT_TASK_DROPDOWN_XPATH)) {
      click(SORT_TASK_DROPDOWN_XPATH);
      if (isElementExistFast(SORT_TASK_DROPDOWN_XPATH)) {
        waitUntilVisibilityOfElementLocated(SORT_TASK_DROPDOWN_XPATH);
        sendKeys(SORT_TASK_DROPDOWN_XPATH, task.replaceAll("\\s+", "").toUpperCase() + Keys.RETURN);
      }
    }

    if (proceedButton.waitUntilVisible(5)) {
      proceedButton.click();
    }
  }

  public void selectTaskToBegin(String task) {
    pause2s();
    //Select Sort Task
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));

    if (isElementExistFast(SORT_TASK_DROPDOWN_XPATH)) {
      click(SORT_TASK_DROPDOWN_XPATH);
      if (isElementExistFast(SORT_TASK_DROPDOWN_XPATH)) {
        waitUntilVisibilityOfElementLocated(SORT_TASK_DROPDOWN_XPATH);
        sendKeys(SORT_TASK_DROPDOWN_XPATH, task.replaceAll("\\s+", "").toUpperCase() + Keys.RETURN);
      }
    }

    if (proceedButton.waitUntilVisible(5)) {
      proceedButton.click();
    }
  }

  public void verifyAccessDeniedModal(Map<String, String> mapOfData) {
    pause2s();
    getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));
    boolean isAccessDeniedModal = getText(MODAL_HEADER_TITLE_XPATH).equalsIgnoreCase(mapOfData.get("title"));
    boolean isMessageCorrect = getText(MODAL_BODY_CONTENT_XPATH).equalsIgnoreCase(mapOfData.get("message"));

    Assertions.assertThat(isAccessDeniedModal).as("Modal heading").isTrue();
    Assertions.assertThat(isMessageCorrect).as("Modal Body").isTrue();
  }
}
