package com.nv.qa.selenium.page;

import com.nv.qa.support.APIEndpoint;
import com.nv.qa.support.CommonUtil;
import com.nv.qa.support.SeleniumHelper;
import org.hamcrest.Matchers;
import org.junit.Assert;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.LoadableComponent;
import org.openqa.selenium.support.ui.WebDriverWait;

/**
 *
 * @author Soewandi Wirjawan
 */
public class LoginPage extends LoadableComponent<LoginPage>
{
    private static final String GOOGLE_EXPECTED_URL_1 = "https://accounts.google.com/ServiceLogin";
    private static final String GOOGLE_EXPECTED_URL_2 = "https://accounts.google.com/signin/oauth/identifier";

    private final WebDriver driver;

    public LoginPage(WebDriver driver)
    {
        this.driver = driver;
        PageFactory.initElements(driver, this);
    }

    @Override
    protected void load()
    {
        driver.get(APIEndpoint.OPERATOR_PORTAL_URL);
    }

    @Override
    protected void isLoaded() throws Error
    {
        String url = driver.getCurrentUrl();
        Assert.assertThat("Default Operator Portal URL not loaded.", url, Matchers.containsString(APIEndpoint.OPERATOR_PORTAL_URL));
    }

    public void clickLoginButton() throws InterruptedException
    {
        driver.findElement(By.xpath("//button[@ng-click='ctrl.login()']")).click();
    }

    public void enterCredential(String username, String password) throws InterruptedException
    {
        final StringBuilder googlePageUrlSb = new StringBuilder();

        WebDriverWait webDriverWait = new WebDriverWait(driver, APIEndpoint.SELENIUM_IMPLICIT_WAIT_TIMEOUT_SECONDS);
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

    public void enterCredentialWithMethod1(String username, String password) throws InterruptedException
    {
        driver.findElement(By.xpath("//input[@id='Email'][@name='Email']")).sendKeys(username);
        CommonUtil.pause10ms();

        driver.findElement(By.xpath("//input[@id='next'][@name='signIn']")).click();
        CommonUtil.pause10ms();

        driver.findElement(By.xpath("//input[@id='Passwd'][@name='Passwd']")).sendKeys(password);
        CommonUtil.pause10ms();

        driver.findElement(By.xpath("//input[@id='signIn'][@name='signIn']")).click();
        CommonUtil.pause10ms();
    }

    public void enterCredentialWithMethod2(String username, String password) throws InterruptedException
    {
        driver.findElement(By.xpath("//input[@id='identifierId'][@name='identifier']")).sendKeys(username);
        CommonUtil.pause100ms();

        driver.findElement(By.xpath("//div[@id='identifierNext']")).click();
        CommonUtil.pause100ms();

        driver.findElement(By.xpath("//input[@name='password']")).sendKeys(password);
        CommonUtil.pause100ms();

        driver.findElement(By.xpath("//div[@id='passwordNext']")).click();
        CommonUtil.pause100ms();
    }

    public void checkForGoogleSimpleVerification(String location)
    {
        if(driver.findElements(By.xpath("//span[text()='Enter the city you usually sign in from']")).size() > 0)
        {
            WebElement enterCityButton = driver.findElement(By.xpath("//span[text()='Enter the city you usually sign in from']/../.."));
            enterCityButton.click();
            CommonUtil.pause1s();

            String txtAnswerXpath = "//input[@id='answer' and @type='text']";
            SeleniumHelper.waitUntilElementVisible(driver, By.xpath(txtAnswerXpath));
            WebElement txtAnswer = driver.findElement(By.xpath(txtAnswerXpath));
            txtAnswer.clear();
            txtAnswer.sendKeys(location);

            WebElement submitButton = driver.findElement(By.xpath("//input[@id='submit' and @type='submit']"));
            submitButton.click();
            CommonUtil.pause1s();
        }
    }

    public void backToLoginPage() throws InterruptedException
    {
        CommonUtil.pause1s();
        String url = driver.getCurrentUrl();
        Assert.assertThat("Default Operator Portal URL not loaded.", url, Matchers.containsString(APIEndpoint.OPERATOR_PORTAL_URL));
    }
}
