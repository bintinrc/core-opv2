package com.nv.qa.cucumber.glue.step;

import com.nv.qa.selenium.page.MainPage;
import com.nv.qa.support.CommonUtil;
import com.nv.qa.support.SeleniumSharedDriver;
import cucumber.api.java.Before;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.openqa.selenium.WebDriver;

/**
 * Created by sw on 6/30/16.
 */
@ScenarioScoped
public class MainStep {

    private WebDriver driver;
    private MainPage mainPage;

    @Before
    public void setup() {
        driver = SeleniumSharedDriver.getInstance().getDriver();
        mainPage = new MainPage(driver);
    }

    @Given("^op click navigation ([^\"]*) in ([^\"]*)$")
    public void clickNavigation(String navTitle, String parentTitle) throws InterruptedException {
        mainPage.clickNavigation(parentTitle, navTitle);
        CommonUtil.pause1s();
    }

    @Then("^op is in main page$")
    public void dpAdm() throws InterruptedException {
        mainPage.dpAdm();
    }

    @Given("^op refresh page$")
    public void refreshPage() {
        mainPage.refreshPage();
    }

}