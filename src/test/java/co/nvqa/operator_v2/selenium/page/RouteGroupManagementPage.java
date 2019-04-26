package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.RouteGroupJobDetails;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.common.collect.ImmutableMap;
import org.openqa.selenium.WebDriver;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class RouteGroupManagementPage extends OperatorV2SimplePage
{
    private static final SimpleDateFormat DATE_FILTER_SDF = new SimpleDateFormat("EEEE MMMM d yyyy");

    private static final String MD_VIRTUAL_REPEAT = "routeGroup in getTableData()";
    public static final String COLUMN_CLASS_DATA_NAME = "name";

    public static final String ACTION_BUTTON_EDIT = "commons.edit";
    public static final String ACTION_BUTTON_DELETE = "commons.delete";

    private CreateRouteGroupsPage createRouteGroupsPage;
    private EditRouteGroupDialog editRouteGroupDialog;
    private DeleteRouteGroupsDialog deleteRouteGroupsDialog;

    public RouteGroupManagementPage(WebDriver webDriver)
    {
        super(webDriver);
        createRouteGroupsPage = new CreateRouteGroupsPage(webDriver);
        editRouteGroupDialog = new EditRouteGroupDialog(webDriver);
        deleteRouteGroupsDialog = new DeleteRouteGroupsDialog(webDriver);
    }

    public void createRouteGroup(String routeGroupName, String hubName)
    {
        clickNvIconTextButtonByNameAndWaitUntilDone("container.route-group.create-route-group");
        setRouteGroupNameValue(routeGroupName);
        setRouteGroupDescriptionValue(String.format("This Route Group is created by automation test from Operator V2. Created at %s.", CREATED_DATE_SDF.format(new Date())));

        if(hubName!=null)
        {
            selectValueFromNvAutocompleteByPossibleOptions("fields.hub.options", hubName);
        }

        clickCreateRouteGroupAndAddTransactionsOnCreateDialog();
        createRouteGroupsPage.waitUntilRouteGroupPageIsLoaded();
    }

    public void editRouteGroup(String filterRouteGroupName, String newRouteGroupName)
    {
        searchTable(filterRouteGroupName);
        pause100ms();
        String actualName = getTextOnTable(1, RouteGroupManagementPage.COLUMN_CLASS_DATA_NAME);
        assertTrue("Route Group name not matched.", actualName.startsWith(filterRouteGroupName)); //Route Group name is concatenated with description.

        clickActionButtonOnTable(1, ACTION_BUTTON_EDIT);
        setRouteGroupNameValue(newRouteGroupName);
        clickNvButtonSaveByName("container.route-group.dialogs.save-changes");
        waitUntilInvisibilityOfToast("Route Group Updated");
    }

    public void deleteRouteGroup(String filterRouteGroupName)
    {
        searchTable(filterRouteGroupName);
        pause100ms();
        clickActionButtonOnTable(1, ACTION_BUTTON_DELETE);
        pause100ms();
        click("//md-dialog/md-dialog-actions/button[@aria-label='Delete']");
        waitUntilInvisibilityOfToast("Route Group Deleted");
    }

    public DeleteRouteGroupsDialog openDeleteRouteGroupsDialog()
    {
        clickMdMenuItem("Apply Action", "Delete Selected");
        return deleteRouteGroupsDialog.waitUntilVisible();
    }

    public void selectRouteGroups(List<String> routeGroupNames)
    {
        routeGroupNames.forEach(this::selectRouteGroup);
    }

    public void selectRouteGroup(String routeGroupName)
    {
        searchTable(routeGroupName);
        pause100ms();
        checkRowWithMdVirtualRepeat(1, "routeGroup in getTableData()");
    }

    public EditRouteGroupDialog openEditRouteGroupDialog(String filterRouteGroupName)
    {
        searchTable(filterRouteGroupName);
        pause100ms();
        clickActionButtonOnTable(1, ACTION_BUTTON_EDIT);
        return editRouteGroupDialog.waitUntilVisible();
    }

    public void setRouteGroupNameValue(String value)
    {
        sendKeysById("commons.model.group-name", value);
    }

    public void setRouteGroupDescriptionValue(String value)
    {
        sendKeysById("commons.description", value);
    }

    public void clickCreateRouteGroupAndAddTransactionsOnCreateDialog()
    {
        clickNvButtonSaveByNameAndWaitUntilDone("Create Route Group & Add Transactions");
    }

    public void searchTable(String keyword)
    {
        String dateLabel = DATE_FILTER_SDF.format(TestUtils.getNextDate(1));

        click("//md-datepicker[@ng-model='ctrl.filter.toDate']/button");
        pause1s();
        click("//td[@aria-label='" + dateLabel + "']");
        pause1s();
        sendKeys("//input[@type='text'][@ng-model='searchText']", keyword);
    }

    public String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT);
    }

    public void clickActionButtonOnTable(int rowNumber, String actionButtonName)
    {
        clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName, MD_VIRTUAL_REPEAT);
    }

    public void waitUntilRouteGroupPageIsLoaded()
    {
        waitUntilInvisibilityOfElementLocated("//div[contains(@class,'message') and text()='Loading route groups...']");
    }

    /**
     * Accessor for Edit Route Group dialog
     */
    public static class EditRouteGroupDialog extends OperatorV2SimplePage
    {
        private static final String DIALOG_TITLE = "Edit Route Group";

        private JobDetailsTable jobDetailsTable;

        public EditRouteGroupDialog(WebDriver webDriver)
        {
            super(webDriver);
            jobDetailsTable = new JobDetailsTable(webDriver);
        }

        public EditRouteGroupDialog waitUntilVisible()
        {
            waitUntilVisibilityOfMdDialogByTitle(DIALOG_TITLE);
            return this;
        }

        public JobDetailsTable jobDetailsTable()
        {
            return jobDetailsTable;
        }

        public EditRouteGroupDialog clickRemoveSelected()
        {
            clickNvIconTextButtonByName("container.route-group.dialogs.remove-selected");
            return this;
        }

        /**
         * Accessor for Jobs table
         */
        public static class JobDetailsTable extends MdVirtualRepeatTable<RouteGroupJobDetails>
        {
            public static final String COLUMN_TRACKING_ID = "trackingId";
            public static final String COLUMN_TYPE = "type";

            public JobDetailsTable(WebDriver webDriver)
            {
                super(webDriver);
                setColumnLocators(ImmutableMap.<String, String>builder()
                        .put("sn", "_idx")
                        .put("id", "id")
                        .put("orderId", "order-id")
                        .put(COLUMN_TRACKING_ID, "tracking-id")
                        .put(COLUMN_TYPE, "type")
                        .build()
                );
                setEntityClass(RouteGroupJobDetails.class);
                setMdVirtualRepeat("job in getTableData()");
            }
        }

        public void saveChanges()
        {
            clickNvButtonSaveByNameAndWaitUntilDone("container.route-group.dialogs.save-changes");
            waitUntilInvisibilityOfMdDialogByTitle(DIALOG_TITLE);
        }
    }

    /**
     * Accessor for Delete Route Group(s) dialog
     */
    public static class DeleteRouteGroupsDialog extends OperatorV2SimplePage
    {
        private static final String DIALOG_TITLE = "Delete Route Group(s)";

        public DeleteRouteGroupsDialog(WebDriver webDriver)
        {
            super(webDriver);
        }

        public DeleteRouteGroupsDialog waitUntilVisible()
        {
            waitUntilVisibilityOfMdDialogByTitle(DIALOG_TITLE);
            return this;
        }

        public DeleteRouteGroupsDialog enterPassword(String password)
        {
            sendKeysById("password", password);
            return this;
        }

        public List<String> getRouteGroupNames()
        {
            return getTextOfElements("//tr[@ng-repeat='routeGroup in ctrl.routeGroups']/td[2]");
        }

        public void clickDeleteRouteGroups()
        {
            clickNvApiTextButtonByNameAndWaitUntilDone("container.route-group.delete-route-groups");
            waitUntilInvisibilityOfMdDialogByTitle(DIALOG_TITLE);
        }
    }
}
