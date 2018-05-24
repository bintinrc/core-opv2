package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.cucumber.glue.AbstractDatabaseSteps;
import co.nvqa.commons.model.addressing.JaroScore;
import co.nvqa.commons.model.entity.RouteDriverTypeEntity;
import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.model.CreateRouteParams;
import co.nvqa.operator_v2.model.DriverTypeParams;
import com.google.inject.Inject;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.hamcrest.Matchers;
import org.junit.Assert;

import java.util.List;
import java.util.stream.Collectors;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class StandardDatabaseExtSteps extends AbstractDatabaseSteps<ScenarioManager>
{
    @Inject
    public StandardDatabaseExtSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
    }

    /**
     * Cucumber regex: ^DB Operator verify driver types of multiple routes is updated successfully$
     */
    @Given("^DB Operator verify driver types of multiple routes is updated successfully$")
    public void dbOperatorVerifyDriverTypesOfMultipleRoutesIsUpdatedSuccessfully()
    {
        List<CreateRouteParams> listOfCreateRouteParams = get(KEY_LIST_OF_CREATE_ROUTE_PARAMS);
        DriverTypeParams driverTypeParams = get(KEY_DRIVER_TYPE_PARAMS);

        Long driverTypeId = driverTypeParams.getDriverTypeId();

        for (CreateRouteParams createRouteParams : listOfCreateRouteParams)
        {
            long routeId = createRouteParams.getCreatedRoute().getId();
            List<RouteDriverTypeEntity> listOfRouteDriverTypeEntity = getRouteJdbc().findRouteDriverTypeByRouteIdAndNotDeleted(routeId);
            List<Long> listOfRouteDriverTypeId = listOfRouteDriverTypeEntity.stream().map(RouteDriverTypeEntity::getDriverTypeId).collect(Collectors.toList());
            Assert.assertThat(String.format("Route with ID = %d does not contain the expected Driver Type ID = %d", routeId, driverTypeId), listOfRouteDriverTypeId, Matchers.hasItem(driverTypeId));
        }
    }

    @Then("^Operator verify Jaro Scores are created successfully$")
    public void operatorVerifyJaroScoresAreCreatedSuccessfully()
    {
        List<JaroScore> jaroScores = get(KEY_LIST_OF_CREATED_JARO_SCORES);
        jaroScores.forEach(jaroScore -> {
            JaroScore actualJaroScore = getAddressingJdbc().getJaroScores(jaroScore.getWaypointId());
            Assert.assertEquals("Latitude", jaroScore.getLatitude(), actualJaroScore.getLatitude(), 0);
            Assert.assertEquals("Longitude", jaroScore.getLongitude(), actualJaroScore.getLongitude(), 0);
            Assert.assertEquals("Verified Address Id", jaroScore.getVerifiedAddressId(), actualJaroScore.getVerifiedAddressId());
        });
    }
}
