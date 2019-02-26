package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.util.NvLogger;
import co.nvqa.commons.util.StandardTestConstants;
import co.nvqa.operator_v2.model.DriverTypeParams;
import org.apache.commons.lang3.StringUtils;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import static co.nvqa.commons.util.NvMatchers.hasItemIgnoreCase;
import static co.nvqa.commons.util.NvMatchers.hasItemsIgnoreCase;
import static org.hamcrest.Matchers.anyOf;
import static org.hamcrest.Matchers.greaterThanOrEqualTo;
import static org.hamcrest.Matchers.notNullValue;

/**
 * Modified by Sergey Mishanin
 *
 * @author Soewandi Wirjawan
 */
@SuppressWarnings("WeakerAccess")
public class DriverTypeManagementPage extends OperatorV2SimplePage
{
    private static final String MD_VIRTUAL_REPEAT = "driverTypeProp in ctrl.tableData";
    private static final String CSV_FILENAME_PATTERN = "driver-types";
    private static final String PRIORITY_LEVEL = "Priority Level";
    private static final String DELIVERY_TYPE = "Delivery Type";
    private static final String RESERVATION_SIZE = "Reservation Size";
    private static final String PARCEL_SIZE = "Parcel Size";
    private static final String TIMESLOT = "Timeslot";

    private DriverTypesTable driverTypesTable;
    private AddDriverTypeDialog addDriverTypeDialog;
    private EditDriverTypeDialog editDriverTypeDialog;
    private FiltersForm filtersForm;

    public DriverTypeManagementPage(WebDriver webDriver)
    {
        super(webDriver);
        driverTypesTable = new DriverTypesTable(webDriver);
        addDriverTypeDialog = new AddDriverTypeDialog(webDriver);
        editDriverTypeDialog = new EditDriverTypeDialog(webDriver);
        filtersForm = new FiltersForm(webDriver);
    }

    public DriverTypesTable driverTypesTable()
    {
        return driverTypesTable;
    }

    public FiltersForm filtersForm()
    {
        return filtersForm;
    }

    public void downloadFile()
    {
        clickNvApiTextButtonByName("Download CSV File");
    }

    public void verifyDownloadedFileContent(List<DriverTypeParams> expectedDriverTypeParams)
    {
        String fileName = CSV_FILENAME_PATTERN + ".csv";
        verifyFileDownloadedSuccessfully(fileName);
        String pathName = StandardTestConstants.TEMP_DIR + fileName;
        NvLogger.info("FILE_NAME = " + fileName);
        List<DriverTypeParams> actualDriverTypeParams = DriverTypeParams.fromCsvFile(pathName, true);

        Assert.assertThat("Unexpected number of lines in CSV file", actualDriverTypeParams.size(), greaterThanOrEqualTo(expectedDriverTypeParams.size()));

        Map<Long, DriverTypeParams> actualMap = actualDriverTypeParams.stream().collect(Collectors.toMap(
                DriverTypeParams::getDriverTypeId,
                params -> params
        ));

        for (DriverTypeParams expectedParams : expectedDriverTypeParams)
        {
            DriverTypeParams actualParams = actualMap.get(expectedParams.getDriverTypeId());

            Assert.assertThat("Driver Type with Id", actualParams, notNullValue());
            Assert.assertEquals("Driver Type Name", expectedParams.getDriverTypeName(), actualParams.getDriverTypeName());
            Assert.assertEquals(DELIVERY_TYPE, expectedParams.getDeliveryType(), actualParams.getDeliveryType());
            Assert.assertEquals(PRIORITY_LEVEL, expectedParams.getPriorityLevel(), actualParams.getPriorityLevel());
            Assert.assertEquals(RESERVATION_SIZE, expectedParams.getReservationSize(), actualParams.getReservationSize());
            Assert.assertEquals(PARCEL_SIZE, expectedParams.getParcelSize(), actualParams.getParcelSize());
        }
    }

