package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.sort.sort_vendor.SortBeltPreset;
import co.nvqa.commons.model.sort.sort_vendor.SortBeltPreset.Filter;
import co.nvqa.commons.model.sort.sort_vendor.SortBeltPreset.Rule;
import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.selenium.elements.ant.v4.AntSelect;
import co.nvqa.operator_v2.selenium.page.sort.sortbeltpreset.CheckSortBeltPresetPage;
import co.nvqa.operator_v2.selenium.page.sort.sortbeltpreset.CreatePresetSortBeltPresetPage;
import co.nvqa.operator_v2.selenium.page.sort.sortbeltpreset.CreatePresetSortBeltPresetPage.CriteriaCard;
import co.nvqa.operator_v2.selenium.page.sort.sortbeltpreset.SortBeltPresetDetailPage;
import co.nvqa.operator_v2.selenium.page.sort.sortbeltpreset.SortBeltPresetDetailPage.CriteriaTableRow;
import co.nvqa.operator_v2.selenium.page.sort.sortbeltpreset.SortBeltPresetPage;
import co.nvqa.operator_v2.selenium.page.sort.sortbeltpreset.SortBeltPresetPage.SBPresetListElement;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Map;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.By;

@ScenarioScoped
public class SortBeltPresetSteps extends AbstractSteps {

  SortBeltPresetPage sortBeltPresetPage;
  CreatePresetSortBeltPresetPage createPresetSortBeltPresetPage;

  CheckSortBeltPresetPage checkSortBeltPresetPage;
  SortBeltPresetDetailPage sortBeltPresetDetailPage;

  @Override
  public void init() {
    sortBeltPresetPage = new SortBeltPresetPage(getWebDriver());
    createPresetSortBeltPresetPage = new CreatePresetSortBeltPresetPage(getWebDriver());
    sortBeltPresetDetailPage = new SortBeltPresetDetailPage(getWebDriver());
    checkSortBeltPresetPage = new CheckSortBeltPresetPage(getWebDriver());
  }

  @Then("Operator search sort belt preset by")
  public void operatorSearchSortBeltPresetBy(Map<String, String> dataTable) {
    String value = resolveValue(dataTable.get("value"));
    String column = dataTable.get("column");
    if (column.equalsIgnoreCase("description")) {
      value = "Description for: " + value;
    }
    sortBeltPresetPage.searchInput.forceClear();
    sortBeltPresetPage.searchInput.sendKeys(value);
  }

  @And("Operator wait until sort belt preset page loaded")
  public void operatorWaitUntilSortBeltPresetPageLoaded() {
    sortBeltPresetPage.switchTo();
    sortBeltPresetPage.waitUntilLoaded();
  }

  @And("Operator verify sort belt preset search result")
  public void operatorVerifySortBeltPresetSearchResult() {
    List<SBPresetListElement> list = sortBeltPresetPage.listItems;
    Assertions.assertThat(list.size())
        .as("Sort Belt Preset contains the search result")
        .isNotEqualTo(0);
    SortBeltPreset savedPreset = get(KEY_CREATED_SORT_BELT_PRESET);
    Assertions.assertThat(list.get(0).title.getText())
        .as("Sort Belt Preset have the correct name as the created preset")
        .isEqualTo(savedPreset.getName());

    Assertions.assertThat(list.get(0).description.getText())
        .as("Sort Belt Preset have the correct description as the created preset")
        .isEqualTo(savedPreset.getDescription());
  }

  @When("Operator click Create a new preset menu on Sort Belt Preset page")
  public void operatorClickCreateANewPresetMenuOnSortBeltPresetPage() {
    sortBeltPresetPage.createPresetBtn.click();
    sortBeltPresetPage.createNewMenu.click();
  }

  @And("Operator verify Create Preset UI")
  public void operatorVerifyCreatePresetUI() {
    createPresetSortBeltPresetPage.waitUntilLoaded();
    //verify the ui
    Assertions.assertThat(createPresetSortBeltPresetPage.cancelBtn.isDisplayed())
        .as("Cancel button is displayed")
        .isTrue();
    Assertions.assertThat(createPresetSortBeltPresetPage.addCriteriaBtn.isDisplayed())
        .as("Add criteri button is displayed")
        .isTrue();
    Assertions.assertThat(createPresetSortBeltPresetPage.presetName.isDisplayed())
        .as("Preset name field is displayed")
        .isTrue();
    Assertions.assertThat(createPresetSortBeltPresetPage.cards.size())
        .as("Show 1 criteria by default")
        .isEqualTo(1);

  }

