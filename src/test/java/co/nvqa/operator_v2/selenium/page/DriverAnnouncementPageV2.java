package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.DriverAnnouncement;
import org.openqa.selenium.WebDriver;

public class DriverAnnouncementPageV2 extends SimpleReactPage {

  public DriverAnnouncementPageV2(WebDriver webDriver) {
    super(webDriver);
  }

  public static class DriverAnnouncementTable extends AntTableV3<DriverAnnouncement> {
    public DriverAnnouncementTable(WebDriver webDriver) {
      super(webDriver);
    }
  }
}
