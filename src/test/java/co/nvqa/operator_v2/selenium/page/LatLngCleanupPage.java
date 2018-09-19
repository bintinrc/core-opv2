package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.WaypointDetails;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

/**
 *
 * @author Sergey Mishanin
 */
@SuppressWarnings("WeakerAccess")
public class LatLngCleanupPage extends OperatorV2SimplePage
{
    public static final String LOCATOR_BUTTON_EDIT_WAYPOINT_DETAILS = "container.lat-lng-cleanup.edit-waypoint-details";

    private EditWaypointDetailsDialog editWaypointDetailsDialog;

    public LatLngCleanupPage(WebDriver webDriver)
    {
        super(webDriver);
        editWaypointDetailsDialog = new EditWaypointDetailsDialog(webDriver);
    }

    public EditWaypointDetailsDialog openEditWaypointDetailsDialog()
    {
        clickNvIconTextButtonByName(LOCATOR_BUTTON_EDIT_WAYPOINT_DETAILS);
        editWaypointDetailsDialog.waitUtilVisibility();
        return editWaypointDetailsDialog;
    }

    public void editWaypointDetails(Long waypointId, WaypointDetails newWaypointDetails)
    {
        openEditWaypointDetailsDialog()
                .searchWaypoint(String.valueOf(waypointId))
                .validateWaypoitWasFound()
                .fillForm(newWaypointDetails)
                .submitForm()
                .close();
    }

    public void validateWaypointDetails(Long waypointId, WaypointDetails expectedWaypointDetails)
    {
        WaypointDetails actualWaypointDetails = openEditWaypointDetailsDialog()
                .searchWaypoint(String.valueOf(waypointId))
                .validateWaypoitWasFound()
                .getWaypointDetails();

        expectedWaypointDetails.compareWithActual(actualWaypointDetails);
    }


    /**
     * Accessor for Edit Waypoint Details dialog
     */
    @SuppressWarnings("UnusedReturnValue")
    public static class EditWaypointDetailsDialog extends OperatorV2SimplePage
    {
        private static final String DIALOG_TITLE = "Edit Waypoint Details";
        private static final String LOCATOR_FIELD_SEARCH_WAYPOINT_ID = "searchWaypointId";
        private static final String LOCATOR_BUTTON_SEARCH = "commons.search";
        private static final String LOCATOR_FIELD_WAYPOINT_ID = "commons.waypoint-id";
        private static final String LOCATOR_FIELD_ADDRESS_1 = "commons.address1";
        private static final String LOCATOR_FIELD_ADDRESS_2 = "commons.address2";
        private static final String LOCATOR_FIELD_CITY = "commons.city";
        private static final String LOCATOR_FIELD_COUNTRY = "commons.country";
        private static final String LOCATOR_FIELD_POSTAL_CODE = "commons.postcode";
        private static final String LOCATOR_FIELD_LATITUDE = "commons.latitude";
        private static final String LOCATOR_FIELD_LONGITUDE = "commons.longitude";
        private static final String BUTTON_SUBMIT_ARIA_LABEL = "Save changes";
        private static final String LOCATOR_BUTTON_CLOSE = "Cancel";
        private static final String LOCATOR_MESSAGE_WAYPOINT_NOT_FOUND = "//div[@ng-message='invalidWaypointId']";

        public EditWaypointDetailsDialog(WebDriver webDriver)
        {
            super(webDriver);
        }

        public void waitUtilVisibility()
        {
            waitUntilVisibilityOfMdDialogByTitle(DIALOG_TITLE);
        }

        public EditWaypointDetailsDialog searchWaypoint(String waypointId)
        {
            sendKeysById(LOCATOR_FIELD_SEARCH_WAYPOINT_ID, waypointId);
            clickNvApiTextButtonByNameAndWaitUntilDone(LOCATOR_BUTTON_SEARCH);
            return this;
        }

        public EditWaypointDetailsDialog setAddress1(String address1)
        {
            sendKeysById(LOCATOR_FIELD_ADDRESS_1, address1);
            return this;
        }

        public EditWaypointDetailsDialog setAddress2(String address2)
        {
            sendKeysById(LOCATOR_FIELD_ADDRESS_2, address2);
            return this;
        }