  @When("Operator fill name and description into Create Preset UI")
  public void operatorFillNameAndDescriptionIntoCreatePresetUI(Map<String, String> dataTable) {
    String name = dataTable.get("name");
    String desc = dataTable.get("description");
    if (name.equalsIgnoreCase("random") && desc.equalsIgnoreCase("random")) {
      name = f("AUTOMATION PRESET %d", new Date().getTime());
      desc = f("Description for: %s", name);
    }
    createPresetSortBeltPresetPage.presetName.sendKeys(name);
    createPresetSortBeltPresetPage.description.sendKeys(desc);
    put(KEY_CREATED_SORT_BELT_PRESET_NAME, name);
  }

  @And("Operator add new criteria to Create Preset UI")
  public void operatorAddNewCriteriaToCreatePresetUI() {
    createPresetSortBeltPresetPage.addCriteriaBtn.click();
    Assertions.assertThat(createPresetSortBeltPresetPage.cards.size())
        .as("New criteria row is addedd")
        .isEqualTo(2);
  }

  @And("Operator remove criteria to Create Preset UI")
  public void operatorRemoveCriteriaToCreatePresetUI() {
    // removing the last criteria
    int currentSize = createPresetSortBeltPresetPage.cards.size();
    createPresetSortBeltPresetPage.cards.get(currentSize - 1).clearBtn.click();
    Assertions.assertThat(createPresetSortBeltPresetPage.cards.size())
        .as("1 criteria is removed")
        .isEqualTo(currentSize - 1);
  }

  @And("Operator click Proceed in the Create Preset UI")
  public void operatorClickProceedInTheCreatePresetUI() {
    createPresetSortBeltPresetPage.nextBtn.click();
  }

  @Then("Operator verify the new preset is failed to be submitted")
  public void operatorVerifyTheNewPresetIsFailedToBeSubmitted(Map<String, String> dataTable) {
    createPresetSortBeltPresetPage.notification.waitUntilVisible();
    String header = dataTable.get("header");
    String message = dataTable.get("message");

    Assertions.assertThat(createPresetSortBeltPresetPage.notification.message.getText())
        .as("show correct header message :" + header)
        .isEqualTo(header);

    Assertions.assertThat(createPresetSortBeltPresetPage.notification.description.getText())
        .as("show correct message :" + message)
        .isEqualTo(message);
  }

  @And("Operator clear name and description in Create Preset UI")
  public void operatorClearNameAndDescriptionInCreatePresetUI() {
    createPresetSortBeltPresetPage.presetName.forceClear();
    createPresetSortBeltPresetPage.description.forceClear();
  }

  @And("Operator fill the criteria with following data")
  public void operatorFillTheCriteriaWithFollowingData(Map<String, String> dataTable) {
    String description = resolveValue(dataTable.get("description"));
    String fieldsString = resolveValue(dataTable.get("fields"));
    String valuesString = resolveValue(dataTable.get("values"));

    List<String> fields = Arrays.asList(fieldsString.split(","));
    List<String> values = Arrays.asList(valuesString.split(","));

    if (fields.size() != values.size()) {
      throw new NvTestRuntimeException("Number of fields != number of values");
    }

    CriteriaCard criteriaElement = createPresetSortBeltPresetPage.cards.get(
        createPresetSortBeltPresetPage.cards.size() - 1);
    criteriaElement.description.sendKeys(description);
    for (int i = 0; i < fields.size(); i++) {
      criteriaElement.addFilterMenu.selectOption(fields.get(i));
      AntSelect select = new AntSelect(getWebDriver(),
          criteriaElement.findElement(By.xpath(f(CriteriaCard.SELECTOR_XPATH, fields.get(i)))));
      List<String> vals = Arrays.asList(values.get(i).split("\\."));
      vals.forEach(v -> {
        select.enterSearchTerm(v);
        select.sendReturnButton();
      });

      createPresetSortBeltPresetPage.title.click();
      pause300ms();
    }
  }

