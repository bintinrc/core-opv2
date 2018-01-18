package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.cucumber.glue.StandardApiDriverSteps;
import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.util.TestConstants;
import com.google.inject.Inject;
import cucumber.api.java.en.Given;
import cucumber.runtime.java.guice.ScenarioScoped;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class ApiDriverSteps extends StandardApiDriverSteps<ScenarioManager>
{
    @Inject
    public ApiDriverSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage, TestConstants.NINJA_DRIVER_USERNAME, TestConstants.NINJA_DRIVER_PASSWORD);
    }

    @Override
    public void init()
    {
    }

    @Given("^API Driver get Confirmation Code of RSVN waypoint from response of route list endpoint$")
    @Override
    public void apiDriverGetConfirmationCodeOfRsvnWaypointFromResponseOfRouteListEndpoint()
    {
        super.apiDriverGetConfirmationCodeOfRsvnWaypointFromResponseOfRouteListEndpoint();
    }

    @Given("^API Driver collect all his routes$")
    @Override
    public void apiDriverCollectAllHisRoutes()
    {
        super.apiDriverCollectAllHisRoutes();
    }

    @Given("^API Driver get pickup/delivery waypoint of the created order$")
    @Override
    public void apiDriverGetPickupOrDeliveryWaypointOfTheCreatedOrder()
    {
        super.apiDriverGetPickupOrDeliveryWaypointOfTheCreatedOrder();
    }

    @Given("^API Driver failed the C2C/Return order pickup$")
    @Override
    public void apiDriverFailedTheC2cOrReturnOrderPickup()
    {
        super.apiDriverFailedTheC2cOrReturnOrderPickup();
    }

    @Given("^API Driver failed the delivery of the created parcel$")
    @Override
    public void apiDriverFailedTheDeliveryOfTheCreatedParcel()
    {
        super.apiDriverFailedTheDeliveryOfTheCreatedParcel();
    }

    @Given("^API Driver deliver the created parcel successfully$")
    @Override
    public void apiDriverDeliverTheCreatedParcelSuccessfully()
    {
        super.apiDriverDeliverTheCreatedParcelSuccessfully();
    }
}
