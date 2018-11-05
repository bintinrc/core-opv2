package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.selenium.page.GlobalSettingsPage;
import com.google.inject.Inject;
import cucumber.api.java.en.And;
import cucumber.runtime.java.guice.ScenarioScoped;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class GlobalSettingsSteps extends AbstractSteps
{
    private GlobalSettingsPage globalSettingsPage;

    @Inject
    public GlobalSettingsSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        globalSettingsPage = new GlobalSettingsPage(getWebDriver());
    }

    @And("^Operator set Weight Tolerance value to \"([^\"]*)\" on Global Settings page$")
    public void operatorSetWeightToleranceValueToOnGlobalSettingsPage(String weightTolerance)
    {
        globalSettingsPage.setWeightTolerance(weightTolerance);
    }

    @And("^Operator save Inbound settings on Global Settings page$")
    public void operatorSaveInboundSettingsOnGlobalSettingsPage()
    {
        globalSettingsPage.clickInboudSettingsUpdateButton();
    }
}
