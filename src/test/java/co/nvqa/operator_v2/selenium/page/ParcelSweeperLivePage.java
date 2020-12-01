package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.Color;
import org.openqa.selenium.support.FindBy;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class ParcelSweeperLivePage extends OperatorV2SimplePage {

    private static final String ROUTE_ID_DIV_XPATH = "//div[contains(@class, 'route-info-container')]";
    private static final String ROUTE_ID_DIV_TEXT_XPATH = "/div[contains(@class,'inbound-data-info')]";
    private static final String ZONE_DIV_XPATH = "//div[contains(@class, 'zone-info-container')]";
    private static final String ZONE_DIV_TEXT_XPATH = "//div[contains(@class,'inbound-data-info')]";
    private static final String DESTINATION_HUB_DIV_XPATH = "//div[contains(@class, 'destination-hub-container')]";
    private static final String DESTINATION_HUB_DIV_TEXT_XPATH = "//div[contains(@class,'destination-hub')]";
    private static final String SCAN_ERROR_CLASS_XPATH = "[contains(@ng-class,'scan-error')]";
    private static final String PRIORITY_LEVEL_XPATH = "//div[contains(@class,'priority-container')]//h5";
    private static final String PRIORITY_LEVEL_COLOR_XPATH ="//div[contains(@class,'priority-container')]";
    private static final String LOCATOR_RTS_INFO = "//div[contains(@class,'rts-info-container')]/div/h5";
    private static final String XPATH_ORDER_TAGS = "//div[contains(@class,'panel tags-info-container')]//span";
    private static final String HUB_DROPDOWN_XPATH = "//input[contains(@ng-model,'AutocompleteCtrl.scope.searchText') and not(@disabled)]/ancestor::md-autocomplete";
    private static final String HUB_INPUT_XPATH = "//input[contains(@ng-model,'AutocompleteCtrl.scope.searchText') and not(@disabled)]";
    private static final String CHOSEN_VALUE_SELECTION_XPATH = "//li[@ng-click='$mdAutocompleteCtrl.select($index)']//span[text()='%s']";
    private static final String SORT_TASK_DROPDOWN_XPATH = "//input[contains(@ng-model,'AutocompleteCtrl.scope.searchText') and contains(@class,'invalid')]/ancestor::md-autocomplete";
    private static final String SORT_TASK_INPUT_XPATH = "//input[contains(@ng-model,'AutocompleteCtrl.scope.searchText') and contains(@class,'invalid')]";
    private static final String MASTER_VIEW_SORT_TASK_OPTION = "Master View";

    @FindBy(xpath = "//nv-icon-text-button[@name='Proceed']")
    public Button proceedButton;

    public ParcelSweeperLivePage(WebDriver webDriver) {
        super(webDriver);
    }

    public void selectHubToBegin(String hubName){
        pause2s();

        // Select Hub
        click(HUB_DROPDOWN_XPATH);
        waitUntilVisibilityOfElementLocated(HUB_INPUT_XPATH);
        sendKeys(HUB_INPUT_XPATH, hubName);
        waitUntilVisibilityOfElementLocated(f(CHOSEN_VALUE_SELECTION_XPATH, hubName));
        click(f(CHOSEN_VALUE_SELECTION_XPATH, hubName));

        pause2s();

        //Select Sort Task
        if (isElementExistFast(SORT_TASK_DROPDOWN_XPATH)) {
            click(SORT_TASK_DROPDOWN_XPATH);
            if (isElementExistFast(SORT_TASK_INPUT_XPATH)) {
                waitUntilVisibilityOfElementLocated(SORT_TASK_INPUT_XPATH);
                sendKeys(SORT_TASK_INPUT_XPATH, MASTER_VIEW_SORT_TASK_OPTION);
                waitUntilVisibilityOfElementLocated(f(CHOSEN_VALUE_SELECTION_XPATH, MASTER_VIEW_SORT_TASK_OPTION));
                click(f(CHOSEN_VALUE_SELECTION_XPATH, MASTER_VIEW_SORT_TASK_OPTION));
            }
        }

        proceedButton.waitUntilClickable();
        proceedButton.click();
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
        actualPriorityLevel = actualPriorityLevel.split(" ")[1];
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

    public void verifiesTags(List<String> expectedOrderTags)
    {
        List<String> tags = new ArrayList<>();
        List<WebElement> listOfTags = findElementsByXpath(XPATH_ORDER_TAGS);
        for (WebElement we : listOfTags)
        {
            tags.add(we.getText());
        }
        assertEquals("Order tags is not equal to tags set on Order Tag Management page for order Id - %s", expectedOrderTags.stream().map(String::toLowerCase).sorted().collect(Collectors.toList()), tags.stream().map(String::toLowerCase).sorted().collect(Collectors.toList()));
    }

}
