package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.util.ScenarioStorage;
import co.nvqa.operator_v2.util.ScenarioStorageKeys;
import co.nvqa.operator_v2.util.TestConstants;
import co.nvqa.operator_v2.util.TestUtils;
import com.nv.qa.api.client.operator_portal.OperatorPortalAuthenticationClient;
import com.nv.qa.commons.constants.NvTimeZone;
import com.nv.qa.integration.client.DriverClient;
import com.nv.qa.integration.model.auth.DriverLoginRequest;
import com.nv.qa.integration.model.auth.DriverLoginResponse;
import com.nv.qa.model.operator_portal.authentication.AuthRequest;
import com.nv.qa.model.operator_portal.authentication.AuthResponse;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;

import java.util.Map;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public abstract class AbstractSteps implements ScenarioStorageKeys
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
        return TestConstants.API_BASE_URL;
    }

    public String getOperatorAuthenticationUrl()
    {
        return TestConstants.API_BASE_URL+"/auth/login?grant_type=client_credentials";
    }

    public AuthResponse getOperatorAuthToken()
    {
        ScenarioStorage scenarioStorage = getScenarioStorage();
        AuthResponse operatorAuthResponse = scenarioStorage.get(KEY_OPERATOR_AUTH_RESPONSE);

        if(operatorAuthResponse==null)
        {
            operatorAuthResponse = operatorLogin();
            scenarioStorage.put(KEY_OPERATOR_AUTH_RESPONSE, operatorAuthResponse);
        }

        return operatorAuthResponse;
    }

    public AuthResponse operatorLogin()
    {
        AuthRequest operatorAuthRequest = new AuthRequest();
        operatorAuthRequest.setClientId(TestConstants.OPERATOR_V1_CLIENT_ID);
        operatorAuthRequest.setClientSecret(TestConstants.OPERATOR_V1_CLIENT_SECRET);

        OperatorPortalAuthenticationClient operatorPortalRoutingClient = new OperatorPortalAuthenticationClient(getOperatorApiBaseUrl(), getOperatorAuthenticationUrl(), null, NvTimeZone.ASIA_SINGAPORE);
        return operatorPortalRoutingClient.login(operatorAuthRequest);
    }

    public DriverLoginResponse getDriverAuthToken()
    {
        ScenarioStorage scenarioStorage = getScenarioStorage();
        DriverLoginResponse driverLoginResponse = scenarioStorage.get(KEY_DRIVER_LOGIN_RESPONSE);

        if(driverLoginResponse==null)
        {
            DriverLoginRequest driverLoginRequest = new DriverLoginRequest();
            driverLoginRequest.setUsername(TestConstants.NINJA_DRIVER_USERNAME);
            driverLoginRequest.setPassword(TestConstants.NINJA_DRIVER_PASSWORD);

            DriverClient driverClient = new DriverClient(TestConstants.API_BASE_URL);
            driverLoginResponse = driverClient.authenticate(driverLoginRequest);
        }

        return driverLoginResponse;
    }

    public void takesScreenshot()
    {
        final byte[] screenshot = ((TakesScreenshot) getWebDriver()).getScreenshotAs(OutputType.BYTES);
        scenarioManager.getCurrentScenario().embed(screenshot, "image/png");
    }

    public void reloadPage()
    {
        scenarioManager.getWebDriver().navigate().refresh();
    }

    public void writeToScenarioLog(String message)
    {
        scenarioManager.writeToScenarioLog(message);
    }

    public String replaceParam(String data, Map<String,String> mapOfDynamicVariable)
    {
        return TestUtils.replaceParam(data, mapOfDynamicVariable);
    }

    public WebDriver getWebDriver()
    {
        return scenarioManager.getWebDriver();
    }

    public void pause10ms()
    {
        pause(10);
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
        TestUtils.pause(millis);
    }

    public ScenarioManager getScenarioManager()
    {
        return scenarioManager;
    }

    public ScenarioStorage getScenarioStorage()
    {
        ScenarioStorage scenarioStorage = getScenarioManager().getCurrentScenarioStorage();

        if(scenarioStorage==null)
        {
            throw new RuntimeException("ScenarioStorage not injected to ScenarioManager.");
        }

        return scenarioStorage;
    }
}
