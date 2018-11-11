package co.nvqa.operator_v2.selenium.page;

import org.openqa.selenium.WebDriver;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

/**
 * @author Sergey Mishanin
 */
@SuppressWarnings("WeakerAccess")
public class ZonesSelectedPolygonsPage extends OperatorV2SimplePage
{
    public ZonesSelectedPolygonsPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void waitUntilPageLoaded()
    {
        super.waitUntilPageLoaded();
        waitUntilInvisibilityOfElementLocated("//div[@class='md-half-circle']");
    }

    public void addZone(String zoneName)
    {
        waitUntilPageLoaded();
        sendKeysById("zone-name", zoneName);
        click("//nv-icon-button[@name='search']/button");
        checkRowWithNgRepeat(1, "zone in ctrl.searchZoneResult");
        clickNvIconTextButtonByNameAndWaitUntilDone("container.zones.polygon.add-selected-to-list");
    }

    public void removeZoneIfAdded(String zoneName)
    {
        String xpath = String.format("//div[contains(@class,'zone-info ')][.//div[normalize-space(text())='%s']]//nv-icon-button[@icon='close']", zoneName);
        if (isElementExist(xpath, 2))
        {
            click(xpath);
        }
    }

    public void verifySelectedZone(String zoneName)
    {
        String xpath = String.format("//div[contains(@class,'zone-info ')][.//div[normalize-space(text())='%s']]", zoneName);
        assertTrue("Zone [" + zoneName + " is selected", isElementExist(xpath, 2));
    }

    public void verifyCountOfSelectedZones(int numberOfZones)
    {
        assertEquals("Count of selected zones ", numberOfZones, getElementsCount("//div[contains(@class,'zone-info ')]"));
        assertEquals("Count of markers", numberOfZones, getElementsCount("//div[contains(@class, 'marker')]"));
    }
}
