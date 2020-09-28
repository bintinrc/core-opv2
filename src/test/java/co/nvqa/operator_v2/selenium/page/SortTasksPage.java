package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

/**
 * @author Niko Susanto
 */
@SuppressWarnings("WeakerAccess")
public class SortTasksPage extends OperatorV2SimplePage
{
    private static final String IFRAME_XPATH = "//iframe[contains(@src,'sort-tasks')]";

    @FindBy(xpath = "(//div[@id='hubId'])[1]")
    public AntSelect selectHub;

    @FindBy(xpath = "(//button[contains(@class,'ant-btn')])[1]")
    public Button load;

    @FindBy(xpath = "(//span[contains(text(), 'Add/Remove Outputs')])[1]")
    public PageElement sideBar;

    @FindBy(xpath = "//button/span[contains(text(), 'Create new middle tier')]")
    public Button createNewMidTier;

    @FindBy(id = "name")
    public PageElement midTierName;

    @FindBy(xpath = "//button/span[text()='Create']")
    public Button create;

    @FindBy(xpath = "(//input[@placeholder='Find...'])[1]")
    public PageElement find;

    @FindBy(xpath = "//span/mark[@class='highlight ']")
    public PageElement actualSortName;

    @FindBy(xpath = "//td[@class='hubName']/span/span")
    public PageElement actualHubName;

    @FindBy(xpath = "//td[@class='type.name']/span/span")
    public PageElement actualSortType;

    @FindBy(xpath = "//a[@class='link']/span")
    public PageElement delete;

    @FindBy(xpath = "//button//span[text()='Confirm']")
    public Button confirm;

    @FindBy(xpath = "//div[contains(@class,'NoResult')]/span")
    public PageElement noResult;

    public SortTasksPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void selectHub (String hubName)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));

        selectHub.waitUntilClickable();
        selectHub.jsClick();
        pause1s();

        selectHub.searchInput.sendKeys(hubName);
        selectHub.searchInput.sendKeys(Keys.RETURN);
        load.waitUntilClickable();
        load.click();

        getWebDriver().switchTo().parentFrame();
    }

    public void openSidebar()
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));

        pause1s();
        sideBar.click();

        getWebDriver().switchTo().parentFrame();
    }

    public void createMiddleTier(String name)
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));

        createNewMidTier.click();
        midTierName.sendKeys(name);
        create.waitUntilClickable();
        create.click();
    }

    public void verifyMidTierIsExistAndDataIsCorrect(String sortName, String hubName, String sortType)
    {
        find.sendKeys(sortName);
        assertThat("Sort Name", actualSortName.getText(), equalToIgnoringCase(sortName));
        assertThat("Hub Name", actualHubName.getText(), equalToIgnoringCase(hubName));
        assertThat("Sort Name", actualSortType.getText(), equalToIgnoringCase(sortType));

        getWebDriver().switchTo().parentFrame();
    }

    public void deleteMidTier()
    {
        getWebDriver().switchTo().frame(findElementByXpath(IFRAME_XPATH));

        delete.click();
        confirm.waitUntilClickable();
        confirm.click();
    }

    public void verifyMidTierIsDeleted()
    {
        assertThat("Result", noResult.getText(), equalToIgnoringCase("No Results Found"));

        getWebDriver().switchTo().parentFrame();
    }
}