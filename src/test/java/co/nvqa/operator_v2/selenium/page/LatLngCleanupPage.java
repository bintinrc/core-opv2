package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.WaypointDetails;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

/**
 * @author Sergey Mishanin
 */
public class LatLngCleanupPage extends OperatorV2SimplePage
{
    @FindBy(name = "container.lat-lng-cleanup.edit-waypoint-details")
    public NvIconTextButton editWaypointDetails;

    @FindBy(css = "md-dialog")
    public EditWaypointDetailsDialog editWaypointDetailsDialog;

    public LatLngCleanupPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public EditWaypointDetailsDialog openEditWaypointDetailsDialog()
    {
        editWaypointDetails.click();
        editWaypointDetailsDialog.waitUntilVisible();
        return editWaypointDetailsDialog;
    }

    public void editWaypointDetails(Long waypointId, WaypointDetails newWaypointDetails)
    {
        openEditWaypointDetailsDialog()
                .searchWaypoint(String.valueOf(waypointId))
                .validateWaypointWasFound()
                .fillForm(newWaypointDetails)
                .submitForm()
                .close();
    }

    public void validateWaypointDetails(Long waypointId, WaypointDetails expectedWaypointDetails)
    {
        WaypointDetails actualWaypointDetails = openEditWaypointDetailsDialog()
                .searchWaypoint(String.valueOf(waypointId))
                .validateWaypointWasFound()
                .getWaypointDetails();

        expectedWaypointDetails.compareWithActual(actualWaypointDetails);
    }


    /**
     * Accessor for Edit Waypoint Details dialog
     */
    @SuppressWarnings("UnusedReturnValue")
    public static class EditWaypointDetailsDialog extends MdDialog
    {

        @FindBy(name = "commons.search")
        public NvApiTextButton search;

        @FindBy(xpath = ".//div[@ng-message='invalidWaypointId']")
        public PageElement invalidWaypointIdMessage;

        @FindBy(css = "[id^='searchWaypointId']")
        public TextBox searchWaypointId;


        @FindBy(css = "[id^='commons.waypoint-id']")
        public PageElement waypointId;

        @FindBy(css = "[id^='commons.address1']")
        public TextBox address1;

        @FindBy(css = "[id^='commons.address2']")
        public TextBox address2;

        @FindBy(css = "[id^='commons.city']")
        public TextBox city;

        @FindBy(css = "[id^='commons.country']")
        public TextBox country;

        @FindBy(css = "[id^='commons.postcode']")
        public TextBox postcode;

        @FindBy(css = "[id^='commons.latitude']")
        public TextBox latitude;

        @FindBy(css = "[id^='commons.longitude']")
        public TextBox longitude;

        @FindBy(name = "commons.save-changes")
        public NvApiTextButton saveChanges;

        public EditWaypointDetailsDialog(WebDriver webDriver, WebElement webElement)
        {
            super(webDriver, webElement);
        }

        public EditWaypointDetailsDialog searchWaypoint(String waypointId)
        {
            this.searchWaypointId.sendKeys(waypointId);
            search.click();
            return this;
        }


        public EditWaypointDetailsDialog fillForm(WaypointDetails waypointDetails)
        {
            if (waypointDetails.getAddress1() != null)
            {
                address1.setValue(waypointDetails.getAddress1());
            }

            if (waypointDetails.getAddress2() != null)
            {
                address2.setValue(waypointDetails.getAddress2());
            }

            if (waypointDetails.getCity() != null)
            {
                city.setValue(waypointDetails.getCity());
            }

            if (waypointDetails.getCountry() != null)
            {
                country.setValue(waypointDetails.getCountry());
            }

            if (waypointDetails.getPostalCode() != null)
            {
                postcode.setValue(waypointDetails.getPostalCode());
            }

            if (waypointDetails.getLatitude() != null)
            {
                latitude.setValue(waypointDetails.getLatitude());
            }

            if (waypointDetails.getLongitude() != null)
            {
                longitude.setValue(waypointDetails.getLongitude());
            }

            return this;
        }

        public WaypointDetails getWaypointDetails()
        {
            WaypointDetails waypointDetails = new WaypointDetails();
            waypointDetails.setId(waypointId.getValue());
            waypointDetails.setAddress1(address1.getValue());
            waypointDetails.setAddress2(address2.getValue());
            waypointDetails.setCity(city.getValue());
            waypointDetails.setCountry(country.getValue());
            waypointDetails.setPostalCode(postcode.getValue());
            waypointDetails.setLatitude(latitude.getValue());
            waypointDetails.setLongitude(longitude.getValue());

            return waypointDetails;
        }

        public EditWaypointDetailsDialog validateWaypointWasFound()
        {
            assertFalse("Waypoint Id cannot be found", invalidWaypointIdMessage.isDisplayedFast());
            return this;
        }

        public EditWaypointDetailsDialog submitForm()
        {
            saveChanges.clickAndWaitUntilDone();
            return this;
        }

        public void close()
        {
            sendKeys(Keys.ESCAPE);
            waitUntilInvisible();
        }
    }
}