        public EditWaypointDetailsDialog setCity(String city)
        {
            sendKeysById(LOCATOR_FIELD_CITY, city);
            return this;
        }

        public EditWaypointDetailsDialog setCountry(String country)
        {
            sendKeysById(LOCATOR_FIELD_COUNTRY, country);
            return this;
        }

        public EditWaypointDetailsDialog setPostalCode(String postalCode)
        {
            sendKeysById(LOCATOR_FIELD_POSTAL_CODE, postalCode);
            return this;
        }

        public EditWaypointDetailsDialog setLatitude(String latitude)
        {
            sendKeysById(LOCATOR_FIELD_LATITUDE, latitude);
            return this;
        }

        public EditWaypointDetailsDialog setLongitude(String longitude)
        {
            sendKeysById(LOCATOR_FIELD_LONGITUDE, longitude);
            return this;
        }

        public EditWaypointDetailsDialog fillForm(WaypointDetails waypointDetails)
        {
            if(waypointDetails.getAddress1()!=null)
            {
                setAddress1(waypointDetails.getAddress1());
            }

            if(waypointDetails.getAddress2()!=null)
            {
                setAddress2(waypointDetails.getAddress2());
            }

            if(waypointDetails.getCity()!=null)
            {
                setCity(waypointDetails.getCity());
            }

            if(waypointDetails.getCountry()!=null)
            {
                setCountry(waypointDetails.getCountry());
            }

            if(waypointDetails.getPostalCode()!=null)
            {
                setPostalCode(waypointDetails.getPostalCode());
            }

            if(waypointDetails.getLatitude()!=null)
            {
                setLatitude(String.valueOf(waypointDetails.getLatitude()));
            }

            if(waypointDetails.getLongitude()!=null)
            {
                setLongitude(String.valueOf(waypointDetails.getLongitude()));
            }

            return this;
        }

        public String getWaypointId()
        {
            return getInputValueById(LOCATOR_FIELD_WAYPOINT_ID, XpathTextMode.STARTS_WITH);
        }

        public String getAddress1()
        {
            return getInputValueById(LOCATOR_FIELD_ADDRESS_1, XpathTextMode.STARTS_WITH);
        }

        public String getAddress2()
        {
            return getInputValueById(LOCATOR_FIELD_ADDRESS_2, XpathTextMode.STARTS_WITH);
        }

        public String getCity()
        {
            return getInputValueById(LOCATOR_FIELD_CITY, XpathTextMode.STARTS_WITH);
        }

        public String getCountry()
        {
            return getInputValueById(LOCATOR_FIELD_COUNTRY, XpathTextMode.STARTS_WITH);
        }

        public String getPostalCode()
        {
            return getInputValueById(LOCATOR_FIELD_POSTAL_CODE, XpathTextMode.STARTS_WITH);
        }

        public String getLatitude()
        {
            return getInputValueById(LOCATOR_FIELD_LATITUDE, XpathTextMode.STARTS_WITH);
        }

        public String getLongitude()
        {
            return getInputValueById(LOCATOR_FIELD_LONGITUDE, XpathTextMode.STARTS_WITH);
        }

        public WaypointDetails getWaypointDetails()
        {
            WaypointDetails waypointDetails = new WaypointDetails();
            waypointDetails.setId(getWaypointId());
            waypointDetails.setAddress1(getAddress1());
            waypointDetails.setAddress2(getAddress2());
            waypointDetails.setCity(getCity());
            waypointDetails.setCountry(getCountry());
            waypointDetails.setPostalCode(getPostalCode());
            waypointDetails.setLatitude(getLatitude());
            waypointDetails.setLongitude(getLongitude());

            return waypointDetails;
        }

        public EditWaypointDetailsDialog validateWaypoitWasFound()
        {
            Assert.assertFalse("Waypoint Id cannot be found", isElementVisible(LOCATOR_MESSAGE_WAYPOINT_NOT_FOUND));
            return this;
        }

        public EditWaypointDetailsDialog submitForm()
        {
            clickButtonByAriaLabelAndWaitUntilDone(BUTTON_SUBMIT_ARIA_LABEL);
            return this;
        }

        public void close()
        {
            clickNvIconButtonByName(LOCATOR_BUTTON_CLOSE);
            waitUntilInvisibilityOfMdDialogByTitle(DIALOG_TITLE);
        }
    }
}
