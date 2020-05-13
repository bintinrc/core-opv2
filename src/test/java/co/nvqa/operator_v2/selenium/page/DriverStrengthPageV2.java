package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.DriverInfo;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.md.MdDialog;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.common.collect.ImmutableMap;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import java.text.ParseException;

import static co.nvqa.operator_v2.selenium.page.DriverStrengthPageV2.DriversTable.*;

/**
 * @author Sergey Mishanin
 */
@SuppressWarnings("WeakerAccess")
public class DriverStrengthPageV2 extends OperatorV2SimplePage
{
    private static final String LOCATOR_SPINNER = "//md-progress-circular";
    public static final String LOCATOR_BUTTON_LOAD_EVERYTHING = "container.driver-strength.load-everything";
    public static final String LOCATOR_DELETE_BUTTON = "//md-dialog//button[@aria-label='Delete']";

    private AddDriverDialog addDriverDialog;
    private EditDriverDialog editDriverDialog;
    private DriversTable driversTable;
    private ContactDetailsMenu contactDetailsMenu;

    public DriverStrengthPageV2(WebDriver webDriver)
    {
        super(webDriver);
        addDriverDialog = new AddDriverDialog(webDriver);
        editDriverDialog = new EditDriverDialog(webDriver);
        driversTable = new DriversTable(webDriver);
        contactDetailsMenu = new ContactDetailsMenu(webDriver);
    }

    public DriversTable driversTable()
    {
        return driversTable;
    }

    public void clickAddNewDriver()
    {
        waitUntilVisibilityOfElementLocated("//nv-icon-text-button[@name='Add New Driver']//button");
        click("//nv-icon-text-button[@name='Add New Driver']//button");
    }

    public void addNewDriver(DriverInfo driverInfo)
    {
        waitUntilInvisibilityOfElementLocated(LOCATOR_SPINNER);
        clickAddNewDriver();
        addDriverDialog.fillForm(driverInfo);
    }

    public void editDriver(String username, DriverInfo newDriverInfo)
    {
        filterBy(COLUMN_USERNAME, username);
        driversTable.clickActionButton(1, ACTION_EDIT);
        editDriverDialog.fillForm(newDriverInfo);
    }

    public void filterBy(String columnName, String value)
    {
        if (isElementExist(String.format("//*[@name='%s']", LOCATOR_BUTTON_LOAD_EVERYTHING), 0))
        {
            clickNvIconTextButtonByNameAndWaitUntilDone(LOCATOR_BUTTON_LOAD_EVERYTHING);
        }
        driversTable.filterByColumn(columnName, value);
    }

    public void verifyContactDetails(String username, DriverInfo expectedContactDetails)
    {
        filterBy(COLUMN_USERNAME, username);
        driversTable.clickActionButton(1, ACTION_CONTACT_INFO);
        DriverInfo actualContactDetails = contactDetailsMenu.readData();
        if (StringUtils.isNotBlank(expectedContactDetails.getLicenseNumber()))
        {
            assertThat("License Number", actualContactDetails.getLicenseNumber(), equalTo(expectedContactDetails.getLicenseNumber()));
        }
        if (StringUtils.isNotBlank(expectedContactDetails.getContact()))
        {
            assertThat("Contact", actualContactDetails.getContact(), equalTo(expectedContactDetails.getContact()));
        }
        if (StringUtils.isNotBlank(expectedContactDetails.getContactType()))
        {
            assertThat("Contact Type", actualContactDetails.getContactType(), containsString(expectedContactDetails.getContactType()));
        }
        if (StringUtils.isNotBlank(expectedContactDetails.getComments()))
        {
            assertThat("Comments", actualContactDetails.getComments(), equalTo(expectedContactDetails.getComments()));
        }
    }

