package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.TaggedOrderParams;
import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect2;
import co.nvqa.operator_v2.selenium.elements.ant.AntSelect3;
import co.nvqa.operator_v2.selenium.elements.nv.NvFilterBox;
import co.nvqa.operator_v2.selenium.elements.nv.NvIconTextButton;
import com.google.common.collect.ImmutableMap;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

/**
 * @author Sergey Mishanin
 */
public class ViewTaggedOrdersPage extends SimpleReactPage<ViewTaggedOrdersPage> {

  @FindBy(xpath = "//div[contains(@class,'ant-select')][.//*[@id='orderTagOptions']]")
  public AntSelect3 orderTagsFilter;

  @FindBy(xpath = "//div[contains(@class,'ant-select')][.//*[@id='granularStatusOptions']]")
  public AntSelect3 granularStatusFilter;

  @FindBy(name = "container.view-tagged-orders.load-selection")
  public Button loadSelection;

  @FindBy(xpath = "//button[.='Clear Selection']")
  public Button clearSelection;

  @FindBy(css = "md-dialog")

  public TaggedOrdersTable taggedOrdersTable;

  public ViewTaggedOrdersPage(WebDriver webDriver) {
    super(webDriver);
    taggedOrdersTable = new TaggedOrdersTable(webDriver);
  }

  @Override
  public void waitUntilPageLoaded() {
    super.waitUntilPageLoaded();
    if (halfCircleSpinner.waitUntilVisible(3)) {
      halfCircleSpinner.waitUntilInvisible();
    }
  }

  public static class TaggedOrdersTable extends MdVirtualRepeatTable<TaggedOrderParams> {

    public static final String COLUMN_DRIVER = "driver";
    public static final String COLUMN_ROUTE = "route";
    public static final String COLUMN_TAGS = "tags";

    public TaggedOrdersTable(WebDriver webDriver) {
      super(webDriver);
      setColumnLocators(ImmutableMap.<String, String>builder()
          .put("trackingId", "tracking-id")
          .put(COLUMN_TAGS, "order-tags")
          .put(COLUMN_DRIVER, "driver-and-route")
          .put(COLUMN_ROUTE, "driver-and-route")
          .put("destinationHub", "destination-hub")
          .put("lastAttempt", "last-attempt")
          .put("daysFromFirstInbound", "days-from-first-inbound")
          .put("granularStatus", "granular-status")
          .build()
      );
      setMdVirtualRepeat("data in getTableData()");
      setColumnValueProcessors(ImmutableMap.of(
          COLUMN_DRIVER,
          value -> value == null ? null : StringUtils.normalizeSpace(value.split(" - ")[0]),
          COLUMN_ROUTE,
          value -> value == null ? null : StringUtils.normalizeSpace(value.split(" - ")[1]),
          COLUMN_TAGS, value -> value == null ? null
              : StringUtils.replace(StringUtils.normalizeSpace(value), " ", ",")
      ));
      setEntityClass(TaggedOrderParams.class);
    }

  }

}