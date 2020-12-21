package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.Color;
import org.openqa.selenium.support.FindBy;

/**
 * @author Sergey Mishanin
 */
public class ParcelSweeperPage extends OperatorV2SimplePage {

  private static final String LOCATOR_SPINNER = "//md-progress-circular";
  private static final String LOCATOR_ROUTE_INFO_CONTAINER = "//div[contains(@class, 'route-info-container')]";
  private static final String LOCATOR_ZONE_INFO_CONTAINER = "//div[contains(@class, 'zone-info-container')]";
  private static final String LOCATOR_DESTINATION_HUB_CONTAINER = "//div[contains(@class, 'destination-hub-container')]";

  @FindBy(xpath = "//md-select[starts-with(@id,'commons.hub')]")
  public MdSelect hub;

  @FindBy(xpath = LOCATOR_SPINNER)
  public PageElement loadingSpinner;

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

  public void verifyRouteInfo(String routeId, String driverName, String color) {
    if (routeId != null) {
      assertEquals("Unexpected Route ID", routeId, getText(LOCATOR_ROUTE_INFO_CONTAINER + "//h3"));
    }

    if (StringUtils.isNotBlank(driverName)) {
      assertThat("Unexpected Driver Name", getText(LOCATOR_ROUTE_INFO_CONTAINER + "//h4"),
          equalToIgnoringCase(driverName));
    }

    if (StringUtils.isNotBlank(color)) {
      Color actualColor = Color
          .fromString(getCssValue(LOCATOR_ROUTE_INFO_CONTAINER, "background-color"));
      assertEquals("Unexpected Route Info Container color", color, actualColor.asHex());
    }
  }

  public void verifyZoneInfo(String shortName, String name, String color) {
    if (StringUtils.isNotBlank(shortName)) {
      String zoneShortName = getText(LOCATOR_ZONE_INFO_CONTAINER + "//h3[@class=\"zone-title\"]");
      String zoneFullName = getText(LOCATOR_ZONE_INFO_CONTAINER + "//h5");
      if (!("NIL".equalsIgnoreCase(shortName))) {
        if ((zoneFullName != null && !zoneFullName.isEmpty())) {
          assertThat("Unexpected Zone Name", zoneFullName, equalToIgnoringCase(name));
        } else {
          assertThat("Unexpected Zone Name", zoneShortName, equalToIgnoringCase(shortName));
        }
      } else {
        assertThat("Unexpected Zone Name", "NIL", equalToIgnoringCase(shortName));
      }
    }

    if (StringUtils.isNotBlank(color)) {
      Color actualColor = Color
          .fromString(getCssValue(LOCATOR_ZONE_INFO_CONTAINER, "background-color"));
      assertEquals("Unexpected Zone Info Container color", color, actualColor.asHex());
    }
  }

  public void verifyDestinationHub(String hubName, String color) {
    if (StringUtils.isNotBlank(hubName)) {
      assertThat("Unexpected Destination Hub Name",
          getText(LOCATOR_DESTINATION_HUB_CONTAINER + "//h4"), equalToIgnoringCase(hubName));
    }

    if (StringUtils.isNotBlank(color)) {
      Color actualColor = Color
          .fromString(getCssValue(LOCATOR_ZONE_INFO_CONTAINER, "background-color"));
      assertEquals("Unexpected Zone Info Container color", color, actualColor.asHex());
    }
  }
}
