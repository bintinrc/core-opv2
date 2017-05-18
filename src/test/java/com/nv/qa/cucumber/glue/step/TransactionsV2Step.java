package com.nv.qa.cucumber.glue.step;

import com.google.inject.Inject;
import com.nv.qa.model.order_creation.v2.Order;
import com.nv.qa.selenium.page.TransactionsV2Page;
import com.nv.qa.support.ScenarioStorage;
import cucumber.api.java.en.When;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class TransactionsV2Step extends AbstractSteps
{
    @Inject private ScenarioStorage scenarioStorage;
    private TransactionsV2Page transactionsPage;

    @Inject
    public TransactionsV2Step(CommonScenario commonScenario)
    {
        super(commonScenario);
    }

    @Override
    public void init()
    {
        transactionsPage = new TransactionsV2Page(getDriver());
    }

    @When("^Operator V2 add created Transaction to Route Group$")
    public void addCreatedTransactionToRouteGroup()
    {

        Order order = scenarioStorage.get("order");
        String expectedTrackingId = order.getTracking_id();

        String routeGroupName = scenarioStorage.get("routeGroupName");

        transactionsPage.removeFilter("Start Datetime");
        transactionsPage.removeFilter("End Datetime");
        transactionsPage.setCreationTimeFilter();
        transactionsPage.clickLoadSelectionButton();
        transactionsPage.searchByTrackingId(expectedTrackingId);
        transactionsPage.selectAllShown();
        transactionsPage.clickAddToRouteGroupButton();
        transactionsPage.selectRouteGroupOnAddToRouteGroupDialog(routeGroupName);
        pause2s();
        takesScreenshot();
        transactionsPage.clickAddTransactionsOnAddToRouteGroupDialog();
        takesScreenshot();
        pause5s();
    }
}
