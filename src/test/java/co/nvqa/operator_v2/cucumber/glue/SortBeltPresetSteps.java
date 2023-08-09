package co.nvqa.operator_v2.cucumber.glue;


import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.commonsort.model.sort_vendor.persisted_class.SortBeltPresetEntity;
import co.nvqa.commonsort.model.sort_vendor.SortBeltPreset;
import co.nvqa.commonsort.model.sort_vendor.SortBeltPreset.Filter;
import co.nvqa.commonsort.model.sort_vendor.SortBeltPreset.Rule;
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
  public void operatorVerifySortBeltPresetSearchResult(Map<String,String>data) {
    data = resolveKeyValues(data);
    String presetName = data.get("presetName");
    String description = data.get("description");
    List<SBPresetListElement> list = sortBeltPresetPage.listItems;
    Assertions.assertThat(list.size())
        .as("Sort Belt Preset contains the search result")
        .isNotEqualTo(0);
    SortBeltPreset savedPreset = new SortBeltPreset();
    savedPreset.setName(presetName);
    savedPreset.setDescription(description);
    Assertions.assertThat(list.get(0).title.getText())
        .as("Sort Belt Preset have the correct name as the created preset")
        .isEqualTo(savedPreset.getName());

    Assertions.assertThat(list.get(0).description.getText())
        .as("Sort Belt Preset have the correct description as the created preset")
        .isEqualTo(savedPreset.getDescription());
  }

  @When("Operator click {string} preset menu on Sort Belt Preset page")
  public void operatorClickCreateANewPresetMenuOnSortBeltPresetPage(String newOrCopy) {
    sortBeltPresetPage.createPresetBtn.click();
    if (newOrCopy.equalsIgnoreCase("Create new")) {
      sortBeltPresetPage.createNewMenu.click();
    } else {
      sortBeltPresetPage.createACopyMenu.click();
    }


  }

  @And("Operator verify Create Preset UI")
  public void operatorVerifyCreatePresetUI() {
    createPresetSortBeltPresetPage.waitUntilLoaded();
    //verify the ui
    Assertions.assertThat(createPresetSortBeltPresetPage.cancelBtn.isDisplayed())
        .as("Cancel button is displayed")
        .isTrue();
    Assertions.assertThat(createPresetSortBeltPresetPage.addCriteriaBtn.isDisplayed())
        .as("Add criteria button is displayed")
        .isTrue();
    Assertions.assertThat(createPresetSortBeltPresetPage.presetName.isDisplayed())
        .as("Preset name field is displayed")
        .isTrue();
  }

  @When("Operator fill name and description into Create Preset UI")
  public void operatorFillNameAndDescriptionIntoCreatePresetUI(Map<String, String> dataTable) {
    String name = dataTable.get("name");
    String desc = dataTable.get("description");
    if (name.equalsIgnoreCase("random") && desc.equalsIgnoreCase("random")) {
      name = f("AUTOMATION PRESET %d", new Date().getTime());
      desc = f("Description for: %s", name);
    }
    createPresetSortBeltPresetPage.presetName.forceClear();
    createPresetSortBeltPresetPage.description.forceClear();
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
    createPresetSortBeltPresetPage.loadingIcon.waitUntilInvisible();
  }

  @Then("Operator verify the new preset is failed to be submitted")
  public void operatorVerifyTheNewPresetIsFailedToBeSubmitted(Map<String, String> dataTable) {
    createPresetSortBeltPresetPage.notification.waitUntilVisible();
    String header = dataTable.get("header");
    String message = dataTable.get("message");
doWithRetry(()->{Assertions.assertThat(createPresetSortBeltPresetPage.notification.message.getText())
    .as("show correct header message :" + header)
    .isEqualTo(header);

  Assertions.assertThat(createPresetSortBeltPresetPage.notification.description.getText())
      .as("show correct message :" + message)
      .isEqualTo(message);},"Assert failed notification");

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
      criteriaElement.addFilterMenu.click();
      pause1s();
      criteriaElement.findElement(
              By.xpath(f(CriteriaCard.FILTER_OPTION, criteriaElement.getFilterTestId(fields.get(i)))))
          .click();

      List<String> vals;
      if (fields.get(i).equalsIgnoreCase("Shipper")) {
        List<String> include = Arrays.asList(values.get(i).split(":"));
        vals = Arrays.asList(include.get(1).split("\\."));
        AntSelect select = new AntSelect(getWebDriver(),
            criteriaElement
                .findElement(By.xpath(f(CriteriaCard.INCLUDE_SELECTOR_XPATH, "Shipper"))));
        select.selectValue(include.get(0));
      } else {
        vals = Arrays.asList(values.get(i).split("\\."));
      }

      AntSelect select = new AntSelect(getWebDriver(),
          criteriaElement.findElement(By.xpath(f(CriteriaCard.SELECTOR_XPATH, fields.get(i)))));

      vals.forEach(v -> {
        select.enterSearchTerm(v);
        select.sendReturnButton();
      });

      createPresetSortBeltPresetPage.title.click();
      pause300ms();
    }
  }

  @And("Operator verify preset created correctly on Sort Belt Preset detail page")
  public void operatorVerifyPresetCreatedCorrectlyOnSortBeltPresetDetailPage(
      Map<String, String> dataTable) {

    dataTable=resolveKeyValues(dataTable);
    SortBeltPresetEntity entity = new SortBeltPresetEntity();
    entity.setRulesString(dataTable.get("rulesString"));
    entity.setName(dataTable.get("name"));
    entity.setDescription(dataTable.get("description"));
    SortBeltPreset sb = SortBeltPreset.fromEntity(entity);
    Assertions.assertThat(sortBeltPresetDetailPage.cancelBtn.isDisplayed())
        .as("Cancel button is displayed")
        .isTrue();

    Assertions.assertThat(sortBeltPresetDetailPage.editButton.isDisplayed())
        .as("Edit button is displayed")
        .isTrue();

    Assertions.assertThat(sortBeltPresetDetailPage.presetTitle.getText())
        .as("Preset title contains the correct string: " + sb.getName())
        .isEqualTo("Preset: " + sb.getName());

    Assertions.assertThat(
            sortBeltPresetDetailPage.description.getText().contains(sb.getDescription()))
        .as("Preset description contain the correct string: " + sb.getDescription());
    // outer loop, read all the rule
    Rule rule = null;
    int ruleIndex = 0;
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
          String dpName = dataTable.get("dpName");
          if (dpName != null) {
            String finalDpName = resolveValue(dpName);
            Assertions.assertThat(row.getFilterValue())
                .as(f("DP show correct value : %s", finalDpName))
                .isEqualTo(finalDpName);
          }
          break;
        case "Zones":
          String zones = dataTable.get("zones");
          if (zones != null) {
            String finalZones = resolveValue(zones);
            Assertions.assertThat(row.getFilterValue())
                .as(f("Zones show correct value : %s", finalZones))
                .isEqualTo(finalZones);
          }
          break;
        case "Destination Hub":
          String destinationHub = dataTable.get("destinationHub");
          if (destinationHub != null) {
            String finalDestinationHub = resolveValue(destinationHub);
            Assertions.assertThat(row.getFilterValue())
                .as(f("Destination Hub show correct value : %s", finalDestinationHub))
                .isEqualTo(finalDestinationHub);
          }
          break;
        case "Marketplace Shipper":
          String masterShipper = dataTable.get("masterShipper");
          if (masterShipper != null) {
            String finalMasterShipper = resolveValue(masterShipper);
            Assertions.assertThat(row.getFilterValue())
                .as(f("Master shipper show correct value : %s", finalMasterShipper))
                .isEqualTo(finalMasterShipper);
          }
          break;
        case "Shipper":
        case "Exclude Shippers":
          String shipper = dataTable.get("shipper");
          if (shipper != null) {
            String finalShipper = resolveValue(shipper);
            doWithRetry(() -> {
              Assertions.assertThat(row.getFilterValue())
                  .as(f("shipper show correct value : %s", finalShipper))
                  .isEqualTo(finalShipper);
            },"Assert shipper filter show correct value ");
          }
          break;
        case "Granular Status":
          String statuses = String.join(", ", f.getGranularStatuses());
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
          String serviceLevels = dataTable.get("serviceLevel");
          doWithRetry(()->{Assertions.assertThat(row.getFilterValue())
              .as("Service levels show correct values")
              .isEqualTo(serviceLevels);},"Assert Service Levels");
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
  public void operatorVerifyNoSortBeltPresetIsCreated(Map<String,String>dataTable) {
    dataTable=resolveKeyValues(dataTable);
    SortBeltPresetEntity entity = new SortBeltPresetEntity();
    entity.setRulesString(dataTable.get("rulesString"));
    entity.setName(dataTable.get("name"));
    entity.setDescription(dataTable.get("description"));
    SortBeltPreset sb = SortBeltPreset.fromEntity(entity);
    Assertions.assertThat(sb)
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

  @And("Operator select {string} as the preset base on Sort Belt Preset page")
  public void operatorSelectBasePresetNameAsThePresetBaseOnSortBeltPresetPage(
      String basePresetName) {
    sortBeltPresetPage.presetBaseModal.waitUntilVisible();
    sortBeltPresetPage.presetBaseModal.presetBaseSelect.selectValue(basePresetName);
    sortBeltPresetPage.presetBaseModal.confirmBtn.click();
  }

  @Then("Operator select the preset from Sort Belt Preset page")
  public void operatorSelectThePresetFromSortBeltPresetPage() {
    sortBeltPresetPage.listItems.get(0).click();
  }

  @Then("Operator click edit on Sort Belt Preset Detail page")
  public void operatorClickEditOnSortBeltPresetDetailPage() {
    sortBeltPresetDetailPage.waitUntilLoaded();
    sortBeltPresetDetailPage.editButton.click();

  }

  @And("Operator take note the old preset name")
  public void operatorTakeNoteTheOldPresetName(Map<String,String>data) {
    data = resolveKeyValues(data);
    String oldPresetName = data.get("oldPresetName");
    put(KEY_UPDATED_SORT_BELT_PRESET_NAME, oldPresetName);
  }

  @And("Operator verify sort belt preset is not updated")
  public void operatorVerifySortBeltPresetIsNotUpdated(Map<String,String>data) {
    data = resolveKeyValues(data);
    String savedPreset = data.get("savedPreset");
    String oldName = data.get("oldName");

    Assertions.assertThat(savedPreset)
        .as("Preset name is not updated")
        .isEqualTo(oldName);
  }

  @When("Operator click on Edit button at the Check Sort Belt Preset detail page")
  public void operatorClickOnEditButtonAtTheCheckSortBeltPresetDetailPage() {
    checkSortBeltPresetPage.editButton.click();
    createPresetSortBeltPresetPage.waitUntilLoaded();
  }

  @When("Operator search sort belt preset by {string} name and make sure its {string}")
  public void operatorSearchSortBeltPresetByNameAndMakeSureIts(String name, String isExist) {
    String sortBeltPresetName = resolveValue(name);
    sortBeltPresetPage.assertSortBeltCreated(sortBeltPresetName,isExist);

  }
}
