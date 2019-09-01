package co.nvqa.operator_v2.selenium.page;

import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.Color;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * @author Sergey Mishanin
 */
public class ParcelSweeperByHubPage extends OperatorV2SimplePage
{
    private static final String LOCATOR_SPINNER = "//md-progress-circular";
    private static final String LOCATOR_ROUTE_INFO_CONTAINER = "//div[contains(@class, 'route-info-container')]";
    private static final String LOCATOR_ZONE_INFO_CONTAINER = "//div[contains(@class, 'zone-info-container')]";
    private static final String LOCATOR_DESTINATION_HUB_CONTAINER = "//div[contains(@class, 'destination-hub-container')]";
    private static final String LOCATOR_RTS_INFO = "//div[@ng-if='ctrl.data.isRtsed']";
    private static final String LOCATOR_DIFFERENT_DATE_INFO = "//div[contains(@class,'different-date-container')]";
    private static final Pattern ZONE_NAME_PATTERN = Pattern.compile("^(.+?)(\\(.*\\))$");

    private SyncOrdersByDestinationHubDialog syncOrdersByDestinationHubDialog;

    public ParcelSweeperByHubPage(WebDriver webDriver)
    {
        super(webDriver);
        syncOrdersByDestinationHubDialog = new SyncOrdersByDestinationHubDialog(webDriver);
    }

    public void selectHub(String hubName)
    {
        pause3s();
        selectValueFromMdSelectById("commons.hub", hubName);
        clickNvIconTextButtonByNameAndWaitUntilDone("Continue");
        waitUntilInvisibilityOfElementLocated(LOCATOR_SPINNER);
    }

    public void syncOrdersByDestinationHub(String destinationHubName)
    {
        syncOrdersByDestinationHubDialog
                .waitUntilVisibility()
                .selectHub(destinationHubName)
                .submit();
        waitUntilInvisibilityOfElementLocated("//div[@class='md-half-circle']");
        pause5s();
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
            assertThat("Unexpected Driver Name", getText(LOCATOR_ROUTE_INFO_CONTAINER + "//h5"), equalToIgnoringCase(driverName));
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
            Matcher matcher = ZONE_NAME_PATTERN.matcher(zoneName);
            if (matcher.matches())
            {
                zoneName = matcher.group(1).trim();
            }
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
            Color actualColor = Color.fromString(getCssValue(LOCATOR_DESTINATION_HUB_CONTAINER, "background-color"));
            assertEquals("Unexpected Destination Hub Container color", color, actualColor.asHex());
        }
    }

    public void verifyRTSInfo(boolean isRTSed)
    {
        if (isRTSed)
        {
            assertTrue("RTS Label is not displayed", isElementVisible(LOCATOR_RTS_INFO));
            assertThat("Unexpected text of RTS Label", getText(LOCATOR_RTS_INFO), equalToIgnoringCase("RTS ORDER"));
        } else
        {
            assertFalse("RTS Label is displayed, but must not", isElementVisible(LOCATOR_RTS_INFO));
        }
    }

    public void verifyParcelRouteDifferentDateInfo(boolean hasDifferentDate)
    {
        if (hasDifferentDate)
        {
            assertTrue("Parcel Route different date Label is not displayed", isElementVisible(LOCATOR_DIFFERENT_DATE_INFO));
            assertThat("Unexpected text of Parcel Route different date Label", getText(LOCATOR_DIFFERENT_DATE_INFO), equalToIgnoringCase("Parcel route has different date"));
        } else
        {
            assertFalse("Parcel Route different date Label is displayed, but must not", isElementVisible(LOCATOR_DIFFERENT_DATE_INFO));
        }
    }

    /**
     * Accessor for Sync Orders By Destination Hub dialog
     */
    public static class SyncOrdersByDestinationHubDialog extends OperatorV2SimplePage
    {
        private static final String DIALOG_TITLE = "Sync Orders by Destination Hub";
        private static final String LOCATOR_FIELD_HUB_LOCATOR = "Hub";
        private static final String LOCATOR_BUTTON_SYNC = "container.parcel-sweeper.sync";

        public SyncOrdersByDestinationHubDialog(WebDriver webDriver)
        {
            super(webDriver);
        }

        public SyncOrdersByDestinationHubDialog waitUntilVisibility()
        {
            waitUntilVisibilityOfMdDialogByTitle(DIALOG_TITLE);
            return this;
        }

        public SyncOrdersByDestinationHubDialog selectHub(String hub)
        {
            selectValueFromMdAutocomplete(LOCATOR_FIELD_HUB_LOCATOR, hub);
            return this;
        }

        public void submit()
        {
            clickNvApiTextButtonByNameAndWaitUntilDone(LOCATOR_BUTTON_SYNC);
            waitUntilInvisibilityOfMdDialogByTitle(DIALOG_TITLE);
        }
    }
}
