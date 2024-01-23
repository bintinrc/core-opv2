package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.ForceClearTextBox;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;


/**
 * @author Sergey Mishanin
 */
public class BatchOrderPage extends SimpleReactPage<BatchOrderPage> {

  @FindBy(css = "[data-testid='batchId-input']")
  public ForceClearTextBox batchId;

  @FindBy(css = "[data-testid='search-batch-id-button']")
  public Button search;

  @FindBy(css = "[data-testid='rollback-button']")
  public Button rollback;

  @FindBy(css = "[data-testid='password-input']")
  public ForceClearTextBox password;

  @FindBy(css = "[data-testid='modal-rollback-button']")
  public Button rollbackDialogButton;

  public String getCellText(int rowIndex, String columnIdentifier) {
    String cellLocator = String.format("[data-testid='row-%d-%s']", rowIndex + 1, columnIdentifier);
    WebElement cell = getWebDriver().findElement(By.cssSelector(cellLocator));
    return cell.getText();
  }

  public BatchOrderPage(WebDriver webDriver) {
    super(webDriver);

  }
}