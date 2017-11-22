package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.util.TestUtils;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class RouteGroupsPage extends SimplePage
{
    private static final SimpleDateFormat DATE_FILTER_SDF = new SimpleDateFormat("EEEE MMMM d yyyy");

    private static final String MD_VIRTUAL_REPEAT = "routeGroup in getTableData()";
    public static final String COLUMN_CLASS_NAME = "name";

    public static final String ACTION_BUTTON_EDIT = "commons.edit";
    public static final String ACTION_BUTTON_DELETE = "commons.delete";

    public RouteGroupsPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void createRouteGroup(String routeGroupName)
    {
        clickNvIconTextButtonByNameAndWaitUntilDone("container.route-group.create-route-group");
        setRouteGroupNameValue(routeGroupName);
        setRouteGroupDescriptionValue(String.format("This Route Group is created by automation test from Operator V2. Created at %s.", new Date().toString()));
        clickCreateRouteGroupAndAddTransactionsOnCreateDialog();
    }

    public void editRouteGroup(String filterRouteGroupName, String newRouteGroupName)
    {
        searchTable(filterRouteGroupName);
        pause100ms();
        String actualName = getTextOnTable(1, RouteGroupsPage.COLUMN_CLASS_NAME);
        Assert.assertTrue("Route Group name not matched.", actualName.startsWith(filterRouteGroupName)); //Route Group name is concatenated with description.

        clickActionButtonOnTable(1, ACTION_BUTTON_EDIT);
        setRouteGroupNameValue(newRouteGroupName);
        clickCreateRouteGroupAndAddTransactionsOnEditDialog();
    }

    public void deleteRouteGroup(String filterRouteGroupName)
    {
        searchTable(filterRouteGroupName);
        pause100ms();
        clickActionButtonOnTable(1, ACTION_BUTTON_DELETE);
        pause100ms();
        click("//md-dialog/md-dialog-actions/button[@aria-label='Delete']");
        pause1s();
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

    public void clickCreateRouteGroupAndAddTransactionsOnEditDialog()
    {
        clickCreateRouteGroupAndAddTransactionsOnCreateDialog();
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
}
