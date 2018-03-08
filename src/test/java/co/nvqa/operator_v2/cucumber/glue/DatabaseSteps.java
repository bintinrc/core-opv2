package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.cucumber.glue.StandardDatabaseSteps;
import co.nvqa.commons.utils.StandardScenarioStorage;
import com.google.inject.Inject;
import cucumber.api.java.After;
import cucumber.api.java.en.Given;
import cucumber.runtime.java.guice.ScenarioScoped;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class DatabaseSteps extends StandardDatabaseSteps<ScenarioManager>
{
    @Inject
    public DatabaseSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
    }

    @After("@ArchiveRouteViaDb")
    public void dbOperatorArchiveRoute()
    {
        super.dbOperatorArchiveRoute();
    }

    @Given("^DB Operator set overstay date of DP order to current date$")
    @Override
    public void dbOperatorSetOverstayDateOfDpOrderToCurrentDate()
    {
        super.dbOperatorSetOverstayDateOfDpOrderToCurrentDate();
    }

    @Given("^DB Operator verify order is lodged in successfully$")
    @Override
    public void dbOperatorVerifyOrderIsLodgedInSuccessfully()
    {
        super.dbOperatorVerifyOrderIsLodgedInSuccessfully();
    }

    @Given("^DB Operator verify Return order is created successfully$")
    @Override
    public void dbOperatorVerifyReturnOrderIsCreatedSuccessfully()
    {
        super.dbOperatorVerifyReturnOrderIsCreatedSuccessfully();
    }

    @Given("^DB Operator verify order is dropped off successfully$")
    @Override
    public void dbOperatorVerifyOrderIsDroppedOffSuccessfully()
    {
        super.dbOperatorVerifyOrderIsDroppedOffSuccessfully();
    }

    @Given("^DB Operator verify DP order is picked up successfully by customer$")
    @Override
    public void dbOperatorVerifyDpOrderIsPickedUpSuccessfullyByCustomer()
    {
        super.dbOperatorVerifyDpOrderIsPickedUpSuccessfullyByCustomer();
    }

    @Given("^DB Operator get DP order SMS code from database$")
    @Override
    public void dbOperatorGetDpOrderSmsCodeFromDatabase()
    {
        super.dbOperatorGetDpOrderSmsCodeFromDatabase();
    }

    @Given("^DB Operator verify the new DP order SMS code is generated and should be different from the old one$")
    @Override
    public void dbOperatorVerifyTheNewDpOrderSmsCodeIsGeneratedAndShouldBeDifferentFromTheOldOne()
    {
        super.dbOperatorVerifyTheNewDpOrderSmsCodeIsGeneratedAndShouldBeDifferentFromTheOldOne();
    }

    @Given("^DB Operator find Waypoint ID and One-Time Password of an order from database$")
    @Override
    public void dbOperatorFindWaypointIdAndOneTimePasswordOfAnOrderFromDatabase()
    {
        super.dbOperatorFindWaypointIdAndOneTimePasswordOfAnOrderFromDatabase();
    }

    @Given("^DB Operator soft delete shipper by Legacy ID$")
    @Override
    public void dbOperatorSoftDeleteShipperWithLegacyId()
    {
        super.dbOperatorSoftDeleteShipperWithLegacyId();
    }
}
