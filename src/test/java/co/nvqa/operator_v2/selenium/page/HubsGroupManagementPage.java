package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.HubsGroup;
import com.google.common.collect.ImmutableMap;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import static co.nvqa.operator_v2.selenium.page.HubsGroupManagementPage.HubsGroupTable.*;

/**
 * @author Sergey Mishanin
 */
@SuppressWarnings("WeakerAccess")
public class HubsGroupManagementPage extends OperatorV2SimplePage
{
    public static final String LOCATOR_SPINNER_LOADING_FILTERS = "//md-progress-circular/following-sibling::div[text()='Loading filters...']";

    private CreateHubsGroupDialog createHubsGroupDialog;
    private EditHubsGroupDialog editHubsGroupDialog;
    private HubsGroupTable hubsGroupTable;

    public HubsGroupManagementPage(WebDriver webDriver)
    {
        super(webDriver);
        createHubsGroupDialog = new CreateHubsGroupDialog(webDriver);
        hubsGroupTable = new HubsGroupTable(webDriver);
        editHubsGroupDialog = new EditHubsGroupDialog(webDriver);
    }

    public void clickCreateHubGroup()
    {
        clickNvIconTextButtonByName("container.hub-group-management.create-hub-group");
    }

    public void waitUntilPageLoaded()
    {
        super.waitUntilPageLoaded();
        waitUntilInvisibilityOfElementLocated(LOCATOR_SPINNER_LOADING_FILTERS);
        pause3s();
    }

    public void createHubsGroup(HubsGroup hubGroup)
    {
        waitUntilPageLoaded();
        clickCreateHubGroup();
        createHubsGroupDialog.fillForm(hubGroup);
    }

    public void editHubsGroup(String hubsGroupName, HubsGroup hubsGroup)
    {
        hubsGroupTable.filterByColumn(COLUMN_NAME, hubsGroupName);
        hubsGroupTable.clickActionButton(1, ACTION_EDIT);
        editHubsGroupDialog.fillForm(hubsGroup);
    }

    public void deleteHubsGroup(Long hubsGroupId)
    {
        hubsGroupTable.filterByColumn(COLUMN_ID, String.valueOf(hubsGroupId));
        hubsGroupTable.clickActionButton(1, ACTION_DELETE);
        clickButtonOnMdDialogByAriaLabel("Delete");
        waitUntilInvisibilityOfToast(String.format("Hub Group %d successfully deleted", hubsGroupId));
    }

    public void verifyHubsGroup(String hubGroupName, HubsGroup expectedHubsGroup)
    {
        hubsGroupTable.filterByColumn(COLUMN_NAME, hubGroupName);
        HubsGroup actualHubsGroup = hubsGroupTable.readEntity(1);
        expectedHubsGroup.compareWithActual(actualHubsGroup);
        expectedHubsGroup.setId(actualHubsGroup.getId());
    }

    public void verifyHubsGroupDeleted(Long hubsGroupId)
    {
        hubsGroupTable.filterByColumn(COLUMN_ID, String.valueOf(hubsGroupId));
        Assert.assertTrue("Hubs Group with ID [" + hubsGroupId + "] was not deleted", hubsGroupTable.isTableEmpty());
    }

    /**
     * Accessor for Add Driver dialog
     */
    @SuppressWarnings("UnusedReturnValue")
    public static class CreateHubsGroupDialog extends OperatorV2SimplePage
    {
        protected String dialogTittle;
        protected String locatorButtonSubmit;

        public static final String DIALOG_TITLE = "Create Hub Group";
        public static final String LOCATOR_FIELD_HUB_GROUP_NAME = "Hub Group Name";
        public static final String LOCATOR_BUTTON_SUBMIT = "container.hub-group-management.create-hub-group";

        public CreateHubsGroupDialog(WebDriver webDriver)
        {
            super(webDriver);
            dialogTittle = DIALOG_TITLE;
            locatorButtonSubmit = LOCATOR_BUTTON_SUBMIT;
        }

        public CreateHubsGroupDialog waitUntilVisible()
        {
            waitUntilVisibilityOfMdDialogByTitle(dialogTittle);
            return this;
        }

        public CreateHubsGroupDialog setHubGroupName(String value)
        {
            fillIfNotNull(LOCATOR_FIELD_HUB_GROUP_NAME, value);
            return this;
        }

        public CreateHubsGroupDialog addHub(String value)
        {
            if (StringUtils.isNotBlank(value))
            {
                selectValueFromMdAutocomplete("Select Hub", value);
                clickNvIconButtonByName("commons.add");
            }
            return this;
        }

        public CreateHubsGroupDialog addHubs(List<String> values)
        {
            if (CollectionUtils.isNotEmpty(values))
            {
                values.forEach(this::addHub);
            }
            return this;
        }

        public void submitForm()
        {
            clickNvApiTextButtonByNameAndWaitUntilDone(locatorButtonSubmit);
            waitUntilInvisibilityOfMdDialogByTitle(dialogTittle);
        }

        public void fillForm(HubsGroup hubGroup)
        {
            waitUntilVisible();
            setHubGroupName(hubGroup.getName());
            addHubs(hubGroup.getHubs());
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
     * Accessor for Edit Hubs Group dialog
     */
    public static class EditHubsGroupDialog extends CreateHubsGroupDialog
    {
        public static final String DIALOG_TITLE = "Edit Hub Group";
        public static final String LOCATOR_BUTTON_SUBMIT = "commons.save";

        public EditHubsGroupDialog(WebDriver webDriver)
        {
            super(webDriver);
            dialogTittle = DIALOG_TITLE;
            locatorButtonSubmit = LOCATOR_BUTTON_SUBMIT;
        }
    }

    /**
     * Accessor for Hub Groups table
     */
    public static class HubsGroupTable extends MdVirtualRepeatTable<HubsGroup>
    {
        public static final String COLUMN_ID = "id";
        public static final String COLUMN_NAME = "name";
        public static final String COLUMN_HUBS = "hubs";

        public static final String ACTION_EDIT = "edit";
        public static final String ACTION_DELETE = "delete";

        public static final String LOCATOR_HUB_NAME = "//tr[@md-virtual-repeat='hubGroup in getTableData()'][%d]//td[starts-with(@class,'hubs')]//a[@class='hub-link']";

        public HubsGroupTable(WebDriver webDriver)
        {
            super(webDriver);
            setColumnLocators(ImmutableMap.<String, String>builder()
                    .put(COLUMN_ID, "id")
                    .put(COLUMN_NAME, "name")
                    .put(COLUMN_HUBS, "hubs")
                    .build()
            );
            setActionButtonsLocators(ImmutableMap.of(ACTION_EDIT, "Edit", ACTION_DELETE, "Delete"));
            setColumnReaders(ImmutableMap.of(COLUMN_HUBS, this::getHubs));
            setEntityClass(HubsGroup.class);
            setMdVirtualRepeat("hubGroup in getTableData()");
        }

        public String getHubs(int rowNumber)
        {
            String xpath = String.format(LOCATOR_HUB_NAME, rowNumber);
            int hubsCount = getElementsCount(xpath);
            return IntStream.rangeClosed(1, hubsCount).mapToObj(i -> getText(xpath + "[" + i + "]"))
                    .collect(Collectors.joining(","));
        }
    }
}
