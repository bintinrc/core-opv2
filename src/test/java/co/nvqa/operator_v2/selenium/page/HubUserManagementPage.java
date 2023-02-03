package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.FileInput;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect;
import java.io.File;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

public class HubUserManagementPage extends OperatorV2SimplePage {

  public HubUserManagementPage(WebDriver webDriver) {
    super(webDriver);
  }

  public String XPATH_OF_EDIT_BUTTON = "//button[@data-testid='view-users-navigation-button-%s']";

  public String hubTitleXpath = "//span[@title='%s']";

  @FindBy(xpath = "//div[@data-testid='hub-selection-select']")
  public AntSelect selectHub;

  @FindBy(xpath = "//input[@accept='.csv']")
  public FileInput uploadCsvFileInput;
  @FindBy(xpath = "//span[@class='ant-upload-span']//span[@class='ant-upload-list-item-name']")
  public PageElement uploadCsvFileName;
  @FindBy(xpath = "//button/span[@data-testid='submit-button']")
  public PageElement submitCsvFile;
  @FindBy(xpath = "//button[@data-testid='bulk-assign-button']")
  public Button bulkAssignButton;
  @FindBy(xpath = "//div[contains(text(),'file')]")
  public PageElement errorTitle;
  @FindBy(xpath = "//div/p[contains(text(),'upload')]")
  public PageElement errorBody;

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