    public void verifyFilterResults(DriverTypeParams filterParams)
    {
        List<DriverTypeParams> filterResults = driverTypesTable.getAllDriverTypeParams();

        filterResults.forEach(driverTypeParams -> {
            if (StringUtils.isNotBlank(filterParams.getDeliveryType()))
            {
                Assert.assertThat(DELIVERY_TYPE,
                        driverTypeParams.getDeliveryTypes(),
                        anyOf(hasItemsIgnoreCase(filterParams.getDeliveryTypes()), hasItemIgnoreCase("All")));
            }
            if (StringUtils.isNotBlank(filterParams.getPriorityLevel()))
            {
                List<String> expectedItems = filterParams.getPriorityLevels().stream().map(item -> {
                    if (!StringUtils.containsAny(item,"Only", "All", "Both"))
                    {
                        item += " Only";
                    }
                    return item;
                }).collect(Collectors.toList());
                Assert.assertThat(PRIORITY_LEVEL,
                        driverTypeParams.getPriorityLevels(),
                        anyOf(hasItemsIgnoreCase(expectedItems), hasItemIgnoreCase("All")));
            }
            if (StringUtils.isNotBlank(filterParams.getReservationSize()))
            {
                Assert.assertThat(RESERVATION_SIZE,
                        driverTypeParams.getReservationSizes(),
                        anyOf(hasItemsIgnoreCase(filterParams.getReservationSizes()), hasItemIgnoreCase("All")));
            }
            if (StringUtils.isNotBlank(filterParams.getParcelSize()))
            {
                Assert.assertThat(PARCEL_SIZE,
                        driverTypeParams.getParcelSizes(),
                        anyOf(hasItemsIgnoreCase(filterParams.getParcelSizes()), hasItemIgnoreCase("All")));
            }
            if (StringUtils.isNotBlank(filterParams.getTimeslot()))
            {
                Assert.assertThat(TIMESLOT,
                        driverTypeParams.getTimeslots(),
                        anyOf(hasItemsIgnoreCase(filterParams.getTimeslots()), hasItemIgnoreCase("All")));
            }
        });
    }

    public void createDriverType(DriverTypeParams driverTypeParams)
    {
        clickButtonByAriaLabel("Create Driver Type");
        addDriverTypeDialog.fillForm(driverTypeParams);
        addDriverTypeDialog.submitForm();
    }

    public void editDriverType(DriverTypeParams driverTypeParams, String searchString)
    {
        searchingCreatedDriver(searchString);
        driverTypesTable.clickEditButton(1);
        editDriverTypeDialog.fillForm(driverTypeParams);
        editDriverTypeDialog.submitForm();
    }

    public void verifyDriverType(DriverTypeParams expectedDriverTypeParams)
    {
        searchingCreatedDriver(expectedDriverTypeParams.getDriverTypeName());
        DriverTypeParams actualDriverTypeParams = driverTypesTable.getDriverTypeParams(1);
        if (expectedDriverTypeParams.getDriverTypeId() != null)
        {
            Assert.assertThat("Driver Type ID", actualDriverTypeParams.getDriverTypeId(), equalTo(expectedDriverTypeParams.getDriverTypeId()));
        }
        if (expectedDriverTypeParams.getDriverTypeName() != null)
        {
            Assert.assertThat("Driver Type Name", actualDriverTypeParams.getDriverTypeName(), equalToIgnoringCase(expectedDriverTypeParams.getDriverTypeName()));
        }
        if (expectedDriverTypeParams.getDeliveryType() != null)
        {
            Assert.assertThat(DELIVERY_TYPE, actualDriverTypeParams.getDeliveryType(), equalToIgnoringCase(expectedDriverTypeParams.getDeliveryType()));
        }
        if (expectedDriverTypeParams.getPriorityLevel() != null)
        {
            String expectedPriorityLevel = expectedDriverTypeParams.getPriorityLevel();
            if (!StringUtils.containsAny(expectedPriorityLevel, "Only", "All", "Both"))
            {
                expectedPriorityLevel += " Only";
            }

            Assert.assertThat(PRIORITY_LEVEL, actualDriverTypeParams.getPriorityLevel(), equalToIgnoringCase(expectedPriorityLevel));
        }
        if (expectedDriverTypeParams.getReservationSize() != null)
        {
            Assert.assertThat(RESERVATION_SIZE, actualDriverTypeParams.getReservationSize(), equalToIgnoringCase(expectedDriverTypeParams.getReservationSize()));
        }
        if (expectedDriverTypeParams.getParcelSize() != null)
        {
            Assert.assertThat(PARCEL_SIZE, actualDriverTypeParams.getParcelSize(), equalToIgnoringCase(expectedDriverTypeParams.getParcelSize()));
        }
        if (expectedDriverTypeParams.getTimeslot() != null)
        {
            Assert.assertThat(TIMESLOT, actualDriverTypeParams.getTimeslot(), equalToIgnoringCase(expectedDriverTypeParams.getTimeslot()));
        }
    }

    public DriverTypeParams getDriverTypeParams(String driverTypeName)
    {
        searchingCreatedDriver(driverTypeName);
        return driverTypesTable.getDriverTypeParams(1);
    }

