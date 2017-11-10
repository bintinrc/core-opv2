package co.nvqa.operator_v2.cucumber.glue.step;

import com.google.inject.Inject;
import co.nvqa.operator_v2.selenium.page.LoginPage;
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
    public LoginSteps(ScenarioManager scenarioManager)
    {
        super(scenarioManager);
    }

    @Override
    public void init()
    {
        loginPage = new LoginPage(getDriver());
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
