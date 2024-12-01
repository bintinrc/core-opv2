package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.utils.NvSoftAssertions;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.page.BatchOrderPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.List;
import java.util.Map;
import org.assertj.core.api.Assertions;


/**
 * @author Sergey Mishanin
 */
@SuppressWarnings("unused")
@ScenarioScoped
public class BatchOrderSteps extends AbstractSteps {

  private BatchOrderPage batchOrdersPage;

  public BatchOrderSteps() {
  }

  @Override
  public void init() {
    batchOrdersPage = new BatchOrderPage(getWebDriver());
  }

  @When("Operator search for {value} batch on Batch Orders page")
  public void operatorSearchForCreatedBatchId(String batchId) {
    batchOrdersPage.inFrame(() -> {
      batchOrdersPage.batchId.setValue(batchId);
      batchOrdersPage.search.click();
    });
  }

  @When("Operator click rollback button on Batch Orders page")
  public void operatorClickRollback() {
    batchOrdersPage.inFrame(() -> {
      batchOrdersPage.rollback.click();
    });
  }

  @When("Operator rollback orders on Batch Orders page")
  public void rollbackOrders() {
    batchOrdersPage.inFrame(() -> {
      batchOrdersPage.rollback.click();
      batchOrdersPage.password.setValue("1234567890");
      batchOrdersPage.rollbackDialogButton.click();
    });
  }

  @When("Operator verifies orders info on Batch Orders page:")
  public void operatorVerifiesBatchOrders(List<Map<String, String>> dataMap) {
    batchOrdersPage.inFrame(() -> {
      List<Map<String, String>> data = resolveListOfMaps(dataMap);
      data = resolveListOfMaps(data);
      NvSoftAssertions softly = new NvSoftAssertions();
      List<Map<String, String>> finalData = data;
      data.forEach(map -> {
        if (map.containsKey("trackingId")) {
          softly.assertEquals(batchOrdersPage.getCellText(finalData.indexOf(map), "tracking-id"),
              map.get("trackingId"));
        }
        if (map.containsKey("type")) {
          softly.assertEquals(batchOrdersPage.getCellText(finalData.indexOf(map), "type"),
              map.get("type"));
        }
        if (map.containsKey("fromName")) {
          softly.assertEquals(batchOrdersPage.getCellText(finalData.indexOf(map), "from-name"),
              map.get("fromName"));
        }
        if (map.containsKey("fromAddress")) {
          softly.assertEquals(batchOrdersPage.getCellText(finalData.indexOf(map), "from-address"),
              map.get("fromAddress"));
        }
        if (map.containsKey("toName")) {
          softly.assertEquals(batchOrdersPage.getCellText(finalData.indexOf(map), "to-name"),
              map.get("toName"));
        }
        if (map.containsKey("toAddress")) {
          softly.assertEquals(batchOrdersPage.getCellText(finalData.indexOf(map), "to-address"),
              map.get("toAddress"));
        }
        if (map.containsKey("status")) {
          softly.assertEquals(batchOrdersPage.getCellText(finalData.indexOf(map), "to-status"),
              map.get("status"));
        }
        if (map.containsKey("granularStatus")) {
          softly.assertEquals(
              batchOrdersPage.getCellText(finalData.indexOf(map), "to-granular-status"),
              map.get("granularStatus"));
        }
        softly.assertAll();
      });
    });
  }


  @Then("Operator verifies that error toast {string} displayed")
  public void verifyErrorToast(String message, Map<String, String> data) {
    batchOrdersPage.inFrame(() -> {
      Map<String, String> finalData = resolveKeyValues(data);
      String xpath = "//div[@id='toast-container']//div[contains(text(), '%s')]";
      batchOrdersPage.waitUntilVisibilityOfElementLocated(
          f(xpath, message));
      String toast = new PageElement(getWebDriver(), f(xpath, message)).getText();
      Assertions.assertThat(toast).as("toast message")
          .isEqualTo(finalData.get("description"));
    });
  }

  @Then("Operator verifies that success toast {string} displayed")
  public void verifySuccessToast(String message) {
    batchOrdersPage.inFrame(() -> {
      batchOrdersPage.waitUntilVisibilityOfElementLocated(
          f("//div[@id='toast-container']//div[contains(text(), '%s')]", message));
    });
  }
}