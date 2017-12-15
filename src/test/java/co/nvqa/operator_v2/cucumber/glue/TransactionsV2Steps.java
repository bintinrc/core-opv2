package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.selenium.page.TransactionsV2Page;
import com.google.inject.Inject;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

import java.util.List;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class TransactionsV2Steps extends AbstractSteps
{
    private TransactionsV2Page transactionsPage;

    @Inject
    public TransactionsV2Steps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        transactionsPage = new TransactionsV2Page(getWebDriver());
    }

    @When("^Operator V2 add created Transaction to Route Group$")
    public void addCreatedTransactionToRouteGroup()
    {
        String expectedTrackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        String routeGroupName = get(KEY_ROUTE_GROUP_NAME);

        transactionsPage.removeFilter("Start Datetime");
        transactionsPage.removeFilter("End Datetime");
        transactionsPage.setCreationTimeFilter();
        transactionsPage.clickLoadSelectionButton();
        transactionsPage.searchByTrackingId(expectedTrackingId);
        transactionsPage.selectAllShown();
        transactionsPage.clickAddToRouteGroupButton();
        transactionsPage.selectRouteGroupOnAddToRouteGroupDialog(routeGroupName);
        pause1s();
        takesScreenshot();
        transactionsPage.clickAddTransactionsOnAddToRouteGroupDialog();
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
            transactionsPage.removeFilter("Start Datetime");
            transactionsPage.removeFilter("End Datetime");
            transactionsPage.setCreationTimeFilter();
            transactionsPage.clickLoadSelectionButton();
            transactionsPage.searchByTrackingId(trackingId);
            transactionsPage.selectAllShown();
            transactionsPage.clickAddToRouteGroupButton();
            transactionsPage.selectRouteGroupOnAddToRouteGroupDialog(routeGroupName);
            pause1s();
            takesScreenshot();
            transactionsPage.clickAddTransactionsOnAddToRouteGroupDialog();
            takesScreenshot();
            pause3s();
        });
    }
}
