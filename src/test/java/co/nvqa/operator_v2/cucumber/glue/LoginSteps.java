package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commonauth.utils.TokenUtils;
import co.nvqa.operator_v2.selenium.page.LoginPage;
import co.nvqa.operator_v2.selenium.page.MainPage;
import co.nvqa.operator_v2.selenium.page.ProfilePage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Given;

/**
 * @author Soewandi Wirjawan
 */
@ScenarioScoped
public class LoginSteps extends AbstractSteps {

  private LoginPage loginPage;
  private MainPage mainPage;
  private ProfilePage profilePage;

  public LoginSteps() {
  }

  @Override
  public void init() {
    loginPage = new LoginPage(getWebDriver());
    mainPage = new MainPage(getWebDriver());
    profilePage = new ProfilePage(getWebDriver());
  }

  @Given("Operator login with username = {string} and password = {string}")
  public void loginToOperatorV2(String username, String password) {
    loginPage.loadPage();
    loginPage.forceLogin(TokenUtils.getOperatorAuthToken());
    mainPage.verifyTheMainPageIsLoaded();
  }

}
