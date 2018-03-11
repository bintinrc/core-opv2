package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Address;
import org.hamcrest.Matchers;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

import java.util.Date;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class ShipperPickupsPage extends OperatorV2SimplePage
{
    private static final String MD_VIRTUAL_REPEAT = "data in getTableData()";

    public static final String COLUMN_CLASS_SHIPPER_NAME_AND_CONTACT = "name";
    public static final String COLUMN_CLASS_ROUTE_ID = "route-id";
    public static final String COLUMN_CLASS_DRIVER_NAME = "driver-name";
    public static final String COLUMN_CLASS_PRIORITY_LEVEL = "priority-level";
    public static final String COLUMN_CLASS_PICKUP_ADDRESS = "pickup-address";
    public static final String COLUMN_CLASS_APPROX_VOLUME = "approx-volume";
    public static final String COLUMN_CLASS_COMMENTS = "comments";

    public static final String ACTION_BUTTON_ROUTE_EDIT = "Route Edit";
    public static final String ACTION_BUTTON_DETAILS = "Details";

    public ShipperPickupsPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    private String buildPickupAddress(Address address)
    {
        String address1 = address.getAddress1();
        String address2 = address.getAddress2();
        String pickupAddress = address1;

        if(address2!=null && !address2.isEmpty())
        {
            pickupAddress += " "+address2;
        }

        if(pickupAddress!=null)
        {
            pickupAddress = pickupAddress.trim();
        }

        return pickupAddress;
    }

    public void assignReservationToRoute(Address address, Long routeId)
    {
        assignReservationToRoute(address, routeId, null);
    }

    public void assignReservationToRoute(Address address, Long routeId, Integer priorityLevel)
    {
        String pickupAddress = buildPickupAddress(address);
        searchTableByPickupAddress(pickupAddress);
        clickActionButtonOnTable(1, ACTION_BUTTON_ROUTE_EDIT);

        Assert.assertNotNull("Route ID should not be null.", routeId);
        selectValueFromNvAutocomplete("ctrl.data.textRoute", String.valueOf(routeId));

        if(priorityLevel!=null)
        {
            sendKeysById("Priority Level", String.valueOf(priorityLevel));
        }

        clickNvApiTextButtonByNameAndWaitUntilDone("commons.save-changes");
    }

    public void verifyReservationInfo(Address address, String shipperName, String routeId, String driverName, String priorityLevel, String approxVolume, String comments)
    {
        String pickupAddress = buildPickupAddress(address);
        searchTableByPickupAddress(pickupAddress);

        String actualShipperNameAndContact = getTextOnTable(1, COLUMN_CLASS_SHIPPER_NAME_AND_CONTACT);
        String actualPickupAddress = getTextOnTable(1, COLUMN_CLASS_PICKUP_ADDRESS);
        String actualRouteId = getTextOnTable(1, COLUMN_CLASS_ROUTE_ID);
        String actualDriverName = getTextOnTable(1, COLUMN_CLASS_DRIVER_NAME);
        String actualPriorityLevel = getTextOnTable(1, COLUMN_CLASS_PRIORITY_LEVEL);
        String actualApproxVolume = getTextOnTable(1, COLUMN_CLASS_APPROX_VOLUME);
        String actualComments = getTextOnTable(1, COLUMN_CLASS_COMMENTS);

        // Remove multiple [SPACE] chars from String value.
        actualPickupAddress = actualPickupAddress.trim().replaceAll("\\s+", " ");
        pickupAddress = pickupAddress.trim().replaceAll("\\s+", " ");

        Assert.assertThat("Shipper Name", actualShipperNameAndContact, Matchers.startsWith(shipperName));
        Assert.assertThat("Pickup Address", actualPickupAddress, Matchers.startsWith(pickupAddress));

        if(routeId!=null && !routeId.isEmpty())
        {
            Assert.assertEquals("Route ID", routeId, actualRouteId);
        }

        if(driverName!=null && !driverName.isEmpty())
        {
            Assert.assertEquals("Driver Name", driverName, actualDriverName);
        }

        if(priorityLevel!=null && !priorityLevel.isEmpty())
        {
            Assert.assertEquals("Priority Level", priorityLevel, actualPriorityLevel);
        }

        if(approxVolume!=null && !approxVolume.isEmpty())
        {
            Assert.assertEquals("Approx. Volume", approxVolume, actualApproxVolume);
        }

        if(comments!=null && !comments.isEmpty())
        {
            if(comments.length()>255)
            {
                comments = comments.substring(0, 255)+"...";
            }

            Assert.assertEquals("Comments", comments, actualComments);
        }
    }

    public void verifyReservationDetails(Address address, String shipperName, String shipperId, String reservationId)
    {
        String pickupAddress = buildPickupAddress(address);
        searchTableByPickupAddress(pickupAddress);
        clickActionButtonOnTable(1, ACTION_BUTTON_DETAILS);
        waitUntilVisibilityOfElementLocated("//md-dialog-content//h5[text()='Details']");

        String actualShipperName = getTextTrimmed("//md-input-container[@id='field-shipper-name']/div");
        String actualShipperId = getTextTrimmed("//md-input-container[@id='field-shipper-id']/div");
        String actualReservationId = getTextTrimmed("//md-input-container[@id='field-reservation-id']/div");
        String actualPickupAddress = getTextTrimmed("//md-input-container[@id='field-pickup-address']/div");

        Assert.assertEquals("Shipper Name", shipperName, actualShipperName);
        Assert.assertEquals("Shipper ID", shipperId, actualShipperId);
        Assert.assertEquals("Reservation ID", reservationId, actualReservationId);
        Assert.assertThat("Pickup Address", actualPickupAddress, Matchers.startsWith(pickupAddress));
    }

    public void filterReservationDate(Date fromDate, Date toDate)
    {
        setMdDatepicker("fromModel", fromDate);
        setMdDatepicker("toModel", toDate);
    }

    public void clickButtonLoadSelection()
    {
        clickNvApiTextButtonByNameAndWaitUntilDone("Load Selection");
    }

    public void clickButtonRefresh()
    {
        clickNvApiIconButtonByNameAndWaitUntilDone("Refresh");
    }

    public void searchTableByPickupAddress(String pickupAddress)
    {
        searchTableCustom1("pickup-address", pickupAddress);
    }

    public String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTable(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT);
    }

    public void clickActionButtonOnTable(int rowNumber, String actionButtonName)
    {
        clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName, MD_VIRTUAL_REPEAT);
    }
}
