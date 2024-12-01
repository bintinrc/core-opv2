package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.common.core.model.order.OrderTag;
import co.nvqa.common.core.utils.CoreScenarioStorageKeys;
import co.nvqa.operator_v2.selenium.page.ManageOrderTagsPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.List;
import java.util.Map;
import org.apache.commons.lang3.RandomStringUtils;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;

import static co.nvqa.operator_v2.selenium.page.ManageOrderTagsPage.TagsTable.ACTION_DELETE;
import static co.nvqa.operator_v2.selenium.page.TagManagementPage.TagsTable.COLUMN_DESCRIPTION;
import static co.nvqa.operator_v2.selenium.page.TagManagementPage.TagsTable.COLUMN_NAME;

/**
 * @author Sergey Mishanin
 */
@SuppressWarnings("WeakerAccess")
@ScenarioScoped
public class ManageOrderTagsSteps extends AbstractSteps {

  private ManageOrderTagsPage manageOrderTagsPage;

  public ManageOrderTagsSteps() {
  }

  @Override
  public void init() {
    manageOrderTagsPage = new ManageOrderTagsPage(getWebDriver());
  }


  @When("Operator create new route tag on Manage Order Tags page:")
  public void createNewTag(Map<String, String> data) {
    OrderTag newTag = new OrderTag(resolveKeyValues(data));
    if (StringUtils.equalsIgnoreCase("GENERATED", newTag.getName())) {
      newTag.setName(RandomStringUtils.randomAlphanumeric(3).toUpperCase());
    }
    boolean getId = Boolean.parseBoolean(data.getOrDefault("getId", "true"));
    put(KEY_CREATED_ORDER_TAG, newTag);
    putInList(CoreScenarioStorageKeys.KEY_CORE_LIST_OF_CREATED_ORDER_TAGS, newTag);
    manageOrderTagsPage.inFrame(page -> {
      page.waitUntilLoaded();
      page.createTag.click();
      page.addTagDialog.waitUntilVisible();
      page.addTagDialog.tagName.setValue(newTag.getName());
      page.addTagDialog.description.setValue(newTag.getDescription());
      page.addTagDialog.submit.click();
      if (getId) {
        page.addTagDialog.waitUntilInvisible();
        String id = manageOrderTagsPage.noticeNotifications.get(0).message.getText();
        newTag.setId(Long.valueOf(id.split(" ")[1].trim()));
      }
    });
  }

  @Then("Operator verify the new tag is created successfully on Manage Order Tags page")
  public void verifyNewTagCreatedSuccessfully() {
    OrderTag tag = get(KEY_CREATED_ORDER_TAG);
    manageOrderTagsPage.inFrame(page -> {
      page.tagsTable.filterByColumn(COLUMN_NAME, tag.getName());
      int size = page.tagsTable.getRowsCount();
      OrderTag actual = null;
      for (int i = 1; i <= size; i++) {
        OrderTag next = page.tagsTable.readEntity(i);
        if (StringUtils.equals(tag.getName(), next.getName())) {
          actual = next;
          break;
        }
      }
      Assertions.assertThat(actual).as("Tag " + tag.getName() + " was not found").isNotNull();
      tag.compareWithActual(actual, "id");
    });
  }

  @Then("Operator filter tags on Manage Order Tags page:")
  public void filterTags(Map<String, String> data) {
    Map<String, String> finalData = resolveKeyValues(data);
    manageOrderTagsPage.inFrame(page -> {
      page.waitUntilLoaded();
      page.tagsTable.clearColumnFilters();
      if (finalData.containsKey(COLUMN_NAME)) {
        page.tagsTable.filterByColumn(COLUMN_NAME, finalData.get(COLUMN_NAME));
      }
      if (finalData.containsKey(COLUMN_DESCRIPTION)) {
        page.tagsTable.filterByColumn(COLUMN_DESCRIPTION, finalData.get(COLUMN_DESCRIPTION));
      }
    });
  }

  @Then("Operator verify tag record on Manage Order Tags page:")
  public void verifyTagRecord(Map<String, String> data) {
    OrderTag expected = new OrderTag(resolveKeyValues(data));
    manageOrderTagsPage.inFrame(page -> {
      List<OrderTag> actual = page.tagsTable.readAllEntities();
      OrderTag.assertListContains(actual, expected, "Tag");
    });
  }

  @When("Operator deletes {string} tag on Manage Order Tags page")
  public void deleteCreatedTagWithFiltering(String tagName) {
    String tagNameValue = resolveValue(tagName);
    manageOrderTagsPage.inFrame(page -> {
      page.waitUntilLoaded();
      page.tagsTable.filterByColumn(COLUMN_NAME, tagNameValue);
      int size = manageOrderTagsPage.tagsTable.getRowsCount();
      int index = 0;
      for (int i = 1; i <= size; i++) {
        OrderTag next = manageOrderTagsPage.tagsTable.readEntity(i);
        if (StringUtils.equals(tagNameValue, next.getName())) {
          index = i;
          break;
        }
      }
      page.tagsTable.clickActionButton(index, ACTION_DELETE);
      page.confirmDeleteDialog.waitUntilVisible();
      page.confirmDeleteDialog.delete.click();
    });
  }

  @When("Operator deletes {value} tag without filtering on Manage Order Tags page")
  public void deleteCreatedTag(String tagName) {
    manageOrderTagsPage.inFrame(page -> {
      page.waitUntilLoaded();
      int size = manageOrderTagsPage.tagsTable.getRowsCount();
      int index = 0;
      for (int i = 1; i <= size; i++) {
        OrderTag next = manageOrderTagsPage.tagsTable.readEntity(i);
        if (StringUtils.equals(tagName, next.getName())) {
          index = i;
          break;
        }
      }
      page.tagsTable.clickActionButton(index, ACTION_DELETE);
      page.confirmDeleteDialog.waitUntilVisible();
      page.confirmDeleteDialog.delete.click();
    });
  }

  @When("Operator verifies that {string} tag has been deleted on Manage Order Tags page")
  public void verifyTagHasBeenDeleted(String tagName) {
    String tagNameValue = resolveValue(tagName);
    manageOrderTagsPage.inFrame(page -> {
      page.tagsTable.filterByColumn(COLUMN_NAME, tagNameValue);
      int size = page.tagsTable.getRowsCount();
      for (int i = 1; i <= size; i++) {
        OrderTag next = page.tagsTable.readEntity(i);
        if (StringUtils.equals(tagNameValue, next.getName())) {
          throw new AssertionError(
              "Tag [" + tagNameValue + "] is displayed in Manage Order Tags table");
        }
      }
    });
  }
}