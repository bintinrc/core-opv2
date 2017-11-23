package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.model.RouteCashInboundCod;
import co.nvqa.operator_v2.selenium.page.RouteCashInboundPage;
import co.nvqa.operator_v2.util.ScenarioStorage;
import com.google.inject.Inject;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class RouteCashInboundSteps extends AbstractSteps
{
    @Inject ScenarioStorage scenarioStorage;
    private RouteCashInboundPage routeCashInboundPage;

    @Inject
    public RouteCashInboundSteps(ScenarioManager scenarioManager)
    {
        super(scenarioManager);
    }

    @Override
    public void init()
    {
        routeCashInboundPage = new RouteCashInboundPage(getWebDriver());
    }

    @When("^Operator create new COD on Route Cash Inbound page$")
    public void operatorCreateNewCod()
    {
        int routeId = scenarioStorage.get(KEY_CREATED_ROUTE_ID);
        RouteCashInboundCod routeCashInboundCod = new RouteCashInboundCod();

        routeCashInboundPage.addCod(routeCashInboundCod);
        scenarioStorage.put("routeCashInboundCod", routeCashInboundCod);
    }
}
