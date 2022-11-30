package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.util.TestConstants;
import java.time.ZonedDateTime;
import org.openqa.selenium.WebDriver;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class BulkAddToRoutePage extends OperatorV2SimplePage {

  public static final String NG_REPEAT = "row in $data";

  public BulkAddToRoutePage(WebDriver webDriver) {
    super(webDriver);
  }

  public void selectCurrentDate() {
    switch (TestConstants.NV_SYSTEM_ID.toUpperCase()) {
      case "MSI":
        setMdDatepickerById("commons.model.route-date", ZonedDateTime.now());
        break;
      default:
        setMdDatepickerById("commons.model.route-date",
            ZonedDateTime.now().minusDays(1)); //This is a hack for now. It should be select current date.
    }
  }

  public void selectRouteGroup(String routeGroupName) {
    selectMultipleValuesFromMdSelectById("select-route-group(s)", routeGroupName);
  }

  public void unselectTag(String tagName) {
    if (isElementExistFast(
        String.format("//md-switch[@aria-label='%s'][@aria-checked='true']", tagName))) {
      selectTag(tagName); //By clicking the tag, the tag will be switched to false.
    }
  }

  public void selectTag(String tagName) {
    clickf("//md-switch[@aria-label='%s']", tagName);
    pause100ms();
  }

  public void clickSubmit() {
    clickNvApiTextButtonByNameAndWaitUntilDone("commons.submit");
    waitUntilInvisibilityOfToast("Submitted successfully");
  }

  public String getTextOnTable(int rowNumber, String columnDataClass) {
    return getTextOnTableWithNgRepeat(rowNumber, columnDataClass, NG_REPEAT);
  }
}
