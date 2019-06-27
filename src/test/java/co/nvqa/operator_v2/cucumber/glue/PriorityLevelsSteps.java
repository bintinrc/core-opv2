package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.cucumber.glue.StandardApiOperatorPortalSteps;
import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.model.core.Transaction;
import co.nvqa.operator_v2.selenium.page.PriorityLevelsPage;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.runtime.java.guice.ScenarioScoped;
import io.cucumber.datatable.DataTable;

import javax.inject.Inject;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;


@ScenarioScoped
public class PriorityLevelsSteps extends AbstractSteps {

    private PriorityLevelsPage priorityLevelsPage;

    private final String TRANSACTION_TYPE = "DELIVERY";
    @Inject
    private StandardApiOperatorPortalSteps standardApiOperatorPortalSteps;

    public PriorityLevelsSteps(){

    }

    @Override
    public void init() {
        priorityLevelsPage = new PriorityLevelsPage(getWebDriver());
    }

    @Then("^Operator verifies \"Orders Sample CSV\" is downloaded successfully and correct$")
    public void operatorsVerifiesSampleCsvOrdersIsDownloadedSuccessfullyAndCorrect() {
        priorityLevelsPage.clickDownloadSampleCsvOrdersButton();
        priorityLevelsPage.verifyDownloadedSampleCsvOrders();
    }

    @Then("^Operator verifies \"Reservations Sample CSV\" is downloaded successfully and correct$")
    public void operatorsVerifiesSampleCsvReservationsIsDownloadedSuccessfullyAndCorrect() {
        priorityLevelsPage.clickDownloadSampleCsvReservationsButton();
        priorityLevelsPage.verifyDownloadedSampleCsvReservations();
    }

    @And("^Operator uploads \"Order CSV\" using next priority levels for orders:$")
    public void operatorsUploads(DataTable dataTable) {
        List<Order> orders = get(KEY_LIST_OF_CREATED_ORDER);
        Map<String, String> transactionToPriorityLevel = new HashMap<>();

        dataTable.asMaps().forEach(rowAsMap -> {
            String transactionId = orders.get(Integer.parseInt(rowAsMap.get("order")) - 1)
                    .getTransactions().stream().filter(transaction -> Objects.equals(transaction.getType(), TRANSACTION_TYPE))
                    .map(transaction -> String.valueOf(transaction.getId()))
                    .findFirst()
                    .orElseThrow(() -> new IllegalArgumentException(f("No transaction with Type %s", TRANSACTION_TYPE)));
                    String priorityLevel = rowAsMap.get("priorityLevel");

                    transactionToPriorityLevel.put(transactionId, priorityLevel);
        });
            put(KEY_PRIORITY_LEVELS_TRANSACTION_TO_PRIORITY_LEVEL, transactionToPriorityLevel);

        priorityLevelsPage.uploadUpdateViaCsvOrders(transactionToPriorityLevel);
        priorityLevelsPage.clickBulkUpdateButton();
    }

    @Then("^Operator verifies order's priority is changed$")
    public void operatorVerifiesOrdersPriorityIsChangedCorrectly() {
        Map<String, String> transactionToPriorityLevelExpected = get(KEY_PRIORITY_LEVELS_TRANSACTION_TO_PRIORITY_LEVEL);
        Map<String, String> transactionToPriorityLevelActual = new HashMap<>();
        List<Order> orders = get(KEY_LIST_OF_CREATED_ORDER);

        orders.forEach(order -> {
                    Order orderUpdated = retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> standardApiOperatorPortalSteps.getOrderClient()
                            .searchOrderByTrackingId(order.getTrackingId()), f("%s - [Tracking ID = %s]", getCurrentMethodName(),
                            order.getTrackingId()));
                    Transaction transaction = orderUpdated.getTransactions().stream()
                            .filter(transactionItem -> Objects.equals(transactionItem.getType(), TRANSACTION_TYPE))
                            .findFirst()
                            .orElseThrow(() -> new IllegalArgumentException(f("No transaction with %s type", TRANSACTION_TYPE)));
                    transactionToPriorityLevelActual.put(String.valueOf(transaction.getId()), String.valueOf(transaction.getPriorityLevel()));
                });

        assertTrue("Priority Levels are not as expected for Transaction", transactionToPriorityLevelActual.entrySet().stream()
                .allMatch(e -> e.getValue().equals(transactionToPriorityLevelExpected.get(e.getKey()))));
    }
}