  @And("Operator verify preset created correctly on Sort Belt Preset detail page")
  public void operatorVerifyPresetCreatedCorrectlyOnSortBeltPresetDetailPage() {
    sortBeltPresetDetailPage.waitUntilLoaded();

    SortBeltPreset sb = get(KEY_CREATED_SORT_BELT_PRESET);

    Assertions.assertThat(sortBeltPresetDetailPage.cancelBtn.isDisplayed())
        .as("Cancel button is displayed")
        .isTrue();

    Assertions.assertThat(sortBeltPresetDetailPage.editButton.isDisplayed())
        .as("Edit button is displayed")
        .isTrue();

    Assertions.assertThat(sortBeltPresetDetailPage.presetTitle.getText().contains(sb.getName()))
        .as("Preset title contains the correct string: " + sb.getName())
        .isTrue();

    Assertions.assertThat(
            sortBeltPresetDetailPage.description.getText().contains(sb.getDescription()))
        .as("Preset description contain the correct string: " + sb.getDescription());
    // outer loop, read all the rule
    Rule rule = null;
    int ruleIndex = 0;
    System.out.println(sortBeltPresetDetailPage.rows);
    for (int i = 0; i < sortBeltPresetDetailPage.rows.size(); i++) {
      CriteriaTableRow row = sortBeltPresetDetailPage.rows.get(i);
      if (row.isCriteriaRow()) {
        rule = sb.getRules().get(ruleIndex);
        ruleIndex += 1;
      }
      if (rule == null) {
        throw new NvTestRuntimeException("no sort belt preset rule");
      }
      Filter f = rule.getFilter();
      //check the field
      String ruleFieldName = row.getFilterType();
      switch (ruleFieldName) {
        case "Order Tag":
          String tagsString = String.join(",", f.getTags());
          Assertions.assertThat(row.getFilterValue())
              .as("Order tags show correct values :")
              .isEqualTo(tagsString);
          break;
        case "DP IDs":
        case "Zones":
        case "Destination Hub":
        case "Master Shipper":
        case "Shipper":
          //unsupported due to shipper id fetching and dp fetching
          break;
        case "Granular Status":
          String statuses = String.join(",", f.getGranularStatuses());
          Assertions.assertThat(row.getFilterValue())
              .as("granular status show correct values :")
              .isEqualTo(statuses);
          break;
        case "RTS":
          String yesNoRTS = f.getRts() ? "Yes" : "No";
          Assertions.assertThat(row.getFilterValue())
              .as("RTS show correct value")
              .isEqualTo(yesNoRTS);
          break;
        case "Service Level":
          String serviceLevels = String.join(",", f.getServiceLevels());
          Assertions.assertThat(row.getFilterValue())
              .as("Service levels show correct values")
              .isEqualTo(serviceLevels);
          break;
        case "Transaction End Day":
          Assertions.assertThat(row.getFilterValue().contains(String.valueOf(f.getTxnEndInDays())))
              .as("Transaction end days show correct value")
              .isTrue();
          break;
      }
    }
  }

  @And("Operator click Cancel in the Create Preset UI")
  public void operatorClickCancelInTheCreatePresetUI() {
    createPresetSortBeltPresetPage.cancelBtn.click();
  }

  @And("Operator verify no sort belt preset is created")
  public void operatorVerifyNoSortBeltPresetIsCreated() {
    SortBeltPreset preset = get(KEY_CREATED_SORT_BELT_PRESET);
    Assertions.assertThat(preset)
        .as("No sort belt preset is created")
        .isNull();
  }

  @And("Operator verify preset has error on Check Sort Belt Preset detail page")
  public void operatorVerifyPresetHasErrorOnCheckSortBeltPresetDetailPage(
      Map<String, String> dataTable) {

    String duplicateFilter = dataTable.get("fields");
    checkSortBeltPresetPage.waitUntilLoaded();
    Assertions.assertThat(checkSortBeltPresetPage.editButton.isDisplayed())
        .as("Edit button is displayed")
        .isTrue();

    Assertions.assertThat(checkSortBeltPresetPage.criteriaElements.size() > 0)
        .as("Has duplicate table criteria")
        .isTrue();

    Assertions.assertThat(checkSortBeltPresetPage.criteriaElements.get(0).filterType.getText())
        .as(f("%s is duplicated ", duplicateFilter))
        .isEqualTo(duplicateFilter);
  }
}
