package com.nv.qa.selenium.page.page;

import com.nv.qa.support.APIEndpoint;
import com.nv.qa.support.CommonUtil;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.ExpectedCondition;
import org.openqa.selenium.support.ui.LoadableComponent;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.Assert;

/**
 *
 * @author Soewandi Wirjawan
 */
public class LoginPage extends LoadableComponent<LoginPage> {

    private final WebDriver driver;

    public LoginPage(WebDriver driver) {
        this.driver = driver;
        PageFactory.initElements(driver, this);
    }

    @Override
    protected void load() {
        driver.get(APIEndpoint.OPERATOR_PORTAL_URL);
    }

    @Override
    protected void isLoaded() throws Error {
        String url = driver.getCurrentUrl();
        Assert.assertTrue(url.contains(APIEndpoint.OPERATOR_PORTAL_URL));
    }

    public void clickLoginButton() throws InterruptedException {
        driver.findElement(By.xpath("//button[@ng-click='ctrl.login()']")).click();
        (new WebDriverWait(driver, 10000)).until(new ExpectedCondition<Boolean>() {
            public Boolean apply(WebDriver d) {
                return d.getCurrentUrl().startsWith("https://accounts.google.com/ServiceLogin");
            }
        });
    }

    public void enterCredential(String username, String password) throws InterruptedException {
        driver.findElement(By.xpath("//input[@id='Email'][@name='Email']")).sendKeys(username);
        CommonUtil.pause10ms();

        driver.findElement(By.xpath("//input[@id='next'][@name='signIn']")).click();
        CommonUtil.pause10ms();

        driver.findElement(By.xpath("//input[@id='Passwd'][@name='Passwd']")).sendKeys(password);
        CommonUtil.pause10ms();

        driver.findElement(By.xpath("//input[@id='signIn'][@name='signIn']")).click();
        CommonUtil.pause10ms();
    }

    public void backToLoginPage() throws InterruptedException {
        CommonUtil.pause1s();
        String url = driver.getCurrentUrl();
        Assert.assertTrue(url.contains(APIEndpoint.OPERATOR_PORTAL_URL));
    }

}