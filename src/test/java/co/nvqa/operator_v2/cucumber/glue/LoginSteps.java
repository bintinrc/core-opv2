package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.LoginPage;
import com.google.inject.Inject;
import com.nv.qa.commons.utils.StandardScenarioStorage;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

/**
 *
 * @author Soewandi Wirjawan
 */
@ScenarioScoped
public class LoginSteps extends AbstractSteps
{
    private LoginPage loginPage;

    @Inject
    public LoginSteps(ScenarioManager scenarioManager, StandardScenarioStorage scenarioStorage)
    {
        super(scenarioManager, scenarioStorage);
    }

    @Override
    public void init()
    {
        loginPage = new LoginPage(getWebDriver());
    }

    @Given("^op is in op portal login page$")
    public void loginPage()
    {
        loginPage.get();
    }

    @When("^login button is clicked$")
    public void clickLoginButton() throws InterruptedException
    {
        loginPage.clickLoginButton();
    }

    @When("^login as \"([^\"]*)\" with password \"([^\"]*)\"$")
    public void enterCredential(String username, String password) throws InterruptedException
    {
        loginPage.enterCredential(username, password);
    }

    @Then("^op back in the login page$")
    public void backTologinPage() throws InterruptedException
    {
        loginPage.backToLoginPage();
    }
}