    public void verifyDriverInfo(DriverInfo expectedDriverInfo)
    {
        filterBy(COLUMN_USERNAME, expectedDriverInfo.getUsername());
        DriverInfo actualDriverInfo = driversTable.readEntity(1);
        if (expectedDriverInfo.getId() != null)
        {
            assertThat("Id", actualDriverInfo.getId(), equalTo(expectedDriverInfo.getId()));
        }
        if (StringUtils.isNotBlank(expectedDriverInfo.getUsername()))
        {
            assertThat("Username", actualDriverInfo.getUsername(), equalTo(expectedDriverInfo.getUsername()));
        }
        if (StringUtils.isNotBlank(expectedDriverInfo.getFirstName()))
        {
            assertThat("First Name", actualDriverInfo.getFirstName(), equalTo(expectedDriverInfo.getFirstName()));
        }
        if (StringUtils.isNotBlank(expectedDriverInfo.getLastName()))
        {
            assertThat("Last Name", actualDriverInfo.getLastName(), equalTo(expectedDriverInfo.getLastName()));
        }
        if (StringUtils.isNotBlank(expectedDriverInfo.getType()))
        {
            assertThat("Type", actualDriverInfo.getType(), equalTo(expectedDriverInfo.getType()));
        }
        if (expectedDriverInfo.getZoneMin() != null)
        {
            assertThat("Min", actualDriverInfo.getZoneMin(), equalTo(expectedDriverInfo.getZoneMin()));
        }
        if (expectedDriverInfo.getZoneMax() != null)
        {
            assertThat("Max", actualDriverInfo.getZoneMax(), equalTo(expectedDriverInfo.getZoneMax()));
        }
        if (StringUtils.isNotBlank(expectedDriverInfo.getComments()))
        {
            assertThat("Comments", actualDriverInfo.getComments(), equalTo(expectedDriverInfo.getComments()));
        }
    }

    public void deleteDriver(String username)
    {
        filterBy(COLUMN_USERNAME, username);
        driversTable.clickActionButton(1, ACTION_DELETE);
        waitUntilVisibilityOfMdDialogByTitle("Confirm delete");
        waitUntilElementIsClickable(LOCATOR_DELETE_BUTTON);
        clickButtonOnMdDialogByAriaLabel("Delete");
        waitUntilInvisibilityOfMdDialogByTitle("Confirm delete");
    }

    /**
     * Accessor for Add Driver dialog
     */
    @SuppressWarnings("UnusedReturnValue")
    public static class AddDriverDialog extends OperatorV2SimplePage
    {
        protected String dialogTittle;
        protected String locatorButtonSubmit;

        public static final String DIALOG_TITLE = "Add Driver";
        public static final String LOCATOR_FIELD_FIRST_NAME = "First Name";
        public static final String LOCATOR_FIELD_EMPLOYMENT_START_DATE = "employment-start-date";
        public static final String LOCATOR_FIELD_LAST_NAME = "Last Name";
        public static final String LOCATOR_FIELD_DRIVER_LICENSE_NUMBER = "Driver License Number";
        public static final String LOCATOR_FIELD_DRIVER_COD_LIMIT = "COD Limit";
        public static final String LOCATOR_VEHICLES_BUTTON_ADD_MORE_VEHICLES = "Add More Vehicles";
        public static final String LOCATOR_VEHICLES_BUTTON_REMOVE = "//*[@label='Vehicles']//button[@aria-label='Remove']";
        public static final String LOCATOR_VEHICLES_FIELD_LICENSE_NUMBER = "License Number";
        public static final String LOCATOR_VEHICLES_FIELD_CAPACITY = "Vehicle Capacity";
        public static final String LOCATOR_CONTACTS_BUTTON_ADD_MORE_CONTACTS = "Add More Contacts";
        public static final String LOCATOR_CONTACTS_BUTTON_REMOVE = "//*[@label='Contacts']//button[@aria-label='Remove']";
        public static final String LOCATOR_CONTACTS_FIELD_CONTACT_TYPE = "contact-type";
        public static final String LOCATOR_CONTACTS_FIELD_CONTACT = "Contact";
        public static final String LOCATOR_ZONES_BUTTON_ADD_MORE_ZONES = "Add More Zones";
        public static final String LOCATOR_ZONES_BUTTON_REMOVE = "//*[@label='Preferred Zones + Capacity']//button[@aria-label='Remove']";
        public static final String LOCATOR_ZONES_FIELD_ZONE_ID = "zone";
        public static final String LOCATOR_ZONES_FIELD_MIN = "Min";
        public static final String LOCATOR_ZONES_FIELD_MAX = "Max";
        public static final String LOCATOR_ZONES_FIELD_COST = "Cost";
        public static final String LOCATOR_FIELD_USERNAME = "Username";
        public static final String LOCATOR_FIELD_PASSWORD = "Password";
        public static final String LOCATOR_FIELD_COMMENTS = "Comments";
        public static final String LOCATOR_BUTTON_SUBMIT = "Submit";
        public static final String LOCATOR_HUB = "Hub";

