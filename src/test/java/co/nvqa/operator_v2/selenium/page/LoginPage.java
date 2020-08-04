package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.util.NvLogger;
import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.util.TestConstants;
import org.hamcrest.Matchers;
import org.openqa.selenium.Cookie;
import org.openqa.selenium.InvalidElementStateException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.List;

/**
 *
 * @author Soewandi Wirjawan
 */
@SuppressWarnings("WeakerAccess")
public class LoginPage extends OperatorV2SimplePage
{
    private static final String GOOGLE_EXPECTED_URL_1 = "https://accounts.google.com/ServiceLogin";
    private static final String GOOGLE_EXPECTED_URL_2 = "https://accounts.google.com/signin/oauth/identifier";

    public LoginPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void loadPage()
    {
        boolean loaded = false;
        do {
            try {
                getWebDriver().get(TestConstants.OPERATOR_PORTAL_LOGIN_URL);
                waitUntilPageLoaded();
                loaded = true;
            } catch (Exception ex){
                executeScript("window.open()");
                String currentWindowHandle = getWebDriver().getWindowHandle();
                String newWindowHandle = null;

                for(String windowHandle : getWebDriver().getWindowHandles())
                {
                    if(!windowHandle.equals(currentWindowHandle))
                    {
                        newWindowHandle = windowHandle;
                        break;
                    }
                }

                getWebDriver().close();
                getWebDriver().switchTo().window(newWindowHandle);
            }
        } while (!loaded);
    }

    public void forceLogin(String operatorBearerToken)
    {
        NvLogger.info("========== FORCE LOGIN BY INJECTING COOKIES TO BROWSER ==========");

        try
        {
            String userCookie = URLEncoder.encode(TestConstants.OPERATOR_PORTAL_USER_COOKIE, "UTF-8");
            NvLogger.info("ninja_access_token = "+operatorBearerToken);
            NvLogger.info("user = "+userCookie);

            getWebDriver().manage().addCookie(new Cookie("ninja_access_token", operatorBearerToken, TestConstants.OPERATOR_PORTAL_COOKIE_DOMAIN, "/", null));
            getWebDriver().manage().addCookie(new Cookie("user", userCookie, TestConstants.OPERATOR_PORTAL_COOKIE_DOMAIN, "/", null));
            executeScript("window.open()");
            String currentWindowHandle = getWebDriver().getWindowHandle();
            String newWindowHandle = null;

            for(String windowHandle : getWebDriver().getWindowHandles())
            {
                if(!windowHandle.equals(currentWindowHandle))
                {
                    newWindowHandle = windowHandle;
                    break;
                }
            }

            getWebDriver().close();
            getWebDriver().switchTo().window(newWindowHandle);
            getWebDriver().get(TestConstants.OPERATOR_PORTAL_LOGIN_URL);
        }
        catch(UnsupportedEncodingException ex)
        {
            throw new NvTestRuntimeException(ex);
        }
        finally
        {
            NvLogger.info("=================================================================");
        }
    }

    public void clickLoginButton()
    {
        click("//button[@ng-click='ctrl.login()']");
        waitUntilPageLoaded();
    }

    public void enterCredential(String username, String password)
    {
        final StringBuilder googlePageUrlSb = new StringBuilder();

        waitUntil(()->
        {
            String currentUrl = getCurrentUrl();
            googlePageUrlSb.setLength(0);
            googlePageUrlSb.append(currentUrl);
            boolean isExpectedUrlFound = currentUrl.startsWith(GOOGLE_EXPECTED_URL_1) || currentUrl.startsWith(GOOGLE_EXPECTED_URL_2);

            NvLogger.info("========== GOOGLE LOGIN PAGE ==========");
            NvLogger.info("Current URL          : "+currentUrl);
            NvLogger.info("Expected URL 1       : "+GOOGLE_EXPECTED_URL_1);
            NvLogger.info("Expected URL 2       : "+GOOGLE_EXPECTED_URL_2);
            NvLogger.info("Is Expected URL Found: "+isExpectedUrlFound);
            NvLogger.info("=======================================");

            return isExpectedUrlFound;
        }, TestConstants.SELENIUM_WEB_DRIVER_WAIT_TIMEOUT_IN_MILLISECONDS);


        String googlePageUrl = googlePageUrlSb.toString();

        if(googlePageUrl.startsWith(GOOGLE_EXPECTED_URL_1))
        {
            enterCredentialWithMethod1(username, password);
        }
        else if(googlePageUrl.startsWith(GOOGLE_EXPECTED_URL_2))
        {
            enterCredentialWithMethod2(username, password);
        }
    }

    public void enterCredentialWithMethod1(String username, String password)
    {
        sendKeys("//input[@id='Email'][@name='Email']", username);
        click("//input[@id='next'][@name='signIn']");
        sendKeys("//input[@id='Passwd'][@name='Passwd']", password);
        click("//input[@id='signIn'][@name='signIn']");
    }

    @SuppressWarnings("unchecked")
    public void enterCredentialWithMethod2(String username, String password)
    {
        sendKeys("//input[@id='identifierId'][@name='identifier']", username);
        click("//div[@id='identifierNext']");
        pause10ms();
        retryIfExpectedExceptionOccurred(()->sendKeys("//input[@name='password']", password), InvalidElementStateException.class);
        click("//div[@id='passwordNext']");
    }

    public void checkForGoogleSimpleVerification(String location)
    {
        List<WebElement> listOfWebElements = findElementsByXpath("//span[text()='Enter the city you usually sign in from']");

        if(!listOfWebElements.isEmpty())
        {
            click("//span[text()='Enter the city you usually sign in from']/../..");
            pause1s();

            WebElement txtAnswerWe = waitUntilVisibilityOfElementLocated("//input[@id='answer' and @type='text']");
            txtAnswerWe.clear();
            txtAnswerWe.sendKeys(location);

            click("//input[@id='submit' and @type='submit']");
            pause1s();
        }
    }

    public void backToLoginPage()
    {
        pause1s();
        String currentUrl = getCurrentUrl();
        assertThat("Default Operator Portal URL not loaded.", currentUrl, Matchers.containsString(TestConstants.OPERATOR_PORTAL_LOGIN_URL));
    }

    public void changeCountry(String countryName)
    {
        click("//button[contains(@ng-click,'$mdOpenMenu($event)') and @aria-label='Profile']");
        waitUntilVisibilityOfElementLocated("//md-select[@ng-model='domain.current']/md-select-value[contains(@id,'select_value_label')]");
        click("//md-select[@ng-model='domain.current']/md-select-value[contains(@id,'select_value_label')]");
        click(f("//md-option[contains(@ng-repeat,'domain.all')]//span[text()='%s']", countryName));
        getWebDriver().navigate().refresh();
        pause3s();
    }
}
