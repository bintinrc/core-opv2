package co.nvqa.operator_v2.selenium.page;

import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.Color;

/**
 * @author Sergey Mishanin
 */
public class ParcelSweeperPage extends OperatorV2SimplePage
{
    public static final String LOCATOR_SPINNER = "//md-progress-circular";
    public static final String LOCATOR_ROUTE_INFO_CONTAINER = "//div[contains(@class, 'route-info-container')]";
    public static final String LOCATOR_ZONE_INFO_CONTAINER = "//div[contains(@class, 'zone-info-container')]";
    public static final String LOCATOR_DESTINATION_HUB_CONTAINER = "//div[contains(@class, 'destination-hub-container')]";

    public ParcelSweeperPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void selectHub(String hubName)
    {
        pause3s();
        selectValueFromMdSelectById("commons.hub", hubName);
        clickNvIconTextButtonByNameAndWaitUntilDone("Continue");
        waitUntilInvisibilityOfElementLocated(LOCATOR_SPINNER);
    }

    public void enterTrackingId(String trackingId)
    {
        sendKeysAndEnterByAriaLabel("Tracking ID", trackingId);
    }

    public void addPrefix(String prefix)
    {
        clickNvIconTextButtonByName("container.parcel-sweeper.add-prefix");
        waitUntilVisibilityOfMdDialogByTitle("Set Prefix");
        sendKeysById("container.global-inbound.prefix", prefix);
        clickNvIconTextButtonByName("Save");
        waitUntilInvisibilityOfMdDialogByTitle("Set Prefix");
    }

    public void verifyRouteInfo(Long routeId, String driverName, String color)
    {
        if (routeId != null)
        {
            assertEquals("Unexpected Route ID", String.valueOf(routeId), getText(LOCATOR_ROUTE_INFO_CONTAINER + "//h4"));
        }

        if (StringUtils.isNotBlank(driverName))
        {
            assertThat("Unexpected Route ID", getText(LOCATOR_ROUTE_INFO_CONTAINER + "//h5"), equalToIgnoringCase(driverName));
        }

        if (StringUtils.isNotBlank(color))
        {
            Color actualColor = Color.fromString(getCssValue(LOCATOR_ROUTE_INFO_CONTAINER, "background-color"));
            assertEquals("Unexpected Route Info Container color", color, actualColor.asHex());
        }
    }

    public void verifyZoneInfo(String zoneName, String color)
    {
        if (StringUtils.isNotBlank(zoneName))
        {
            assertThat("Unexpected Zone Name", getText(LOCATOR_ZONE_INFO_CONTAINER + "//h4"), equalToIgnoringCase(zoneName));
        }

        if (StringUtils.isNotBlank(color))
        {
            Color actualColor = Color.fromString(getCssValue(LOCATOR_ZONE_INFO_CONTAINER, "background-color"));
            assertEquals("Unexpected Zone Info Container color", color, actualColor.asHex());
        }
    }

    public void verifyDestinationHub(String hubName, String color)
    {
        if (StringUtils.isNotBlank(hubName))
        {
            assertThat("Unexpected Destination Hub Name", getText(LOCATOR_DESTINATION_HUB_CONTAINER + "//h4"), equalToIgnoringCase(hubName));
        }

        if (StringUtils.isNotBlank(color))
        {
            Color actualColor = Color.fromString(getCssValue(LOCATOR_ZONE_INFO_CONTAINER, "background-color"));
            assertEquals("Unexpected Zone Info Container color", color, actualColor.asHex());
        }
    }
}