    public void searchingCreatedDriver(String driverTypeName)
    {
        searchTable(driverTypeName);
        pause1s();
    }

    public void deleteDriverType(DriverTypeParams driverTypeParams)
    {
        searchingCreatedDriver(driverTypeParams.getDriverTypeName());
        driverTypesTable.clickDeleteButton(1);
        waitUntilVisibilityOfMdDialogByTitle("Confirm delete");
        clickButtonOnMdDialogByAriaLabel("Delete");
        waitUntilInvisibilityOfMdDialogByTitle("Confirm delete");
        pause2s();
    }

    public String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTable(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT);
    }

    public void clickActionButtonOnTable(int rowNumber, String actionButtonName)
    {
        clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName, MD_VIRTUAL_REPEAT);
    }

    /**
     * Accessor for Reservations table
     */
    public static class DriverTypesTable extends OperatorV2SimplePage
    {
        private static final String MD_VIRTUAL_REPEAT = "driverTypeProp in ctrl.tableData";
        private static final String COLUMN_CLASS_ID = "id";
        private static final String COLUMN_CLASS_NAME = "name";
        private static final String COLUMN_CLASS_DELIVERY_TYPE = "delivery-type";
        private static final String COLUMN_CLASS_PRIORITY_LEVEL = "priority-level";
        private static final String COLUMN_CLASS_RESERVATION_SIZE = "reservation-size";
        private static final String COLUMN_CLASS_PARCEL_SIZE = "parcel-size";
        private static final String COLUMN_CLASS_TIMESLOT = "timeslot";

        public static final String ACTION_BUTTON_EDIT = "Edit";
        public static final String ACTION_BUTTON_DELETE = "Delete";

        public DriverTypesTable(WebDriver webDriver)
        {
            super(webDriver);
        }

        public List<DriverTypeParams> getAllDriverTypeParams()
        {
            waitUntilVisibilityOfElementLocated(String.format("//tr[@md-virtual-repeat='%s']", MD_VIRTUAL_REPEAT));
            int rowsCount = getRowsCount();
            List<DriverTypeParams> params = new ArrayList<>(rowsCount);
            for (int rowIndex = 1; rowIndex <= rowsCount; rowIndex++)
            {
                params.add(getDriverTypeParams(rowIndex));
            }
            return params;
        }

        public DriverTypeParams getDriverTypeParams(int rowIndex)
        {
            DriverTypeParams driverTypeParams = new DriverTypeParams();
            driverTypeParams.setDriverTypeId(Long.parseLong(getId(rowIndex)));
            driverTypeParams.setDriverTypeName(getName(rowIndex));
            driverTypeParams.setDeliveryType(getDeliveryType(rowIndex));
            driverTypeParams.setPriorityLevel(getPriorityLevel(rowIndex));
            driverTypeParams.setReservationSize(getReservationSize(rowIndex));
            driverTypeParams.setParcelSize(getParcelSize(rowIndex));
            driverTypeParams.setTimeslot(getTimeslot(rowIndex));
            return driverTypeParams;
        }

        public String getId(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_CLASS_ID);
        }

        public String getName(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_CLASS_NAME);
        }

        public String getDeliveryType(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_CLASS_DELIVERY_TYPE);
        }

        public String getPriorityLevel(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_CLASS_PRIORITY_LEVEL);
        }

        public String getReservationSize(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_CLASS_RESERVATION_SIZE);
        }

        public String getParcelSize(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_CLASS_PARCEL_SIZE);
        }

        public String getTimeslot(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_CLASS_TIMESLOT);
        }

        private String getTextOnTable(int rowNumber, String columnDataClass)
        {
            String text = getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT);
            text = StringUtils.normalizeSpace(text);
            return text.equals("-") ? null : text;
        }

        public void clickEditButton(int rowNumber)
        {
            clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, ACTION_BUTTON_EDIT, MD_VIRTUAL_REPEAT);
        }

        public void clickDeleteButton(int rowNumber)
        {
            clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, ACTION_BUTTON_DELETE, MD_VIRTUAL_REPEAT);
        }

        public int getRowsCount()
        {
            return getRowsCountOfTableWithMdVirtualRepeatFast(MD_VIRTUAL_REPEAT);
        }
    }

    /**
     * Accessor for Create Reservation dialog
     */
    public static class AddDriverTypeDialog extends FiltersForm
    {
        private static final String DIALOG_TITLE = "Add Driver Type";
        private static final String FIELD_NAME_LOCATOR = "Name";
        private static final String BUTTON_SUBMIT_LOCATOR = "Submit";
        private static final String LOCATOR_BUTTON_PRIORITY_LEVEL_BOTH = "Both";

        public AddDriverTypeDialog(WebDriver webDriver)
        {
            super(webDriver);
        }

        @SuppressWarnings("UnusedReturnValue")
        public AddDriverTypeDialog waitUntilVisible()
        {
            waitUntilVisibilityOfMdDialogByTitle(DIALOG_TITLE);
            return this;
        }

        public AddDriverTypeDialog setName(String name)
        {
            if (StringUtils.isNotBlank(name))
            {
                sendKeysByAriaLabel(FIELD_NAME_LOCATOR, name);
            }
            return this;
        }

        public void submitForm()
        {
            clickNvButtonSaveByNameAndWaitUntilDone(BUTTON_SUBMIT_LOCATOR);
            waitUntilInvisibilityOfMdDialogByTitle(DIALOG_TITLE);
        }

        @Override
        public void selectDeliveryTypeNormal()
        {
            clickButtonOnMdDialogByAriaLabel(LOCATOR_BUTTON_DELIVERY_TYPE_NORMAL);
        }

        @Override
        public void selectDeliveryTypeC2C()
        {
            clickButtonOnMdDialogByAriaLabel(LOCATOR_BUTTON_DELIVERY_TYPE_C2C);
        }

        @Override
        public void selectDeliveryTypeReservationPickUp()
        {
            clickButtonOnMdDialogByAriaLabel(LOCATOR_BUTTON_DELIVERY_TYPE_RESERVATION_PICK_UP);
        }

        @Override
        public void clearDeliveryTypeSelection()
        {
            findElementsByXpathFast("//nv-button-group[@label='" + DELIVERY_TYPE + "']//button[contains(@class, 'active')]")
                    .forEach(WebElement::click);
        }

        @Override
        public void selectPriorityLevelPriority()
        {
            clickButtonOnMdDialogByAriaLabel(LOCATOR_BUTTON_PRIORITY_LEVEL_PRIORITY + " Only");
        }

        @Override
        public void selectPriorityLevelNonPriority()
        {
            clickButtonOnMdDialogByAriaLabel(LOCATOR_BUTTON_PRIORITY_LEVEL_NON_PRIOROTY + " Only");
        }

        @SuppressWarnings("unused")
        public void selectPriorityLevelBoth()
        {
            clickButtonOnMdDialogByAriaLabel(LOCATOR_BUTTON_PRIORITY_LEVEL_BOTH);
        }

        @Override
        public void clearPriorityLevelSelection()
        {
            findElementsByXpathFast("//nv-button-group-radio[@label='" + PRIORITY_LEVEL + "']//button[contains(@class, 'active')]")
                    .forEach(WebElement::click);
        }

        @Override
        public void selectReservationSizeLessThan3Parcels()
        {
            clickButtonOnMdDialogByAriaLabelIgnoreCase(LOCATOR_BUTTON_RESERVATION_SIZE_LESS_THAN_3_PARCELS);
        }

        @Override
        public void selectReservationSizeLessThan10Parcels()
        {
            clickButtonOnMdDialogByAriaLabelIgnoreCase(LOCATOR_BUTTON_RESERVATION_SIZE_LESS_THAN_10_PARCELS);
        }

        @Override
        public void selectReservationSizeTrolleyRequired()
        {
            clickButtonOnMdDialogByAriaLabel(LOCATOR_BUTTON_RESERVATION_SIZE_TROLLEY_REQUIRED);
        }

        @Override
        public void selectReservationSizeHalfVanLoad()
        {
            clickButtonOnMdDialogByAriaLabel(LOCATOR_BUTTON_RESERVATION_SIZE_HALF_VAN_LOAD);
        }

        @Override
        public void selectReservationSizeFullVanLoad()
        {
            clickButtonOnMdDialogByAriaLabel(LOCATOR_BUTTON_RESERVATION_SIZE_FULL_VAN_LOAD);
        }

        @Override
        public void selectReservationSizeLargerThanVanLoad()
        {
            clickButtonOnMdDialogByAriaLabelIgnoreCase(LOCATOR_BUTTON_RESERVATION_SIZE_LARGER_THAN_VAN_LOAD);
        }

        @Override
        public void clearReservationSizeSelection()
        {
            findElementsByXpathFast("//nv-button-group[@label='" + RESERVATION_SIZE + "']//button[contains(@class, 'active')]")
                    .forEach(WebElement::click);
        }

        @Override
        public void selectParcelSizeSmall()
        {
            clickButtonOnMdDialogByAriaLabel(LOCATOR_BUTTON_PARCEL_SIZE_SMALL);
        }

        @Override
        public void selectParcelSizeMedium()
        {
            clickButtonOnMdDialogByAriaLabel(LOCATOR_BUTTON_PARCEL_SIZE_MEDIUM);
        }

        @Override
        public void selectParcelSizeLarge()
        {
            clickButtonOnMdDialogByAriaLabel(LOCATOR_BUTTON_PARCEL_SIZE_LARGE);
        }

        @Override
        public void selectParcelSizeExtraLarge()
        {
            clickButtonOnMdDialogByAriaLabel(LOCATOR_BUTTON_PARCEL_SIZE_EXTRA_LARGE);
        }

        @Override
        public void clearParcelSizeSelection()
        {
            findElementsByXpathFast("//nv-button-group[@label='" + PARCEL_SIZE + "']//button[contains(@class, 'active')]")
                    .forEach(WebElement::click);
        }

        @Override
        public void selectTimeslot9amTo6pm()
        {
            clickButtonOnMdDialogByAriaLabelIgnoreCase(LOCATOR_BUTTON_TIMESLOT_9AM_TO_6PM);
        }

        @Override
        public void selectTimeslot9amTo10pm()
        {
            clickButtonOnMdDialogByAriaLabelIgnoreCase(LOCATOR_BUTTON_TIMESLOT_9AM_TO_10PM);
        }

        @Override
        public void selectTimeslot9amTo12pm()
        {
            clickButtonOnMdDialogByAriaLabelIgnoreCase(LOCATOR_BUTTON_TIMESLOT_9AM_TO_12PM);
        }

        @Override
        public void selectTimeslot12pmTo3pm()
        {
            clickButtonOnMdDialogByAriaLabelIgnoreCase(LOCATOR_BUTTON_TIMESLOT_12PM_TO_3PM);
        }

        @Override
        public void selectTimeslot3pmTo6pm()
        {
            clickButtonOnMdDialogByAriaLabelIgnoreCase(LOCATOR_BUTTON_TIMESLOT_3PM_TO_6PM);
        }

        @Override
        public void selectTimeslot6pmTo10pm()
        {
            clickButtonOnMdDialogByAriaLabelIgnoreCase(LOCATOR_BUTTON_TIMESLOT_6PM_TO_10PM);
        }

        @Override
        public void clearTimeslotSelection()
        {
            findElementsByXpathFast("//nv-button-group[@label='" + TIMESLOT + "']//button[contains(@class, 'active')]")
                    .forEach(WebElement::click);
        }

        @Override
        public void fillForm(DriverTypeParams driverTypeParams)
        {
            waitUntilVisible();
            setName(driverTypeParams.getDriverTypeName());
            if (StringUtils.isNotBlank(driverTypeParams.getDeliveryType()))
            {
                selectDeliveryType(driverTypeParams.getDeliveryTypes());
            }
            if (StringUtils.isNotBlank(driverTypeParams.getPriorityLevel()))
            {
                selectPriorityLevel(driverTypeParams.getPriorityLevels());
            }
            if (StringUtils.isNotBlank(driverTypeParams.getReservationSize()))
            {
                selectReservationSize(driverTypeParams.getReservationSizes());
            }
            if (StringUtils.isNotBlank(driverTypeParams.getParcelSize()))
            {
                selectParcelSize(driverTypeParams.getParcelSizes());
            }
            if (StringUtils.isNotBlank(driverTypeParams.getTimeslot()))
            {
                selectTimeslot(driverTypeParams.getTimeslots());
            }
        }
    }

    /**
     * Accessor for Create Reservation dialog
     */
    public static class EditDriverTypeDialog extends AddDriverTypeDialog
    {
        private static final String DIALOG_TITLE = "Edit Driver Type";
        private static final String BUTTON_SUBMIT_LOCATOR = "Submit Changes";

        public EditDriverTypeDialog(WebDriver webDriver)
        {
            super(webDriver);
        }

        @Override
        public EditDriverTypeDialog waitUntilVisible()
        {
            waitUntilVisibilityOfMdDialogByTitle(DIALOG_TITLE);
            return this;
        }

        public void submitForm()
        {
            clickNvButtonSaveByNameAndWaitUntilDone(BUTTON_SUBMIT_LOCATOR);
            waitUntilInvisibilityOfMdDialogByTitle(DIALOG_TITLE);
        }
    }

    /**
     * Accessor for Create Reservation dialog
     */
    public static class FiltersForm extends OperatorV2SimplePage
    {
        static final String LOCATOR_BUTTON_DELIVERY_TYPE_NORMAL = "Normal Delivery";
        static final String LOCATOR_BUTTON_DELIVERY_TYPE_C2C = "C2C + Return Pick Up";
        static final String LOCATOR_BUTTON_DELIVERY_TYPE_RESERVATION_PICK_UP = "Reservation Pick Up";
        static final String LOCATOR_BUTTON_DELIVERY_TYPE_CLEAR_ALL = "//div[contains(@class,'delivery-type')]//button[@aria-label='Clear All']";

        static final String LOCATOR_BUTTON_PRIORITY_LEVEL_PRIORITY = "Priority";
        static final String LOCATOR_BUTTON_PRIORITY_LEVEL_NON_PRIOROTY = "Non-Priority";
        static final String LOCATOR_BUTTON_PRIORITY_LEVEL_CLEAR_ALL = "//div[contains(@class,'priority-level')]//button[@aria-label='Clear All']";

        static final String LOCATOR_BUTTON_RESERVATION_SIZE_LESS_THAN_3_PARCELS = "Less Than 3 Parcels";
        static final String LOCATOR_BUTTON_RESERVATION_SIZE_LESS_THAN_10_PARCELS = "Less Than 10 Parcels";
        static final String LOCATOR_BUTTON_RESERVATION_SIZE_TROLLEY_REQUIRED = "Trolley Required";
        static final String LOCATOR_BUTTON_RESERVATION_SIZE_HALF_VAN_LOAD = "Half Van Load";
        static final String LOCATOR_BUTTON_RESERVATION_SIZE_FULL_VAN_LOAD = "Full Van Load";
        static final String LOCATOR_BUTTON_RESERVATION_SIZE_LARGER_THAN_VAN_LOAD = "Larger Than Van Load";
        static final String LOCATOR_BUTTON_RESERVATION_SIZE_CLEAR_ALL = "//div[contains(@class,'reservation-size')]//button[@aria-label='Clear All']";

        static final String LOCATOR_BUTTON_PARCEL_SIZE_SMALL = "Small";
        static final String LOCATOR_BUTTON_PARCEL_SIZE_MEDIUM = "Medium";
        static final String LOCATOR_BUTTON_PARCEL_SIZE_LARGE = "Large";
        static final String LOCATOR_BUTTON_PARCEL_SIZE_EXTRA_LARGE = "Extra Large";
        static final String LOCATOR_BUTTON_PARCEL_SIZE_CLEAR_ALL = "//div[contains(@class,'parcel-size')]//button[@aria-label='Clear All']";

        static final String LOCATOR_BUTTON_TIMESLOT_9AM_TO_6PM = "9AM To 6PM";
        static final String LOCATOR_BUTTON_TIMESLOT_9AM_TO_10PM = "9AM TO 10PM";
        static final String LOCATOR_BUTTON_TIMESLOT_9AM_TO_12PM = "9AM TO 12PM";
        static final String LOCATOR_BUTTON_TIMESLOT_12PM_TO_3PM = "12PM TO 3PM";
        static final String LOCATOR_BUTTON_TIMESLOT_3PM_TO_6PM = "3PM TO 6PM";
        static final String LOCATOR_BUTTON_TIMESLOT_6PM_TO_10PM = "6PM TO 10PM";
        static final String LOCATOR_BUTTON_TIMESLOT_CLEAR_ALL = "//div[contains(@class,'timeslot')]//button[@aria-label='Clear All']";

        public FiltersForm(WebDriver webDriver)
        {
            super(webDriver);
        }

        public void selectDeliveryTypeNormal()
        {
            clickButtonByAriaLabel(LOCATOR_BUTTON_DELIVERY_TYPE_NORMAL);
        }

        public void selectDeliveryTypeC2C()
        {
            clickButtonByAriaLabel(LOCATOR_BUTTON_DELIVERY_TYPE_C2C);
        }

        public void selectDeliveryTypeReservationPickUp()
        {
            clickButtonByAriaLabel(LOCATOR_BUTTON_DELIVERY_TYPE_RESERVATION_PICK_UP);
        }

        public void clearDeliveryTypeSelection()
        {
            click(LOCATOR_BUTTON_DELIVERY_TYPE_CLEAR_ALL);
        }

        public void selectDeliveryType(String deliveryType)
        {
            switch (deliveryType.trim().toLowerCase())
            {
                case "normal delivery":
                    selectDeliveryTypeNormal();
                    break;
                case "c2c + return pick up":
                    selectDeliveryTypeC2C();
                    break;
                case "reservation pick up":
                    selectDeliveryTypeReservationPickUp();
                    break;
                case "all":
                    clearDeliveryTypeSelection();
                    selectDeliveryTypeNormal();
                    selectDeliveryTypeC2C();
                    selectDeliveryTypeReservationPickUp();
                    break;
            }
        }

        public void selectDeliveryType(Set<String> deliveryTypes)
        {
            clearDeliveryTypeSelection();
            deliveryTypes.forEach(this::selectDeliveryType);
        }

        public void selectPriorityLevelPriority()
        {
            clickButtonByAriaLabel(LOCATOR_BUTTON_PRIORITY_LEVEL_PRIORITY);
        }

        public void selectPriorityLevelNonPriority()
        {
            clickButtonByAriaLabel(LOCATOR_BUTTON_PRIORITY_LEVEL_NON_PRIOROTY);
        }

        public void clearPriorityLevelSelection()
        {
            click(LOCATOR_BUTTON_PRIORITY_LEVEL_CLEAR_ALL);
        }

        public void selectPriorityLevel(String priorityLevel)
        {
            switch (priorityLevel.trim().toLowerCase())
            {
                case "priority":
                case "priority only":
                    selectPriorityLevelPriority();
                    break;
                case "non-priority":
                case "non-priority only":
                    selectPriorityLevelNonPriority();
                    break;
                case "both":
                case "all":
                    clearPriorityLevelSelection();
                    selectPriorityLevelPriority();
                    selectPriorityLevelNonPriority();
                    break;
            }
        }

        public void selectPriorityLevel(Set<String> priorityLevels)
        {
            clearPriorityLevelSelection();
            priorityLevels.forEach(this::selectPriorityLevel);
        }

        public void selectReservationSizeLessThan3Parcels()
        {
            clickButtonByAriaLabel(LOCATOR_BUTTON_RESERVATION_SIZE_LESS_THAN_3_PARCELS);
        }

        public void selectReservationSizeLessThan10Parcels()
        {
            clickButtonByAriaLabel(LOCATOR_BUTTON_RESERVATION_SIZE_LESS_THAN_10_PARCELS);
        }

        public void selectReservationSizeTrolleyRequired()
        {
            clickButtonByAriaLabel(LOCATOR_BUTTON_RESERVATION_SIZE_TROLLEY_REQUIRED);
        }

        public void selectReservationSizeHalfVanLoad()
        {
            clickButtonByAriaLabel(LOCATOR_BUTTON_RESERVATION_SIZE_HALF_VAN_LOAD);
        }

        public void selectReservationSizeFullVanLoad()
        {
            clickButtonByAriaLabel(LOCATOR_BUTTON_RESERVATION_SIZE_FULL_VAN_LOAD);
        }

        public void selectReservationSizeLargerThanVanLoad()
        {
            clickButtonByAriaLabel(LOCATOR_BUTTON_RESERVATION_SIZE_LARGER_THAN_VAN_LOAD);
        }

        public void clearReservationSizeSelection()
        {
            click(LOCATOR_BUTTON_RESERVATION_SIZE_CLEAR_ALL);
        }

        public void selectReservationSize(String reservationSize)
        {
            switch (reservationSize.trim().toLowerCase())
            {
                case "less than 3 parcels":
                    selectReservationSizeLessThan3Parcels();
                    break;
                case "less than 10 parcels":
                    selectReservationSizeLessThan10Parcels();
                    break;
                case "trolley required":
                    selectReservationSizeTrolleyRequired();
                    break;
                case "half van load":
                    selectReservationSizeHalfVanLoad();
                    break;
                case "full van load":
                    selectReservationSizeFullVanLoad();
                    break;
                case "larger than van load":
                    selectReservationSizeLargerThanVanLoad();
                    break;
                case "all":
                    clearReservationSizeSelection();
                    selectReservationSizeLessThan3Parcels();
                    selectReservationSizeLessThan10Parcels();
                    selectReservationSizeTrolleyRequired();
                    selectReservationSizeHalfVanLoad();
                    selectReservationSizeFullVanLoad();
                    selectReservationSizeLargerThanVanLoad();
                    break;
            }
        }

        public void selectReservationSize(Set<String> reservationSizes)
        {
            clearReservationSizeSelection();
            reservationSizes.forEach(this::selectReservationSize);
        }

        public void selectParcelSizeSmall()
        {
            clickButtonByAriaLabel(LOCATOR_BUTTON_PARCEL_SIZE_SMALL);
        }

        public void selectParcelSizeMedium()
        {
            clickButtonByAriaLabel(LOCATOR_BUTTON_PARCEL_SIZE_MEDIUM);
        }

        public void selectParcelSizeLarge()
        {
            clickButtonByAriaLabel(LOCATOR_BUTTON_PARCEL_SIZE_LARGE);
        }

        public void selectParcelSizeExtraLarge()
        {
            clickButtonByAriaLabel(LOCATOR_BUTTON_PARCEL_SIZE_EXTRA_LARGE);
        }

        public void clearParcelSizeSelection()
        {
            click(LOCATOR_BUTTON_PARCEL_SIZE_CLEAR_ALL);
        }

        public void selectParcelSize(String parcelSize)
        {
            switch (parcelSize.trim().toLowerCase())
            {
                case "small":
                    selectParcelSizeSmall();
                    break;
                case "medium":
                    selectParcelSizeMedium();
                    break;
                case "large":
                    selectParcelSizeLarge();
                    break;
                case "extra large":
                    selectParcelSizeExtraLarge();
                    break;
                case "all":
                    clearParcelSizeSelection();
                    selectParcelSizeSmall();
                    selectParcelSizeMedium();
                    selectParcelSizeLarge();
                    selectParcelSizeExtraLarge();
                    break;
            }
        }

        public void selectParcelSize(Set<String> parcelSizes)
        {
            clearParcelSizeSelection();
            parcelSizes.forEach(this::selectParcelSize);
        }

        public void selectTimeslot9amTo6pm()
        {
            clickButtonByAriaLabel(LOCATOR_BUTTON_TIMESLOT_9AM_TO_6PM);
        }

        public void selectTimeslot9amTo10pm()
        {
            clickButtonByAriaLabel(LOCATOR_BUTTON_TIMESLOT_9AM_TO_10PM);
        }

        public void selectTimeslot9amTo12pm()
        {
            clickButtonByAriaLabel(LOCATOR_BUTTON_TIMESLOT_9AM_TO_12PM);
        }

        public void selectTimeslot12pmTo3pm()
        {
            clickButtonByAriaLabel(LOCATOR_BUTTON_TIMESLOT_12PM_TO_3PM);
        }

        public void selectTimeslot3pmTo6pm()
        {
            clickButtonByAriaLabel(LOCATOR_BUTTON_TIMESLOT_3PM_TO_6PM);
        }

        public void selectTimeslot6pmTo10pm()
        {
            clickButtonByAriaLabel(LOCATOR_BUTTON_TIMESLOT_6PM_TO_10PM);
        }

        public void clearTimeslotSelection()
        {
            click(LOCATOR_BUTTON_TIMESLOT_CLEAR_ALL);
        }

        public void selectTimeslot(String timeslot)
        {
            switch (timeslot.trim().toLowerCase())
            {
                case "9am to 6pm":
                    selectTimeslot9amTo6pm();
                    break;
                case "9am to 10pm":
                    selectTimeslot9amTo10pm();
                    break;
                case "9am to 12pm":
                    selectTimeslot9amTo12pm();
                    break;
                case "12pm to 3pm":
                    selectTimeslot12pmTo3pm();
                    break;
                case "3pm to 6pm":
                    selectTimeslot3pmTo6pm();
                    break;
                case "6pm to 10pm":
                    selectTimeslot6pmTo10pm();
                    break;
                case "all":
                    clearTimeslotSelection();
                    selectTimeslot9amTo6pm();
                    selectTimeslot9amTo10pm();
                    selectTimeslot9amTo10pm();
                    selectTimeslot9amTo12pm();
                    selectTimeslot12pmTo3pm();
                    selectTimeslot3pmTo6pm();
                    selectTimeslot6pmTo10pm();
                    break;
            }
        }

        public void selectTimeslot(Set<String> timeslots)
        {
            clearTimeslotSelection();
            timeslots.forEach(this::selectTimeslot);
        }

        public void fillForm(DriverTypeParams driverTypeParams)
        {
            selectDeliveryType(driverTypeParams.getDeliveryTypes());
            selectPriorityLevel(driverTypeParams.getPriorityLevels());
            selectReservationSize(driverTypeParams.getReservationSizes());
            selectParcelSize(driverTypeParams.getParcelSizes());
            selectTimeslot(driverTypeParams.getTimeslots());
        }
    }
}
