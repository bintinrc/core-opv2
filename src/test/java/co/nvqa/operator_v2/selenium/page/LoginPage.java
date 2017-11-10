package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.util.TestConstants;
import co.nvqa.operator_v2.util.TestUtils;
import org.hamcrest.Matchers;
import org.junit.Assert;
import org.openqa.selenium.*;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.LoadableComponent;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

/**
 *
 * @author Soewandi Wirjawan
 */
public class LoginPage extends LoadableComponent<LoginPage>
{
    private static final String GOOGLE_EXPECTED_URL_1 = "https://accounts.google.com/ServiceLogin";
    private static final String GOOGLE_EXPECTED_URL_2 = "https://accounts.google.com/signin/oauth/identifier";

    private final WebDriver webDriver;

    public LoginPage(WebDriver webDriver)
    {
        this.webDriver = webDriver;
        PageFactory.initElements(webDriver, this);
    }

    @Override
    protected void load()
    {
        webDriver.get(TestConstants.OPERATOR_PORTAL_URL);
    }

    @Override
    protected void isLoaded() throws Error
    {
        String url = webDriver.getCurrentUrl();
        Assert.assertThat("Default Operator Portal URL not loaded.", url, Matchers.containsString(TestConstants.OPERATOR_PORTAL_URL));
    }

    public void forceLogin(String operatorBearerToken)
    {
        System.out.println("[INFO] Force login by injecting cookies to browser.");

        try
        {
            String userCookie = URLEncoder.encode(TestConstants.OPERATOR_PORTAL_USER_COOKIE, "UTF-8");

            System.out.println("[INFO] Injecting cookies:");
            System.out.println("[INFO] ninja_access_token = "+operatorBearerToken);
            System.out.println("[INFO] user = "+userCookie);

            webDriver.manage().addCookie(new Cookie("ninja_access_token", operatorBearerToken, ".ninjavan.co", "/", null));
            webDriver.manage().addCookie(new Cookie("user", userCookie, ".ninjavan.co", "/", null));
            ((ChromeDriver) webDriver).executeScript("window.open()");
            String currentWindowHandle = webDriver.getWindowHandle();
            String newWindowHandle = null;

            for(String windowHandle : webDriver.getWindowHandles())
            {
                if(!windowHandle.equals(currentWindowHandle))
                {
                    newWindowHandle = windowHandle;
                    break;
                }
            }

            webDriver.close();
            webDriver.switchTo().window(newWindowHandle);
            webDriver.get(TestConstants.OPERATOR_PORTAL_URL);
        }
        catch(UnsupportedEncodingException ex)
        {
            throw new RuntimeException(ex);
        }
    }

    public void clickLoginButton()
    {
        webDriver.findElement(By.xpath("//button[@ng-click='ctrl.login()']")).click();
    }

    public void enterCredential(String username, String password)
    {
        final StringBuilder googlePageUrlSb = new StringBuilder();

        WebDriverWait webDriverWait = new WebDriverWait(webDriver, TestConstants.SELENIUM_DEFAULT_WEB_DRIVER_WAIT_TIMEOUT_IN_SECONDS);
        webDriverWait.until((WebDriver d) ->
        {
            String currentUrl = d.getCurrentUrl();
            googlePageUrlSb.setLength(0);
            googlePageUrlSb.append(currentUrl);
            boolean isExpectedUrlFound = currentUrl.startsWith(GOOGLE_EXPECTED_URL_1) || currentUrl.startsWith(GOOGLE_EXPECTED_URL_2);

            System.out.println("===== GOOGLE LOGIN PAGE =====");
            System.out.println("Current URL          : "+currentUrl);
            System.out.println("Expected URL 1       : "+GOOGLE_EXPECTED_URL_1);
            System.out.println("Expected URL 2       : "+GOOGLE_EXPECTED_URL_2);
            System.out.println("Is Expected URL Found: "+isExpectedUrlFound);
            System.out.println("=============================");

            return isExpectedUrlFound;
        });


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
        webDriver.findElement(By.xpath("//input[@id='Email'][@name='Email']")).sendKeys(username);
        TestUtils.pause10ms();

        webDriver.findElement(By.xpath("//input[@id='next'][@name='signIn']")).click();
        TestUtils.pause10ms();

        webDriver.findElement(By.xpath("//input[@id='Passwd'][@name='Passwd']")).sendKeys(password);
        TestUtils.pause10ms();

        webDriver.findElement(By.xpath("//input[@id='signIn'][@name='signIn']")).click();
        TestUtils.pause10ms();
    }

    public void enterCredentialWithMethod2(String username, String password)
    {
        webDriver.findElement(By.xpath("//input[@id='identifierId'][@name='identifier']")).sendKeys(username);
        TestUtils.pause100ms();

        webDriver.findElement(By.xpath("//div[@id='identifierNext']")).click();
        TestUtils.pause100ms();

        webDriver.findElement(By.xpath("//input[@name='password']")).sendKeys(password);
        TestUtils.pause100ms();

        webDriver.findElement(By.xpath("//div[@id='passwordNext']")).click();
        TestUtils.pause100ms();
    }

    public void checkForGoogleSimpleVerification(String location)
    {
        if(webDriver.findElements(By.xpath("//span[text()='Enter the city you usually sign in from']")).size() > 0)
        {
            WebElement enterCityButton = webDriver.findElement(By.xpath("//span[text()='Enter the city you usually sign in from']/../.."));
            enterCityButton.click();
            TestUtils.pause1s();

            String txtAnswerXpath = "//input[@id='answer' and @type='text']";
            TestUtils.waitUntilElementVisible(webDriver, By.xpath(txtAnswerXpath));
            WebElement txtAnswer = webDriver.findElement(By.xpath(txtAnswerXpath));
            txtAnswer.clear();
            txtAnswer.sendKeys(location);

            WebElement submitButton = webDriver.findElement(By.xpath("//input[@id='submit' and @type='submit']"));
            submitButton.click();
            TestUtils.pause1s();
        }
    }

    public void backToLoginPage()
    {
        TestUtils.pause1s();
        String url = webDriver.getCurrentUrl();
        Assert.assertThat("Default Operator Portal URL not loaded.", url, Matchers.containsString(TestConstants.OPERATOR_PORTAL_URL));
    }
}
