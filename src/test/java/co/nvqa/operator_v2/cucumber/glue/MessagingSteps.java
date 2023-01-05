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
import org.assertj.core.api.Assertions;

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
    Assertions.assertThat(actual).as("Total count of selected drivers").isLessThan(expected);
    Assertions.assertThat(messagingPage.driverNames.size()).as("Count of shown drivers")
        .isEqualTo(actual);
  }

  @When("Count of selected drivers is greater than {int} on Messaging panel")
  public void checkTotalSelectedCountIsMoreThen(int expected) {
    String selectedCount = messagingPage.selectedCount.getText();
    int actual = Integer.parseInt(selectedCount.split(" ")[0]);
    Assertions.assertThat(actual).as("Total count of selected drivers").isGreaterThan(expected);
    Assertions.assertThat(messagingPage.hiddenCount.isDisplayed())
        .as("Count of hidden drivers is displayed").isTrue();
    int expectedHiddenCount = actual - 100;
    String hiddenCount = messagingPage.hiddenCount.getText();
    int actualHiddenCount = Integer.parseInt(hiddenCount.split(" ")[1]);
    Assertions.assertThat(actualHiddenCount).as("Count of hidden drivers")
        .isEqualTo(expectedHiddenCount);
    Assertions.assertThat(messagingPage.driverNames.size()).as("Count of shown drivers")
        .isEqualTo(100);
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
    Assertions.assertThat(uiDrivers.size())
        .as("Count of drivers found on UI is not the same as in DB").isEqualTo(dbDrivers.size());

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
