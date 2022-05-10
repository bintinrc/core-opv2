package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.page.DpAdministrationPage.DpPartnersTable;
import org.openqa.selenium.WebDriver;
import co.nvqa.operator_v2.selenium.elements.Button;
import org.openqa.selenium.support.FindBy;

public class DpAdministrationReactPage extends SimpleReactPage<DpAdministrationReactPage>{

  @FindBy(xpath = "//button[@data-testid='button_download_csv']")
  public Button buttonDownloadCsv;

  private final DpPartnersTable dpPartnersTable;

  public DpAdministrationReactPage(WebDriver webDriver) {
    super(webDriver);
    this.dpPartnersTable = new DpAdministrationPage.DpPartnersTable(webDriver);
  }

  public DpPartnersTable dpPartnersTable() {
    return dpPartnersTable;
  }
}
