package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.util.ScenarioStorage;
import com.google.inject.Inject;
import com.nv.qa.api.client.operator_portal.OperatorPortalTagManagementClient;
import com.nv.qa.model.operator_portal.authentication.AuthResponse;
import cucumber.api.java.en.Given;
import cucumber.runtime.java.guice.ScenarioScoped;

import java.io.IOException;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class CommonTagManagementSteps extends AbstractSteps
{
    @Inject ScenarioStorage scenarioStorage;
    private OperatorPortalTagManagementClient operatorPortalTagManagementClient;


    @Inject
    public CommonTagManagementSteps(ScenarioManager scenarioManager, ScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        try
        {
            AuthResponse operatorAuthResponse = getOperatorAuthToken();
            operatorPortalTagManagementClient = new OperatorPortalTagManagementClient(getOperatorApiBaseUrl(), getOperatorAuthenticationUrl(), operatorAuthResponse.getAccessToken());
        }
        catch(Exception ex)
        {
            throw new RuntimeException(ex);
        }
    }

    @Given("^Operator V2 cleaning Tag Management by calling API endpoint directly$")
    public void cleaningTagManagement() throws IOException
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
