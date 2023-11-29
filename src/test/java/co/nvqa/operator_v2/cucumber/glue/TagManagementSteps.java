package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.core.model.route.RouteTag;
import co.nvqa.common.core.utils.CoreScenarioStorageKeys;
import co.nvqa.operator_v2.selenium.page.SimpleReactPage;
import co.nvqa.operator_v2.selenium.page.TagManagementPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.Map;
import org.apache.commons.lang3.RandomStringUtils;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;

import static co.nvqa.operator_v2.selenium.page.TagManagementPage.TagsTable.ACTION_EDIT;
import static co.nvqa.operator_v2.selenium.page.TagManagementPage.TagsTable.COLUMN_NAME;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
@ScenarioScoped
public class TagManagementSteps extends AbstractSteps {

  private TagManagementPage tagManagementPage;

  public TagManagementSteps() {
  }

  @Override
  public void init() {
    tagManagementPage = new TagManagementPage(getWebDriver());
  }


  @When("Tag Management page is loaded")
  public void pageIsLoaded() {
    tagManagementPage.inFrame(SimpleReactPage::waitUntilLoaded);
  }

  @When("Operator create new route tag on Tag Management page:")
  public void createNewTag(Map<String, String> data) {
    tagManagementPage.inFrame(page -> {
      RouteTag newTag = new RouteTag(resolveKeyValues(data));
      if (StringUtils.equalsIgnoreCase("GENERATED", newTag.getName())) {
        newTag.setName(RandomStringUtils.randomAlphanumeric(3).toUpperCase());
      }
      put(KEY_CREATED_ROUTE_TAG, newTag);
      putInList(CoreScenarioStorageKeys.KEY_CORE_LIST_OF_CREATED_ROUTE_TAGS, newTag);
      page.createTag.click();
      page.addTagDialog.waitUntilVisible();
      page.addTagDialog.tagName.setValue(newTag.getName());
      page.addTagDialog.description.setValue(newTag.getDescription());
      page.addTagDialog.submit.click();
      page.addTagDialog.waitUntilInvisible();
    });
  }

  @Then("Operator verifies tag on Tag Management page:")
  public void verifyNewTagCreatedSuccessfully(Map<String, String> data) {
    tagManagementPage.inFrame(page -> {
      RouteTag expected = new RouteTag(resolveKeyValues(data));
      page.tagsTable.filterByColumn(COLUMN_NAME, expected.getName());
      Assertions.assertThat(page.tagsTable.isEmpty())
          .as("Tags Table is empty")
          .isFalse();
      RouteTag actual = page.tagsTable.readEntity(1);
      expected.compareWithActual(actual);
    });
  }

  @Then("Operator search tag on Tag Management page:")
  public void SearchTag(Map<String, String> data) {
    data = resolveKeyValues(data);
    String column = data.get("column");
    String value = data.get("value");
    tagManagementPage.inFrame(page -> {
      page.tagsTable.clearColumnFilters();
      page.tagsTable.filterByColumn(column, value);
    });
  }

  @Then("Operator verifies search result on Tag Management page:")
  public void verifySearchResult(Map<String, String> data) {
    tagManagementPage.inFrame(page -> {
      RouteTag tag = new RouteTag(resolveKeyValues(data));
      Assertions.assertThat(page.tagsTable.isEmpty())
          .as("Tags Table is empty")
          .isFalse();
      RouteTag actual = page.tagsTable.readEntity(1);
      tag.compareWithActual(actual);
    });
  }

  @When("Operator update {string} tag on Tag Management page:")
  public void updateTag(String tagName, Map<String, String> data) {
    String createdTagName = resolveValue(tagName);
    tagManagementPage.inFrame(page -> {
      RouteTag newTag = new RouteTag(resolveKeyValues(data));
      page.tagsTable.filterByColumn(COLUMN_NAME, createdTagName);
      Assertions.assertThat(page.tagsTable.isEmpty())
          .as("Tags Table is empty")
          .isFalse();

      tagManagementPage.tagsTable.clickActionButton(1, ACTION_EDIT);
      tagManagementPage.addTagDialog.waitUntilVisible();
      tagManagementPage.addTagDialog.tagName.setValue(newTag.getName());
      tagManagementPage.addTagDialog.description.setValue(newTag.getDescription());
      tagManagementPage.addTagDialog.submitChanges.click();
      tagManagementPage.addTagDialog.waitUntilInvisible();
      putInList(CoreScenarioStorageKeys.KEY_CORE_LIST_OF_CREATED_ROUTE_TAGS, newTag);
    });
  }
}