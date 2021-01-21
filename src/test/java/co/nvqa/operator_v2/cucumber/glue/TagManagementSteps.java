package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.core.Tag;
import co.nvqa.operator_v2.selenium.page.TagManagementPage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import java.util.Map;
import org.apache.commons.lang3.RandomStringUtils;
import org.apache.commons.lang3.StringUtils;

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


  @When("^Operator create new route tag on Tag Management page:$")
  public void createNewTag(Map<String, String> data) {
    data = resolveKeyValues(data);
    Tag newTag = new Tag(resolveKeyValues(data));
    if (StringUtils.equalsIgnoreCase("GENERATED", newTag.getName())) {
      newTag.setName(RandomStringUtils.randomAlphanumeric(3).toUpperCase());
    }
    put(KEY_CREATED_ROUTE_TAG, newTag);
    tagManagementPage.createTag.click();
    tagManagementPage.addTagDialog.waitUntilVisible();
    tagManagementPage.addTagDialog.tagName.setValue(newTag.getName());
    tagManagementPage.addTagDialog.description.setValue(newTag.getDescription());
    tagManagementPage.addTagDialog.submit.clickAndWaitUntilDone();
    tagManagementPage.addTagDialog.waitUntilInvisible();
    String id = tagManagementPage.toastSuccess.get(0).toastTop.getText();
    newTag.setId(Long.valueOf(id.split(" ")[1].trim()));
  }

  @Then("^Operator verify the new tag is created successfully on Tag Management$")
  public void verifyNewTagCreatedSuccessfully() {
    Tag tag = get(KEY_CREATED_ROUTE_TAG);
    tagManagementPage.tagsTable.sortColumn(COLUMN_NAME, true);
    int size = tagManagementPage.tagsTable.getRowsCount();
    Tag actual = null;
    for (int i = 1; i <= size; i++) {
      Tag next = tagManagementPage.tagsTable.readEntity(i);
      if (StringUtils.equals(tag.getName(), next.getName())) {
        actual = next;
        break;
      }
    }
    assertNotNull("Tag " + tag.getName() + " was not found", actual);
    tag.compareWithActual(actual, "id");
  }

  @When("^Operator update created tag on Tag Management page:$")
  public void updateTag(Map<String, String> data) {
    Tag tag = get(KEY_CREATED_ROUTE_TAG);
    Tag newTag = new Tag(resolveKeyValues(data));

    tagManagementPage.tagsTable.sortColumn(COLUMN_NAME, true);

    int size = tagManagementPage.tagsTable.getRowsCount();
    int index = 0;
    for (int i = 1; i <= size; i++) {
      Tag next = tagManagementPage.tagsTable.readEntity(i);
      if (StringUtils.equals(tag.getName(), next.getName())) {
        index = i;
        break;
      }
    }

    tagManagementPage.tagsTable.clickActionButton(index, ACTION_EDIT);
    tagManagementPage.addTagDialog.waitUntilVisible();
    tagManagementPage.addTagDialog.tagName.setValue(newTag.getName());
    tagManagementPage.addTagDialog.description.setValue(newTag.getDescription());
    tagManagementPage.addTagDialog.submitChanges.clickAndWaitUntilDone();
    tagManagementPage.addTagDialog.waitUntilInvisible();

    tag.merge(newTag);
  }

  @Then("^Operator verify the tag is updated successfully on Tag Management$")
  public void verifyTagUpdatedSuccessfully() {
    Tag tag = get(KEY_CREATED_ROUTE_TAG);
    tagManagementPage.tagsTable.sortColumn(COLUMN_NAME, true);
    int size = tagManagementPage.tagsTable.getRowsCount();
    Tag actual = null;
    for (int i = 1; i <= size; i++) {
      Tag next = tagManagementPage.tagsTable.readEntity(i);
      if (StringUtils.equals(tag.getName(), next.getName())) {
        actual = next;
        break;
      }
    }
    assertNotNull("Tag " + tag.getName() + " was not found", actual);
    tag.compareWithActual(actual, "id", "createdAt", "updatedAt", "deletedAt");
  }
}