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
}
