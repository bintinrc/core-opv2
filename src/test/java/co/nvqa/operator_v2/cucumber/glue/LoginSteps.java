package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commonauth.utils.TokenUtils;
import co.nvqa.operator_v2.selenium.page.LoginPage;
import co.nvqa.operator_v2.selenium.page.MainPage;
import co.nvqa.operator_v2.selenium.page.ProfilePage;
import co.nvqa.operator_v2.util.TestConstants;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;

/**
 * @author Soewandi Wirjawan
 */
@ScenarioScoped
public class LoginSteps extends AbstractSteps {

  private LoginPage loginPage;
  private MainPage mainPage;
  private ProfilePage profilePage;
  private static final String COUNTRY = "country";

  public LoginSteps() {
  }

  @Override
  public void init() {
    loginPage = new LoginPage(getWebDriver());
    mainPage = new MainPage(getWebDriver());
    profilePage = new ProfilePage(getWebDriver());
  }

  @Given("^Operator is in Operator Portal V2 login page$")
  public void loginPage() {
    loginPage.loadPage();
  }

  @When("^Operator click login button$")
  public void clickLoginButton() {
    loginPage.clickLoginButton();
  }

  @Then("^Operator back in the login page$")
  public void backTologinPage() {
    loginPage.backToLoginPage();
  }

  @When("Operator change the country to {string}")
  public void operatorChangeTheCountryTo(String countryName) {
    profilePage.clickProfileButton();
    profilePage.changeCountry(countryName);
    put(COUNTRY, countryName);
 /*   Note: Update contry code and API base URL when we change country name
    also change timezone if needed
    This is global change, and impacting to all APIs
    Son Ha
  */
    switch (countryName) {
      case "Singapore":
        TestConstants.NV_SYSTEM_ID = "sg";
        break;
      case "Indonesia":
        TestConstants.NV_SYSTEM_ID = "id";
        break;
      case "Thailand":
        TestConstants.NV_SYSTEM_ID = "th";
        break;
      case "Vietnam":
        TestConstants.NV_SYSTEM_ID = "vn";
        break;
      case "Malaysia":
        TestConstants.NV_SYSTEM_ID = "my";
        break;
      case "Philippines":
        TestConstants.NV_SYSTEM_ID = "ph";
        break;
    }
    TestConstants.API_BASE_URL =
        TestConstants.API_BASE_URL.substring(0, TestConstants.API_BASE_URL.length() - 2)
            + TestConstants.NV_SYSTEM_ID;
  }

  @Given("^Operator login with username = \"([^\"]*)\" and password = \"([^\"]*)\"$")
  public void loginToOperatorV2(String username, String password) {
    loginPage.loadPage();

    if (TestConstants.OPERATOR_PORTAL_FORCE_LOGIN_BY_INJECTING_COOKIES) {
      loginPage.forceLogin(TokenUtils.getOperatorAuthToken());
    } else {
      loginPage.clickLoginButton();
    }

    mainPage.verifyTheMainPageIsLoaded();
  }

  @Given("Operator login with client id = {string} and client secret = {string}")
  public void operatorLoginWithClientIdAndClientSecret(String clientId, String clientSecret) {
    loginPage.loadPage();
    TokenUtils.overrideOperatorAuthToken(clientId, clientSecret);
    loginPage.forceLogin(TokenUtils.getOperatorAuthToken());
  }
}
