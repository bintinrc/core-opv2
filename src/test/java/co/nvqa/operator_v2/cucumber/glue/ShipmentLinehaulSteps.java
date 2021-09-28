package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.support.JsonHelper;
import co.nvqa.operator_v2.model.Linehaul;
import co.nvqa.operator_v2.selenium.page.ShipmentLinehaulPage;
import co.nvqa.operator_v2.util.TestUtils;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.guice.ScenarioScoped;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;
import org.hamcrest.Matchers;
import org.openqa.selenium.WebElement;

/**
 * Modified by Daniel Joi Partogi Hutapea.
 *
 * @author Lanang Jati
 */
@ScenarioScoped
public class ShipmentLinehaulSteps extends AbstractSteps {

  private static final SimpleDateFormat CREATED_DATE_SDF = new SimpleDateFormat(
      "EEE, d MMM yyyy HH:mm:ss Z");

  private ShipmentLinehaulPage shipmentLinehaulPage;
  private Linehaul linehaul;
  private String linehaulId = "0";

  public ShipmentLinehaulSteps() {
  }

  @Override
  public void init() {
    shipmentLinehaulPage = new ShipmentLinehaulPage(getWebDriver());
  }

  @When("^op click create linehaul button$")
  public void createActionButtonClicked() {
    String url = getCurrentUrl();

    if (url.endsWith("entries")) {
      shipmentLinehaulPage.clickCreateLinehaul();
    } else {
      shipmentLinehaulPage.clickCreateLinehaulOnSchedule();
    }
  }

  @When("^op click delete linehaul button$")
  public void deleteButtonClicked() {
    shipmentLinehaulPage.search(linehaulId);
    List<Linehaul> list = shipmentLinehaulPage.grabListOfLinehaul();

    for (Linehaul item : list) {
      if (item.getId().equals(linehaulId)) {
        item.clickDeleteButton();
        break;
      }
    }
  }

  @When("^create new linehaul:$")
  public void createLinehaul(Map<String, String> arg1) {
    //shipmentLinehaulPage.clickCreateLinehaul();
    fillLinehaulForm(arg1);
    shipmentLinehaulPage.clickOnLabelCreate();
    shipmentLinehaulPage.clickCreateButton();

    WebElement toast = shipmentLinehaulPage.getToast();
    String toastMessage = toast.getText();
    assertTrue("Toast message does not contain: linehaul <LINEHAUL_ID> created",
        toastMessage.contains("Linehaul") && toastMessage.contains("created"));
    linehaulId = toast.getText().split(" ")[1];
    shipmentLinehaulPage.waitUntilInvisibilityOfToast("created", false);
  }

  @Then("^op wait until 'Linehaul Entries' tab on 'Linehaul Management' page is loaded$")
  public void waitUntilLinehaulEntriesTabIsLoaded() {
    shipmentLinehaulPage.waitUntilLinehaulEntriesIsLoaded();
  }

  @Then("^op wait until 'Linehaul Date' tab on 'Linehaul Management' page is loaded$")
  public void waitUntilLinehaulDateTabIsLoaded() {
    shipmentLinehaulPage.waitUntilLinehaulDateTabIsLoaded();
  }

  @Then("^linehaul exist$")
  public void linehaulExist() {
    shipmentLinehaulPage.clickTab("LINEHAUL ENTRIES");
    shipmentLinehaulPage.clickButtonLoadSelection();
    shipmentLinehaulPage.search(linehaulId);
    List<WebElement> list = shipmentLinehaulPage.grabListOfLinehaulId();
    boolean isExist = false;

    for (WebElement item : list) {
      String text = item.getText();

      if (text.contains(linehaulId)) {
        isExist = true;
        break;
      }
    }

    assertTrue("Linehaul does not exist.", isExist);
    pause3s();
  }

  @Given("^op click tab ([^\"]*)$")
  public void opClickTabLinehaul(String tabName) {
    shipmentLinehaulPage.clickTab(tabName);
  }

  @When("^op search linehaul with name ([^\"]*)$")
  public void op_search_linehaul(String linehaulName) {
    shipmentLinehaulPage.search(linehaulName);
  }

