package co.nvqa.operator_v2.selenium.page;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.Color;

public class ParcelSweeperLivePage extends OperatorV2SimplePage {

    private static final String ROUTE_ID_DIV_XPATH = "//div[contains(@class, 'route-info-container')]";
    private static final String ROUTE_ID_DIV_TEXT_XPATH = "/div[contains(@class,'inbound-data-info')]";
    private static final String ZONE_DIV_XPATH = "//div[contains(@class, 'zone-info-container')]";
    private static final String ZONE_DIV_TEXT_XPATH = "//div[contains(@class,'inbound-data-info')]";
    private static final String DESTINATION_HUB_DIV_XPATH = "//div[contains(@class, 'destination-hub-container')]";
    private static final String DESTINATION_HUB_DIV_TEXT_XPATH = "//div[contains(@class,'destination-hub')]";
    private static final String SCAN_ERROR_CLASS_XPATH = "[contains(@ng-class,'scan-error')]";
    private static final String PRIORITY_LEVEL_XPATH = "//div[contains(text(), 'Priority Level')]/following-sibling::div";
    private static final String PRIORITY_LEVEL_COLOR_XPATH ="//div[contains(@class,'priority-container')][descendant::div[contains(text(), 'Priority Level')]]";
    private static final String LOCATOR_RTS_INFO = "//div[@ng-if='ctrl.data.isRtsed']";

    public ParcelSweeperLivePage(WebDriver webDriver) {
        super(webDriver);
    }

    public void selectHubToBegin(String hubName){
        pause2s();
        selectValueFromMdSelectWithSearch("model", hubName);
        clickButtonByAriaLabelAndWaitUntilDone("Continue");
    }

    public void scanTrackingId(String trackingId)
    {
        sendKeysAndEnterByAriaLabel("Tracking ID", trackingId);
        pause1s();
    }

    public void verifyRoute(String value, String color){
        String[] textInRouteIdExpected = value.split(";");
        waitUntilVisibilityOfElementLocated(ROUTE_ID_DIV_XPATH + SCAN_ERROR_CLASS_XPATH);
        String textInRouteIdActual = getText(ROUTE_ID_DIV_XPATH + ROUTE_ID_DIV_TEXT_XPATH);
        assertThat("Expected another value for Route ID", textInRouteIdActual, containsString(textInRouteIdExpected[0]));
        assertThat("Expected another value for Route ID", textInRouteIdActual, containsString(textInRouteIdExpected[0]));
        Color actualColor = Color.fromString(getCssValue(ROUTE_ID_DIV_XPATH, "background-color"));
        assertEquals("Expected another color for Route ID background", color, actualColor.asHex());
    }

    public void verifyZone(String value, String color){
        waitUntilVisibilityOfElementLocated(ZONE_DIV_XPATH + SCAN_ERROR_CLASS_XPATH);
        String textInZone = getText(ZONE_DIV_XPATH + ZONE_DIV_TEXT_XPATH);
        assertThat("Expected another value for Zone", textInZone, containsString(value));
        Color actualColor = Color.fromString(getCssValue(ZONE_DIV_XPATH, "background-color"));
        assertEquals("Expected another color for Route ID background", color, actualColor.asHex());
    }

    public void verifyDestinationHub(String value, String color){
        waitUntilVisibilityOfElementLocated(DESTINATION_HUB_DIV_XPATH + SCAN_ERROR_CLASS_XPATH);
        String textInZone = getText(DESTINATION_HUB_DIV_XPATH + DESTINATION_HUB_DIV_TEXT_XPATH);
        assertThat("Expected another value for Destination Hub", textInZone, containsString(value));
        Color actualColor = Color.fromString(getCssValue(DESTINATION_HUB_DIV_XPATH, "background-color"));
        assertEquals("Expected another color for Route ID background", color, actualColor.asHex());
    }

    public void verifiesPriorityLevel(int expectedPriorityLevel, String expectedPriorityLevelColorAsHex)
    {
        String actualPriorityLevel = getText(PRIORITY_LEVEL_XPATH);
        Color actualPriorityLevelColor = getBackgroundColor(PRIORITY_LEVEL_COLOR_XPATH);

        assertEquals("Priority Level", String.valueOf(expectedPriorityLevel), actualPriorityLevel);
        assertEquals("Priority Level Color", expectedPriorityLevelColorAsHex, actualPriorityLevelColor.asHex());
    }

    public void verifyRTSInfo(boolean isRTSed)
    {
        if (isRTSed)
        {
            assertTrue("RTS Label is not displayed", isElementVisible(LOCATOR_RTS_INFO));
            assertThat("Unexpected text of RTS Label", getText(LOCATOR_RTS_INFO), equalToIgnoringCase("RTS"));
        } else
        {
            assertFalse("RTS Label is displayed, but must not", isElementVisible(LOCATOR_RTS_INFO));
        }
    }

}
