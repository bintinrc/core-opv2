package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Address;
import co.nvqa.commons.model.core.Reservation;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.md.ContainerSwitch;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import co.nvqa.operator_v2.selenium.elements.nv.NvAutocomplete;
import co.nvqa.operator_v2.selenium.elements.nv.NvButtonSave;
import co.nvqa.operator_v2.util.TestConstants;
import co.nvqa.operator_v2.util.TestUtils;
import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.FindBy;

import java.util.Calendar;
import java.util.Locale;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings({"WeakerAccess", "unused"})
public class ReservationsPage extends OperatorV2SimplePage
{
    @FindBy(css = "nv-autocomplete[search-text='ctrl.shipperSearchText']")
    public NvAutocomplete shipper;

    @FindBy(css = "nv-autocomplete[search-text='ctrl.addressSearchText']")
    public NvAutocomplete address;

    @FindBy(css = "button[aria-label='Create Reservations']")
    public Button createReservations;

    @FindBy(css = "nv-button-timeslot")
    public ContainerSwitch timeslot;

    @FindBy(css = "[aria-label='Approx. Volume']")
    public MdSelect approxVolume;

    @FindBy(css = "[aria-label='Comments']")
    public TextBox comments;

    @FindBy(css = "[aria-label='Priority Level']")
    public TextBox priorityLevel;

    @FindBy(name = "Create Reservation")
    public NvButtonSave createReservation;

    public ReservationsPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    private int getNextDateNumber()
    {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(TestUtils.getNextDate(1));

        String expectedMonth = calendar.getDisplayName(Calendar.MONTH, Calendar.LONG, Locale.ENGLISH);
        String actualMonth = getMdSelectValue("calendar.month");

        if (!expectedMonth.equals(actualMonth))
        {
            clickButtonByAriaLabel("Next month");
        }

        return calendar.get(Calendar.DATE);
    }

    private String getNextDateCellXpath()
    {
        return f("//nv-calendar//div[@ng-repeat='day in week track by $index'][@tabindex='%d']", getNextDateNumber());
    }

    public void waitUntilReservationsLoaded()
    {
        waitUntilInvisibilityOfElementLocated("//div[text()='Loading reservations...']");
    }

    public void createNewReservation(String shipperName, Address address, Reservation reservation, String timeslot)
    {
        String completeAddress = address.getAddress1() + ' ' + address.getAddress2();

        shipper.selectValue(shipperName);
        retryIfRuntimeExceptionOccurred(() -> this.address.selectValue(completeAddress), "Select address");
        waitUntilInvisibilityOfElementLocated(getNextDateCellXpath() + "//div[contains(@style, 'inherit')]/md-progress-circular");
        click(getNextDateCellXpath());
        createReservations.click();
        pause1s(); // Delay for sliding animation.
        this.timeslot.selectValue(timeslot);
        approxVolume.selectValue(reservation.getApproxVolume());
        comments.setValue(reservation.getComments());

        if (reservation.getPriorityLevel() != null)
        {
            priorityLevel.setValue(reservation.getPriorityLevel());
        }

        createReservation.clickAndWaitUntilDone();
        waitUntilInvisibilityOfToast("Reservation Created Successfully");
    }

    public void verifyReservationIsCreatedSuccessfully(String expectedTimeslotTextOnCalendar)
    {
        boolean isNextDateCellLabeledAsReserved = isElementExist(getNextDateCellXpath() + "//div[text()='Reserved']");
        assertTrue(f("Reservation is not created. Label 'Reserved' is not found at the calendar on date %d.", getNextDateNumber()), isNextDateCellLabeledAsReserved);

        String actualTimeslotTextOnCalendar = getText(getNextDateCellXpath() + "//div[contains(@ng-repeat,'rsvn in $calendar.reservations')]/nv-icon-text-button/button/div[1]");
        assertEquals("Reservation is not created correctly. Timeslot does not change.", expectedTimeslotTextOnCalendar.trim(), actualTimeslotTextOnCalendar.trim());
    }

    public void editReservation(String shipperName, Address address, Reservation reservation, String newTimeslot)
    {
        String editBtnXpath = getNextDateCellXpath() + "//nv-icon-button[@name='Edit Reservation']";
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
        boolean isNextDateCellLabeledAsReserved = isElementExist(getNextDateCellXpath() + "//div[text()='Reserved']");
        assertTrue(f("Reservation is not updated. Label 'Reserved' is not found at the calendar on date %d.", getNextDateNumber()), isNextDateCellLabeledAsReserved);

        String actualTimeslotTextOnCalendar = getText(getNextDateCellXpath() + "//div[contains(@ng-repeat,'rsvn in $calendar.reservations')]/nv-icon-text-button/button/div[1]");
        assertEquals("Reservation is not updated. Timeslot does not change.", expectedTimeslotTextOnCalendar.trim(), actualTimeslotTextOnCalendar.trim());
    }

    public void deleteReservation(String shipperName, Address address, Reservation reservation)
    {
        String deleteBtnXpath = getNextDateCellXpath() + "//nv-icon-button[@name='Delete Reservation']";
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
            waitUntilInvisibilityOfElementLocated(getNextDateCellXpath() + "//div[text()='Reserved']");
            isNextDateCellLabeledAsReserved = false;
        } catch (TimeoutException ex)
        {
            isNextDateCellLabeledAsReserved = true;
        }

        assertFalse(f("Reservation is not deleted. Label 'Reserved' is still found at the calendar on date %d.", getNextDateNumber()), isNextDateCellLabeledAsReserved);
    }
}
