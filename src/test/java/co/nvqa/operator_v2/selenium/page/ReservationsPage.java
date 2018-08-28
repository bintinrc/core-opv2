package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Address;
import co.nvqa.commons.model.core.Reservation;
import co.nvqa.operator_v2.util.TestConstants;
import co.nvqa.operator_v2.util.TestUtils;
import org.junit.Assert;
import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;

import java.util.Calendar;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings({"WeakerAccess", "unused"})
public class ReservationsPage extends OperatorV2SimplePage
{
    public ReservationsPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    private int getNextDateNumber()
    {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(TestUtils.getNextDate(1));
        return calendar.get(Calendar.DATE);
    }

    private String getNextDateCellXpath()
    {
        return String.format("//nv-calendar//div[@ng-repeat='day in week track by $index'][@tabindex='%d']", getNextDateNumber());
    }

    public void waitUntilReservationsLoaded()
    {
        waitUntilInvisibilityOfElementLocated("//div[text()='Loading reservations...']");
    }

    public void createNewReservation(String shipperName, Address address, Reservation reservation, String timeslot)
    {
        String completeAddress = address.getAddress1() + ' ' + address.getAddress2();

        selectValueFromNvAutocomplete("ctrl.shipperSearchText", shipperName);
        selectValueFromNvAutocomplete("ctrl.addressSearchText", completeAddress);
        waitUntilInvisibilityOfElementLocated(getNextDateCellXpath()+"//div[contains(@style, 'inherit')]/md-progress-circular");
        click(getNextDateCellXpath());
        clickButtonByAriaLabel("Create Reservations");
        pause1s(); // Delay for sliding animation.
        clickf("//form[@name='createForm']//button[@aria-label='%s']", timeslot);
        selectValueFromMdSelect("ctrl.createForm.approxVolume", reservation.getApproxVolume());
        sendKeys("//md-input-container[@form='createForm']//input[@aria-label='Comments']", reservation.getComments());
        clickNvButtonSaveByNameAndWaitUntilDone("Create Reservation");
        waitUntilInvisibilityOfToast("Reservation Created Successfully");
    }

    public void verifyReservationIsCreatedSuccessfully(String expectedTimeslotTextOnCalendar)
    {
        boolean isNextDateCellLabeledAsReserved = isElementExist(getNextDateCellXpath()+"//div[text()='Reserved']");
        Assert.assertTrue(String.format("Reservation is not created. Label 'Reserved' is not found at the calendar on date %d.", getNextDateNumber()), isNextDateCellLabeledAsReserved);

        String actualTimeslotTextOnCalendar = getText(getNextDateCellXpath()+"//div[contains(@ng-repeat,'rsvn in $calendar.reservations')]/nv-icon-text-button/button/div[1]");
        Assert.assertEquals("Reservation is not created correctly. Timeslot does not change.", expectedTimeslotTextOnCalendar.trim(), actualTimeslotTextOnCalendar.trim());
    }

    public void editReservation(String shipperName, Address address, Reservation reservation, String newTimeslot)
    {
        String editBtnXpath = getNextDateCellXpath()+"//nv-icon-button[@name='Edit Reservation']";
        WebElement editBtnWe = findElementByXpath(editBtnXpath);
        Actions action = new Actions(getWebDriver());
        action.moveToElement(editBtnWe).pause(100).click().pause(100).perform();
        pause1s(); // Delay for sliding animation.
        clickf("//form[@name='editForm']//button[@aria-label='%s']", newTimeslot);
        clickNvButtonSaveByNameAndWaitUntilDone("Save changes");
        waitUntilInvisibilityOfElementLocated("//div[@id='toast-container']//div[@class='toast-message']/div[@class='toast-right']/div[@class='toast-top']/div[text()='Reservations updated']", TestConstants.VERY_LONG_WAIT_FOR_TOAST);
    }

    public void verifyReservationIsUpdatedSuccessfully(String expectedTimeslotTextOnCalendar)
    {
        boolean isNextDateCellLabeledAsReserved = isElementExist(getNextDateCellXpath()+"//div[text()='Reserved']");
        Assert.assertTrue(String.format("Reservation is not updated. Label 'Reserved' is not found at the calendar on date %d.", getNextDateNumber()), isNextDateCellLabeledAsReserved);

        String actualTimeslotTextOnCalendar = getText(getNextDateCellXpath()+"//div[contains(@ng-repeat,'rsvn in $calendar.reservations')]/nv-icon-text-button/button/div[1]");
        Assert.assertEquals("Reservation is not updated. Timeslot does not change.", expectedTimeslotTextOnCalendar.trim(), actualTimeslotTextOnCalendar.trim());
    }

    public void deleteReservation(String shipperName, Address address, Reservation reservation)
    {
        String deleteBtnXpath = getNextDateCellXpath()+"//nv-icon-button[@name='Delete Reservation']";
        WebElement deleteBtnWe = findElementByXpath(deleteBtnXpath);
        Actions action = new Actions(getWebDriver());
        action.moveToElement(deleteBtnWe).pause(100).click().pause(100).perform();
        pause1s(); // Delay for sliding animation.
        clickButtonOnMdDialogByAriaLabel("Delete");
        waitUntilInvisibilityOfElementLocated("//div[@id='toast-container']//div[@class='toast-message']/div[@class='toast-right']/div[@class='toast-top']/div[text()='Reservations deleted']", TestConstants.VERY_LONG_WAIT_FOR_TOAST);
    }

    public void verifyReservationIsDeletedSuccessfully()
    {
        boolean isNextDateCellLabeledAsReserved;

        try
        {
            waitUntilInvisibilityOfElementLocated(getNextDateCellXpath()+"//div[text()='Reserved']");
            isNextDateCellLabeledAsReserved = false;
        }
        catch(TimeoutException ex)
        {
            isNextDateCellLabeledAsReserved = true;
        }

        Assert.assertFalse(String.format("Reservation is not deleted. Label 'Reserved' is still found at the calendar on date %d.", getNextDateNumber()), isNextDateCellLabeledAsReserved);
    }
}
