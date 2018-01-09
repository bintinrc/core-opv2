package co.nvqa.operator_v2.selenium.page;

import org.openqa.selenium.WebDriver;

/**
 *
 * @author Tristania Siagian
 */
public class AllOrdersPage extends SimplePage
{
    public AllOrdersPage(WebDriver webDriver) {
        super(webDriver);
    }

    public void enterTrackingId(String trackingId) {
        sendKeysById("searchTerm", trackingId);
        clickNvApiTextButtonByName("commons.search");
    }
}
