package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.dp.OrderCsvData;
import java.io.File;
import java.util.Arrays;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebDriver;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DpDataCheckingPage extends OperatorV2SimplePage{

  private static final Logger LOGGER = LoggerFactory.getLogger(DpDataCheckingPage.class);

  public DpDataCheckingPage(WebDriver webDriver) {
    super(webDriver);
  }

  public String getLatestDownloadOrderDataPathFile() {
    File file = new File(co.nvqa.common.utils.StandardTestConstants.TEMP_DIR);
    List <String> fileName = getFile(file);

    return co.nvqa.common.utils.StandardTestConstants.TEMP_DIR+fileName.get(0);
  }

  public List<String> getFile(File filePath) {
    return Arrays
        .stream(Objects.requireNonNull(filePath.list(), "file path not null"))
        .peek(s -> LOGGER.trace("available file: {}", s))
        .collect(Collectors.toList());
  }

  public void checkMsgFromRegularPickupCsv(List<String> reasons,
      List<OrderCsvData> orderCsvData) {
    int index = 0;
    for (OrderCsvData order : orderCsvData) {
      Assertions.assertThat(order.getStatus())
          .as(f("[%s] - %s", order.getTrackingId(), reasons.get(index)))
          .contains(reasons.get(index));
      index++;
    }
  }
}
