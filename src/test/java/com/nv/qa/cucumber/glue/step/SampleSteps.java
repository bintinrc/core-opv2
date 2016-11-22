package com.nv.qa.cucumber.glue.step;

import com.google.inject.Inject;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class SampleSteps extends AbstractSteps
{
    @Inject
    public SampleSteps(CommonScenario commonScenario)
    {
        super(commonScenario);
    }

    @Override
    public void init()
    {
    }

    @When("browser open \"([^\"]*)\"")
    public void browserOpen(String url)
    {
        getDriver().get(url);
    }
}
