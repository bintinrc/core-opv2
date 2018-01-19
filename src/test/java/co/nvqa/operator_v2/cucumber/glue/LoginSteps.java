package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.utils.StandardScenarioStorage;
import co.nvqa.operator_v2.selenium.page.LoginPage;
import com.google.inject.Inject;
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

    @Given("^Operator is in Operator Portal V2 login page$")
    public void loginPage()
    {
        loginPage.loadPage();
    }

    @When("^Operator click login button$")
    public void clickLoginButton()
    {
        loginPage.clickLoginButton();
    }

    @When("^Operator login as \"([^\"]*)\" with password \"([^\"]*)\"$")
    public void enterCredential(String username, String password)
    {
        loginPage.enterCredential(username, password);
    }

    @Then("^Operator back in the login page$")
    public void backTologinPage()
    {
        loginPage.backToLoginPage();
    }
}
