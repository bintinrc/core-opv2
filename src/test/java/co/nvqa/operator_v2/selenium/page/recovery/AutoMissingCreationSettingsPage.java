package co.nvqa.operator_v2.selenium.page.recovery;

import co.nvqa.commons.model.core.hub.Hub;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.page.AntTableV2;
import co.nvqa.operator_v2.selenium.page.SimpleReactPage;
import com.google.common.collect.ImmutableMap;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

import java.util.List;

public class AutoMissingCreationSettingsPage extends
        SimpleReactPage<AutoMissingCreationSettingsPage> {
    public HubMissingInvestigationMappingTable hubTable;

    @FindBy(xpath = "//div[@class='ant-modal-content']")
    public EditHubMissingInvestigationMappingDialog editHubDialog;

    @FindBy(xpath = "//div[@class='ant-notification-notice-message']")
    public PageElement notificationMessage;

    public final String XPATH_RESULT_NOT_FOUND = "//div[@class='BaseTable__empty-layer']";

    public AutoMissingCreationSettingsPage(WebDriver webDriver) {
        super(webDriver);
        hubTable = new HubMissingInvestigationMappingTable(webDriver);
    }

    public void noResultFound() {
        Assertions.assertThat(isElementExist(XPATH_RESULT_NOT_FOUND)).as("Hub ID is Not Found")
            .isTrue();
    }

    public static class HubMissingInvestigationMappingTable extends AntTableV2<Hub> {

        @FindBy(css = "[data-datakey='id']")
        public PageElement id;

        @FindBy(css = "[data-datakey='hubName']")
        public PageElement name;
        public final String XPATH_HUB_ID_FILTER_INPUT = "//input[@data-testid='virtual-table.id.header.filter']";

        public static final String ACTION_EDIT = "Edit";

        public HubMissingInvestigationMappingTable(WebDriver webDriver) {
            super(webDriver);
            PageFactory.initElements(new CustomFieldDecorator(webDriver), this);
            setColumnLocators(ImmutableMap.<String, String>builder()
                    .put("id", "id")
                    .put("name", "name")
                    .put("investigatingDept", "investigatingDept")
                    .put("assignee", "assignee")
                    .build()
            );
            setEntityClass(Hub.class);
            setActionButtonsLocators(ImmutableMap.of(
                    ACTION_EDIT, "//button[@data-pa-action='Edit Hub Missing Investigation']"
            ));
        }

        public void filterTableByHubId(String columName, String value) {
            filterTableByColumn(XPATH_HUB_ID_FILTER_INPUT, columName, value);
        }

        private void filterTableByColumn(String xPath, String columName, String value) {
            retryIfAssertionErrorOrRuntimeExceptionOccurred(() -> {
                findElementBy(By.xpath(f(xPath, columName))).sendKeys(
                        value);
            }, 1000, 5);
        }
    }

    public static class EditHubMissingInvestigationMappingDialog extends AntModal {

        @FindBy(xpath = "//div[@class='ant-modal-title']")
        public PageElement title;

        @FindBy(xpath = "//div[@class='ant-modal-body']//div[.='Hub Name']//input[@class='ant-input']")
        public PageElement hubName;

        @FindBy(xpath = "//div[@class='ant-modal-body']//div[.='Region']//input[@class='ant-input']")
        public PageElement region;

        @FindBy(xpath = "//div[@class='ant-modal-body']//div[.='Id']//input[@class='ant-input']")
        public PageElement id;

        @FindBy(xpath = "//div[@data-testid='single-select']")
        public List<PageElement> selectionInput;

        @FindBy(xpath = "//span[@title='Recovery']")
        public PageElement recoveryInvestigationDept;

        @FindBy(xpath = "//span[@title='AUTOMATION EDITED']")
        public PageElement autoEditedAssignee;

        @FindBy(xpath = "//button[@data-testid='submit.edit.form']")
        public Button submitChanges;

        public EditHubMissingInvestigationMappingDialog(WebDriver webDriver, WebElement webElement) {
            super(webDriver, webElement);
        }
    }
}