  @When("^op click edit action button$")
  public void editActionButtonClicked() {
    shipmentLinehaulPage.search(linehaulId);
    List<Linehaul> list = shipmentLinehaulPage.grabListOfLinehaul();

    for (Linehaul item : list) {
      if (item.getId().equals(linehaulId)) {
        item.clickEditButton();
        break;
      }
    }
  }

  @When("^edit linehaul with:$")
  public void edit_linehaul_with(Map<String, String> arg1) {
    fillLinehaulForm(arg1);
    shipmentLinehaulPage.clickOnLabelEdit();
    shipmentLinehaulPage.clickSaveChangesButton();
  }

  private void fillLinehaulForm(Map<String, String> arg1) {
    pause3s();
    linehaul = JsonHelper.mapToObject(arg1, Linehaul.class);
    linehaul.setComment(linehaul.getComment() + " " + CREATED_DATE_SDF.format(new Date()));
    shipmentLinehaulPage.fillLinehaulNameFT(linehaul.getName());
    shipmentLinehaulPage.fillCommentsFT(linehaul.getComment());
    shipmentLinehaulPage.fillHubs(linehaul.getHubs());
    shipmentLinehaulPage.chooseFrequency(linehaul.getFrequency());
    shipmentLinehaulPage.chooseWorkingDays(linehaul.getDays());
  }

  @Then("^linehaul deleted$")
  public void linehaulDeleted() {
    String msg = "Success delete Linehaul ID " + linehaulId;
    WebElement toast = shipmentLinehaulPage.getToast();

    if (toast == null) {
      fail("Cannot find toast message.");
    } else {
      assertThat(f("Toast message not contains: '%s'", msg), toast.getText(), containsString(msg));
      shipmentLinehaulPage.waitUntilInvisibilityOfToast("Success delete Linehaul ID", false);
    }
  }

  @Then("^linehaul edited$")
  public void linehaul_edited() {
    String msg = "Linehaul " + linehaulId + " updated";
    WebElement toast = shipmentLinehaulPage.getToast();

    if (toast == null) {
      fail("Cannot find toast message.");
    } else {
      assertThat(f("Toast message not contains: '%s'", msg), toast.getText(),
          Matchers.containsString(msg));
      shipmentLinehaulPage.waitUntilInvisibilityOfToast("updated");
    }

    shipmentLinehaulPage.clickTab("LINEHAUL DATE");
    linehaulExist();
    List<Linehaul> list = shipmentLinehaulPage.grabListOfLinehaul();

    for (Linehaul item : list) {
      if (item.getId().equals(linehaulId)) {
        assertEquals("Linehaul name", linehaul.getName(), item.getName());
        assertEquals("Linehaul frequency", linehaul.getFrequency().toLowerCase(),
            item.getFrequency().toLowerCase());
        break;
      }
    }
  }

  @Then("^Schedule is right$")
  public void scheduleIsRight() {
    shipmentLinehaulPage.clickTab("LINEHAUL DATE");
    List<Calendar> dates = new ArrayList<>();

    for (String day : linehaul.getDays()) {
      int dayNumber = TestUtils.dayToInteger(day);
      Calendar now = Calendar.getInstance();
      int todayNumber = now.get(Calendar.DAY_OF_WEEK);
      int diffToDayNumber = dayNumber - todayNumber;

      if (diffToDayNumber < 0) {
        diffToDayNumber += 7;
      }

      now.add(Calendar.DATE, diffToDayNumber);
      dates.add(now);
    }

    for (Calendar date : dates) {
      shipmentLinehaulPage.clickLinehaulScheduleDate(date);
      shipmentLinehaulPage.checkLinehaulAtDate(linehaulId);
    }
  }

  @When("^op click edit linehaul button on schedule$")
  public void op_click_edit_linehaul_button_on_schedule() {
    shipmentLinehaulPage.clickEditLinehaulAtDate(linehaulId);
  }

  @Given("^op click edit linehaul filter$")
  public void op_click_edit_filter() {
    shipmentLinehaulPage.clickEditSearchFilterButton();
    pause1s();
  }

  @When("^Operator click \"Load All Selection\" on Linehaul Management page$")
  public void operatorClickLoadAllSelectionOnLinehaulManagementPage() {
    shipmentLinehaulPage.clickButtonLoadSelection();
  }
}
