package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.FileInput;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect;
import java.io.File;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

public class HubUserManagementPage extends SimpleReactPage<HubUserManagementPage> {

  public HubUserManagementPage(WebDriver webDriver) {
    super(webDriver);
  }

  public String XPATH_OF_EDIT_BUTTON = "//button[@data-testid='view-users-navigation-button-%s']";

  public String XPATH_OF_EDIT_USER_BUTTON = "//button[@data-testid='edit-button-%s']";

  public String XPATH_OF_REMOVE_USER_BUTTON = "//button[@data-testid='delete-button-%s']";

  public String XPATH_OF_USERNAME = "//td[@class='name']//*[contains(text(),'%s')]";

  public String XPATH_OF_HUB_SELECTED_HUB = "//span[@title='%s']";

  public String hubTitleXpath = "//span[@title='%s']";

  public String XPATH_OF_IFRAME = "//iframe";

  @FindBy(xpath = "//div[@data-testid='hub-selection-select']")
  public AntSelect selectHub;

  @FindBy(xpath = "//span[@class='delete-button-container']")
  public PageElement deleteButtonContainer;

  @FindBy(xpath = "//input[@accept='.csv']")
  public FileInput uploadCsvFileInput;

  @FindBy(xpath = "//th[contains(@class,'name')]//input")
  public PageElement usernameInput;

  @FindBy(xpath = "//td[contains(@class,'name')]//mark")
  public PageElement usernameHighlight;

  @FindBy(xpath = "//td[contains(@class,'role')]//mark")
  public PageElement roleHighlight;

  @FindBy(xpath = "//th[contains(@class,'role')]//input")
  public PageElement roleInput;


  @FindBy(xpath = "//span[@class='ant-upload-span']//span[@class='ant-upload-list-item-name']")
  public PageElement uploadCsvFileName;

  @FindBy(xpath = "//div[@class='ant-modal-title'][text()='Add a new user?']")
  public PageElement addNewUserModal;

  @FindBy(xpath = "//div[@class='ant-modal-title'][text()='Add User']")
  public PageElement addUserModal;

  @FindBy(xpath = "//div[@class='ant-modal-title'][text()='Edit user']")
  public PageElement editUserModal;

  @FindBy(xpath = "//div[@class='ant-modal-title'][text()='Remove User']")
  public PageElement removeUserModal;

  @FindBy(css = "[data-testid='remove-user-button']")
  public PageElement removeUserButton;

  @FindBy(xpath = "//input[@class='ant-input']")
  public PageElement searchHub;

  @FindBy(xpath = "//button/span[@data-testid='submit-button']")
  public PageElement submitCsvFile;

  @FindBy(xpath = "//button[@data-testid='bulk-assign-button']")
  public Button bulkAssignButton;

  @FindBy(xpath = "//div[contains(text(),'file')]")
  public PageElement errorTitle;

  @FindBy(xpath = "//div/p[contains(text(),'upload')]")
  public PageElement errorBody;

  @FindBy(xpath = "//p[@class='error']/span[contains(text(),'exceeds the maximum size.')]")
  public PageElement errorExceedMaximumSize;

  @FindBy(xpath = "//p[@class='error']/span[contains(text(),'contains no email')]")
  public PageElement errorContainsNoEmail;

  @FindBy(css = "[data-testid='add-user-button']")
  public PageElement addUserButton;

  @FindBy(css = "[data-testid='email-input']")
  public PageElement emailInput;

  @FindBy(css = "[id='role']")
  public PageElement roleSelection;

  @FindBy(css = "[data-testid='ok-text']")
  public PageElement addButton;

  @FindBy(xpath = "//button[@data-testid='edit-user-button']")
  public PageElement editUserButton;

  @FindBy(css = "[data-testid='username-or-email-input']")
  public PageElement usernameOrEmailInput;

  @FindBy(xpath = "//button[@disabled]/span[@data-testid='ok-text']")
  public PageElement disabledAddButton;

  @FindBy(css = "[data-testid='remove-button']")
  public PageElement removeButton;

  @FindBy(css = "[data-testid='search-button']")
  public PageElement searchButton;

  @FindBy(css = "[data-testid='selected-hub-1-selection']")
  public AntSelect selectHub1;

  @FindBy(css = "[data-testid='selected-hub-2-selection']")
  public AntSelect selectHub2;

  @FindBy(css = "[data-testid='selected-hub-3-selection']")
  public AntSelect selectHub3;

  public void uploadCsvFile(File file) {
    uploadCsvFileInput.sendKeys(file.getAbsoluteFile());
    uploadCsvFileName.waitUntilVisible();
    Assertions.assertThat(uploadCsvFileName.isDisplayed())
        .as("CSV file is SELECTED")
        .isTrue();
    Assertions.assertThat(uploadCsvFileName.getText())
        .as("Selected CSV file is CORRECT")
        .isEqualTo(file.getName());
  }

}


