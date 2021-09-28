package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Driver;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.page.MessagingPage;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.guice.ScenarioScoped;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.hamcrest.Matchers;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class MessagingSteps extends AbstractSteps {

  private MessagingPage messagingPage;

  public MessagingSteps() {
  }

  @Override
  public void init() {
    messagingPage = new MessagingPage(getWebDriver());
  }

  @When("Operator opens Messaging panel")
  public void openSmsPanel() {
    if (!messagingPage.smsButton.getAttribute("class").contains("active")) {
      messagingPage.smsButton.click();
    }
    messagingPage.addDriver.waitUntilClickable();
  }

  @When("Operator enters {string} into Add Driver field on Messaging panel")
  public void enterDriverName(String driverName) {
    messagingPage.addDriver.inputElement.sendKeys(driverName);
    pause2s();
  }

  @When("Operator selects {string} drivers group on Messaging panel")
  public void selectDriversGroup(String driverTypeName) {
    messagingPage.addGroup.selectValue(driverTypeName);
    pause2s();
  }

  @When("Count of selected drivers is less than {int} on Messaging panel")
  public void checkTotalSelectedCountIsLessThen(int expected) {
    String selectedCount = messagingPage.selectedCount.getText();
    int actual = Integer.parseInt(selectedCount.split(" ")[0]);
    assertThat("Total count of selected drivers", actual, Matchers.lessThan(expected));
    assertEquals("Count of shown drivers", actual, messagingPage.driverNames.size());
  }

  @When("Count of selected drivers is greater than {int} on Messaging panel")
  public void checkTotalSelectedCountIsMoreThen(int expected) {
    String selectedCount = messagingPage.selectedCount.getText();
    int actual = Integer.parseInt(selectedCount.split(" ")[0]);
    assertThat("Total count of selected drivers", actual, Matchers.greaterThan(expected));
    assertTrue("Count of hidden drivers is displayed", messagingPage.hiddenCount.isDisplayed());
    int expectedHiddenCount = actual - 100;
    String hiddenCount = messagingPage.hiddenCount.getText();
    int actualHiddenCount = Integer.parseInt(hiddenCount.split(" ")[1]);
    assertEquals("Count of hidden drivers", expectedHiddenCount, actualHiddenCount);
    assertEquals("Count of shown drivers", 100, messagingPage.driverNames.size());
  }

  @When("All selected drivers belongs to selected group")
  public void checkDriversByDriverType() {
    List<Driver> dbDrivers = get(KEY_DB_FOUND_DRIVERS);
    if (CollectionUtils.isEmpty(dbDrivers)) {
      throw new IllegalArgumentException("No drivers found in DB");
    }
    List<String> uiDrivers = messagingPage.driverNames.stream().map(PageElement::getNormalizedText)
        .collect(Collectors.toList());
    if (CollectionUtils.isEmpty(uiDrivers)) {
      throw new IllegalArgumentException("No drivers found on UI");
    }

    uiDrivers.forEach(uiDriver ->
        dbDrivers.stream()
            .filter(dbDriver -> Objects.equals(uiDriver,
                StringUtils.trimToEmpty(dbDriver.getFirstName()) + StringUtils
                    .trimToEmpty(dbDriver.getLastName())))
            .findFirst()
            .orElseThrow(() -> new AssertionError(
                "Driver " + uiDriver + " was not found in DB selection result"))
    );
  }

  @Then("Drivers found on Messaging panel and in DB are the same")
  public void compareUiAndDbFirstNameSearchResults() {
    List<Driver> dbDrivers = get(KEY_DB_FOUND_DRIVERS);
    if (CollectionUtils.isEmpty(dbDrivers)) {
      throw new IllegalArgumentException("No drivers found in DB");
    }
    List<String> uiDrivers = messagingPage.addDriver.getOptions();
    if (CollectionUtils.isEmpty(uiDrivers)) {
      throw new IllegalArgumentException("No drivers found on UI");
    }
    assertEquals("Count of drivers found on UI is not the same as in DB", dbDrivers.size(),
        uiDrivers.size());

    dbDrivers.forEach(dbDriver ->
        uiDrivers.stream()
            .filter(uiDriver -> Objects.equals(uiDriver,
                StringUtils.trimToEmpty(dbDriver.getFirstName()) + StringUtils
                    .trimToEmpty(dbDriver.getLastName())))
            .findFirst()
            .orElseThrow(() -> new AssertionError(
                "Driver with first name " + dbDriver.getFirstName() + " was not found on UI"))
    );
  }

}
