package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.shipper.v2.Shipper;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.FileInput;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.elements.ant.AntModal;
import co.nvqa.operator_v2.selenium.elements.ant.AntTable;
import com.google.common.collect.ImmutableMap;
import java.util.List;
import java.util.function.Consumer;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

/**
 * @author Lanang Jati
 */
public class B2bManagementPage extends OperatorV2SimplePage {

  public final B2bShipperTable subShipperTable;

  public static final String NAME_COLUMN_LOCATOR_KEY = "name";

  @FindBy(css = "[aria-label='icon: arrow-left']")
  public Button goBack;

  @FindBy(xpath = "//button[.='Add Sub-shipper']")
  public Button addSubShipper;

  @FindBy(xpath = "//button[.='Add Another Account']")
  public Button addAnotherAccount;

  @FindBy(xpath = "//button[.='Create Sub-shipper Account(s)']")
  public Button createSubShipperAccount;

  @FindBy(xpath = "//button[.='Switch to File Upload']")
  public Button switchToFileUpload;

  @FindBy(xpath = "//button[.='Download Template']")
  public Button downloadTemplate;

  @FindBy(xpath = "//button[.='Download Error log']")
  public Button downloadErrorLog;

  @FindBy(id = "csv_uploads")
  public FileInput uploadCsvFile;

  @FindBy(css = "li.ant-pagination-prev")
  public Button prevPage;

  @FindBy(css = "li.ant-pagination-next")
  public Button nextPage;

  @FindBy(id = "branchId")
  public List<TextBox> branchId;

  @FindBy(id = "name")
  public List<TextBox> name;

  @FindBy(id = "email")
  public List<TextBox> email;

  @FindBy(css = "div.ant-form-explain")
  public List<PageElement> errorMessage;

  @FindBy(css = "div[class*='BulkCreation__ListItem']")
  public List<PageElement> bulkCreationErrorMessage;

  @FindBy(xpath = "//div[./i[@aria-label='icon: exclamation-circle']]")
  public List<PageElement> bulkCreationWarningMessage;

  @FindBy(xpath = "//iframe[contains(@src,'b2b-management')]")
  public PageElement iframe;

  @FindBy(css = ".ant-modal")
  public BeforeYouGoModal beforeYouGoModal;

  public void inFrame(Consumer<B2bManagementPage> consumer) {
    getWebDriver().switchTo().defaultContent();
    iframe.waitUntilVisible();
    getWebDriver().switchTo().frame(iframe.getWebElement());
    try {
      consumer.accept(this);
    } finally {
      getWebDriver().switchTo().defaultContent();
    }
  }

  public B2bManagementPage(WebDriver webDriver) {
    super(webDriver);
    subShipperTable = new B2bShipperTable(webDriver);
  }

  public boolean isPrevPageButtonDisable() {
    return prevPage.getAttribute("class").contains("disabled");
  }

  public boolean isNextPageButtonDisable() {
    return nextPage.getAttribute("class").contains("disabled");
  }

  public void backToSubShipperTable() {
    inFrame(page -> {
      if (page.goBack.isDisplayedFast()) {
        page.goBack.click();
      }
    });
  }

  public void goToFirstPage() {
    while (!isPrevPageButtonDisable()) {
      prevPage.click();
    }
  }

  public void shipperDetailsDisplayed(String shipperName) {
    switchToNewWindow();
    String actualShipperName = getInputValueById("shipper-name");
    Assertions.assertThat(actualShipperName).as("Check corporate sub shipper")
        .isEqualTo(shipperName);
  }

  public static class B2bShipperTable extends AntTable<Shipper> {

    public static final String CULUMN_BRANCH_ID = "externalRef";
    public static final String ACTION_NINJA_DASH_LOGIN = "Ninja Dashboard Login";
    public static final String ACTION_EDIT = "Edit";

    public B2bShipperTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put(CULUMN_BRANCH_ID, "id")
          .put("name", "name")
          .put("email", "email")
          .build()
      );
      setActionButtonsLocators(ImmutableMap.of(
          ACTION_NINJA_DASH_LOGIN, "//tr[%d]/td[contains(@class,'action')]//button[1]",
          ACTION_EDIT, "//tr[%d]/td[contains(@class,'action')]//button[2]"));
      setEntityClass(Shipper.class);
    }

    @Override
    public int getRowsCount() {
      if (StringUtils.isNotBlank(tableLocator)) {
        return executeInContext(tableLocator,
            () -> getElementsCount(".//tr[@class]"));
      } else {
        return getElementsCount("//tr[@class]");
      }
    }
  }

  public static class BeforeYouGoModal extends AntModal {

    public BeforeYouGoModal(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    @FindBy(css = ".ant-typography")
    public PageElement message;

    @FindBy(xpath = ".//button[.='Cancel']")
    public Button cancel;

    @FindBy(xpath = ".//button[.='OK']")
    public Button ok;

  }
}
