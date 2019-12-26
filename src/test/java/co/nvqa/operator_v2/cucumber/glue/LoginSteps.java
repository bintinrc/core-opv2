package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.cucumber.glue.StandardApiOperatorPortalSteps;
import co.nvqa.operator_v2.selenium.page.LoginPage;
import co.nvqa.operator_v2.selenium.page.MainPage;
import co.nvqa.operator_v2.util.TestConstants;
import cucumber.runtime.java.guice.ScenarioScoped;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;

import javax.inject.Inject;
import javax.inject.Provider;

/**
 * @author Soewandi Wirjawan
 */
@ScenarioScoped
public class LoginSteps extends AbstractSteps
{
    @Inject
    private Provider<StandardApiOperatorPortalSteps> providerOfStandardApiOperatorPortalSteps;
    private LoginPage loginPage;
    private MainPage mainPage;

    public LoginSteps()
    {
    }

    @Override
    public void init()
    {
        loginPage = new LoginPage(getWebDriver());
        mainPage = new MainPage(getWebDriver());
    }

    @Given("^Operator login with username = \"([^\"]*)\" and password = \"([^\"]*)\"$")
    public void loginToOperatorV2(String username, String password)
    {
        loginPage.loadPage();

        if (TestConstants.OPERATOR_PORTAL_FORCE_LOGIN_BY_INJECTING_COOKIES)
        {
            String operatorAccessToken = providerOfStandardApiOperatorPortalSteps.get().getOperatorAccessToken();
            loginPage.forceLogin(operatorAccessToken);
        } else
        {
            loginPage.clickLoginButton();
            loginPage.enterCredential(username, password);
            //loginPage.checkForGoogleSimpleVerification("Singapore");
        }

        mainPage.verifyTheMainPageIsLoaded();
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
