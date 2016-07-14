package com.nv.qa.cucumber.glue.step;

import com.nv.qa.selenium.page.page.LoginPage;
import com.nv.qa.support.APIEndpoint;
import com.nv.qa.support.SeleniumSharedDriver;
import cucumber.api.java.After;
import cucumber.api.java.Before;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.openqa.selenium.Dimension;
import org.openqa.selenium.WebDriver;

/**
 *
 * @author Soewandi Wirjawan
 */
@ScenarioScoped
public class LoginStep {

    private WebDriver driver;
    private LoginPage loginPage;

    @Before
    public void setup() {
        driver = SeleniumSharedDriver.getInstance().getDriver();
        driver.manage().window().setSize(new Dimension(APIEndpoint.SELENIUM_WINDOW_WIDTH, APIEndpoint.SELENIUM_WINDOW_HEIGHT));
        loginPage = new LoginPage(driver);
    }

    @After
    public void teardown() {

    }

    @Given("^op is in op portal login page$")
    public void loginPage() {
        loginPage.get();
    }

    @When("^login button is clicked$")
    public void clickLoginButton() throws InterruptedException {
        loginPage.clickLoginButton();
    }

    @When("^login as \"([^\"]*)\" with password \"([^\"]*)\"$")
    public void enterCredential(String username, String password) throws InterruptedException {
        loginPage.enterCredential(username, password);
    }

    @Then("^op back in the login page$")
    public void backTologinPage() throws InterruptedException {
        loginPage.backToLoginPage();
    }

    @Then("^close browser$")
    public void closeBrowser() {
        SeleniumSharedDriver.getInstance().closeDriver();
    }

}