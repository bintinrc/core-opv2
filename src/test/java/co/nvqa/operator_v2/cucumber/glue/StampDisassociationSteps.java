package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.order_create.v2.OrderRequestV2;
import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.selenium.page.LoginPage;
import co.nvqa.operator_v2.selenium.page.StampDisassociationPage;
import com.google.inject.Inject;
import cucumber.api.PendingException;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class StampDisassociationSteps extends AbstractSteps
{
    private StampDisassociationPage stampDisassociationPage;

    @Inject
    public StampDisassociationSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        stampDisassociationPage = new StampDisassociationPage(getWebDriver());
    }

    @And("^Operator enter Stamp ID of the created order on Stamp Disassociation page$")
    public void operatorEnterStampIDOfTheCreatedOrder()
    {
        String trackingId = get(KEY_CREATED_ORDER_TRACKING_ID);
        stampDisassociationPage.enterStampId(trackingId);
    }

    @Then("^Operator verify order details on Stamp Disassociation page$")
    public void operatorVerifyOrderDetailsOnStampDisassociationPage()
    {
        Order order = get(KEY_ORDER_DETAILS);
        stampDisassociationPage.verifyOrderDetails(order);

    }

    @Then("^Operator verify the label says \"([^\"]*)\" on Stamp Disassociation page$")
    public void operatorVerifyTheLabelSaysOnStampDisassociationPage(String labelText)
    {
        stampDisassociationPage.verifyLabelText(labelText);
    }
}
