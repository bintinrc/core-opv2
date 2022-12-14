package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Tag;
import co.nvqa.operator_v2.selenium.page.ManageOrderTagsPage;
import io.cucumber.guice.ScenarioScoped;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import java.util.Map;
import org.apache.commons.lang3.RandomStringUtils;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;

import static co.nvqa.operator_v2.selenium.page.ManageOrderTagsPage.TagsTable.ACTION_DELETE;
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


  @When("^Operator create new route tag on Manage Order Tags page:$")
  public void createNewTag(Map<String, String> data) {
    data = resolveKeyValues(data);
    Tag newTag = new Tag(resolveKeyValues(data));
    if (StringUtils.equalsIgnoreCase("GENERATED", newTag.getName())) {
      newTag.setName(RandomStringUtils.randomAlphanumeric(3).toUpperCase());
    }
    put(KEY_CREATED_ORDER_TAG, newTag);
    putInList(KEY_LIST_OF_CREATED_ORDER_TAGS, newTag);
    manageOrderTagsPage.inFrame(page -> {
      page.waitUntilLoaded();
      page.createTag.click();
      page.addTagDialog.waitUntilVisible();
      page.addTagDialog.tagName.setValue(newTag.getName());
      page.addTagDialog.description.setValue(newTag.getDescription());
      page.addTagDialog.submit.click();
      page.addTagDialog.waitUntilInvisible();
      String id = manageOrderTagsPage.noticeNotifications.get(0).message.getText();
      newTag.setId(Long.valueOf(id.split(" ")[1].trim()));
    });
  }

  @Then("^Operator verify the new tag is created successfully on Manage Order Tags page$")
  public void verifyNewTagCreatedSuccessfully() {
    Tag tag = get(KEY_CREATED_ORDER_TAG);
    manageOrderTagsPage.inFrame(page -> {
      page.tagsTable.filterByColumn(COLUMN_NAME, tag.getName());
      int size = page.tagsTable.getRowsCount();
      Tag actual = null;
      for (int i = 1; i <= size; i++) {
        Tag next = page.tagsTable.readEntity(i);
        if (StringUtils.equals(tag.getName(), next.getName())) {
          actual = next;
          break;
        }
      }
      Assertions.assertThat(actual).as("Tag " + tag.getName() + " was not found").isNotNull();
      tag.compareWithActual(actual, "id");
    });
  }

  @When("Operator deletes created tag on Manage Order Tags page")
  public void deleteCreatedTag() {
    Tag tag = get(KEY_CREATED_ORDER_TAG);
    manageOrderTagsPage.inFrame(page -> {
      page.waitUntilLoaded();
      page.tagsTable.filterByColumn(COLUMN_NAME, tag.getName());
      int size = manageOrderTagsPage.tagsTable.getRowsCount();
      int index = 0;
      for (int i = 1; i <= size; i++) {
        Tag next = manageOrderTagsPage.tagsTable.readEntity(i);
        if (StringUtils.equals(tag.getName(), next.getName())) {
          index = i;
          break;
        }
      }
      page.tagsTable.clickActionButton(index, ACTION_DELETE);
      page.confirmDeleteDialog.waitUntilVisible();
      page.confirmDeleteDialog.delete.click();
    });
  }

  @When("Operator verifies that created tag has been deleted on Manage Order Tags page")
  public void verifyTagHasBeenDeleted() {
    Tag tag = get(KEY_CREATED_ORDER_TAG);
    manageOrderTagsPage.inFrame(page -> {
      page.tagsTable.filterByColumn(COLUMN_NAME, tag.getName());
      int size = page.tagsTable.getRowsCount();
      for (int i = 1; i <= size; i++) {
        Tag next = page.tagsTable.readEntity(i);
        if (StringUtils.equals(tag.getName(), next.getName())) {
          throw new AssertionError(
              "Tag [" + tag.getName() + "] is displayed in Manage Order Tags table");
        }
      }
    });
  }
}