        public AddDriverDialog(WebDriver webDriver)
        {
            super(webDriver);
            dialogTittle = DIALOG_TITLE;
            locatorButtonSubmit = LOCATOR_BUTTON_SUBMIT;
        }

        public AddDriverDialog waitUntilVisible()
        {
            waitUntilVisibilityOfMdDialogByTitle(dialogTittle);
            return this;
        }

        public AddDriverDialog setHub(String value)
        {
            selectValueFromMdAutocomplete(LOCATOR_HUB, value);
            return this;
        }

        public AddDriverDialog setFirstName(String value)
        {
            fillIfNotNull(LOCATOR_FIELD_FIRST_NAME, value);
            return this;
        }

        public AddDriverDialog setLastName(String value)
        {
            fillIfNotNull(LOCATOR_FIELD_LAST_NAME, value);
            return this;
        }

        public AddDriverDialog setEmploymentStartDate(String value)
        {
            try
            {
                setMdDatepickerById(LOCATOR_FIELD_EMPLOYMENT_START_DATE, TestUtils.MD_DATEPICKER_SDF.parse(value));
            } catch (ParseException e)
            {
                throw new RuntimeException("Incorrect value for Employment Satrt Field", e);
            }

            return this;
        }

        public AddDriverDialog setDriverLicenseNumber(String value)
        {
            fillIfNotNull(LOCATOR_FIELD_DRIVER_LICENSE_NUMBER, value);
            return this;
        }

        public AddDriverDialog setCodLimit(Integer value)
        {
            fillIfNotNull(LOCATOR_FIELD_DRIVER_COD_LIMIT, value);
            return this;
        }

        public AddDriverDialog addVehicle(String licenseNumber, Integer capacity)
        {
            clickNvIconTextButtonByName(LOCATOR_VEHICLES_BUTTON_ADD_MORE_VEHICLES);
            fillIfNotNull(LOCATOR_VEHICLES_FIELD_LICENSE_NUMBER, licenseNumber);
            fillIfNotNull(LOCATOR_VEHICLES_FIELD_CAPACITY, capacity);
            return this;
        }

        public AddDriverDialog addContact(String contactType, String contact)
        {
            clickNvIconTextButtonByName(LOCATOR_CONTACTS_BUTTON_ADD_MORE_CONTACTS);
            if (StringUtils.isNotBlank(contactType))
            {
                selectValueFromMdSelectById(LOCATOR_CONTACTS_FIELD_CONTACT_TYPE, contactType);
            }
            fillIfNotNull(LOCATOR_CONTACTS_FIELD_CONTACT, contact);
            return this;
        }

        public AddDriverDialog addZone(String zoneId, Integer min, Integer max, Integer cost)
        {
            scrollIntoView("//nv-icon-text-button[@name='Add More Zones']");
            clickNvIconTextButtonByName(LOCATOR_ZONES_BUTTON_ADD_MORE_ZONES);
            if (StringUtils.isNotBlank(zoneId))
            {
                selectValueFromMdSelectById(LOCATOR_ZONES_FIELD_ZONE_ID, zoneId);
            }
            fillIfNotNull(LOCATOR_ZONES_FIELD_MIN, min);
            fillIfNotNull(LOCATOR_ZONES_FIELD_MAX, max);
            fillIfNotNull(LOCATOR_ZONES_FIELD_COST, cost);
            return this;
        }

        public AddDriverDialog setUsername(String value)
        {
            fillIfNotNull(LOCATOR_FIELD_USERNAME, value);
            return this;
        }

        public AddDriverDialog setPassword(String value)
        {
            fillIfNotNull(LOCATOR_FIELD_PASSWORD, value);
            return this;
        }

        public AddDriverDialog setComments(String value)
        {
            fillIfNotNull(LOCATOR_FIELD_COMMENTS, value);
            return this;
        }

        public void submitForm()
        {
            clickNvButtonSaveByNameAndWaitUntilDone(locatorButtonSubmit);
            waitUntilInvisibilityOfMdDialogByTitle(dialogTittle);
        }

