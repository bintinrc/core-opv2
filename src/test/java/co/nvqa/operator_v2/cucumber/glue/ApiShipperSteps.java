package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.util.TestConstants;
import com.google.inject.Inject;
import com.nv.qa.commons.cucumber.glue.StandardApiShipperSteps;
import com.nv.qa.commons.utils.StandardScenarioStorage;
import cucumber.api.DataTable;
import cucumber.api.java.en.Given;
import cucumber.runtime.java.guice.ScenarioScoped;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class ApiShipperSteps extends StandardApiShipperSteps<ScenarioManager>
{
    @Inject
    public ApiShipperSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage, TestConstants.SHIPPER_V2_CLIENT_ID, TestConstants.SHIPPER_V2_CLIENT_SECRET);
    }

    @Override
    public void init()
    {
    }

    @Given("^API Shipper create Order V2 Parcel using data below:$")
    @Override
    public void apiShipperCreateOrderV2ParcelUsingDataBelow(DataTable dataTable)
    {
        super.apiShipperCreateOrderV2ParcelUsingDataBelow(dataTable);
    }

    @Given("^API Shipper create multiple Order V2 Parcel using data below:$")
    @Override
    public void apiShipperCreateMultipleOrderV2ParcelUsingDataBelow(DataTable dataTable)
    {
        super.apiShipperCreateMultipleOrderV2ParcelUsingDataBelow(dataTable);
    }

    @Given("^API Shipper create multiple Order V2 Parcel with multiple template using data below:$")
    @Override
    public void apiShipperCreateMultipleOrderV2ParcelWithMultipleTemplateUsingDataBelow(DataTable dataTable)
    {
        super.apiShipperCreateMultipleOrderV2ParcelWithMultipleTemplateUsingDataBelow(dataTable);
    }
}
