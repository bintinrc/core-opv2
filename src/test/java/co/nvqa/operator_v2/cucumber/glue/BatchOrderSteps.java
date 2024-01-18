package co.nvqa.operator_v2.cucumber.glue;

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
      for (int i = 0; i < data.size(); i++) {
        if (data.get(i).containsKey("trackingId")) {
          Assertions.assertThat(batchOrdersPage.getCellText(i, "tracking-id"))
              .as("tracking id")
              .isEqualTo(data.get(i).get("trackingId"));
        }
        if (data.get(i).containsKey("type")) {
          Assertions.assertThat(batchOrdersPage.getCellText(i, "type"))
              .as("type")
              .isEqualTo(data.get(i).get("type"));
        }
        if (data.get(i).containsKey("fromName")) {
          Assertions.assertThat(batchOrdersPage.getCellText(i, "from-name"))
              .as("from Name")
              .isEqualTo(data.get(i).get("fromName"));
        }
        if (data.get(i).containsKey("fromAddress")) {
          Assertions.assertThat(batchOrdersPage.getCellText(i, "from-address"))
              .as("from Address")
              .isEqualTo(data.get(i).get("fromAddress"));
        }
        if (data.get(i).containsKey("toName")) {
          Assertions.assertThat(batchOrdersPage.getCellText(i, "to-name"))
              .as("to Name")
              .isEqualTo(data.get(i).get("toName"));
        }
        if (data.get(i).containsKey("toAddress")) {
          Assertions.assertThat(batchOrdersPage.getCellText(i, "to-address"))
              .as("toAddress")
              .isEqualTo(data.get(i).get("toAddress"));
        }
        if (data.get(i).containsKey("status")) {
          Assertions.assertThat(batchOrdersPage.getCellText(i, "to-status"))
              .as("status")
              .isEqualTo(data.get(i).get("status"));
        }
        if (data.get(i).containsKey("granularStatus")) {
          Assertions.assertThat(batchOrdersPage.getCellText(i, "to-granular-status"))
              .as("granularStatus")
              .isEqualTo(data.get(i).get("granularStatus"));
        }
      }
    });
  }


  @Then("Operator verifies that error toast {string} displayed")
  public void verifyErrorToast(String message , Map<String, String> data) {
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