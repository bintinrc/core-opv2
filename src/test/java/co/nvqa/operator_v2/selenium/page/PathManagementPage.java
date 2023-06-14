package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect;
import co.nvqa.operator_v2.selenium.elements.ant.NvTable;
import java.util.List;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.Color;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

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
  public Button addDefaultPathButton;

  @FindBy(xpath = "//div[.='Show / Hide Filters']")
  public PageElement showHideFilters;

  @FindBy(xpath = "//div[contains(@class,'ant-col ant-col')][.//*[.='Path Type']]//div[contains(@class,'ant-select ant-select')]")
  public PageElement pathTypeFilter;

  @FindBy(xpath = "//div[contains(@class,'ant-col ant-col')][.//*[.='Origin Hub']]//div[contains(@class,'ant-select ant-select')]")
  public PageElement originHubFilter;

  @FindBy(xpath = "//div[contains(@class,'ant-col ant-col')][.//*[.='Destination Hub']]//div[contains(@class,'ant-select ant-select')]")
  public PageElement destinationHubFilter;

  @FindBy(xpath = "//button[.='Load Selection']")
  public Button loadSelectionButton;

  @FindBy(xpath = "//button[.='Manual Path']")
  public Button addManualPathButton;

  @FindBy(xpath = "//div[contains(@class,'ant-spin-blur')]")
  public PageElement antBlurSpinner;

  @FindBy(xpath = "//tr[2]//td[1]")
  public TextBox originHubFirstRow;

  @FindBy(xpath = "//tr[2]//td[2]")
  public TextBox destinationHubFirstRow;

  @FindBy(xpath = "//tr[2]//td[3]//span[@class='ant-tag']")
  public TextBox pathTagFirstRow;

  @FindBy(xpath = "//tr[2]//td[3]//span")
  public TextBox pathFirstRow;

  @FindBy(xpath = "//tr[2]//td[4]")
  public TextBox actionFirstRow;

  @FindBy(xpath = "//tr[2]//td[4]//div//a[.='View']")
  public PageElement viewActionFirstRow;

  @FindBy(xpath = "//tr[2]//td[4]//div//a[.='Edit']")
  public PageElement editActionFirstRow;

  @FindBy(xpath = "//tr[2]//td[4]//div//a[.='Remove']")
  public PageElement removeActionFirstRow;

  @FindBy(className = "ant-modal-wrap")
  public PathDetailsModal pathDetailsModal;

  @FindBy(className = "ant-modal-wrap")
  public RemovePathModal removePathModal;

  @FindBy(className = "ant-modal-wrap")
  public CreateManualPathModal createManualPathModal;

  @FindBy(className = "ant-modal-wrap")
  public EditManualPathModal editManualPathModal;

  @FindBy(className = "ant-modal-wrap")
  public CreateDefaultPathModal createDefaultPathModal;

  @FindBy(className = "ant-modal-wrap")
  public PathDetailsModal createdPathDetailsModal;

  @FindBy(xpath = "(//div[@class='ant-modal-wrap'])[2]")
  public EditManualPathModal createdEditPathModal;

  @FindBy(xpath = "//div[contains(@class,'ant-empty-description')]")
  public TextBox footerRowDiv;

  @FindBy(xpath = "//th//input[@aria-label='input-origin_hub_name']")
  public PageElement originHubField;

  @FindBy(xpath = "//th//input[@aria-label='input-destination_hub_name']")
  private PageElement destinationHubField;

  @FindBy(xpath = "//th//input[@aria-label='input-_pathItems']")
  private PageElement pathField;

  @FindBy(xpath = "//div[@class='ant-notification-notice-message']")
  public PageElement antNotificationMessage;

  @FindBy(xpath = "//div[@class='ant-notification-notice-description']")
  public PageElement antNotificationDescription;

  @FindBy(className = "ant-notification-notice-close")
  public PageElement closeAntNotificationMessage;

  @FindBy(xpath = "//table")
  public NvTable<PathRow> pathRowNvTable;

  public static String notificationMessage = "";

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
    pathTypeFilter.click();
    sendKeysAndEnter("//input[@id='pathType']", value);
  }

  public void selectOriginHub(String value) {
    originHubFilter.click();
    sendKeysAndEnter("//input[@id='originHubs']", value);
  }

  public void selectDestinationHub(String value) {
    destinationHubFilter.click();
    sendKeysAndEnter("//input[@id='destinationHubs']", value);
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
      expectedActionText += "\nEdit\nRemove";
    }

   Assertions.assertThat(originHubName).as("Origin Hub not empty").isNotEmpty();
   Assertions.assertThat(destinationHubName).as("Destination Hub not empty").isNotEmpty();
   Assertions.assertThat(pathTagText).as("Path Tag is not empty").isEqualTo(pathType);
   Assertions.assertThat(path).as("Path is not empty").isNotEmpty();
   Assertions.assertThat(actionText).as("Action Text is not empty").isEqualTo(expectedActionText);
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

   Assertions.assertThat(actualPath).as("Actual Path is true").isNotEmpty();
   Assertions.assertThat(actualPathType).as("Actual Path Type is true").isEqualTo(expectedPathType);
   Assertions.assertThat(actualMovementType).as("Actual Movement Type is true").isNotEmpty();

    Boolean actualAddManualPathButtonExistence = pathDetailsModal.addManualPathButton.isDisplayed();
   Assertions.assertThat(actualAddManualPathButtonExistence).as("Add Manual Path Button existed").isEqualTo(true);
    if ("manual paths".equals(pathType)) {
      String actualPathScheduleTableHeadText = pathDetailsModal.pathScheduleTableHead.getText();
      String departureTimeText = "Departure Time";
      String daysOfWeekText = "Days of Week";
     Assertions.assertThat(actualPathScheduleTableHeadText).as("Departure Time in Table Head").contains(departureTimeText);
     Assertions.assertThat(actualPathScheduleTableHeadText).as("Departure Time in Table Head").contains(daysOfWeekText);

      Boolean actualRemoveManualPathButtonExistence = pathDetailsModal.removePathButton
          .isDisplayed();
     Assertions.assertThat(actualRemoveManualPathButtonExistence).as("Remove Manual Path Button existed").isTrue();

      Boolean actualEditManualPathButtonExistence = pathDetailsModal.editPathButton.isDisplayed();
     Assertions.assertThat(actualEditManualPathButtonExistence).as("Edit Manual Path Button existed").isTrue();
    }
  }

  public void verifyShownRemovePathDetail(String pathType) {
    pause3s();
    String removePathInfo = removePathModal.removePathInfo.getText();
    String expectedRemovePathInfo =
        "Removing path cannot be undone! Are you sure want to remove? " +
            "The following schedule(s) will be associated with the default path instead.";
   Assertions.assertThat(removePathInfo).as("Remove path info is equal").isEqualTo(expectedRemovePathInfo);

    String pathDetailsRaw = removePathModal.pathDetails.getText();
    String actualPath = pathDetailsRaw.split("Path Type")[0].split("Path")[1].trim();
    String actualPathType = pathDetailsRaw.split("Movement Type")[0].split("Path Type")[1].trim();
    String actualMovementType = pathDetailsRaw.split("Movement Type")[1].trim();

    String expectedPathType = "AUTO_GENERATED";
    if ("manual paths".equals(pathType)) {
      expectedPathType = "MANUAL";
    }

   Assertions.assertThat(actualPath).as("Actual Path is true").isNotEmpty();
   Assertions.assertThat(actualPathType).as("Actual Path Type is true").isEqualTo(expectedPathType);
   Assertions.assertThat(actualMovementType).as("Actual Movement Type is true").isNotEmpty();
    if ("manual paths".equals(pathType)) {
      String actualPathScheduleTableHeadText = removePathModal.pathScheduleTableHead.getText();
      String departureTimeText = "Departure Time";
      String daysOfWeekText = "Days of Week";
     Assertions.assertThat(actualPathScheduleTableHeadText).as("Departure Time in Table Head").contains(departureTimeText);
     Assertions.assertThat(actualPathScheduleTableHeadText).as("Departure Time in Table Head").contains(daysOfWeekText);

      Boolean actualRemoveManualPathButtonExistence = removePathModal.removePathButton
          .isDisplayed();
     Assertions.assertThat(actualRemoveManualPathButtonExistence).as("Remove Manual Path Button existed").isTrue();
    }
  }

  public void verifyPathDataAppearInPathTable(String expectedOriginHub,
      String expectedDestinationHub, List<String> passedHub, String arrow) {
    String originHubName = originHubFirstRow.getText();
    String destinationHubName = destinationHubFirstRow.getText();
    String path = pathFirstRow.getText();

    String expectedPath = String.join(arrow.equals("")? " → " : " " + arrow + " ", passedHub);

   Assertions.assertThat(originHubName).as("Origin Hub is equal").isEqualTo(expectedOriginHub);
   Assertions.assertThat(destinationHubName).as("Destination Hub is equal").isEqualTo(expectedDestinationHub);
   Assertions.assertThat(path).as("Path is equal").isEqualTo(expectedPath);
    String actualActionText = actionFirstRow.getText();
   Assertions.assertThat(actualActionText).as("View Hyperlink in action column").contains("View");
   Assertions.assertThat(actualActionText).as("View Hyperlink in action column").contains("Edit");
   Assertions.assertThat(actualActionText).as("View Hyperlink in action column").contains("Remove");
  }

  public void verifyNoResultsFound() {
    String actualMessage = footerRowDiv.getText();
    String expectedMessage = "No data";
   Assertions.assertThat(actualMessage).as("Message is no results found").isEqualTo(expectedMessage);
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
   Assertions.assertThat(actualCreateManualPathModalTitle).as("Modal title is the same").isEqualTo(expectedFirstCreateManualPathModalTitle);
    createManualPathModal.originHubFilter.click();
    sendKeysAndEnter("//input[@id='originHub']", originHubName);
    createManualPathModal.destinationHubFilter.click();
    sendKeysAndEnter("//input[@id='destinationHub']", destinationHubName);
  }

  public void createManualPathSecondStage(String transitHubName, String transitHubInfo) {
    String actualCreateManualPathModalTitle = createManualPathModal.modalTitle.getText();
    String expectedSecondCreateManualPathModalTitle = "Create Manual Path (2/3)";
   Assertions.assertThat(actualCreateManualPathModalTitle).as("Modal title is the same").isEqualTo(expectedSecondCreateManualPathModalTitle);
    if (transitHubName != null) {
      switch (transitHubInfo) {
        case "first":
          createManualPathModal.firstTransitHubFilter.click();
          createManualPathModal.firstTransitHubInput.sendKeysAndEnterNoXpath(transitHubName);
          break;
        case "second":
          createManualPathModal.secondTransitHubFilter.click();
          createManualPathModal.secondTransitHubInput.sendKeysAndEnterNoXpath(transitHubName);
          break;
        case "third":
          createManualPathModal.thirdTransitHubFilter.click();
          createManualPathModal.thirdTransitHubInput.sendKeysAndEnterNoXpath(transitHubName);
          break;
      }
    }
  }

  public void createManualPathThirdStage(Boolean hasMultipleSchedule) {
    String actualCreateManualPathModalTitle = createManualPathModal.modalTitle.getText();
    String expectedThirdCreateManualPathModalTitle = "Create Manual Path (3/3)";
   Assertions.assertThat(actualCreateManualPathModalTitle).as("Modal title is the same").isEqualTo(expectedThirdCreateManualPathModalTitle);
    createManualPathModal.departureScheduleFirst.click();
    if (hasMultipleSchedule) {
      createManualPathModal.departureScheduleSecond.click();
    }
  }

  public void verifyNotificationMessageIsShown(String expectedNotificationMessage) {
    antNotificationMessage.waitUntilVisible();
    String actualNotificationMessage = antNotificationMessage.getText();
    closeAntNotificationMessage.click();
    antNotificationMessage.waitUntilInvisible();
   Assertions.assertThat(actualNotificationMessage).as("Notification message is the same").isEqualTo(expectedNotificationMessage);
  }

  public void verifyCreatedPathDetail(String expectedPath, List<String> departureTimes) {
    createdPathDetailsModal.waitUntilVisible();
    String pathDetailsRaw = createdPathDetailsModal.pathDetails.getText();
    String actualPath = pathDetailsRaw.split("Path Type")[0].split("Path")[1].trim();
   Assertions.assertThat(actualPath).as("Path is the same").isEqualTo(expectedPath);

    if (departureTimes != null) {
      if (departureTimes.size() != 0) {
        String actualDepartureTime = createdPathDetailsModal.pathDepartureTime.getText();
       Assertions.assertThat(actualDepartureTime).as("Departure time is the same").isEqualTo(departureTimes.get(0));
        String actualDaysOfWeek = createdPathDetailsModal.pathDepartureDaysOfWeek.getText();
        String expectedDaysOfWeek = "MO\nTU\nWE\nTH\nFR\nSA\nSU";
       Assertions.assertThat(actualDaysOfWeek).as("Days of week is the same").isEqualTo(expectedDaysOfWeek);
        if (departureTimes.size() > 1) {
          String secondActualDepartureTime = createdPathDetailsModal.secondPathDepartureTime
              .getText();
          String secondActualDaysOfWeek = createdPathDetailsModal.secondPathDepartureDaysOfWeek
              .getText();
         Assertions.assertThat(secondActualDepartureTime).as("Departure time is the same").isEqualTo(departureTimes.get(1));
         Assertions.assertThat(secondActualDaysOfWeek).as("Days of week is the same").isEqualTo(expectedDaysOfWeek);
        }
      }
      if (departureTimes.size() == 0) {
        String actualEmptyDescription = createdPathDetailsModal.emptyDescription.getText();
        String expectedEmptyDescription = "No data";
       Assertions.assertThat(actualEmptyDescription).as("Empty Description is the same").isEqualTo(expectedEmptyDescription);
      }
    }

    createdPathDetailsModal.closeModalButton.click();
    createdPathDetailsModal.waitUntilInvisible();
  }

  public void verifyCannotCreateSchedule(String reason, String sourceHub, String targetHub) {
    if ("no schedule(s) selected".equals(reason)) {
      Color actualBorderColor = Color
          .fromString(createManualPathModal.departureScheduleFirst.getCssValue("border-top-color"));
      String actualErrorInfo = createManualPathModal.thirdStageErrorTypography.get(0).getText();
      Color actualErrorInfoColor = Color
          .fromString(createManualPathModal.thirdStageErrorTypography.get(0).getCssValue("color"));
      String expectedErrorInfo = "Cannot be blank";
      String expectedBorderColor = "#f5222d";
      String expectedTextColor = "#ff4d4f";

     Assertions.assertThat(actualBorderColor.asHex()).as("Border color is correct").isEqualTo(expectedBorderColor);
     Assertions.assertThat(actualErrorInfo).as("Error info is correct").isEqualTo(expectedErrorInfo);
     Assertions.assertThat(actualErrorInfoColor.asHex()).as("Text color is correct").isEqualTo(expectedTextColor);
    }
    if ("no schedules between hubs".equals(reason)) {
      List<PageElement> actualErrorInfo = createManualPathModal.thirdStageErrorTypography;
      String expectedErrorInfo = f("No schedule from: %s to %s", sourceHub, targetHub);
     Assertions.assertThat(actualErrorInfo.stream().anyMatch(item -> expectedErrorInfo.equals(item.getText()))).as("Error info is contained").isTrue();

      Boolean actualNextButtonIsEnabled = createManualPathModal.nextButton.isEnabled();
     Assertions.assertThat(actualNextButtonIsEnabled).as("NextButton is disabled").isEqualTo(false);
    }
    if ("multiple same transit hubs".equals(reason)) {
      createManualPathModal.secondTransitHubFilter.click();
      createManualPathModal.secondTransitHubInput.sendKeys(sourceHub);
      Boolean actualTransitHubExistence = isElementExist(
          "//div[@role='listbox']//div[@class='ant-empty-description'][.='No data']");
     Assertions.assertThat(actualTransitHubExistence).as("Cannot find a selected transit hub").isEqualTo(true);
    }
    if ("no schedules between transit hubs".equals(reason)) {
      List<PageElement> actualErrorInfo = createManualPathModal.thirdStageErrorAlert;
      String expectedErrorInfo = f("No schedule from: %s to %s", sourceHub, targetHub);
     Assertions.assertThat(actualErrorInfo.stream().anyMatch(item -> expectedErrorInfo.equals(item.getText()))).as("Error info is contained").isTrue();

      Boolean actualNextButtonIsEnabled = createManualPathModal.nextButton.isEnabled();
     Assertions.assertThat(actualNextButtonIsEnabled).as("NextButton is disabled").isEqualTo(false);
    }
    if ("no schedule(s) available".equals(reason)) {
      String actualErrorInfo = createManualPathModal.thirdStageErrorTypography.get(0).getText();
      Color actualErrorInfoColor = Color
          .fromString(createManualPathModal.thirdStageErrorTypography.get(0).getCssValue("color"));
      String expectedErrorInfo = "Cannot be blank";
      String expectedTextColor = "#ff4d4f";
      String actualErrorDetail = createManualPathModal.thirdStageErrorDetail.getText();
      String expectedErrorDetail = "You cannot select some schedules because they have been associated with other manual paths. Please edit or remove other paths in order to solve this issue.";
      Boolean actualScheduleButtonAvailability = createManualPathModal.departureScheduleFirst
          .isEnabled();

     Assertions.assertThat(actualErrorInfo).as("Error info is correct").isEqualTo(expectedErrorInfo);
     Assertions.assertThat(actualErrorInfoColor.asHex()).as("Text color is correct").isEqualTo(expectedTextColor);
     Assertions.assertThat(actualErrorDetail).as("Error detail is correct").isEqualTo(expectedErrorDetail);
     Assertions.assertThat(actualScheduleButtonAvailability).as("Schedule button is disabled").isEqualTo(false);
    }
  }

  public void verifyCurrentPageIsPathManagementPage() {
    String actualPageTitle = parentPageTitle.getText();
    String expectedPageTitle = "Path Management";
   Assertions.assertThat(actualPageTitle).as("Page title is the same").isEqualTo(expectedPageTitle);
  }

  public void verifyTransitHubInputIsEmpty() {
    String actualTransitHubValue = createManualPathModal.firstTransitHubFilter.getValue();
   Assertions.assertThat(actualTransitHubValue).as("Transit Hub Value is empty").isNullOrEmpty();
  }

  public void removeTransitHubInManualPathCreation(String transitHubInfo) {
    if ("first".equals(transitHubInfo)) {
      createManualPathModal.removeTransitHubs.get(0).click();
    }
    if ("second".equals(transitHubInfo)) {
      createManualPathModal.removeTransitHubs.get(1).click();
    }
    if ("third".equals(transitHubInfo)) {
      createManualPathModal.removeTransitHubs.get(2).click();
    }
    if ("all".equals(transitHubInfo)) {
      createManualPathModal.removeTransitHubs.get(2).click();
      createManualPathModal.removeTransitHubs.get(1).click();
      createManualPathModal.removeTransitHubs.get(0).click();
    }
  }

  public void updateTransitHubInManualPathCreation(String transitHubInfo,
      String resolvedNewTransitHub) {
    switch (transitHubInfo) {
      case "first":
        createManualPathModal.firstTransitHubFilter.click();
        createManualPathModal.firstTransitHubInput.sendKeysAndEnterNoXpath(resolvedNewTransitHub);
        break;
      case "second":
        createManualPathModal.secondTransitHubFilter.click();
        createManualPathModal.secondTransitHubInput.sendKeysAndEnterNoXpath(resolvedNewTransitHub);
        break;
      case "third":
        createManualPathModal.thirdTransitHubFilter.click();
        createManualPathModal.thirdTransitHubInput.sendKeysAndEnterNoXpath(resolvedNewTransitHub);
        break;
    }
  }

  public void createDefaultPath(String originHubName, String destinationHubName) {
    if (!"empty".equals(originHubName)) {
      createDefaultPathModal.originHubFilter.click();
      sendKeysAndEnter("//input[@id='originHub']", originHubName);
    }
    if (!"empty".equals(destinationHubName)) {
      createDefaultPathModal.destinationHubFilter.click();
      sendKeysAndEnter("//input[@id='destinationHub']", destinationHubName);
    }
    createDefaultPathModal.generateButton.click();
  }

  public void captureErrorNotification() {
    antNotificationMessage.waitUntilVisible(300);
    if(antNotificationMessage.isDisplayed()){
      if(antNotificationDescription.isDisplayed()){
        notificationMessage = antNotificationDescription.getText();
        if(notificationMessage.trim().equals("")){
          notificationMessage = antNotificationMessage.getText();
        }
      }
    }
  }

  public void verifyCreatingDefaultPath(String originHubName, String destinationHubName) {
    String actualCreateDefaultPathInfoText = createDefaultPathModal.createDefaultPathInfo.getText();
    String expectedCreateDefaultPathInfoText = f(
        "The system is generating a path from: %s to %s\nThis might take up few minutes...",
        originHubName, destinationHubName);
   Assertions.assertThat(actualCreateDefaultPathInfoText).as("Create default path is equal").isEqualTo(expectedCreateDefaultPathInfoText);
  }

  public void editManualPathFirstStage(String resolvedTransitHub, boolean createdEditPath) {
    String actualModalTitle = "";
    if (createdEditPath) {
      actualModalTitle = createdEditPathModal.title.getText();
    } else {
      actualModalTitle = editManualPathModal.title.getText();
    }
    String expectedModalTitle = "Edit Path (1/2)";
   Assertions.assertThat(actualModalTitle).as("Modal title is the same").isEqualTo(expectedModalTitle);
    if (StringUtils.isNotEmpty(resolvedTransitHub)) {
      if (createdEditPath) {
        createdEditPathModal.selectTransitHub(resolvedTransitHub);
      } else {
        editManualPathModal.selectTransitHub(resolvedTransitHub);
      }
    }
    pause1s();
  }

  public void editManualPathFirstStage(List<String> resolvedTransitHubs) {
    String actualModalTitle = editManualPathModal.title.getText();
    String expectedModalTitle = "Edit Path (1/2)";
   Assertions.assertThat(actualModalTitle).as("Modal title is the same").isEqualTo(expectedModalTitle);
    for (String resolvedTransitHub : resolvedTransitHubs) {
      sendKeysAndEnter("//div[span[.='Add Transit Hub']]//input", resolvedTransitHub);
    }
    pause1s();
  }

  public void editManualPathSecondStage(boolean second) {
    String actualModalTitle = editManualPathModal.title.getText();
    String expectedModalTitle = "Edit Path (2/2)";
   Assertions.assertThat(actualModalTitle).as("Modal title is the same").isEqualTo(expectedModalTitle);
    if (second) {
      editManualPathModal.selectSecondSchedule();
      pause1s();
      return;
    }
    editManualPathModal.selectFirstSchedule();
    pause1s();
  }

  public void editCreatedManualPathSecondStage() {
    String actualModalTitle = createdEditPathModal.title.getText();
    String expectedModalTitle = "Edit Path (2/2)";
   Assertions.assertThat(actualModalTitle).as("Modal title is the same").isEqualTo(expectedModalTitle);
    createdEditPathModal.selectFirstSchedule();
    pause1s();
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

    @FindBy(xpath = "//div[@class='ant-empty-description']")
    public TextBox emptyDescription;
  }

  public static class CreateManualPathModal extends AntModal {

    @FindBy(xpath = "//div//span[@class='ant-typography ant-typography-danger']")
    public List<PageElement> thirdStageErrorTypography;

    @FindBy(xpath = "//div[@role='alert']")
    public List<PageElement> thirdStageErrorAlert;

    @FindBy(className = "ant-alert-info")
    public PageElement thirdStageErrorDetail;

    @FindBy(className = "ant-modal-title")
    public TextBox modalTitle;

    @FindBy(xpath = ".//div[contains(@class,'ant-col ant-col')][.//*[.='Origin Hub']]//div[contains(@class,'ant-select ant-select')]")
    public PageElement originHubFilter;

    @FindBy(xpath = ".//div[contains(@class,'ant-col ant-col')][.//*[.='Destination Hub']]//div[contains(@class,'ant-select ant-select')]")
    public PageElement destinationHubFilter;

    @FindBy(xpath = "(.//div[contains(@class,'ant-select-selector')])[1]")
    public PageElement firstTransitHubFilter;

    @FindBy(xpath = "(.//div[contains(@class,'ant-select-selector')]//input)[1]")
    public PageElement firstTransitHubInput;

    @FindBy(xpath = "(.//div[contains(@class,'ant-select-selector')])[2]")
    public PageElement secondTransitHubFilter;

    @FindBy(xpath = "(.//div[contains(@class,'ant-select-selector')]//input)[2]")
    public PageElement secondTransitHubInput;

    @FindBy(xpath = "(.//div[contains(@class,'ant-select-selector')])[3]")
    public PageElement thirdTransitHubFilter;

    @FindBy(xpath = "(.//div[contains(@class,'ant-select-selector')]//input)[3]")
    public PageElement thirdTransitHubInput;

    @FindBy(xpath = "//div[contains(text(),'validating')]")
    public PageElement validatingInfo;

    @FindBy(xpath = "//span[@aria-label='minus-circle']")
    public List<PageElement> removeTransitHubs;

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

  public static class RemovePathModal extends AntModal {

    public RemovePathModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    @FindBy(xpath = ".//button[.='Remove Path']")
    public Button removePathButton;

    @FindBy(xpath = ".//button[.='Cancel']")
    public Button cancelButton;

    @FindBy(className = "ant-modal-close")
    public Button closeModalButton;

    @FindBy(xpath = ".//div//p")
    public TextBox removePathInfo;

    @FindBy(className = "ant-card-body")
    public TextBox pathDetails;

    @FindBy(xpath = ".//thead[@class='ant-table-thead']")
    public PageElement pathScheduleTableHead;

    @FindBy(xpath = ".//tbody[@class='ant-table-tbody']//tr[1]//td[1]")
    public PageElement pathDepartureTime;

    @FindBy(xpath = ".//tbody[@class='ant-table-tbody']//tr[1]//td[2]")
    public PageElement pathDepartureDaysOfWeek;
  }

  public static class CreateDefaultPathModal extends AntModal {

    public CreateDefaultPathModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    @FindBy(xpath = ".//div[contains(@class,'ant-col ant-col')][.//*[.='Origin Hub']]//div[contains(@class,'ant-select ant-select')]")
    public PageElement originHubFilter;

    @FindBy(xpath = ".//div[contains(@class,'ant-col ant-col')][.//*[.='Destination Hub']]//div[contains(@class,'ant-select ant-select')]")
    public PageElement destinationHubFilter;

    @FindBy(xpath = ".//button[.='Generate']")
    public Button generateButton;

    @FindBy(xpath = ".//button[.='Cancel']")
    public Button cancelButton;

    @FindBy(className = "ant-modal-body")
    public TextBox createDefaultPathInfo;

    @FindBy(xpath = ".//div[div[.='Origin Hub']]//div[@role='alert']")
    public TextBox originHubErrorInfo;

    @FindBy(xpath = ".//div[div[.='Destination Hub']]//div[@role='alert']")
    public TextBox destinationHubErrorInfo;
  }

  public static class PathRow extends NvTable.NvRow {

    public PathRow(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public PathRow(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
      super(webDriver, searchContext, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    @FindBy(className = "originHubName")
    public PageElement originHubName;

    @FindBy(className = "destinationHubName")
    public PageElement destinationHubName;

    @FindBy(className = "pathItems")
    public PageElement pathItems;

    @FindBy(xpath = "(//td//a)[1]")
    public PageElement viewAction;

    @FindBy(xpath = "(//td//a)[2]")
    public PageElement editAction;

    @FindBy(xpath = "(//td//a)[3]")
    public PageElement removeAction;
  }

  public static class EditManualPathModal extends AntModal {

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

    @FindBy(xpath = "(.//div[contains(@class,'ant-select-selector')])[1]")
    public PageElement firstTransitHubFilter;

    @FindBy(xpath = "(.//div[contains(@class,'ant-select-selector')]//input)[1]")
    public PageElement firstTransitHubInput;

    @FindBy(xpath = "//div[contains(text(),'validating')]")
    public PageElement validatingInfo;

    @FindBy(xpath = ".//i[@class='anticon anticon-minus-circle']")
    public List<AntSelect> removeTransitHubs;

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

    @FindBy(xpath = ".//button[.='Update']")
    public Button updateButton;

    public EditManualPathModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public void selectTransitHub(String resolvedTransitHub) {
      firstTransitHubFilter.click();
      firstTransitHubInput.sendKeysAndEnterNoXpath(resolvedTransitHub);
    }

    public void selectFirstSchedule() {
      departureScheduleFirst.click();
    }

    public void selectSecondSchedule() {
      departureScheduleSecond.click();
    }
  }

}
