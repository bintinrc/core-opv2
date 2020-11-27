package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.Color;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

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

    @FindBy(xpath = "//div[contains(@class,'nv-h4')]")
    private PageElement parentPageTitle;

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

    @FindBy(xpath = "//button[.='Manual Path']")
    public Button addManualPathButton;

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

    @FindBy(className = "ant-modal-wrap")
    public CreateManualPathModal createManualPathModal;

    @FindBy(xpath = "(//div[@class='ant-modal-wrap '])[2]")
    public PathDetailsModal createdPathDetailsModal;

    @FindBy(xpath = "//div[contains(@class,'footer-row')]")
    public TextBox footerRowDiv;

    @FindBy(xpath = "//th[contains(@class,'originHubName')]//input")
    public PageElement originHubField;

    @FindBy(xpath = "//th[contains(@class,'destinationHubName')]//input")
    private PageElement destinationHubField;

    @FindBy(xpath = "//th[contains(@class,'pathItems')]//input")
    private PageElement pathField;

    @FindBy(xpath = "//div[@class='ant-notification-notice-message']")
    public PageElement antNotificationMessage;

    @FindBy(className = "ant-notification-notice-close")
    public PageElement closeAntNotificationMessage;

    public PathManagementPage(WebDriver webDriver) {
        super(webDriver);
    }

    public void switchTo() {
        getWebDriver().switchTo().frame(pageFrame.getWebElement());
    }

    public void switchToParentFrame() {
        getWebDriver().switchTo().parentFrame();
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

    public void verifyPathDataAppearInPathTable(String expectedOriginHub, String expectedDestinationHub, List<String> passedHub) {
        String originHubName = originHubFirstRow.getText();
        String destinationHubName = destinationHubFirstRow.getText();
        String path = pathFirstRow.getText();

        String expectedPath = String.join(" → ", passedHub);

        assertThat("Origin Hub is equal", originHubName, equalTo(expectedOriginHub));
        assertThat("Destination Hub is equal", destinationHubName, equalTo(expectedDestinationHub));
        assertThat("Path is equal", path, equalTo(expectedPath));
        String actualActionText = actionFirstRow.getText();
        assertThat("View Hyperlink in action column", actualActionText, containsString("View"));
        assertThat("View Hyperlink in action column", actualActionText, containsString("Edit"));
        assertThat("View Hyperlink in action column", actualActionText, containsString("Remove"));
    }

    public void verifyNoResultsFound() {
        String actualMessage = footerRowDiv.getText();
        String expectedMessage = "No Results Found";
        assertThat("Message is no results found", actualMessage, equalTo(expectedMessage));
    }

    public void searchOriginHub(String resolvedValue) {
        originHubField.sendKeys(resolvedValue);
    }

    public void searchDestinationHub(String resolvedValue) {
        destinationHubField.sendKeys(resolvedValue);
    }

    public void searchPath(String resolvedValue) {
        pathField.sendKeys(resolvedValue);
    }

    public void createManualPathFirstStage(String originHubName, String destinationHubName) {
        String actualCreateManualPathModalTitle = createManualPathModal.modalTitle.getText();
        String expectedFirstCreateManualPathModalTitle = "Create Manual Path (1/3)";
        assertThat("Modal title is the same", actualCreateManualPathModalTitle, equalTo(expectedFirstCreateManualPathModalTitle));
        createManualPathModal.originHubFilter.selectValue(originHubName);
        createManualPathModal.destinationHubFilter.selectValue(destinationHubName);
    }

    public void createManualPathSecondStage(String transitHubName, String transitHubInfo) {
        String actualCreateManualPathModalTitle = createManualPathModal.modalTitle.getText();
        String expectedSecondCreateManualPathModalTitle = "Create Manual Path (2/3)";
        assertThat("Modal title is the same", actualCreateManualPathModalTitle, equalTo(expectedSecondCreateManualPathModalTitle));
        if (transitHubName != null) {
            switch (transitHubInfo) {
                case "first":
                    createManualPathModal.firstTransitHubFilter.selectValue(transitHubName);
                    break;
                case "second":
                    createManualPathModal.secondTransitHubFilter.selectValue(transitHubName);
                    break;
                case "third":
                    createManualPathModal.thirdTransitHubFilter.selectValue(transitHubName);
                    break;
            }
        }
    }

    public void createManualPathThirdStage(Boolean hasMultipleSchedule) {
        String actualCreateManualPathModalTitle = createManualPathModal.modalTitle.getText();
        String expectedThirdCreateManualPathModalTitle = "Create Manual Path (3/3)";
        assertThat("Modal title is the same", actualCreateManualPathModalTitle, equalTo(expectedThirdCreateManualPathModalTitle));
        createManualPathModal.departureScheduleFirst.click();
        if (hasMultipleSchedule) {
            createManualPathModal.departureScheduleSecond.click();
        }
    }

    public void verifyNotificationMessageIsShown(String expectedNotificationMessage) {
        antNotificationMessage.waitUntilVisible();
        String actualNotificationMessage = antNotificationMessage.getText();
        assertThat("Notification message is the same", actualNotificationMessage, equalTo(expectedNotificationMessage));
        closeAntNotificationMessage.click();
        antNotificationMessage.waitUntilInvisible();
    }

    public void verifyCreatedPathDetail(String expectedPath, List<String> departureTimes) {
        createdPathDetailsModal.waitUntilVisible();
        String pathDetailsRaw = createdPathDetailsModal.pathDetails.getText();
        String actualPath = pathDetailsRaw.split("Path Type")[0].split("Path")[1].trim();
        assertThat("Path is the same", actualPath, equalTo(expectedPath));

        if (departureTimes.size() != 0) {
            String actualDepartureTime = createdPathDetailsModal.pathDepartureTime.getText();
            assertThat("Departure time is the same", actualDepartureTime, equalTo(departureTimes.get(0)));
            String actualDaysOfWeek = createdPathDetailsModal.pathDepartureDaysOfWeek.getText();
            String expectedDaysOfWeek = "MO\nTU\nWE\nTH\nFR\nSA\nSU";
            assertThat("Days of week is the same", actualDaysOfWeek, equalTo(expectedDaysOfWeek));
            if (departureTimes.size() > 1) {
                String secondActualDepartureTime = createdPathDetailsModal.secondPathDepartureTime.getText();
                String secondActualDaysOfWeek = createdPathDetailsModal.secondPathDepartureDaysOfWeek.getText();
                assertThat("Departure time is the same", secondActualDepartureTime, equalTo(departureTimes.get(1)));
                assertThat("Days of week is the same", secondActualDaysOfWeek, equalTo(expectedDaysOfWeek));
            }
        }
        if (departureTimes.size() == 0) {
            String actualEmptyDescription = createdPathDetailsModal.emptyDescription.getText();
            String expectedEmptyDescription = "No Data";
            assertThat("Empty Description is the same", actualEmptyDescription, equalTo(expectedEmptyDescription));
        }

        createdPathDetailsModal.closeModalButton.click();
        createdPathDetailsModal.waitUntilInvisible();
    }

    public void verifyCannotCreateSchedule(String reason, String sourceHub, String targetHub) {
        if ("no schedule(s) selected".equals(reason)) {
            Color actualBorderColor = Color.fromString(createManualPathModal.departureScheduleFirst.getCssValue("border-top-color"));
            String actualErrorInfo = createManualPathModal.thirdStageErrorInfo.get(0).getText();
            Color actualErrorInfoColor = Color.fromString(createManualPathModal.thirdStageErrorInfo.get(0).getCssValue("color"));
            String expectedErrorInfo = "Cannot be blank.";
            String expectedColor = "#f5222d";

            assertThat("Border color is correct", actualBorderColor.asHex(), equalTo(expectedColor));
            assertThat("Error info is correct", actualErrorInfo, equalTo(expectedErrorInfo));
            assertThat("Text color is correct", actualErrorInfoColor.asHex(), equalTo(expectedColor));
        }
        if ("no schedules between hubs".equals(reason)) {
            List<PageElement> actualErrorInfo = createManualPathModal.thirdStageErrorInfo;
            String expectedErrorInfo = f("No schedule from: %s to %s", sourceHub, targetHub);
            assertThat("Error info is contained",
                    actualErrorInfo.stream().anyMatch(item -> expectedErrorInfo.equals(item.getText())),
                    equalTo(true));

            Boolean actualNextButtonIsEnabled = createManualPathModal.nextButton.isEnabled();
            assertThat("NextButton is disabled", actualNextButtonIsEnabled, equalTo(false));
        }
        if ("multiple same transit hubs".equals(reason)) {
            createManualPathModal.secondTransitHubFilter.enterSearchTerm(sourceHub);
            Boolean actualTransitHubExistence = isElementExist(f("//div[not(contains(@class,'dropdown-hidden'))]/div/ul/li[contains(text(),'%s')]", sourceHub));
            assertThat("Cannot find a selected transit hub", actualTransitHubExistence, equalTo(false));
        }
        if ("no schedule(s) available".equals(reason)) {
            String actualErrorInfo = createManualPathModal.thirdStageErrorInfo.get(0).getText();
            Color actualErrorInfoColor = Color.fromString(createManualPathModal.thirdStageErrorInfo.get(0).getCssValue("color"));
            String expectedErrorInfo = "Cannot be blank.";
            String expectedColor = "#f5222d";
            String actualErrorDetail = createManualPathModal.thirdStageErrorDetail.getText();
            String expectedErrorDetail = "You cannot select some schedules because they have been associated with other manual paths. Please edit or remove other paths in order to solve this issue.";
            Boolean actualScheduleButtonAvailability = createManualPathModal.departureScheduleFirst.isEnabled();

            assertThat("Error info is correct", actualErrorInfo, equalTo(expectedErrorInfo));
            assertThat("Text color is correct", actualErrorInfoColor.asHex(), equalTo(expectedColor));
            assertThat("Error detail is correct", actualErrorDetail, equalTo(expectedErrorDetail));
            assertThat("Schedule button is disabled", actualScheduleButtonAvailability, equalTo(false));
        }
    }

    public void verifyCurrentPageIsPathManagementPage() {
        String actualPageTitle = parentPageTitle.getText();
        String expectedPageTitle = "Path Management";
        assertThat("Page title is the same", actualPageTitle, equalTo(expectedPageTitle));
    }

    public void verifyTransitHubInputIsEmpty() {
        String actualTransitHubValue = createManualPathModal.firstTransitHubFilter.getValue();
        assertThat("Transit Hub Value is empty", actualTransitHubValue, isEmptyOrNullString());
    }

    public void removeTransitHubInManualPathCreation(String transitHubInfo) {
        if ("first".equals(transitHubInfo)) {
            createManualPathModal.removeFirstTransitHub.click();
        }
        if ("second".equals(transitHubInfo)) {
            createManualPathModal.removeSecondTransitHub.click();
        }
        if ("third".equals(transitHubInfo)) {
            createManualPathModal.removeThirdTransitHub.click();
        }
    }

    public void updateTransitHubInManualPathCreation(String transitHubInfo, String resolvedNewTransitHub) {
        if ("first".equals(transitHubInfo)) {
            createManualPathModal.firstTransitHubFilter.selectValue(resolvedNewTransitHub);
        }
        if ("second".equals(transitHubInfo)) {
            createManualPathModal.secondTransitHubFilter.selectValue(resolvedNewTransitHub);
        }
        if ("third".equals(transitHubInfo)) {
            createManualPathModal.thirdTransitHubFilter.selectValue(resolvedNewTransitHub);
        }
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

        @FindBy(className = "ant-modal-close")
        public Button closeModalButton;

        @FindBy(className = "ant-card-body")
        public TextBox pathDetails;

        @FindBy(xpath = ".//thead[@class='ant-table-thead']")
        public PageElement pathScheduleTableHead;

        @FindBy(xpath = ".//tbody[@class='ant-table-tbody']//tr[1]//td[1]")
        public PageElement pathDepartureTime;

        @FindBy(xpath = ".//tbody[@class='ant-table-tbody']//tr[1]//td[2]")
        public PageElement pathDepartureDaysOfWeek;

        @FindBy(xpath = ".//tbody[@class='ant-table-tbody']//tr[2]//td[1]")
        public PageElement secondPathDepartureTime;

        @FindBy(xpath = ".//tbody[@class='ant-table-tbody']//tr[2]//td[2]")
        public PageElement secondPathDepartureDaysOfWeek;

        @FindBy(xpath = "//p[@class='ant-empty-description']")
        public TextBox emptyDescription;
    }

    public static class CreateManualPathModal extends AntModal {
        @FindBy(xpath = "//div[contains(@class,'ant-form-explain')]")
        public List<PageElement> thirdStageErrorInfo;

        @FindBy(className = "ant-alert-info")
        public PageElement thirdStageErrorDetail;

        @FindBy(className = "ant-modal-title")
        public TextBox modalTitle;

        @FindBy(id = "originHub")
        public AntSelect originHubFilter;

        @FindBy(id = "destinationHub")
        public AntSelect destinationHubFilter;

        @FindBy(xpath = "(.//div[div[div[div[.='Add Transit Hub']]]])[1]")
        public AntSelect firstTransitHubFilter;

        @FindBy(xpath = "(.//div[div[div[div[.='Add Transit Hub']]]])[2]")
        public AntSelect secondTransitHubFilter;

        @FindBy(xpath = "(.//div[div[div[div[.='Add Transit Hub']]]])[3]")
        public AntSelect thirdTransitHubFilter;

        @FindBy(xpath = "//div[contains(text(),'validating')]")
        public PageElement validatingInfo;

        @FindBy(xpath = "(//i[@class='anticon anticon-minus-circle'])[1]")
        public PageElement removeFirstTransitHub;

        @FindBy(xpath = "(//i[@class='anticon anticon-minus-circle'])[2]")
        public PageElement removeSecondTransitHub;

        @FindBy(xpath = "(//i[@class='anticon anticon-minus-circle'])[3]")
        public PageElement removeThirdTransitHub;

        @FindBy(xpath = "(.//button[span[contains(text(),'Departure time')]])[1]")
        public Button departureScheduleFirst;

        @FindBy(xpath = "(.//button[span[contains(text(),'Departure time')]])[1]//span")
        public TextBox departureScheduleFirstInfo;

        @FindBy(xpath = "(.//button[span[contains(text(),'Departure time')]])[2]")
        public Button departureScheduleSecond;

        @FindBy(xpath = "(.//button[span[contains(text(),'Departure time')]])[2]//span")
        public TextBox departureScheduleSecondInfo;

        @FindBy(xpath = ".//button[.='Cancel']")
        public Button cancelButton;

        @FindBy(xpath = ".//button[.='Next']")
        public Button nextButton;

        @FindBy(xpath = ".//button[.='Create']")
        public Button createButton;

        @FindBy(xpath = ".//button[.='Back']")
        public Button backButton;

        public CreateManualPathModal(WebDriver webDriver, WebElement webElement) {
            super(webDriver, webElement);
            PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
        }
    }

}
