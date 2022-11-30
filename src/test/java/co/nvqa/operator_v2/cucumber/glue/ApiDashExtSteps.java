package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.cucumber.glue.AbstractApiDashSteps;
import co.nvqa.commons.model.dash.report.DashPaymentHistory;
import co.nvqa.commons.model.dash.report.DashPaymentHistoryRequest;
import co.nvqa.commons.model.dash.report.DashPaymentRecord;
import co.nvqa.operator_v2.model.ShipperBillingRecord;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.When;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class ApiDashExtSteps extends AbstractApiDashSteps<ScenarioManager> {

  public ApiDashExtSteps() {
  }

  @Override
  public void init() {
  }

  @When("^API Dash user verify created record in shipper billing history$")
  public void apiDashUserVerifyUpdatedShipperAmount() {
    ShipperBillingRecord billingRecord = get(KEY_SHIPPER_BILLING_RECORD);
    DashPaymentHistoryRequest request = new DashPaymentHistoryRequest();
    request.setPage(1);
    request.setPageSize(100);
    DashPaymentHistory dashPaymentHistory = getDashClient().getPaymentHistory(request);
    DashPaymentRecord dashPaymentRecord = dashPaymentHistory.getValue().stream()
        .filter(record -> StringUtils.contains(record.getComments(), billingRecord.getComment()))
        .findFirst()
        .orElseThrow(() -> new AssertionError(
            f("Dash payment history doesn't containt record with comment [%s].",
                billingRecord.getComment())));

    Assertions.assertThat(billingRecord.getAmount()).as("Amount")
        .isEqualTo(dashPaymentRecord.getAmount());
    Assertions.assertThat("SUCCESS").as("Status").isEqualTo(dashPaymentRecord.getStatus());
    Assertions.assertThat(dashPaymentRecord.getMetadata()).as("Metadata").isNotNull();
    Assertions.assertThat(billingRecord.getReason()).as("Metadata - Reason")
        .isEqualTo(dashPaymentRecord.getMetadata().getReason());
    Assertions.assertThat(billingRecord.getComment()).as("Metadata - Details")
        .isEqualTo(dashPaymentRecord.getMetadata().getDetails());

    String expectedType;

    switch (billingRecord.getType().toLowerCase()) {
      case "add":
        expectedType = "CREDIT";
        break;
      case "deduct":
        expectedType = "DEBIT";
        break;
      default:
        throw new IllegalArgumentException(
            f("Unknown operation type [%s]. Can be 'add' or 'deduct'.", billingRecord.getType()));
    }

    Assertions.assertThat(expectedType).as("Type").isEqualTo(dashPaymentRecord.getType());
    Assertions.assertThat("ACCOUNT_CORRECTION").as("Event").isEqualTo(dashPaymentRecord.getEvent());
  }
}
