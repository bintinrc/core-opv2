package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.selenium.page.CreateRouteGroupsPage;
import com.google.inject.Inject;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

import java.util.List;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class CreateRouteGroupsSteps extends AbstractSteps
{
    private CreateRouteGroupsPage createRouteGroupsPage;

    @Inject
    public CreateRouteGroupsSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        createRouteGroupsPage = new CreateRouteGroupsPage(getWebDriver());
    }

    @When("^Operator V2 add created Transaction to Route Group$")
    public void addCreatedTransactionToRouteGroup()
    {
        String expectedTrackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        String routeGroupName = get(KEY_ROUTE_GROUP_NAME);

        createRouteGroupsPage.removeFilter("Start Datetime");
        createRouteGroupsPage.removeFilter("End Datetime");
        createRouteGroupsPage.setCreationTimeFilter();
        createRouteGroupsPage.clickButtonLoadSelection();
        createRouteGroupsPage.searchByTrackingId(expectedTrackingId);
        createRouteGroupsPage.selectAllShown();
        createRouteGroupsPage.clickAddToRouteGroupButton();
        createRouteGroupsPage.selectRouteGroupOnAddToRouteGroupDialog(routeGroupName);
        pause1s();
        takesScreenshot();
        createRouteGroupsPage.clickAddTransactionsOnAddToRouteGroupDialog();
        takesScreenshot();
        pause1s();
    }


    @When("^Operator V2 add created Transactions to Route Group$")
    public void addCreatedTransactionsToRouteGroup()
    {
        List<String> trackingIds = get(KEY_LIST_OF_CREATED_ORDER_TRACKING_ID);
        String routeGroupName = get(KEY_ROUTE_GROUP_NAME);

        trackingIds.forEach((String trackingId)->
        {
            createRouteGroupsPage.removeFilter("Start Datetime");
            createRouteGroupsPage.removeFilter("End Datetime");
            createRouteGroupsPage.setCreationTimeFilter();
            createRouteGroupsPage.clickButtonLoadSelection();
            createRouteGroupsPage.searchByTrackingId(trackingId);
            createRouteGroupsPage.selectAllShown();
            createRouteGroupsPage.clickAddToRouteGroupButton();
            createRouteGroupsPage.selectRouteGroupOnAddToRouteGroupDialog(routeGroupName);
            pause1s();
            takesScreenshot();
            createRouteGroupsPage.clickAddTransactionsOnAddToRouteGroupDialog();
            takesScreenshot();
            pause3s();
        });
    }
}
