package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.TagManagementPage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.junit.Assert;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class TagManagementSteps extends AbstractSteps
{
    public static final String DEFAULT_TAG_NAME = "AAA";
    public static final String EDITED_TAG_NAME = "AAB";
    private static final String DEFAULT_TAG_DESCRIPTION = "This tag is created by Automation Test for testing purpose only. Ignore this tag.";
    private static final String EDITED_DEFAULT_TAG_DESCRIPTION = DEFAULT_TAG_DESCRIPTION + " [EDITED]";

    private TagManagementPage tagManagementPage;

    public TagManagementSteps()
    {
    }

    @Override
    public void init()
    {
        tagManagementPage = new TagManagementPage(getWebDriver());
    }

    @When("^Operator create new tag on Tag Management$")
    public void createNewTag()
    {
        /*
          Check is tag name already exists. If tag is exists, delete that tag first.
          Check twice:
          1. DEFAULT_TAG_NAME = AAA
          2. EDITED_TAG_NAME = AAB
         */
        tagManagementPage.clickTagNameColumnHeader();

        //This code below is removed because KH said the ops want that button to be removed.
        /*for(int i=0; i<2; i++)
        {
            String actualTagName = tagManagementPage.getTextOnTable(1, TagManagementPage.COLUMN_CLASS_TAG_NAME);

            if(DEFAULT_TAG_NAME.equals(actualTagName) || EDITED_TAG_NAME.equals(actualTagName))
            {
                tagManagementPage.clickActionButtonOnTable(1, TagManagementPage.ACTION_BUTTON_DELETE);
                pause100ms();
                tagManagementPage.clickDeleteOnConfirmDeleteDialog();
            }
            else
            {
                break; // Quit from loop if cannot find DEFAULT_TAG_NAME or EDITED_TAG_NAME on the first row.
            }
        }*/

        tagManagementPage.clickCreateTag();
        tagManagementPage.setTagNameValue(DEFAULT_TAG_NAME);
        tagManagementPage.setDescriptionValue(DEFAULT_TAG_DESCRIPTION);
        tagManagementPage.clickSubmitOnAddTag();
    }

    @Then("^Operator verify the new tag is created successfully on Tag Management$")
    public void verifyNewTagCreatedSuccessfully()
    {
        retryIfAssertionErrorOccurred(()->
        {
            reloadPageAndEnableSortByName();

            String actualTagName = tagManagementPage.getTextOnTable(1, TagManagementPage.COLUMN_CLASS_DATA_TAG_NAME);
            Assert.assertEquals(DEFAULT_TAG_NAME, actualTagName);
        }, f("verifyNewTagCreatedSuccessfully - [Expected Tag Name = %s]", DEFAULT_TAG_NAME), getScenarioManager()::writeToCurrentScenarioLog);
    }

    @When("^Operator update tag on Tag Management$")
    public void updateTag()
    {
        /*
          Check first row is tag DEFAULT_TAG_NAME.
         */
        String actualTagName = tagManagementPage.getTextOnTable(1, TagManagementPage.COLUMN_CLASS_DATA_TAG_NAME);
        Assert.assertEquals(DEFAULT_TAG_NAME, actualTagName);

        tagManagementPage.clickActionButtonOnTable(1, TagManagementPage.ACTION_BUTTON_EDIT);
        tagManagementPage.setTagNameValue(EDITED_TAG_NAME);
        tagManagementPage.setDescriptionValue(EDITED_DEFAULT_TAG_DESCRIPTION);
        tagManagementPage.clickSubmitChangesOnEditTag();
    }

    @Then("^Operator verify the tag is updated successfully on Tag Management$")
    public void verifyTagUpdatedSuccessfully()
    {
        retryIfAssertionErrorOccurred(()->
        {
            reloadPageAndEnableSortByName();

            String actualTagName = tagManagementPage.getTextOnTable(1, TagManagementPage.COLUMN_CLASS_DATA_TAG_NAME);
            Assert.assertEquals(EDITED_TAG_NAME, actualTagName);

            String actualTagDescription = tagManagementPage.getTextOnTable(1, TagManagementPage.COLUMN_CLASS_DATA_DESCRIPTION);
            Assert.assertEquals(EDITED_DEFAULT_TAG_DESCRIPTION, actualTagDescription);
        }, "verifyTagUpdatedSuccessfully", getScenarioManager()::writeToCurrentScenarioLog);
    }

    @When("^Operator delete tag on Tag Management$")
    public void deleteTag()
    {
        reloadPageAndEnableSortByName();

        /*
          Check first row is tag EDITED_TAG_NAME.
         */
        String actualTagName = tagManagementPage.getTextOnTable(1, TagManagementPage.COLUMN_CLASS_DATA_TAG_NAME);
        Assert.assertEquals(EDITED_TAG_NAME, actualTagName);

        tagManagementPage.clickActionButtonOnTable(1, TagManagementPage.ACTION_BUTTON_DELETE);
        pause100ms();
        tagManagementPage.clickDeleteOnConfirmDeleteDialog();
        pause200ms();
    }

    @Then("^Operator verify the tag is deleted successfully on Tag Management$")
    public void verifyTagDeletedSuccessfully()
    {
        /*
          Check first row does not contain tag EDITED_TAG_NAME.
         */
        String actualTagName = tagManagementPage.getTextOnTable(1, TagManagementPage.COLUMN_CLASS_DATA_TAG_NAME);
        Assert.assertNotEquals(EDITED_TAG_NAME, actualTagName);
    }

    private void reloadPageAndEnableSortByName()
    {
        reloadPage();
        tagManagementPage.clickTagNameColumnHeader(); // Enable sort name ascending.
    }
}
