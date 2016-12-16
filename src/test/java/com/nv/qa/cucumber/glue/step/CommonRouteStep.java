package com.nv.qa.cucumber.glue.step;

import com.google.inject.Inject;
import com.nv.qa.api.client.operator_portal.OperatorPortalRoutingClient;
import com.nv.qa.model.operator_portal.authentication.AuthRequest;
import com.nv.qa.model.operator_portal.routing.CreateRouteRequest;
import com.nv.qa.model.operator_portal.routing.CreateRouteResponse;
import com.nv.qa.support.APIEndpoint;
import com.nv.qa.support.CommonUtil;
import com.nv.qa.support.JsonHelper;
import com.nv.qa.support.ScenarioStorage;
import cucumber.api.DataTable;
import cucumber.api.java.After;
import cucumber.api.java.en.Given;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * @author Daniel Joi Partogi Hutapea
 */
public class CommonRouteStep extends AbstractSteps
{
    private static final SimpleDateFormat CREATED_DATE_SDF = new SimpleDateFormat("EEE, d MMM yyyy HH:mm:ss Z");
    private static final SimpleDateFormat ROUTE_DATE_SDF = new SimpleDateFormat("yyyy-MM-dd 16:00:00");

    @Inject ScenarioStorage scenarioStorage;
    private OperatorPortalRoutingClient operatorPortalRoutingClient;


    @Inject
    public CommonRouteStep(CommonScenario commonScenario)
    {
        super(commonScenario);
    }

    @Override
    public void init()
    {
        try
        {
            AuthRequest operatorAuthRequest = new AuthRequest();
            operatorAuthRequest.setClientId(APIEndpoint.OPERATOR_V1_CLIENT_ID);
            operatorAuthRequest.setClientSecret(APIEndpoint.OPERATOR_V1_CLIENT_SECRET);

            operatorPortalRoutingClient = new OperatorPortalRoutingClient(APIEndpoint.API_BASE_URL, APIEndpoint.API_BASE_URL+"/auth/login?grant_type=client_credentials");
            operatorPortalRoutingClient.login(operatorAuthRequest);
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
                System.out.println("-----------------------------------------------------");
                System.out.println("DELETING ROUTE");
                System.out.println("Route : "+routeId);
                System.out.println("-----------------------------------------------------");

                operatorPortalRoutingClient.deleteRoute(routeId);
            }
            catch(Exception ex)
            {
                System.out.println("Fail deleting route. Trying to archive route.");
                System.out.println("-----------------------------------------------------");
                System.out.println("ARCHIVING ROUTE");
                System.out.println("Route : "+routeId);
                System.out.println("-----------------------------------------------------");

                operatorPortalRoutingClient.archiveRoute(routeId);
            }
        }
    }

    @Given("^Operator V1 create new route using data below:$")
    public void createNewRoute(DataTable dataTable) throws IOException
    {
        Calendar currentCalendar = Calendar.getInstance();
        currentCalendar.add(Calendar.DATE, -1);

        Map<String,String> mapOfDynamicVariable = new HashMap();
        mapOfDynamicVariable.put("created_date", CREATED_DATE_SDF.format(new Date()));
        mapOfDynamicVariable.put("formatted_route_date", ROUTE_DATE_SDF.format(currentCalendar.getTime()));

        Map<String,String> mapOfData = dataTable.asMap(String.class, String.class);
        String createRouteRequestJson = CommonUtil.replaceParam(mapOfData.get("createRouteRequest"), mapOfDynamicVariable);

        CreateRouteRequest createRouteRequest = JsonHelper.fromJson(createRouteRequestJson, CreateRouteRequest.class);
        CreateRouteResponse createRouteResponse = operatorPortalRoutingClient.createRoute(createRouteRequest);
        scenarioStorage.put("createRouteResponse", createRouteResponse);
    }

    @Given("^Operator V1 set route tags \\[([^\\\"]*)\\]$")
    public void setRouteTags(String strTagIds)
    {
        int[] tagIds;
        CreateRouteResponse createRouteResponse = scenarioStorage.get("createRouteResponse");

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

        operatorPortalRoutingClient.setRouteTags(createRouteResponse.getId(), tagIds);
    }
}
