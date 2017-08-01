package com.nv.qa.cucumber.glue.step;

import com.google.inject.Inject;
import com.nv.qa.model.order_creation.v2.Order;
import com.nv.qa.selenium.page.TransactionsV2Page;
import com.nv.qa.support.ScenarioStorage;
import cucumber.api.java.en.When;

import java.util.List;

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
        pause1s();
        takesScreenshot();
        transactionsPage.clickAddTransactionsOnAddToRouteGroupDialog();
        takesScreenshot();
        pause1s();
    }


    @When("^Operator V2 add created Transactions to Route Group$")
    public void addCreatedTransactionsToRouteGroup()
    {
        List<String> trackingIds = scenarioStorage.get("trackingIds");
        trackingIds.forEach((String trackingId) ->{
            String routeGroupName = scenarioStorage.get("routeGroupName");
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
