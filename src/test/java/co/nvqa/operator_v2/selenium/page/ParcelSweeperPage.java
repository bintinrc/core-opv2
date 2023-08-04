package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.Color;
import org.openqa.selenium.support.FindBy;

/**
 * @author Sergey Mishanin
 */
public class ParcelSweeperPage extends OperatorV2SimplePage {

  private static final String LOCATOR_SPINNER = "//md-progress-circular";
  private static final String LOCATOR_ROUTE_CONTAINER = "//div[@class= 'panel info-container']";
  private static final String LOCATOR_ROUTE_INFO_CONTAINER = "//span[@data-testid = 'route-title']";
  private static final String LOCATOR_ROUTE_DESCRIPTION_CONTAINER = "//h4[@data-testid = 'route-description']";
  private static final String LOCATOR_ZONE_INFO_CONTAINER = "//h3[contains(@class,'zone-title')]";
  private static final String LOCATOR_DESTINATION_HUB_CONTAINER = "//div[contains(@class, 'destination-hub-container')]";
  private static final String LOCATOR_ROUTE_INFO_COLOR = "//div[contains(@class,'panel info-container')]//h3";
  private static final String LOCATOR_ROUTE_DESCRIPTION_COLOR = "//div[contains(@class,'panel info-container')]//h4";

  @FindBy(xpath = "//md-select[starts-with(@id,'commons.hub')]")
  public MdSelect hub;

  @FindBy(xpath = LOCATOR_SPINNER)
  public PageElement loadingSpinner;

  @FindBy(xpath = "//h3[contains(@data-testid,'next-sorting-node')]")
  public PageElement nextSortingTask;

  @FindBy(xpath = "//span[@class='ant-notification-close-x']")
  public PageElement notificationCloseButton;

  @FindBy(xpath = "//div[contains(@class,'panel info-container')]//h3")
  public PageElement routeInfoColorXpath;

  @FindBy(xpath = "//div[contains(@class,'panel info-container')]//h4")
  public PageElement routeDescriptionTextColorXpath;

  public ParcelSweeperPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void selectHub(String hubName) {
    pause3s();
    hub.searchAndSelectValue(hubName);
    clickNvIconTextButtonByNameAndWaitUntilDone("Continue");
    waitUntilInvisibilityOfElementLocated(LOCATOR_SPINNER);
    waitWhilePageIsLoading();
  }

  public void enterTrackingId(String trackingId) {
    sendKeysAndEnterByAriaLabel("Tracking ID", trackingId);
  }

  public void addPrefix(String prefix) {
    clickNvIconTextButtonByName("container.parcel-sweeper.add-prefix");
    waitUntilVisibilityOfMdDialogByTitle("Set Prefix");
    sendKeysById("container.global-inbound.prefix", prefix);
    clickNvIconTextButtonByName("Save");
    waitUntilInvisibilityOfMdDialogByTitle("Set Prefix");
  }

  public void verifyRouteInfo(String routeId, String driverName, String routeInfoColor,
      String routeDescriptionColor, String backgroundColor) {
    pause2s();
    if (routeId != null) {
      Assertions.assertThat(getText(LOCATOR_ROUTE_INFO_CONTAINER))
          .as("Route ID is CORRECT")
          .isEqualTo(routeId);
    }

    if (StringUtils.isNotBlank(driverName)) {
      Assertions.assertThat(getText(LOCATOR_ROUTE_DESCRIPTION_CONTAINER))
          .as("Driver name is CORRECT")
          .isEqualToIgnoringCase(driverName);
    }

    if (StringUtils.isNotBlank(backgroundColor)) {
      Color actualColor = Color
          .fromString(getCssValue(LOCATOR_ROUTE_CONTAINER, "background-color"));
      Assertions.assertThat(actualColor.asHex())
          .as("Background container color is CORRECT")
          .isEqualTo(backgroundColor);
    }

    if (StringUtils.isNotBlank(routeInfoColor)) {
      Color actualColor = Color
          .fromString(getCssValue(LOCATOR_ROUTE_INFO_COLOR, "color"));
      Assertions.assertThat(actualColor.asHex())
          .as("Route info color is CORRECT")
          .isEqualTo(routeInfoColor);
    }

    if (StringUtils.isNotBlank(routeDescriptionColor)) {
      Color actualColor = Color
          .fromString(getCssValue(LOCATOR_ROUTE_DESCRIPTION_COLOR, "color"));
      Assertions.assertThat(actualColor.asHex())
          .as("Route Description color is CORRECT")
          .isEqualTo(routeDescriptionColor);
    }

  }

  public void verifyZoneInfo(String shortName, String name, String color) {
    name = name.equalsIgnoreCase("Z-Out of Zone") ? "?" : name;
    if (StringUtils.isNotBlank(shortName)) {
      String zoneShortName = getText(LOCATOR_ZONE_INFO_CONTAINER);
      if (!("NIL".equalsIgnoreCase(shortName))) {
        Assertions.assertThat(zoneShortName)
            .as(String.format("Zone short name is CORRECT: %s", shortName))
            .isEqualToIgnoringCase(shortName);

      } else {
        Assertions.assertThat("NIL")
            .as(String.format("Zone short name is CORRECT: %s", shortName))
            .isEqualToIgnoringCase(shortName);
      }
    }

    if (StringUtils.isNotBlank(color)) {
      Color actualColor = Color
          .fromString(getCssValue(LOCATOR_ZONE_INFO_CONTAINER, "color"));
      Assertions.assertThat(actualColor.asHex())
          .as("Zone info text color is CORRECT")
          .isEqualTo(color);
    }
  }

  public void verifyNextSortingHubInfo(String nextSort) {
    if (StringUtils.isNotBlank(nextSort)) {
      String actualNextSort = nextSortingTask.getText();
      if (!("NIL".equalsIgnoreCase(nextSort))) {
        Assertions.assertThat(actualNextSort)
            .as("Next sorting hub name is CORRECT")
            .isEqualToIgnoringCase(nextSort);
      } else {
        Assertions.assertThat("NIL")
            .as("Next sorting hub name is CORRECT")
            .isEqualToIgnoringCase(nextSort);
      }
    }
  }

  public void verifyDestinationHub(String hubName, String color) {
    if (StringUtils.isNotBlank(hubName)) {
      Assertions.assertThat(getText(LOCATOR_DESTINATION_HUB_CONTAINER + "//h4"))
          .as("Destination hub name is CORRECT")
          .isEqualToIgnoringCase(hubName);
    }

    if (StringUtils.isNotBlank(color)) {
      Color actualColor = Color
          .fromString(getCssValue(LOCATOR_ZONE_INFO_CONTAINER, "background-color"));
      Assertions.assertThat(actualColor.asHex())
          .as("Zone info container color is CORRECT")
          .isEqualTo(color);
    }
  }
}
