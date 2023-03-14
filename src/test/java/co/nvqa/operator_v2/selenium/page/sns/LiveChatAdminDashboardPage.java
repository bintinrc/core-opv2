package co.nvqa.operator_v2.selenium.page.sns;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CheckBox;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.ForceClearTextBox;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntNotification;
import co.nvqa.operator_v2.selenium.elements.ant.AntTimePicker;
import co.nvqa.operator_v2.selenium.page.SimpleReactPage;

import java.util.List;
import java.util.Objects;

import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class LiveChatAdminDashboardPage extends SimpleReactPage<LiveChatAdminDashboardPage> {

    public static String AGENT_NAME;
    // 0 for customer and 1 for shipper
    public static int elementIndexForLiveAgentPage;

    @FindBy(xpath = "//div[@tabindex='0']//button[span[.='Add a new agent']]")
    public Button addNewAgentButton;

    @FindBy(xpath = "//div[.='Customer support']")
    public PageElement customerSupportTab;

    @FindBy(xpath = "//div[@role='tab'][text()='Shipper support']")
    public PageElement shipperSupportTab;
    public String sectionTab = "//div[@role='tab'][text()='%s']";

    @FindBy(xpath = "//div[@class='ant-modal-wrap' and not(@style='display: none;')]")
    public AddShipperSupportAgentModal addShipperSupportAgentModal;

    @FindBy(xpath = "//input[@placeholder='Search by name or email']")
    public ForceClearTextBox searchInputFields;

    @FindBy(xpath = "//*[@id='rc-tabs-0-panel-2']//input[@placeholder='Search by name or email']")
    public ForceClearTextBox searchShipperSupport;

    @FindBy(css = "tbody > tr.ant-table-row")
    public List<AgentRow> agents;

    @FindBy(xpath = "//div[@class='ant-modal-wrap' and not(@style='display: none;')]")
    public DeleteDialog deleteDialog;

    @FindBy(xpath = "//table//div[text()='No Data']")
    public PageElement noDataMessage;

    @FindBy(xpath = "//span[text()='Update']")
    public PageElement update;

    @FindBy(xpath = "//div[@class='ant-modal-mask'and not(@style='display: none;')]")
    public OperatingHourModal operatingHourModal;

    @FindBy(css = ".ant-notification")
    public AntNotification notification;

    public LiveChatAdminDashboardPage(WebDriver webDriver) {
        super(webDriver);
    }

    @Override
    public void waitUntilLoaded() {
        waitUntilVisibilityOfElementLocated(customerSupportTab.getWebElement());
    }

    public void createLiveChatAgent(String fullName, String email) {
        addNewAgentButton.click();
        waitUntilVisibilityOfElementLocated(addShipperSupportAgentModal.getWebElement());
        AGENT_NAME = fullName;
        waitUntilLoaded();
        fillAndSaveLiveChatAgentDetails(fullName, email);
        addShipperSupportAgentModal.waitUntilInvisible();
    }

    private void fillAndSaveLiveChatAgentDetails(String fullName, String email) {
        addShipperSupportAgentModal.fillAndSaveLiveChatAgentDetails(fullName, email);
    }

    public void verifyLiveAgentAddedSuccessfully() {
        if (this.elementIndexForLiveAgentPage == 0) {
            searchInputFields.setValue(AGENT_NAME);
        } else {
            searchShipperSupport.setValue(AGENT_NAME);
        }
        String addedAgentRowXpath = f("//td[text()='%s']", this.AGENT_NAME);
        String actualName = getText(addedAgentRowXpath);
        Assertions.assertThat(actualName.equalsIgnoreCase(this.AGENT_NAME)).as("Full name is present").isTrue();
    }

    public void updateLiveChatAgent(String fullName, String email) {
        searchInputFields.waitUntilVisible();
        searchInputFields.setValue("testinguser");
        // click update button
        pause3s();
        int updateButtonIndexToClick = elementIndexForLiveAgentPage == 0 ? 0 : (agents.get(elementIndexForLiveAgentPage).updateButtons.size() - 1);
        agents.get(elementIndexForLiveAgentPage).updateButtons.get(updateButtonIndexToClick).click();
        this.AGENT_NAME = Objects.nonNull(fullName) ? fullName : email;
        fillAndSaveLiveChatAgentDetails(fullName, email);
    }

    public void deleteCreatedLiveChatAgent() {
        if (Objects.isNull(this.AGENT_NAME)) {
            this.AGENT_NAME = "testinguser";
        }
        searchInputFields.waitUntilVisible();
        searchInputFields.setValue(this.AGENT_NAME);
        pause1s();
        agents.get(elementIndexForLiveAgentPage).deleteButtons.get(agents.get(elementIndexForLiveAgentPage).deleteButtons.size() - 1).click();
        deleteDialog.verifyDeleteDialogBox("customer");
    }

    public void verifyLiveAgentDeletedSuccessfully() {
        searchInputFields.setValue(this.AGENT_NAME);
        Assertions.assertThat(noDataMessage.getText().equalsIgnoreCase("No Data")).as("Live agent is deleted").isTrue();
    }

    public void deleteLiveChatAgentWithName(String fullName) {
        this.AGENT_NAME = fullName;
        if (this.elementIndexForLiveAgentPage == 0) {
            searchInputFields.waitUntilVisible();
            searchInputFields.setValue(fullName);
        } else {
            searchShipperSupport.waitUntilVisible();
            searchShipperSupport.setValue(fullName);
        }
        pause1s();
        int deleteButtonIndexToClick = elementIndexForLiveAgentPage == 0 ? 0 : (agents.get(elementIndexForLiveAgentPage).deleteButtons.size() - 1);
        agents.get(elementIndexForLiveAgentPage).deleteButtons.get(deleteButtonIndexToClick).click();
        if (this.elementIndexForLiveAgentPage == 0) {
            deleteDialog.verifyDeleteDialogBox("customer");
        } else {
            deleteDialog.verifyDeleteDialogBox("shipper");
        }
    }

    public void verifyLiveAgentDeletedSuccessfullyWithName(String fullName) {
        if (this.elementIndexForLiveAgentPage == 0) {
            searchInputFields.waitUntilVisible();
            searchInputFields.setValue(fullName);
        } else {
            searchShipperSupport.waitUntilVisible();
            searchShipperSupport.setValue(fullName);
        }
        pause1s();
        noDataMessage.waitUntilVisible();
        Assertions.assertThat(noDataMessage.getText().equalsIgnoreCase("No Data")).as("Live agent is deleted").isTrue();
    }


    public static class AddShipperSupportAgentModal extends AntModal {

        @FindBy(xpath = ".//div[./div/label[.='Full name']]//input")
        public ForceClearTextBox fullNameTextInput;

        @FindBy(xpath = ".//div[./div/label[.='Email']]//input")
        public ForceClearTextBox emailTextInput;

        @FindBy(xpath = ".//button[.='OK']")
        public Button okButton;


        @FindBy(xpath = ".//button[.='Cancel']")
        public Button cancelButton;

        public AddShipperSupportAgentModal(WebDriver webDriver, WebElement webElement) {
            super(webDriver, webElement);
            PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
        }

        public void fillAndSaveLiveChatAgentDetails(String name, String email) {
            fullNameTextInput.setValue(name);
            emailTextInput.setValue(email);
            okButton.click();
        }

    }

    public static class AgentRow extends AntModal {

        @FindBy(xpath = "//td[text()='%s']")
        public PageElement addedAgentRow;

        @FindBy(xpath = "//td/div/div[1]/button[@class='ant-btn ant-btn-icon-only']")
        public List<Button> updateButtons;

        @FindBy(xpath = "//td/div/div[2]/button[@class='ant-btn ant-btn-icon-only']")
        public List<Button> deleteButtons;

        @FindBy(xpath = "//tr[contains(@class, 'ant-table-row')]")
        public List<PageElement> tableRows;

        public void verifyAgentListIsVisible() {
            Assertions.assertThat(tableRows.size() > 0).as("Live agent list is visible").isTrue();
        }

        public AgentRow(WebDriver webDriver, WebElement webElement) {
            super(webDriver, webElement);
        }
    }

    public static class DeleteDialog extends AntModal {

        @FindBy(xpath = "//div[@class='ant-modal-header']/div[@class='ant-modal-title' and contains(., 'Delete')]")
        public PageElement title;

        @FindBy(css = "div.ant-modal-body >p")
        public PageElement description;

        @FindBy(xpath = "//*[contains(text(), 'Delete')]//ancestor::div[@class='ant-modal-content']//*[text()='OK']//parent::button")
        public Button okButton;

        public DeleteDialog(WebDriver webDriver, WebElement webElement) {
            super(webDriver, webElement);
        }

        public void verifyDeleteDialogBox(String supportType) {
            title.waitUntilVisible();
            Assertions.assertThat(title.getAttribute("innerText")).as("delete dialog title").isEqualTo("Delete a " + supportType + " support agent");
            description.waitUntilVisible();
            Assertions.assertThat(description.getAttribute("innerText")).as("delete dialog description").contains("Warning: you will permanently delete " + AGENT_NAME);
            pause2s();
            okButton.click();
        }
    }

    public static class OperatingHourModal extends AntModal {

        @FindBy(xpath = "//div[@id='rcDialogTitle0']")
        public PageElement modalHeading;

        @FindBy(xpath = "//div[@class='ant-modal-body']//input[@type='checkbox']")
        public List<CheckBox> checkboxes;

        @FindBy(xpath = "//div[@class='ant-modal-body']//input[@placeholder='Select time']")
        public List<PageElement> timeInputBox;

        @FindBy(xpath = "//div[@class='ant-space-item']//input[@placeholder='Select date']")
        public AntTimePicker selectDate;

        @FindBy(xpath = "//td[contains(@class, 'ant-picker-cell-today')]")
        public AntTimePicker selectHoliday;

        @FindBy(xpath = "//div[text()='Holiday Added']")
        public PageElement notificationMessage;

        @FindBy(xpath = "//span[text()='Add Holiday']")
        public PageElement addHoliday;

        @FindBy(xpath = "//div[@class='ant-modal-content']//div[@class='ant-card-body']")
        public PageElement holidayDatesSection;

        @FindBy(xpath = "//div[@class='ant-modal-body']//input[@placeholder='Select date']")
        public PageElement selectedDate;

        @FindBy(xpath = "//span[text()='Save']")
        public Button save;

        public String removeSpecificDate = "//*[contains(text(), '%s')]//*[contains(@class, 'anticon-close')]";

        public OperatingHourModal(WebDriver webDriver, WebElement webElement) {
            super(webDriver, webElement);
        }

        public void verifyOperatingHourModal() {
            selectDate.waitUntilVisible();
            selectDate.click();
            selectHoliday.waitUntilVisible();
            selectHoliday.click();
            addHoliday.waitUntilVisible();
            addHoliday.click();
            notificationMessage.waitUntilVisible();
            Assertions.assertThat(notificationMessage.isDisplayed()).as("'Holiday Added' popup is visible");
            modalHeading.waitUntilVisible();
            Assertions.assertThat(modalHeading.getText().equalsIgnoreCase("Update live chat operating hours and holidays")).as("Modal heading is correct").isTrue();
            Assertions.assertThat(checkboxes.size() == 7).as("Checkboxes are present for all days").isTrue();
            Assertions.assertThat(timeInputBox.size() == 14).as("Each day has 'from' and 'to' time dropdown").isTrue();
            pause2s();
            holidayDatesSection.waitUntilVisible();
            selectedDate.waitUntilVisible();
            Assertions.assertThat(holidayDatesSection.getAttribute("innerText").contains(selectedDate.getAttribute("value"))).as("Selected date is added in list of holidays").isTrue();
            click(f(removeSpecificDate, selectedDate.getAttribute("value")));
            pause2s();
        }
    }
}
