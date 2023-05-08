package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.core.model.order.Order;
import co.nvqa.common.core.utils.CoreScenarioStorageKeys;
import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.operator_v2.model.CodInfo;
import co.nvqa.operator_v2.selenium.page.CodReportPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.text.ParseException;
import java.util.Collections;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class CodReportSteps extends AbstractSteps {

  private CodReportPage codReportPage;

  public CodReportSteps() {
  }

  @Override
  public void init() {
    codReportPage = new CodReportPage(getWebDriver());
  }

  @When("^Operator filter COD Report by Mode = \"([^\"]*)\" and Date = \"([^\"]*)\"$")
  public void operatorFilterCodReportByGivenModeAndDate(String mode, String dateAsString)
      throws ParseException {
    switch (StringUtils.normalizeSpace(mode.toLowerCase(Locale.ROOT))) {
      case "get cods for a day":
        codReportPage.getCodsForADay.click();
        break;
      case "get driver cods for a route day":
        codReportPage.getDriverCodsForARouteDay.click();
    }
    codReportPage.date.setDate(
        StandardTestUtils.convertToZonedDateTime(dateAsString, DTF_NORMAL_DATE));
    pause2s();
    codReportPage.waitWhilePageIsLoading();
  }

  @Then("Operator verify COD record on COD Report page:")
  public void operatorVerifyOrderIsExistWithCorrectInfo(Map<String, String> data) {
    CodInfo expected = new CodInfo(resolveKeyValues(data));
    int index = codReportPage.codTable.findRow(expected.getTrackingId());
    Assertions.assertThat(index)
        .withFailMessage("Row with Tracking ID " + expected.getTrackingId() + " was not found")
        .isPositive();
    CodInfo actual = codReportPage.codTable.readEntity(index);
    expected.compareWithActual(actual);
  }

  @When("Operator download COD Report")
  public void operatorDownloadCodReport() {
    codReportPage.downloadCsv.click();
  }

  @Then("Operator verify the downloaded COD Report data is correct")
  public void operatorVerifyTheDownloadedCodReportDataIsCorrect(Map<String, String> dataTableRaw) {
    Map<String, String> dataTable = resolveKeyValues(dataTableRaw);
    Long orderId = Long.valueOf(dataTable.get("orderId"));

    List<Order> orders = get(CoreScenarioStorageKeys.KEY_LIST_OF_CREATED_ORDERS, Collections.emptyList());

    Order createdOrder = orders.stream()
        .filter(order -> order.getId().equals(orderId))
        .collect(Collectors.toList()).get(0);

    codReportPage.verifyCsvFileDownloadedSuccessfullyAndContainsCorrectInfo(createdOrder);
  }
}
