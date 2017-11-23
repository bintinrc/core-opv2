package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.util.ScenarioStorage;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.inject.Inject;
import com.nv.qa.api.client.operator_portal.OperatorPortalRoutingClient;
import com.nv.qa.commons.constants.NvTimeZone;
import com.nv.qa.model.operator_portal.authentication.AuthResponse;
import com.nv.qa.model.operator_portal.routing.CreateRouteRequest;
import com.nv.qa.model.operator_portal.routing.CreateRouteResponse;
import com.nv.qa.commons.support.JsonHelper;
import com.nv.qa.commons.utils.NvLogger;
import cucumber.api.DataTable;
import cucumber.api.java.After;
import cucumber.api.java.en.Given;
import cucumber.runtime.java.guice.ScenarioScoped;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class CommonRouteSteps extends AbstractSteps
{
    private static final SimpleDateFormat CREATED_DATE_SDF = new SimpleDateFormat("EEE, d MMM yyyy HH:mm:ss Z");
    private static final SimpleDateFormat ROUTE_DATE_SDF = new SimpleDateFormat("yyyy-MM-dd 16:00:00");

    @Inject ScenarioStorage scenarioStorage;
    private OperatorPortalRoutingClient operatorPortalRoutingClient;


    @Inject
    public CommonRouteSteps(ScenarioManager scenarioManager, ScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        try
        {
            AuthResponse operatorAuthResponse = getOperatorAuthToken();
            operatorPortalRoutingClient = new OperatorPortalRoutingClient(getOperatorApiBaseUrl(), getOperatorAuthenticationUrl(), operatorAuthResponse.getAccessToken(), NvTimeZone.ASIA_SINGAPORE);
        }
        catch(Exception ex)
        {
            throw new RuntimeException(ex);
        }
    }

    @After("@ArchiveRoute")
    public void archiveRoute() throws IOException
    {
        boolean routeDeleted = false;

        if(scenarioStorage.containsKey("routeDeleted"))
        {
            routeDeleted = scenarioStorage.get("routeDeleted");
        }

        if(routeDeleted)
        {
            return;
        }

        CreateRouteResponse createRouteResponse = scenarioStorage.get("createRouteResponse");
        int routeId = -1;

        if(createRouteResponse!=null)
        {
            routeId = createRouteResponse.getId();
        }

        if(routeId!=-1)
        {
            try
            {
                NvLogger.info("=====================================================");
                NvLogger.info("DELETING ROUTE");
                NvLogger.info("Route : "+routeId);
                NvLogger.info("=====================================================");
                operatorPortalRoutingClient.deleteRoute(routeId);
            }
            catch(Exception ex)
            {
                NvLogger.warn("Fail deleting route. Trying to archive route.");
                NvLogger.warn("=====================================================");
                NvLogger.warn("ARCHIVING ROUTE");
                NvLogger.warn("Route : "+routeId);
                NvLogger.warn("=====================================================");
                operatorPortalRoutingClient.archiveRoute(routeId);
            }
        }
    }

    @Given("^Operator create new route using data below:$")
    public void createNewRoute(DataTable dataTable) throws IOException
    {
        Calendar currentCalendar = Calendar.getInstance();
        currentCalendar.add(Calendar.DATE, -1);

        Map<String,String> mapOfDynamicVariable = new HashMap<>();
        mapOfDynamicVariable.put("created_date", CREATED_DATE_SDF.format(new Date()));
        mapOfDynamicVariable.put("formatted_route_date", ROUTE_DATE_SDF.format(currentCalendar.getTime()));

        Map<String,String> mapOfData = dataTable.asMap(String.class, String.class);
        String createRouteRequestJson = TestUtils.replaceParam(mapOfData.get("createRouteRequest"), mapOfDynamicVariable);

        CreateRouteRequest createRouteRequest = JsonHelper.fromJson(createRouteRequestJson, CreateRouteRequest.class);
        CreateRouteResponse createRouteResponse = operatorPortalRoutingClient.createRoute(createRouteRequest);
        int routeId = createRouteResponse.getId();
        scenarioStorage.put(KEY_CREATED_ROUTE, createRouteResponse);
        scenarioStorage.put(KEY_CREATED_ROUTE_ID, routeId);
    }

    @Given("^Operator set route tags \\[([^\"]*)]$")
    public void setRouteTags(String strTagIds)
    {
        int[] tagIds;
        int routeId = scenarioStorage.get(KEY_CREATED_ROUTE_ID);

        try
        {
            String[] tagIdsInString = strTagIds.split(",");
            tagIds = new int[tagIdsInString.length];

            for(int i=0; i<tagIdsInString.length; i++)
            {
                tagIds[i] = Integer.parseInt(tagIdsInString[i]);
            }
        }
        catch (Exception ex)
        {
            throw new RuntimeException("Failed to parsing tag ids.");
        }

        operatorPortalRoutingClient.setRouteTags(routeId, tagIds);
        pause1s();
    }
}
