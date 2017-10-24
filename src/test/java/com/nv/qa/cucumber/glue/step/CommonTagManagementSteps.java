package com.nv.qa.cucumber.glue.step;

import com.google.inject.Inject;
import com.nv.qa.api.client.operator_portal.OperatorPortalTagManagementClient;
import com.nv.qa.model.operator_portal.authentication.AuthRequest;
import com.nv.qa.support.APIEndpoint;
import com.nv.qa.support.ScenarioStorage;
import cucumber.api.java.en.Given;

import java.io.IOException;

/**
 * @author Daniel Joi Partogi Hutapea
 */
public class CommonTagManagementSteps extends AbstractSteps
{
    @Inject ScenarioStorage scenarioStorage;
    private OperatorPortalTagManagementClient operatorPortalTagManagementClient;


    @Inject
    public CommonTagManagementSteps(ScenarioManager scenarioManager)
    {
        super(scenarioManager);
    }

    @Override
    public void init()
    {
        try
        {
            AuthRequest operatorAuthRequest = new AuthRequest();
            operatorAuthRequest.setClientId(APIEndpoint.OPERATOR_V1_CLIENT_ID);
            operatorAuthRequest.setClientSecret(APIEndpoint.OPERATOR_V1_CLIENT_SECRET);

            operatorPortalTagManagementClient = new OperatorPortalTagManagementClient(APIEndpoint.API_BASE_URL, APIEndpoint.API_BASE_URL+"/auth/login?grant_type=client_credentials");
            operatorPortalTagManagementClient.login(operatorAuthRequest);
        }
        catch(Exception ex)
        {
            throw new RuntimeException(ex);
        }
    }

    @Given("^Operator V2 cleaning Tag Management by calling API endpoint directly$")
    public void createNewRoute() throws IOException
    {
        String tagName = TagManagementSteps.DEFAULT_TAG_NAME;

        try
        {
            operatorPortalTagManagementClient.deleteTag(tagName);
        }
        catch(Exception ex)
        {
            System.out.println(String.format("[WARN] An error occurred when trying to delete tag with name = '%s'. Error: %s", tagName, ex.getMessage()));
        }

        tagName = TagManagementSteps.EDITED_TAG_NAME;

        try
        {
            operatorPortalTagManagementClient.deleteTag(tagName);
        }
        catch(Exception ex)
        {
            System.out.println(String.format("[WARN] An error occurred when trying to delete tag with name = '%s'. Error: %s", tagName, ex.getMessage()));
        }
    }
}
