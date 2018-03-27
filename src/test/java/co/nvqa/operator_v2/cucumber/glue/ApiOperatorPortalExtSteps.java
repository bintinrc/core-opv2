package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.cucumber.glue2.AbstractApiOperatorPortalSteps;
import co.nvqa.commons.utils.NvLogger;
import co.nvqa.commons.utils.StandardScenarioStorage;
import com.google.inject.Inject;
import cucumber.api.java.en.Given;
import cucumber.runtime.java.guice.ScenarioScoped;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class ApiOperatorPortalExtSteps extends AbstractApiOperatorPortalSteps<ScenarioManager>
{
    @Inject
    public ApiOperatorPortalExtSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
    }

    @Given("^Operator V2 cleaning Tag Management by calling API endpoint directly$")
    public void cleaningTagManagement()
    {
        String tagName = TagManagementSteps.DEFAULT_TAG_NAME;

        try
        {
            getRouteClient().deleteTag(tagName);
        }
        catch(RuntimeException ex)
        {
            NvLogger.warnf("An error occurred when trying to delete tag with name = '%s'. Error: %s", tagName, ex.getMessage());
        }

        tagName = TagManagementSteps.EDITED_TAG_NAME;

        try
        {
            getRouteClient().deleteTag(tagName);
        }
        catch(RuntimeException ex)
        {
            NvLogger.warnf("An error occurred when trying to delete tag with name = '%s'. Error: %s", tagName, ex.getMessage());
        }
    }
}
