package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.ReservationGroup;
import com.google.common.collect.ImmutableMap;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.WebDriver;

import static co.nvqa.operator_v2.selenium.page.HubsGroupManagementPage.HubsGroupTable.ACTION_DELETE;
import static co.nvqa.operator_v2.selenium.page.HubsGroupManagementPage.HubsGroupTable.ACTION_EDIT;
import static co.nvqa.operator_v2.selenium.page.HubsGroupManagementPage.HubsGroupTable.COLUMN_NAME;

/**
 * @author Sergey Mishanin
 */
@SuppressWarnings("WeakerAccess")
public class ReservationPresetManagementPage extends OperatorV2SimplePage
{
    public static final String LOCATOR_SPINNER_LOADING_FILTERS = "//md-progress-circular/following-sibling::div[text()='Loading filters...']";

    private AddNewGroupDialog addNewGroupDialog;
    private EditGroupDialog editGroupDialog;
    private ReservationPresetTable reservationPresetTable;

    public ReservationPresetManagementPage(WebDriver webDriver)
    {
        super(webDriver);
        addNewGroupDialog = new AddNewGroupDialog(webDriver);
        reservationPresetTable = new ReservationPresetTable(webDriver);
        editGroupDialog = new EditGroupDialog(webDriver);
    }

    public void clickAddNewGroup()
    {
        clickNvIconTextButtonByName("container.reservation-preset-management.add-new-group");
    }

    public void waitUntilPageLoaded()
    {
        super.waitUntilPageLoaded();
        waitUntilInvisibilityOfElementLocated(LOCATOR_SPINNER_LOADING_FILTERS);
        pause3s();
    }

    public void addNewGroup(ReservationGroup reservationPreset)
    {
        waitUntilPageLoaded();
        clickAddNewGroup();
        addNewGroupDialog.fillForm(reservationPreset);
    }

    public void editGroup(String groupName, ReservationGroup reservationPreset)
    {
        reservationPresetTable.filterByColumn(COLUMN_NAME, groupName);
        reservationPresetTable.clickActionButton(1, ACTION_EDIT);
        editGroupDialog.fillForm(reservationPreset);
    }

    public void deleteGroup(String groupName)
    {
        reservationPresetTable.filterByColumn(COLUMN_NAME, groupName);
        reservationPresetTable.clickActionButton(1, ACTION_DELETE);
        clickButtonOnMdDialogByAriaLabel("Delete");
        waitUntilInvisibilityOfToast("Group Deleted");
    }

    public void verifyGroupProperties(String groupName, ReservationGroup expectedGroup)
    {
        reservationPresetTable.filterByColumn(COLUMN_NAME, groupName);
        ReservationGroup actualGroup = reservationPresetTable.readEntity(1);
        expectedGroup.compareWithActual(actualGroup, "id");
    }

    public void verifyGroupDeleted(String groupName)
    {
        reservationPresetTable.filterByColumn(COLUMN_NAME, groupName);
        assertTrue("Group with Name [" + groupName + "] was not deleted", reservationPresetTable.isTableEmpty());
    }

    /**
     * Accessor for Add New Group dialog
     */
    @SuppressWarnings("UnusedReturnValue")
    public static class AddNewGroupDialog extends OperatorV2SimplePage
    {
        protected String dialogTittle;
        protected String locatorButtonSubmit;

        public static final String DIALOG_TITLE = "Add New Group";
        public static final String LOCATOR_BUTTON_SUBMIT = "Submit";

        public AddNewGroupDialog(WebDriver webDriver)
        {
            super(webDriver);
            dialogTittle = DIALOG_TITLE;
            locatorButtonSubmit = LOCATOR_BUTTON_SUBMIT;
        }

        public AddNewGroupDialog waitUntilVisible()
        {
            waitUntilVisibilityOfMdDialogByTitle(dialogTittle);
            return this;
        }

        public AddNewGroupDialog setName(String value)
        {
            if(StringUtils.isNotBlank(value))
            {
                sendKeysById("commons.name", value);
            }
            return this;
        }

        public AddNewGroupDialog setDriver(String value)
        {
            if(StringUtils.isNotBlank(value))
            {
                selectValueFromNvAutocompleteByPossibleOptions("ctrl.driversSelectionOptions", value);
            }
            return this;
        }

        public AddNewGroupDialog setHub(String value)
        {
            if(StringUtils.isNotBlank(value))
            {
                selectValueFromNvAutocompleteByPossibleOptions("ctrl.hubsSelectionOptions", value);
            }
            return this;
        }

        public void submitForm()
        {
            clickNvApiTextButtonByNameAndWaitUntilDone(locatorButtonSubmit);
            waitUntilInvisibilityOfMdDialogByTitle(dialogTittle);
        }

        public void fillForm(ReservationGroup reservationPreset)
        {
            waitUntilVisible();
            setName(reservationPreset.getName());
            setDriver(reservationPreset.getDriver());
            setHub(reservationPreset.getHub());
            submitForm();
        }
    }

    /**
     * Accessor for Edit Group dialog
     */
    public static class EditGroupDialog extends AddNewGroupDialog
    {
        public static final String DIALOG_TITLE = "Edit Group";
        public static final String LOCATOR_BUTTON_SUBMIT = "Update";

        public EditGroupDialog(WebDriver webDriver)
        {
            super(webDriver);
            dialogTittle = DIALOG_TITLE;
            locatorButtonSubmit = LOCATOR_BUTTON_SUBMIT;
        }
    }

    /**
     * Accessor for Reservation Presets table
     */
    public static class ReservationPresetTable extends MdVirtualRepeatTable<ReservationGroup>
    {
        public static final String COLUMN_NAME = "name";
        public static final String COLUMN_DRIVER = "driver";
        public static final String COLUMN_HUB = "hub";
        public static final String COLUMN_NUMBER_OF_PICKUP_LOCATIONS = "number of pickup locations";

        public static final String ACTION_EDIT = "edit";
        public static final String ACTION_DELETE = "delete";

        public ReservationPresetTable(WebDriver webDriver)
        {
            super(webDriver);
            setColumnLocators(ImmutableMap.<String, String>builder()
                    .put(COLUMN_NAME, "name")
                    .put(COLUMN_DRIVER, "c_driver-name")
                    .put(COLUMN_HUB, "c_hub-name")
                    .put(COLUMN_NUMBER_OF_PICKUP_LOCATIONS, "c_address-count")
                    .build()
            );
            setActionButtonsLocators(ImmutableMap.of(ACTION_EDIT, "container.reservation-preset-management.edit-group",
                    ACTION_DELETE, "container.reservation-preset-management.delete-group"));
            setEntityClass(ReservationGroup.class);
            setMdVirtualRepeat("group in getTableData()");
        }
    }
}
