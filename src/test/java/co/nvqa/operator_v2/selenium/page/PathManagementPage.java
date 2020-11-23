package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

import java.util.Arrays;
import java.util.List;

/**
 * Created on 17/11/20.
 *
 * @author refowork
 */
@SuppressWarnings("WeakerAccess")
public class PathManagementPage extends OperatorV2SimplePage {
    @FindBy(tagName = "iframe")
    private PageElement pageFrame;

    @FindBy(xpath = "//button[.='Default Path']")
    public Button defaultPathButton;

    @FindBy(xpath = "//span[.='Show / Hide Filters']")
    public PageElement showHideFilters;

    @FindBy(id = "pathType")
    public AntSelect pathTypeFilter;

    @FindBy(id = "originHubs")
    public AntSelect originHubFilter;

    @FindBy(id = "destinationHubs")
    public AntSelect destinationHubFilter;

    @FindBy(xpath = "//button[.='Load Selection']")
    public Button loadSelectionButton;

    @FindBy(xpath = "//div[contains(@class,'ant-spin-blur')]")
    public PageElement antBlurSpinner;

    @FindBy(xpath = "//tr[1]//td[contains(@class, 'originHubName')]//span")
    public TextBox originHubFirstRow;

    @FindBy(xpath = "//tr[1]//td[contains(@class, 'destinationHubName')]//span")
    public TextBox destinationHubFirstRow;

    @FindBy(xpath = "//tr[1]//td[contains(@class, 'path')]//div[@class='ant-tag']")
    public TextBox pathTagFirstRow;

    @FindBy(xpath = "//tr[1]//td[contains(@class, 'pathItems')]//span")
    public TextBox pathFirstRow;

    @FindBy(xpath = "//tr[1]//td[contains(@class, 'action')]")
    public TextBox actionFirstRow;

    @FindBy(xpath = "//tr[1]//td[contains(@class, 'action')]//a[.='View']")
    public PageElement viewFirstRow;

    @FindBy(className = "ant-modal-wrap")
    public PathDetailsModal pathDetailsModal;

    @FindBy(xpath = "//th[contains(@class,'originHubName')]//input")
    public PageElement originHubField;

    public PathManagementPage(WebDriver webDriver) {
        super(webDriver);
    }

    public void switchTo() {
        getWebDriver().switchTo().frame(pageFrame.getWebElement());
    }

    public void selectPathType(String value) {
        pathTypeFilter.selectValueWithoutSearch(value);
    }

    public void selectOriginHub(String value) {
        originHubFilter.selectValue(value);
    }

    public void selectDestinationHub(String value) {
        destinationHubFilter.selectValue(value);
    }

    public void verifyDataAppearInPathTable(String pathType) {
        String originHubName = originHubFirstRow.getText();
        String destinationHubName = destinationHubFirstRow.getText();
        String pathTagText = "";
        String path = pathFirstRow.getText();
        String actionText = actionFirstRow.getText();

        String expectedActionText = "View";
        if ("default paths".equals(pathType)) {
            pathType = "Default";
            pathTagText = pathTagFirstRow.getText();
        }
        if ("manual paths".equals(pathType)) {
            pathType = "";
            expectedActionText += "EditRemove";
        }

        assertThat("Origin Hub not empty", originHubName, not(equalTo("")));
        assertThat("Destination Hub not empty", destinationHubName, not(equalTo("")));
        assertThat("Path Tag is not empty", pathTagText, equalTo(pathType));
        assertThat("Path is not empty", path, not(equalTo("")));
        assertThat("Action Text is not empty", actionText, equalTo(expectedActionText));
    }

    public void verifyShownPathDetail(String pathType) {
        pause3s();
        String pathDetailsRaw = pathDetailsModal.pathDetails.getText();
        String actualPath = pathDetailsRaw.split("Path Type")[0].split("Path")[1].trim();
        String actualPathType = pathDetailsRaw.split("Movement Type")[0].split("Path Type")[1].trim();
        String actualMovementType = pathDetailsRaw.split("Movement Type")[1].trim();

        String expectedPathType = "AUTO_GENERATED";
        if ("manual paths".equals(pathType)) {
            expectedPathType = "MANUAL";
        }

        assertThat("Actual Path is true", actualPath, not(equalTo("")));
        assertThat("Actual Path Type is true", actualPathType, equalTo(expectedPathType));
        assertThat("Actual Movement Type is true", actualMovementType, not(equalTo("")));

        Boolean actualAddManualPathButtonExistence = pathDetailsModal.addManualPathButton.isDisplayed();
        assertThat("Add Manual Path Button existed", actualAddManualPathButtonExistence, equalTo(true));
        if ("manual paths".equals(pathType)) {
            String actualPathScheduleTableHeadText = pathDetailsModal.pathScheduleTableHead.getText();
            String departureTimeText = "Departure Time";
            String daysOfWeekText = "Days of Week";
            assertThat("Departure Time in Table Head", actualPathScheduleTableHeadText, containsString(departureTimeText));
            assertThat("Departure Time in Table Head", actualPathScheduleTableHeadText, containsString(daysOfWeekText));

            Boolean actualRemoveManualPathButtonExistence = pathDetailsModal.removePathButton.isDisplayed();
            assertThat("Remove Manual Path Button existed", actualRemoveManualPathButtonExistence, equalTo(true));

            Boolean actualEditManualPathButtonExistence = pathDetailsModal.editPathButton.isDisplayed();
            assertThat("Edit Manual Path Button existed", actualEditManualPathButtonExistence, equalTo(true));
        }
    }

    public void verifyPathDataAppearInPathTable(String expectedOriginHub, String expectedDestinationHub) {
        String originHubName = originHubFirstRow.getText();
        String destinationHubName = destinationHubFirstRow.getText();
        String path = pathFirstRow.getText();

        String expectedPath = expectedOriginHub + " → " + expectedDestinationHub;

        assertThat("Origin Hub is equal", originHubName, equalTo(expectedOriginHub));
        assertThat("Destination Hub is equal", destinationHubName, equalTo(expectedDestinationHub));
        assertThat("Path is equal", path, equalTo(expectedPath));
        String actualActionText = actionFirstRow.getText();
        assertThat("View Hyperlink in action column", actualActionText, containsString("View"));
        assertThat("View Hyperlink in action column", actualActionText, containsString("Edit"));
        assertThat("View Hyperlink in action column", actualActionText, containsString("Remove"));
    }

    public void searchOriginHub(String resolvedValue) {
        originHubField.sendKeys(resolvedValue);
    }

    public static class PathDetailsModal extends AntModal {
        public PathDetailsModal(WebDriver webDriver, WebElement webElement) {
            super(webDriver, webElement);
            PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
        }

        @FindBy(xpath = ".//button[.='Manual Path']")
        public Button addManualPathButton;

        @FindBy(xpath = ".//button[.='Remove Path']")
        public Button removePathButton;

        @FindBy(xpath = ".//button[.='Edit Path']")
        public Button editPathButton;

        @FindBy(className = "ant-card-body")
        public TextBox pathDetails;

        @FindBy(xpath = "//thead[@class='ant-table-thead']")
        public PageElement pathScheduleTableHead;
    }

}
