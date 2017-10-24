package com.nv.qa.cucumber.glue.step;

import com.nv.qa.api.client.operator_portal.OperatorPortalAuthenticationClient;
import com.nv.qa.constants.NvTimeZone;
import com.nv.qa.model.operator_portal.authentication.AuthRequest;
import com.nv.qa.model.operator_portal.authentication.AuthResponse;
import com.nv.qa.support.APIEndpoint;
import com.nv.qa.support.CommonUtil;
import com.nv.qa.support.ScenarioStorage;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;

import java.io.IOException;
import java.util.Map;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public abstract class AbstractSteps
{
    private ScenarioManager scenarioManager;

    public AbstractSteps(ScenarioManager scenarioManager)
    {
        this(scenarioManager, null);
    }

    public AbstractSteps(ScenarioManager scenarioManager, ScenarioStorage scenarioStorage)
    {
        this.scenarioManager = scenarioManager;

        if(scenarioStorage!=null)
        {
            this.scenarioManager.setCurrentScenarioStorage(scenarioStorage);
        }

        init();
    }

    public abstract void init();

    public String getOperatorApiBaseUrl()
    {
        return APIEndpoint.API_BASE_URL;
    }

    public String getOperatorAuthenticationUrl()
    {
        return APIEndpoint.API_BASE_URL+"/auth/login?grant_type=client_credentials";
    }

    public AuthResponse getOperatorAuthToken() throws IOException
    {
        ScenarioStorage scenarioStorage = getScenarioManager().getCurrentScenarioStorage();

        if(scenarioStorage==null)
        {
            throw new RuntimeException("ScenarioStorage not injected to ScenarioManager.");
        }

        AuthResponse operatorAuthResponse = scenarioStorage.get("operatorAuthResponse");

        if(operatorAuthResponse==null)
        {
            AuthRequest operatorAuthRequest = new AuthRequest();
            operatorAuthRequest.setClientId(APIEndpoint.OPERATOR_V1_CLIENT_ID);
            operatorAuthRequest.setClientSecret(APIEndpoint.OPERATOR_V1_CLIENT_SECRET);

            OperatorPortalAuthenticationClient operatorPortalRoutingClient = new OperatorPortalAuthenticationClient(APIEndpoint.API_BASE_URL, APIEndpoint.API_BASE_URL+"/auth/login?grant_type=client_credentials", null, NvTimeZone.ASIA_SINGAPORE);
            operatorAuthResponse = operatorPortalRoutingClient.login(operatorAuthRequest);
            scenarioStorage.put("operatorAuthResponse", operatorAuthResponse);
        }

        return operatorAuthResponse;
    }

    public void takesScreenshot()
    {
        final byte[] screenshot = ((TakesScreenshot) getDriver()).getScreenshotAs(OutputType.BYTES);
        scenarioManager.getCurrentScenario().embed(screenshot, "image/png");
    }

    public void reloadPage()
    {
        scenarioManager.getDriver().navigate().refresh();
    }

    public void writeToScenarioLog(String message)
    {
        scenarioManager.writeToScenarioLog(message);
    }

    public String replaceParam(String data, Map<String,String> mapOfDynamicVariable)
    {
        return CommonUtil.replaceParam(data, mapOfDynamicVariable);
    }

    public WebDriver getDriver()
    {
        return scenarioManager.getDriver();
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

    public ScenarioManager getScenarioManager()
    {
        return scenarioManager;
    }

    public ScenarioStorage getScenarioStorage()
    {
        return scenarioManager.getCurrentScenarioStorage();
    }
}
