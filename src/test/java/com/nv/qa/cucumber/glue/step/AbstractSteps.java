package com.nv.qa.cucumber.glue.step;

import com.nv.qa.support.CommonUtil;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;

import java.util.Map;

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

    public String replaceParam(String data, Map<String,String> mapOfDynamicVariable)
    {
        return CommonUtil.replaceParam(data, mapOfDynamicVariable);
    }

    public WebDriver getDriver()
    {
        return commonScenario.getDriver();
    }

    public void pause50ms()
    {
        pause(50);
    }

    public void pause100ms()
    {
        pause(100);
    }

    public void pause200ms()
    {
        pause(200);
    }

    public void pause300ms()
    {
        pause(300);
    }

    public void pause400ms()
    {
        pause(400);
    }

    public void pause500ms()
    {
        pause(500);
    }

    public void pause1s()
    {
        pause(1_000);
    }

    public void pause2s()
    {
        pause(2_000);
    }

    public void pause3s()
    {
        pause(3_000);
    }

    public void pause4s()
    {
        pause(4_000);
    }

    public void pause5s()
    {
        pause(5_000);
    }

    public void pause10s()
    {
        pause(10_000);
    }

    public void pause(long millis)
    {
        try
        {
            Thread.sleep(millis);
        }
        catch(InterruptedException ex)
        {
            ex.printStackTrace();
        }
    }
}
