package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.support.ScenarioStorage;
import com.google.inject.Inject;
import co.nvqa.operator_v2.model.order_creation.v2.Order;
import co.nvqa.operator_v2.selenium.page.TransactionsPage;
import co.nvqa.operator_v2.support.TestConstants;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
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

        //transactionsPage.selectVariable(routeGroupTemplateName);
        transactionsPage.selectShipperFilter(TestConstants.SHIPPER_V2_CLIENT_ID);
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
