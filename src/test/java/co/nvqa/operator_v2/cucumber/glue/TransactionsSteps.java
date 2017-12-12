package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.selenium.page.TransactionsPage;
import co.nvqa.operator_v2.util.TestConstants;
import com.google.inject.Inject;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class TransactionsSteps extends AbstractSteps
{
    private TransactionsPage transactionsPage;

    @Inject
    public TransactionsSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        transactionsPage = new TransactionsPage(getWebDriver());
    }

    @When("^Operator V2 add 'Transaction' to 'Route Group'$")
    public void addTransactionToRouteGroup()
    {
        String trackingId = getScenarioStorage().get(KEY_CREATED_ORDER_TRACKING_ID);
        String routeGroupName = getScenarioStorage().get(KEY_ROUTE_GROUP_NAME);
        String routeGroupTemplateName = getScenarioStorage().get("routeGroupTemplateName");

        //transactionsPage.selectVariable(routeGroupTemplateName);
        transactionsPage.selectShipperFilter(TestConstants.SHIPPER_V2_CLIENT_ID);
        transactionsPage.clickLoadAllEntriesButton();
        transactionsPage.clickLoadAllEntriesButton();
        transactionsPage.searchTrackingId(trackingId);
        transactionsPage.selectAllShown();
        transactionsPage.clickAddToRouteGroupButton();
        transactionsPage.selectRouteGroupOnAddToRouteGroupDialog(routeGroupName);
        takesScreenshot();
        transactionsPage.clickAddTransactionsOnAddToRouteGroupDialog();
        takesScreenshot();
        pause5s();
    }
}
