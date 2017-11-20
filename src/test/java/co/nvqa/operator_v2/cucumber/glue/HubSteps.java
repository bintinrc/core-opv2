package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.util.SingletonStorage;
import co.nvqa.operator_v2.util.TestConstants;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.inject.Inject;
import com.nv.qa.commons.support.*;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.junit.Assert;
import org.openqa.selenium.*;

import java.io.File;

/**
 *
 * @author Soewandi Wirjawan
 */
@ScenarioScoped
public class HubSteps extends AbstractSteps
{
    private static final int MAX_RETRY = 10;
    private static final String HUBS_CSV_FILE_NAME = "hubs.csv";
    private static final String HUBS_CSV_FILE_NAME_LOCATION = TestConstants.SELENIUM_WRITE_PATH + HUBS_CSV_FILE_NAME;

    @Inject
    public HubSteps(ScenarioManager scenarioManager)
    {
        super(scenarioManager);
    }

    @Override
    public void init()
    {
    }

    @When("^hubs administration download button is clicked$")
    public void download()
    {
        TestUtils.deleteFile(HUBS_CSV_FILE_NAME_LOCATION);
        TestUtils.clickBtn(getWebDriver(), String.format("//div[@filename='%s']/nv-api-text-button/button", HUBS_CSV_FILE_NAME));
        TestUtils.pause1s();
    }

    @Then("^hubs administration file should exist$")
    public void verifyFile()
    {
        File file = new File(HUBS_CSV_FILE_NAME_LOCATION);
        int counter = 0;
        boolean isFileExists;

        do
        {
            isFileExists = file.exists();

            if(!isFileExists)
            {
                TestUtils.pause1s();
            }

            counter++;
        }
        while(!isFileExists && counter<MAX_RETRY);

        TestUtils.deleteFile(file);
        Assert.assertTrue(HUBS_CSV_FILE_NAME_LOCATION + " not exist", isFileExists);
    }

    @When("^hubs administration add button is clicked$")
    public void addHub()
    {
        TestUtils.clickBtn(getWebDriver(), "//button[@aria-label='Add Hub']");
    }

    @When("^hubs administration enter default value$")
    public void defaultValue()
    {
        String tmpId = DateUtil.getCurrentTime_HH_MM_SS();
        SingletonStorage.getInstance().setTmpId(tmpId);

        TestUtils.inputText(getWebDriver(), "//input[@type='text' and @id='hub-name-1']", String.format("Hub %s", tmpId));
        TestUtils.inputText(getWebDriver(), "//input[@type='number' and @id='latitude-1']", "1.2843043");
        TestUtils.inputText(getWebDriver(), "//input[@type='number' and @id='longitude-2']", "103.8095597");
        TestUtils.clickBtn(getWebDriver(), "//button[@type='submit' and @aria-label='Save Button']");
    }

    @Then("^hubs administration verify result ([^\"]*)$")
    public void verify(String type)
    {
        String expectedValue = String.format("Hub %s", SingletonStorage.getInstance().getTmpId()) + " [EDITED]";

        if(type.equalsIgnoreCase("add"))
        {
            expectedValue = String.format("Hub %s", SingletonStorage.getInstance().getTmpId());
        }

        TestUtils.inputText(getWebDriver(), "//input[@placeholder='Search Hubs...']", expectedValue);
        TestUtils.pause1s();

        WebElement result = TestUtils.getResultInTable(getWebDriver(), "//table[@ng-table='ctrl.hubsTableParams']/tbody/tr", expectedValue);
        Assert.assertTrue(result != null);
    }

    @When("^hubs administration searching for hub$")
    public void searchHub()
    {
        TestUtils.inputText(getWebDriver(), "//input[@placeholder='Search Hubs...'][@ng-model='searchText']", String.format("Hub %s", SingletonStorage.getInstance().getTmpId()));

        String txt = String.format("Hub %s", SingletonStorage.getInstance().getTmpId());
        WebElement result = TestUtils.getResultInTable(getWebDriver(), "//table[@ng-table='ctrl.hubsTableParams']/tbody/tr", txt);
        Assert.assertTrue(result != null);
    }

    @When("^hubs administration edit button is clicked$")
    public void clickEditHub()
    {
        WebElement el = TestUtils.verifySearchingResults(getWebDriver(), "Search Hubs...", "ctrl.hubsTableParams");
        WebElement editBtn = el.findElement(By.xpath("//nv-icon-button[@name='Edit']"));
        TestUtils.pause100ms();
        TestUtils.moveAndClick(getWebDriver(), editBtn);

        String editValue = String.format("Hub %s", SingletonStorage.getInstance().getTmpId()) + " [EDITED]";
        TestUtils.inputText(getWebDriver(), "//input[@type='text'][@aria-label='Hub Name']", editValue);
        TestUtils.clickBtn(getWebDriver(), "//button[@type='submit'][@aria-label='Save Button']");
    }
}
