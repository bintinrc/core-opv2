package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.utils.StandardTestConstants;
import co.nvqa.commonauth.utils.TokenUtils;
import co.nvqa.operator_v2.selenium.page.MainPage;
import co.nvqa.operator_v2.util.TestConstants;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static co.nvqa.operator_v2.util.KeyConstants.KEY_LIST_OF_GENERATE_PHONE_NUM;

/**
 * @author Soewandi Wirjawan
 */
@ScenarioScoped
public class MainSteps extends AbstractSteps {

  private MainPage mainPage;
  private static final String SYSTEM_ID = StandardTestConstants.NV_SYSTEM_ID;
  private static final Logger LOGGER = LoggerFactory.getLogger(MainSteps.class);

  public MainSteps() {
  }

  @Override
  public void init() {
    mainPage = new MainPage(getWebDriver());
  }

  @Given("^Operator go to menu \"([^\"]*)\" -> \"([^\"]*)\"$")
  public void operatorGoToMenu(String parentMenuName, String childMenuName) {
    mainPage.clickNavigation(parentMenuName, childMenuName);
  }

  @Given("^Operator go to menu ([^\"]*) -> ([^\"]*)$")
  public void operatorGoToMenuWithoutQuote(String parentMenuName, String childMenuName) {
    operatorGoToMenu(parentMenuName, childMenuName);
    takesScreenshot();
  }
  
  @And("Ninja Point V3 User generate {int} random phone number")
  public void generateMultipleRandomPhoneNum(int total) {
    int limit = 0;
    String phoneNum = "";
    while (limit < total) {
      pause1s();
      if (SYSTEM_ID.equalsIgnoreCase("id")) {
        phoneNum = f("857%s", co.nvqa.common.utils.RandomUtil.randomNumbersString(7));
      } else if (SYSTEM_ID.equalsIgnoreCase("ph")) {
        phoneNum = f("564%s", co.nvqa.common.utils.RandomUtil.randomNumbersString(5));
      } else if (SYSTEM_ID.equalsIgnoreCase("th")) {
        phoneNum = f("224%s", co.nvqa.common.utils.RandomUtil.randomNumbersString(4));
      } else if (SYSTEM_ID.equalsIgnoreCase("my")) {
        phoneNum = f("883%s", co.nvqa.common.utils.RandomUtil.randomNumbersString(4));
      }
      pause1s();
      putInList(KEY_LIST_OF_GENERATE_PHONE_NUM, phoneNum);
      LOGGER.info(f("number generated: +%s%s",
          co.nvqa.common.utils.NvCountry.fromString(SYSTEM_ID).getCountryCallingCode(), phoneNum));
      limit++;
    }
  }

  @Given("^Operator go to this URL \"([^\"]*)\"$")
  public void operatorGoToThisUrl(String url) {
    mainPage.goToUrl(url);
  }

  @Then("^Operator verify he is in main page$")
  public void operatorVerifyHeIsInMainPage() {
    mainPage.verifyTheMainPageIsLoaded();
  }

  @Given("^Operator refresh page v1$")
  public void operatorRefreshPage_v1() {
    mainPage.refreshPage_v1();
  }

  @Given("^Operator refresh page$")
  public void operatorRefreshPage() {
    mainPage.refreshPage();
  }

  @Then("^Toast \"(.+)\" is displayed$")
  public void toastIsDisplayed(String message) {
    mainPage.waitUntilInvisibilityOfToast(message, true);
  }
}
