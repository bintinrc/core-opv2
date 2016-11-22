package com.nv.qa.cucumber.glue.step;

import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
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

    public void takesScreenshot()
    {
        final byte[] screenshot = ((TakesScreenshot) getDriver()).getScreenshotAs(OutputType.BYTES);
        commonScenario.getCurrentScenario().embed(screenshot, "image/png");
    }

    public WebDriver getDriver()
    {
        return commonScenario.getDriver();
    }
}
