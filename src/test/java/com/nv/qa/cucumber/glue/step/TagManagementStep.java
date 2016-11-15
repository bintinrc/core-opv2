package com.nv.qa.cucumber.glue.step;

import com.nv.qa.selenium.page.page.TagManagementPage;
import com.nv.qa.support.SeleniumSharedDriver;
import cucumber.api.Scenario;
import cucumber.api.java.After;
import cucumber.api.java.Before;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.junit.Assert;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class TagManagementStep
{
    private static final String DEFAULT_TAG_NAME = "AAA";
    private static final String EDITED_TAG_NAME = "AAB";
    private static final String DEFAULT_TAG_DESCRIPTION = "This tag is created by Automation Test for testing purpose only. Ignore this tag.";
    private static final String EDITED_TAG_DESCRIPTION = DEFAULT_TAG_DESCRIPTION + " [EDITED]";

    private WebDriver driver;
    private TagManagementPage tagManagementPage;

    public TagManagementStep()
    {
    }

    @Before
    public void setup()
    {
        driver = SeleniumSharedDriver.getInstance().getDriver();
        tagManagementPage = new TagManagementPage(driver);
    }

    @After
    public void teardown(Scenario scenario)
    {
        if(scenario.isFailed())
        {
            final byte[] screenshot = ((TakesScreenshot) driver).getScreenshotAs(OutputType.BYTES);
            scenario.embed(screenshot, "image/png");
        }
    }

    @When("^op create new tag on Tag Management$")
    public void createNewTag()
    {
        /**
         * Check is tag name already exists. If tag is exists, delete that tag first.
         * Check twice:
         * 1. DEFAULT_TAG_NAME = AAA
         * 2. EDITED_TAG_NAME = AAB
         */
        tagManagementPage.clickTagNameColumnHeader();

        for(int i=0; i<2; i++)
        {
            String actualTagName = tagManagementPage.getTextOnTable(1, TagManagementPage.COLUMN_CLASS_TAG_NAME);

            if(DEFAULT_TAG_NAME.equals(actualTagName) || EDITED_TAG_NAME.equals(actualTagName))
            {
                tagManagementPage.clickActionButton(1, TagManagementPage.ACTION_BUTTON_DELETE);
                tagManagementPage.pause100ms();
                tagManagementPage.clickDeleteOnConfirmDeleteDialog();
            }
            else
            {
                break; // Quit from loop if cannot find DEFAULT_TAG_NAME or EDITED_TAG_NAME on the first row.
            }
        }

        tagManagementPage.clickCreateTag();
        tagManagementPage.setTagNameValue(DEFAULT_TAG_NAME);
        tagManagementPage.setDescriptionValue(DEFAULT_TAG_DESCRIPTION);
        tagManagementPage.clickSubmitOnAddTag();
    }

    @Then("^new tag on Tag Management created successfully$")
    public void verifyNewTagCreatedSuccessfully()
    {
        String actualTagName = tagManagementPage.getTextOnTable(1, TagManagementPage.COLUMN_CLASS_TAG_NAME);
        Assert.assertEquals(DEFAULT_TAG_NAME, actualTagName);
    }

    @When("^op update tag on Tag Management$")
    public void updateTag()
    {
        /**
         * Check first row is tag DEFAULT_TAG_NAME.
         */
        String actualTagName = tagManagementPage.getTextOnTable(1, TagManagementPage.COLUMN_CLASS_TAG_NAME);
        Assert.assertEquals(DEFAULT_TAG_NAME, actualTagName);

        tagManagementPage.clickActionButton(1, TagManagementPage.ACTION_BUTTON_EDIT);
        tagManagementPage.setTagNameValue(EDITED_TAG_NAME);
        tagManagementPage.setDescriptionValue(EDITED_TAG_DESCRIPTION);
        tagManagementPage.clickSubmitChangesOnEditTag();
    }

    @Then("^tag on Tag Management updated successfully$")
    public void verifyTagManagementUpdatedSuccessfully()
    {
        String actualTagName = tagManagementPage.getTextOnTable(1, TagManagementPage.COLUMN_CLASS_TAG_NAME);
        String actualTagDescription = tagManagementPage.getTextOnTable(1, TagManagementPage.COLUMN_CLASS_DESCRIPTION);
        Assert.assertEquals(EDITED_TAG_NAME, actualTagName);
        Assert.assertEquals(EDITED_TAG_DESCRIPTION, actualTagDescription);
    }

    @When("^op delete tag on Tag Management$")
    public void deleteTag()
    {
        /**
         * Check first row is tag EDITED_TAG_NAME.
         */
        String actualTagName = tagManagementPage.getTextOnTable(1, TagManagementPage.COLUMN_CLASS_TAG_NAME);
        Assert.assertEquals(EDITED_TAG_NAME, actualTagName);

        tagManagementPage.clickActionButton(1, TagManagementPage.ACTION_BUTTON_DELETE);
        tagManagementPage.pause100ms();
        tagManagementPage.clickDeleteOnConfirmDeleteDialog();
    }

    @Then("^tag on Tag Management deleted successfully$")
    public void verifyTagDeletedSuccessfully()
    {
        /**
         * Check first row does not contain tag EDITED_TAG_NAME.
         */
        String actualTagName = tagManagementPage.getTextOnTable(1, TagManagementPage.COLUMN_CLASS_TAG_NAME);
        Assert.assertNotEquals(EDITED_TAG_NAME, actualTagName);
    }
}