        public void fillForm(DriverInfo driverInfo)
        {
            waitUntilVisible();
            setFirstName(driverInfo.getFirstName());
            setLastName(driverInfo.getLastName());
            setDriverLicenseNumber(driverInfo.getLicenseNumber());
            setCodLimit(driverInfo.getCodLimit());
            setHub(driverInfo.getHub());
            setEmploymentStartDate(driverInfo.getEmploymentStartDate());
            if (driverInfo.hasVehicleInfo())
            {
                addVehicle(driverInfo.getVehicleLicenseNumber(), driverInfo.getVehicleCapacity());
            }
            if (driverInfo.hasContactsInfo())
            {
                addContact(driverInfo.getContactType(), driverInfo.getContact());
            }
            if (driverInfo.hasZoneInfo())
            {
                addZone(driverInfo.getZoneId(), driverInfo.getZoneMin(), driverInfo.getZoneMax(), driverInfo.getZoneCost());
            }
            setUsername(driverInfo.getUsername());
            setPassword(driverInfo.getPassword());
            setComments(driverInfo.getComments());
            submitForm();
        }

        protected void fillIfNotNull(String locator, Object value)
        {
            if (value != null)
            {
                sendKeysByAriaLabel(locator, String.valueOf(value));
            }
        }
    }

    /**
     * Accessor for Contact Details menu
     */
    public static class ContactDetailsMenu extends OperatorV2SimplePage
    {
        public static final String LOCATOR_CONTACT = "//*[contains(@class,'md-active')]//*[@class='contact-info-contacts']/div[1]";
        public static final String LOCATOR_CONTACT_TYPE = "//*[contains(@class,'md-active')]//*[@class='contact-info-contacts']/div[2]";
        public static final String LOCATOR_COMMENTS = "//*[contains(@class,'md-active')]//*[@class='contact-info-comments']/div[contains(.,'Comments')]/div[2]";

        @FindBy(xpath = "//*[contains(@class,'md-active')]")
        private ContactDetailsDialog contactDetailsDialog;

        public ContactDetailsMenu(WebDriver webDriver)
        {
            super(webDriver);
        }

        public String getLicenseNumber()
        {
            contactDetailsDialog.waitUntilVisible();
            return contactDetailsDialog.driverLicenseNumber.getText();
        }

        public String getContact()
        {
            return getText(LOCATOR_CONTACT);
        }

        public String getContactType()
        {
            return getText(LOCATOR_CONTACT_TYPE);
        }

        public String getComments()
        {
            if (isElementExistFast(LOCATOR_COMMENTS))
            {
                return getText(LOCATOR_COMMENTS);
            } else
            {
                return null;
            }
        }

        public DriverInfo readData()
        {
            DriverInfo driverInfo = new DriverInfo();
            driverInfo.setLicenseNumber(getLicenseNumber());
            driverInfo.setContact(getContact());
            driverInfo.setContactType(getContactType());
            driverInfo.setComments(getComments());
            return driverInfo;
        }

        public static class ContactDetailsDialog extends MdDialog
        {
            public ContactDetailsDialog(WebDriver webDriver, WebElement webElement)
            {
                super(webDriver, webElement);
            }

            public ContactDetailsDialog(WebDriver webDriver, SearchContext searchContext, WebElement webElement)
            {
                super(webDriver, searchContext, webElement);
            }

            @FindBy(xpath = "//*[contains(@class,'md-active')]//*[@class='contact-info-details']/div[contains(.,'License No.')]/div[2]")
            public PageElement driverLicenseNumber;
        }
    }

    /**
     * Accessor for Edit Driver dialog
     */
    @SuppressWarnings("UnusedReturnValue")
    public static class EditDriverDialog extends AddDriverDialog
    {
        static final String DIALOG_TITLE = "Edit Driver";

        public EditDriverDialog(WebDriver webDriver)
        {
            super(webDriver);
            dialogTittle = DIALOG_TITLE;
        }

        public EditDriverDialog editVehicle(String licenseNumber, Integer capacity)
        {
            fillIfNotNull(LOCATOR_VEHICLES_FIELD_LICENSE_NUMBER, licenseNumber);
            fillIfNotNull(LOCATOR_VEHICLES_FIELD_CAPACITY, capacity);
            return this;
        }

        public EditDriverDialog editContact(String contactType, String contact)
        {
            if (StringUtils.isNotBlank(contactType))
            {
                selectValueFromMdSelectById(LOCATOR_CONTACTS_FIELD_CONTACT_TYPE, contactType);
            }
            fillIfNotNull(LOCATOR_CONTACTS_FIELD_CONTACT, contact);
            return this;
        }

