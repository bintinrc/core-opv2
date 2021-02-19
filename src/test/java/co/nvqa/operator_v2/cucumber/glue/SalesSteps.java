package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.SalesPerson;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.page.SalesPage;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;
import org.hamcrest.Matchers;

import static co.nvqa.operator_v2.selenium.page.SalesPage.SalesPersonsTable.ACTION_EDIT;
import static co.nvqa.operator_v2.selenium.page.SalesPage.SalesPersonsTable.COLUMN_CODE;
import static co.nvqa.operator_v2.selenium.page.SalesPage.SalesPersonsTable.COLUMN_NAME;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class SalesSteps extends AbstractSteps {

  private SalesPage salesPage;

  public SalesSteps() {
  }

  @Override
  public void init() {
    salesPage = new SalesPage(getWebDriver());
  }

  @When("^Operator download sample CSV file for \"Sales Person Creation\" on Sales page$")
  public void operatorDownloadSampleCsvFileForSalesPersonCreationOnSalesPage() {
    salesPage.downloadSampleCsvFile();
  }

  @Then("^Operator verify sample CSV file for \"Sales Person Creation\" on Sales page is downloaded successfully$")
  public void operatorVerifySampleCsvFileForSalesPersonCreationOnSalesPageIsDownloadedSuccessfully() {
    salesPage.verifySampleCsvFileDownloadedSuccessfully();
  }

  @When("^Operator upload CSV contains multiple Sales Persons on Sales page using data below:$")
  public void operatorUploadCsvContainsMultipleSalesPersonsOnSalesPage(
      Map<String, String> dataTableAsMap) {
    List<SalesPerson> listOfSalesPerson = new ArrayList<>();
    int numberOfSalesPerson = Integer
        .parseInt(dataTableAsMap.getOrDefault("numberOfSalesPerson", "1"));

    for (int i = 0; i < numberOfSalesPerson; i++) {
      pause100ms(); //to avoid same uniqueString
      String uniqueString = generateDateUniqueString();
      SalesPerson salesPerson = new SalesPerson();
      salesPerson.setCode("DSP-" + uniqueString);
      salesPerson.setName("Dummy-" + uniqueString);
      listOfSalesPerson.add(salesPerson);
    }

    salesPage.uploadCsvSales(listOfSalesPerson);
    putAllInList(KEY_LIST_OF_SALES_PERSON, listOfSalesPerson);
  }

  @When("^Operator upload CSV with following Sales Persons data on Sales page:$")
  public void operatorUploadCsvOnSalesPage(List<Map<String, String>> data) {
    List<SalesPerson> salesPersons = data.stream()
        .map(entry -> {
          SalesPerson salesPerson = new SalesPerson(resolveKeyValues(entry));
          String uniqueString = generateDateUniqueString();
          if (StringUtils.endsWithIgnoreCase(salesPerson.getName(), "{uniqueString}")) {
            salesPerson.setName(salesPerson.getName().replace("{uniqueString}", uniqueString));
          }
          if (StringUtils.endsWithIgnoreCase(salesPerson.getCode(), "{uniqueString}")) {
            salesPerson.setCode(salesPerson.getCode().replace("{uniqueString}", uniqueString));
          }
          return salesPerson;
        })
        .collect(Collectors.toList());

    salesPage.uploadCsvSales(salesPersons);
    putAllInList(KEY_LIST_OF_SALES_PERSON, salesPersons);
  }

  @When("^Operator verifies that Upload CSV dialog contains following error records:$")
  public void operatorVerifyUploadCsvErrors(List<String> data) {
    data = resolveValues(data);
    List<String> actual = salesPage.findOrdersWithCsvDialog.errorRecords.stream()
        .map(PageElement::getNormalizedText)
        .collect(Collectors.toList());
    assertThat("List of errors", actual, Matchers.contains(data.toArray(new String[0])));
  }

  @And("^Operator verifies all sales persons parameters on Sales page$")
  @Then("^Operator verifies all Sales Persons created successfully$")
  public void operatorVerifiesAllSalesPersonsCreatedSuccessfully() {
    List<SalesPerson> listOfSalesPerson = get(KEY_LIST_OF_SALES_PERSON);
    listOfSalesPerson.forEach(expected -> {
      salesPage.salesPersonsTable.filterByColumn(COLUMN_CODE, expected.getCode());
      SalesPerson actual = salesPage.salesPersonsTable.readEntity(1);
      expected.compareWithActual(actual, "id");
    });
  }

  @Then("^Operator verifies all filters on Sales page works fine$")
  public void operatorVerifiesAllFiltersOnSalesPageWorksFine() {
    List<SalesPerson> salesPersons = get(KEY_LIST_OF_SALES_PERSON);
    salesPersons.forEach(expected -> {
      salesPage.salesPersonsTable.filterByColumn(COLUMN_CODE, expected.getCode());
      SalesPerson actual = salesPage.salesPersonsTable.readEntity(1);
      expected.compareWithActual(actual, "id");
      salesPage.salesPersonsTable.clearColumnFilter(COLUMN_CODE);

      salesPage.salesPersonsTable.filterByColumn(COLUMN_NAME, expected.getName());
      actual = salesPage.salesPersonsTable.readEntity(1);
      expected.compareWithActual(actual, "id");
      salesPage.salesPersonsTable.clearColumnFilter(COLUMN_NAME);
    });
  }

  @Then("Operator edit {string} sales person on Sales page using data below:")
  public void editSalesPerson(String code, Map<String, String> data) {
    String oldCode = resolveValue(code);
    SalesPerson newSalesPerson = new SalesPerson(resolveKeyValues(data));
    if (StringUtils.isNotEmpty(newSalesPerson.getCode())) {
      putInList(KEY_LIST_OF_SALES_PERSON, newSalesPerson);
    }
    List<SalesPerson> salesPersons = get(KEY_LIST_OF_SALES_PERSON);
    salesPersons.stream()
        .filter(person -> StringUtils.equalsIgnoreCase(oldCode, person.getCode()))
        .findFirst()
        .ifPresent(person -> person.merge(newSalesPerson));
    salesPage.salesPersonsTable.filterByColumn(COLUMN_CODE, oldCode);
    salesPage.salesPersonsTable.clickActionButton(1, ACTION_EDIT);
    salesPage.editSalesPersonDialog.waitUntilVisible();
    pause1s();
    if (StringUtils.isNotBlank(newSalesPerson.getName())) {
      salesPage.editSalesPersonDialog.name.setValue(newSalesPerson.getName());
    }
    if (StringUtils.isNotBlank(newSalesPerson.getCode())) {
      salesPage.editSalesPersonDialog.code.setValue(newSalesPerson.getCode());
    }
    salesPage.editSalesPersonDialog.save.clickAndWaitUntilDone();
    salesPage.editSalesPersonDialog.waitUntilInvisible();
  }
}
