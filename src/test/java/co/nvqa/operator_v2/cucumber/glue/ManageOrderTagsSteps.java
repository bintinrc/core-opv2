package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Tag;
import co.nvqa.operator_v2.selenium.page.ManageOrderTagsPage;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.cucumber.guice.ScenarioScoped;
import java.util.Map;
import org.apache.commons.lang3.RandomStringUtils;
import org.apache.commons.lang3.StringUtils;

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
    manageOrderTagsPage.createTag.click();
    manageOrderTagsPage.addTagDialog.waitUntilVisible();
    manageOrderTagsPage.addTagDialog.tagName.setValue(newTag.getName());
    manageOrderTagsPage.addTagDialog.description.setValue(newTag.getDescription());
    manageOrderTagsPage.addTagDialog.submit.clickAndWaitUntilDone();
    manageOrderTagsPage.addTagDialog.waitUntilInvisible();
    String id = manageOrderTagsPage.toastSuccess.get(0).toastTop.getText();
    newTag.setId(Long.valueOf(id.split(" ")[1].trim()));
  }

  @Then("^Operator verify the new tag is created successfully on Manage Order Tags page$")
  public void verifyNewTagCreatedSuccessfully() {
    Tag tag = get(KEY_CREATED_ORDER_TAG);
    manageOrderTagsPage.tagsTable.sortColumn(COLUMN_NAME, true);
    int size = manageOrderTagsPage.tagsTable.getRowsCount();
    Tag actual = null;
    for (int i = 1; i <= size; i++) {
      Tag next = manageOrderTagsPage.tagsTable.readEntity(i);
      if (StringUtils.equals(tag.getName(), next.getName())) {
        actual = next;
        break;
      }
    }
    assertNotNull("Tag " + tag.getName() + " was not found", actual);
    tag.compareWithActual(actual, "id");
  }

  @When("Operator deletes created tag on Manage Order Tags page")
  public void deleteCreatedTag() {
    Tag tag = get(KEY_CREATED_ORDER_TAG);

    manageOrderTagsPage.tagsTable.sortColumn(COLUMN_NAME, true);

    int size = manageOrderTagsPage.tagsTable.getRowsCount();
    int index = 0;
    for (int i = 1; i <= size; i++) {
      Tag next = manageOrderTagsPage.tagsTable.readEntity(i);
      if (StringUtils.equals(tag.getName(), next.getName())) {
        index = i;
        break;
      }
    }

    manageOrderTagsPage.tagsTable.clickActionButton(index, ACTION_DELETE);
    manageOrderTagsPage.confirmDeleteDialog.confirmDelete();
  }

  @When("Operator verifies that created tag has been deleted on Manage Order Tags page")
  public void verifyTagHasBeenDeleted() {
    Tag tag = get(KEY_CREATED_ORDER_TAG);

    manageOrderTagsPage.tagsTable.sortColumn(COLUMN_NAME, true);

    int size = manageOrderTagsPage.tagsTable.getRowsCount();
    int index = 0;
    for (int i = 1; i <= size; i++) {
      Tag next = manageOrderTagsPage.tagsTable.readEntity(i);
      if (StringUtils.equals(tag.getName(), next.getName())) {
        throw new AssertionError(
            "Tag [" + tag.getName() + "] is not displayed in Manage Order Tags table");
      }
    }
  }
}