        public EditDriverDialog editZone(String zoneId, Integer min, Integer max, Integer cost)
        {
            scrollIntoView("//nv-container-box[@label='Preferred Zones + Capacity']");
            if (StringUtils.isNotBlank(zoneId))
            {
                selectValueFromMdSelectById(LOCATOR_ZONES_FIELD_ZONE_ID, zoneId);
            }
            fillIfNotNull(LOCATOR_ZONES_FIELD_MIN, min);
            fillIfNotNull(LOCATOR_ZONES_FIELD_MAX, max);
            fillIfNotNull(LOCATOR_ZONES_FIELD_COST, cost);
            return this;
        }

        public void fillForm(DriverInfo driverInfo)
        {
            waitUntilVisible();
            setFirstName(driverInfo.getFirstName());
            setLastName(driverInfo.getLastName());
            setDriverLicenseNumber(driverInfo.getLicenseNumber());
            setCodLimit(driverInfo.getCodLimit());
            if (driverInfo.hasVehicleInfo())
            {
                if (isElementExistFast(LOCATOR_VEHICLES_BUTTON_REMOVE))
                {
                    editVehicle(driverInfo.getVehicleLicenseNumber(), driverInfo.getVehicleCapacity());
                } else
                {
                    addVehicle(driverInfo.getVehicleLicenseNumber(), driverInfo.getVehicleCapacity());
                }
            }
            if (driverInfo.hasContactsInfo())
            {
                if (isElementExistFast(LOCATOR_CONTACTS_BUTTON_REMOVE))
                {
                    editContact(driverInfo.getContactType(), driverInfo.getContact());
                } else
                {
                    addContact(driverInfo.getContactType(), driverInfo.getContact());
                }
            }
            if (driverInfo.hasZoneInfo())
            {
                if (isElementExistFast(LOCATOR_ZONES_BUTTON_REMOVE))
                {
                    editZone(driverInfo.getZoneId(), driverInfo.getZoneMin(), driverInfo.getZoneMax(), driverInfo.getZoneCost());
                } else
                {
                    addZone(driverInfo.getZoneId(), driverInfo.getZoneMin(), driverInfo.getZoneMax(), driverInfo.getZoneCost());
                }
            }
            setPassword(driverInfo.getPassword());
            setComments(driverInfo.getComments());
            submitForm();
        }
    }

    /**
     * Accessor for DP table
     */
    public static class DriversTable extends MdVirtualRepeatTable<DriverInfo>
    {
        private static final String LOCATOR_COMING_TOGGLE = "//tr[@md-virtual-repeat='%s'][%d]/td[contains(@class, 'availability')]/nv-toggle-button/button";

        public static final String COLUMN_ID = "id";
        public static final String COLUMN_USERNAME = "username";
        public static final String COLUMN_TYPE = "type";
        public static final String COLUMN_ZONE = "zoneId";
        public static final String COLUMN_EMPLOYMENT_START_DATE = "employmentStartName";

        public static final String ACTION_EDIT = "edit";
        public static final String ACTION_DELETE = "delete";
        public static final String ACTION_CONTACT_INFO = "contact_info";

        public DriversTable(WebDriver webDriver)
        {
            super(webDriver);
            setColumnLocators(ImmutableMap.<String, String>builder()
                    .put(COLUMN_ID, "id")
                    .put(COLUMN_USERNAME, "username")
                    .put("name", "name")
                    .put("hub", "hub")
                    .put(COLUMN_TYPE, "driver-type")
                    .put("vehicleType", "vehicles-vehicle-type")
                    .put("vehicleOwn", "vehicles-own-vehicle")
                    .put(COLUMN_ZONE, "zone-preferences-zone-id")
                    .put("zoneMin", "zone-preferences-min-waypoints")
                    .put("zoneMax", "zone-preferences-max-waypoints")
                    .put("comments", "comments")
                    .put(COLUMN_EMPLOYMENT_START_DATE, "_employment-start-date")
                    .build()
            );
            setActionButtonsLocators(ImmutableMap.of(ACTION_CONTACT_INFO, "//button[@aria-label='Contact Info']", ACTION_EDIT, "Edit", ACTION_DELETE, "Delete"));
            setEntityClass(DriverInfo.class);
            setMdVirtualRepeat("driver in getTableData()");
        }

        public String getComingStatus(int rowNumber)
        {
            String xpath = String.format(LOCATOR_COMING_TOGGLE + "/span", getMdVirtualRepeat(), rowNumber);
            return getText(xpath);
        }

        public void toggleComingStatus(int rowNumber)
        {
            String xpath = String.format(LOCATOR_COMING_TOGGLE, getMdVirtualRepeat(), rowNumber);
            waitUntilElementIsClickable(xpath);
            click(xpath);
        }
    }
}
