package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.core.model.miscellanous.SalesPerson;
import co.nvqa.common.core.utils.CoreScenarioStorageKeys;
import co.nvqa.common.utils.StandardTestUtils;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.page.SalesPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;

@ScenarioScoped
public class SalesSteps extends AbstractSteps {

  private static final String COLUMN_CODE = "code";
  private static final String COLUMN_NAME = "name";
  private static final String ACTION_EDIT = "edit";
  private static final String ACTION_DELETE = "delete";

  private SalesPage salesPage;

  public SalesSteps() {
  }

  @Override
  public void init() {
    salesPage = new SalesPage(getWebDriver());
  }

  @When("Operator download sample CSV file for \"Sales Person Creation\" on Sales page")
  public void operatorDownloadSampleCsvFileForSalesPersonCreationOnSalesPage() {
    salesPage.downloadSampleCsvFile();
  }

  @Then("Operator verify sample CSV file for \"Sales Person Creation\" on Sales page is downloaded successfully")
  public void operatorVerifySampleCsvFileForSalesPersonCreationOnSalesPageIsDownloadedSuccessfully() {
    salesPage.verifySampleCsvFileDownloadedSuccessfully();
  }

  @When("Operator upload CSV contains multiple Sales Persons on Sales page using data below:")
  public void operatorUploadCsvContainsMultipleSalesPersonsOnSalesPage(
      Map<String, String> dataTableAsMap) {
    List<SalesPerson> listOfSalesPerson = new ArrayList<>();
    int numberOfSalesPerson = Integer
        .parseInt(dataTableAsMap.getOrDefault("numberOfSalesPerson", "1"));

    for (int i = 0; i < numberOfSalesPerson; i++) {
      pause100ms(); //to avoid same uniqueString
      String uniqueString = StandardTestUtils.generateDateUniqueString();
      SalesPerson salesPerson = new SalesPerson();
      salesPerson.setCode("DSP-" + uniqueString);
      salesPerson.setName("Dummy-" + uniqueString);
      listOfSalesPerson.add(salesPerson);
    }

    salesPage.uploadCsvSales(listOfSalesPerson);
    putAllInList(CoreScenarioStorageKeys.KEY_CORE_LIST_OF_SALES_PERSON, listOfSalesPerson);
  }

  @When("Operator upload CSV with following Sales Persons data on Sales page:")
  public void operatorUploadCsvOnSalesPage(List<Map<String, String>> data) {
    List<SalesPerson> salesPersons = data.stream()
        .map(entry -> {
          SalesPerson salesPerson = new SalesPerson(resolveKeyValues(entry));
          String uniqueString = StandardTestUtils.generateDateUniqueString();
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
    putAllInList(CoreScenarioStorageKeys.KEY_CORE_LIST_OF_SALES_PERSON, salesPersons);
  }

  @When("Operator verifies that Upload CSV dialog contains following error records:")
  public void operatorVerifyUploadCsvErrors(List<String> data) {
    data = resolveValues(data);
    List<String> actual = salesPage.findOrdersWithCsvDialog.errorRecords.stream()
        .map(PageElement::getNormalizedText)
        .collect(Collectors.toList());
    Assertions.assertThat(actual).as("List of errors").contains(data.toArray(new String[0]));
  }

  @And("Operator verifies all sales persons parameters on Sales page")
  @Then("Operator verifies all Sales Persons created successfully")
  public void operatorVerifiesAllSalesPersonsCreatedSuccessfully() {
    List<SalesPerson> listOfSalesPerson = get(CoreScenarioStorageKeys.KEY_CORE_LIST_OF_SALES_PERSON);
    listOfSalesPerson.forEach(expected -> {
      salesPage.salesPersonsTable.filterByColumn(COLUMN_CODE, expected.getCode());
      SalesPerson actual = salesPage.salesPersonsTable.readEntity(1);
      expected.compareWithActual(actual, "id");
    });
  }

  @Then("Operator verifies all filters on Sales page works fine")
  public void operatorVerifiesAllFiltersOnSalesPageWorksFine() {
    List<SalesPerson> salesPersons = get(CoreScenarioStorageKeys.KEY_CORE_LIST_OF_SALES_PERSON);
    salesPersons.forEach(expected -> {
      salesPage.waitWhilePageIsLoading();
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
      putInList(CoreScenarioStorageKeys.KEY_CORE_LIST_OF_SALES_PERSON, newSalesPerson);
    }
    List<SalesPerson> salesPersons = get(CoreScenarioStorageKeys.KEY_CORE_LIST_OF_SALES_PERSON);
    salesPersons.stream()
        .filter(person -> StringUtils.equalsIgnoreCase(oldCode, person.getCode()))
        .findFirst()
        .ifPresent(person -> person.merge(newSalesPerson));
    salesPage.waitWhilePageIsLoading();
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

  @Then("Operator deletes {string} sales person on Sales page")
  public void deleteSalesPerson(String code) {
    String oldCode = resolveValue(code);
    salesPage.salesPersonsTable.filterByColumn(COLUMN_CODE, oldCode);
    salesPage.salesPersonsTable.clickActionButton(1, ACTION_DELETE);
    salesPage.deleteSalesPersonDialog.waitUntilVisible();
    salesPage.deleteSalesPersonDialog.delete.clickAndWaitUntilDone();
    salesPage.deleteSalesPersonDialog.waitUntilInvisible();
  }

  @Then("Operator verifies {string} sales person was deleted on Sales page")
  public void verifyDeletedSalesPerson(String code) {
    String oldCode = resolveValue(code);
    salesPage.salesPersonsTable.filterByColumn(COLUMN_CODE, oldCode);
    Assertions.assertThat(salesPage.salesPersonsTable.isEmpty())
        .as(code + " sales person is not displayed").isTrue();
  }

}
