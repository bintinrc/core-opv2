package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.GlobalSettingsPage;
import cucumber.api.java.en.And;
import cucumber.runtime.java.guice.ScenarioScoped;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class GlobalSettingsSteps extends AbstractSteps
{
    private GlobalSettingsPage globalSettingsPage;

    public GlobalSettingsSteps()
    {
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

    @And("^Operator set Weight Limit value to \"([^\"]*)\" on Global Settings page$")
    public void operatorSetWeightLimitValueToOnGlobalSettingsPage(String weightLimit)
    {
        globalSettingsPage.setWeightLimit(weightLimit);
    }

    @And("^Operator save wight limit settings on Global Settings page$")
    public void operatorSaveWeightLimitOnGlobalSettingsPage()
    {
        globalSettingsPage.clickWeightLimitUpdateButton();
    }
}
