package com.nv.qa.cucumber.glue.step;

import org.openqa.selenium.WebDriver;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public abstract class AbstractSteps
{
    private CommonScenario commonScenario;

    public AbstractSteps(CommonScenario commonScenario)
    {
        this.commonScenario = commonScenario;
        init();
    }

    public abstract void init();

    public WebDriver getDriver()
    {
        return commonScenario.getDriver();
    }
}
