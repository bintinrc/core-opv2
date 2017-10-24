package com.nv.qa.cucumber.glue.step;

import com.google.inject.Inject;
import com.nv.qa.model.order_creation.v2.Order;
import com.nv.qa.selenium.page.TransactionsPage;
import com.nv.qa.support.APIEndpoint;
import com.nv.qa.support.ScenarioStorage;
import cucumber.api.java.en.When;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class TransactionsSteps extends AbstractSteps
{
    @Inject private ScenarioStorage scenarioStorage;
    private TransactionsPage transactionsPage;

    @Inject
    public TransactionsSteps(ScenarioManager scenarioManager)
    {
        super(scenarioManager);
    }

    @Override
    public void init()
    {
        transactionsPage = new TransactionsPage(getDriver());
    }

    @When("^Operator V2 add 'Transaction' to 'Route Group'$")
    public void addTransactionToRouteGroup()
    {
        String routeGroupTemplateName = scenarioStorage.get("routeGroupTemplateName");
        String routeGroupName = scenarioStorage.get("routeGroupName");
        Order order = scenarioStorage.get("order");

//        transactionsPage.selectVariable(routeGroupTemplateName);
        transactionsPage.selectShipperFilter(APIEndpoint.SHIPPER_V2_CLIENT_ID);
        transactionsPage.clickLoadAllEntriesButton();
        transactionsPage.clickLoadAllEntriesButton();
        transactionsPage.searchTrackingId(order.getTracking_id());
        transactionsPage.selectAllShown();
        transactionsPage.clickAddToRouteGroupButton();
        transactionsPage.selectRouteGroupOnAddToRouteGroupDialog(routeGroupName);
        takesScreenshot();
        transactionsPage.clickAddTransactionsOnAddToRouteGroupDialog();
        takesScreenshot();
        pause5s();
    }
}
