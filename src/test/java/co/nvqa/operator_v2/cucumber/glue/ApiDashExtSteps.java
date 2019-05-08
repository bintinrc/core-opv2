package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.cucumber.glue.AbstractApiOperatorPortalSteps;
import co.nvqa.commons.model.dash.report.DashPaymentHistory;
import co.nvqa.commons.model.dash.report.DashPaymentHistoryRequest;
import co.nvqa.commons.model.dash.report.DashPaymentRecord;
import co.nvqa.operator_v2.model.ShipperBillingRecord;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.apache.commons.lang3.StringUtils;
import org.junit.Assert;

/**
 * @author Sergey Mishanin
 */
@ScenarioScoped
public class ApiDashExtSteps extends AbstractApiOperatorPortalSteps<ScenarioManager>
{
    public ApiDashExtSteps()
    {
    }

    @Override
    public void init()
    {
    }

    @When("^Given API Ninja Dash username \"(.+)\", password \"(.+)\"$")
    public void apiDashUserLoginUsingPhone(String email, String password)
    {
        initDashClient(email, password);
    }

    @When("^API Dash user verify created record in shipper billing history$")
    public void apiDashUserVerifyUpdatedShipperAmount()
    {
        ShipperBillingRecord billingRecord = get(KEY_SHIPPER_BILLING_RECORD);
        DashPaymentHistoryRequest request = new DashPaymentHistoryRequest();
        request.setPage(1);
        request.setPageSize(100);
        DashPaymentHistory dashPaymentHistory = getDashClient().getPaymentHistory(request);
        DashPaymentRecord dashPaymentRecord = dashPaymentHistory.getValue().stream()
                .filter(record -> StringUtils.contains(record.getComments(), billingRecord.getComment()))
                .findFirst()
                .orElseThrow(() -> new AssertionError(String.format("Dash payment history doesn't containt record with comment [%s]", billingRecord.getComment())));

        Assert.assertEquals("Amount", dashPaymentRecord.getAmount(), billingRecord.getAmount());
        Assert.assertEquals("Status", dashPaymentRecord.getStatus(), "SUCCESS");
        Assert.assertNotNull("Metadata", dashPaymentRecord.getMetadata());
        Assert.assertEquals("Metadata - Reason", dashPaymentRecord.getMetadata().getReason(), billingRecord.getReason());
        Assert.assertEquals("Metadata - Details", dashPaymentRecord.getMetadata().getDetails(), billingRecord.getComment());
        String expectedType = null;
        switch (billingRecord.getType().toLowerCase())
        {
            case "add":
                expectedType = "CREDIT";
                break;
            case "deduct":
                expectedType = "DEBIT";
                break;
            default:
                throw new IllegalArgumentException(String.format("Unknown operation type [%s]. Can be 'add' or 'deduct'", billingRecord.getType()));
        }
        Assert.assertEquals("Type", dashPaymentRecord.getType(), expectedType);
        Assert.assertEquals("Event", dashPaymentRecord.getEvent(), "ACCOUNT_CORRECTION");
    }
}
