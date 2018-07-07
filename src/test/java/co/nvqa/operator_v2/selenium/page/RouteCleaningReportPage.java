package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.utils.StandardTestConstants;
import co.nvqa.operator_v2.model.RouteCleaningReportCodInfo;
import com.google.common.collect.ImmutableMap;
import org.apache.commons.lang3.StringUtils;
import org.hamcrest.Matchers;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import static co.nvqa.operator_v2.selenium.page.RouteCleaningReportPage.CodTable.COLUMN_COD_INBOUND;
import static org.hamcrest.Matchers.greaterThanOrEqualTo;

/**
 * @author Daniel Joi Partogi Hutapea
 */
public class RouteCleaningReportPage extends OperatorV2SimplePage
{
    private static final String EXCEL_FILENAME_PATTERN = "route-cleaning-report";
    private CodTable codTable;

    public RouteCleaningReportPage(WebDriver webDriver)
    {
        super(webDriver);
        codTable = new CodTable(webDriver);
    }

    public void clickButtonDownloadExcelReport()
    {
        clickNvIconTextButtonByName("container.route-cleaning-report.download-report");
    }

    public void verifyExcelFileIsDownloadedSuccessfully()
    {
        waitUntilInvisibilityOfElementLocated("//div[text()='Attempting to download route-cleaning-report.xls...']");
        waitUntilInvisibilityOfElementLocated("//div[text='Downloading route-cleaning-report.xls...']");
        verifyFileDownloadedSuccessfully(getLatestDownloadedFilename(EXCEL_FILENAME_PATTERN));
    }

    public void fetchByDate(Date date)
    {
        setMdDatepicker("ctrl.data.date", date);
        clickNvApiTextButtonByNameAndWaitUntilDone("container.route-cleaning-report.fetch");
    }

    public void selectCOD()
    {
        clickButtonByAriaLabel("COD");
    }

    public void selectParcel()
    {
        clickButtonByAriaLabel("Parcel");
    }

    public void selectReservation()
    {
        clickButtonByAriaLabel("Reservation");
    }

    public void downloadCsvForSelectedCOD(List<String> codInboundValues)
    {
        codInboundValues.forEach(codInbound -> {
            codTable.filterByColumn(COLUMN_COD_INBOUND, codInbound);
            codTable.selectRow(1);
        });
        clickButtonDownloadExcelReport();
    }

    public void verifyDownloadedCodCsvFileContent(List<RouteCleaningReportCodInfo> expectedCodInfoRecords)
    {
        String fileName = getLatestDownloadedFilename(EXCEL_FILENAME_PATTERN);
        verifyFileDownloadedSuccessfully(fileName);
        String pathName = StandardTestConstants.TEMP_DIR + fileName;
        List<RouteCleaningReportCodInfo> actualCodInfoRecords = RouteCleaningReportCodInfo.fromCsvFile(RouteCleaningReportCodInfo.class, pathName, true);

        Assert.assertThat("Unexpected number of lines in CSV file", actualCodInfoRecords.size(), greaterThanOrEqualTo(expectedCodInfoRecords.size()));

        Map<String, RouteCleaningReportCodInfo> actualMap = actualCodInfoRecords.stream().collect(Collectors.toMap(
                RouteCleaningReportCodInfo::getCodInbound,
                codInfo -> codInfo
        ));

        for (RouteCleaningReportCodInfo expectedCodInfo : expectedCodInfoRecords)
        {
            RouteCleaningReportCodInfo actualCodInfo = actualMap.get(expectedCodInfo.getCodInbound());
            verifyCodInfo(expectedCodInfo, actualCodInfo);
        }
    }

    public void verifyCodInfo(RouteCleaningReportCodInfo expectedCodInfo)
    {
        codTable.filterByColumn(COLUMN_COD_INBOUND, expectedCodInfo.getCodInbound());
        RouteCleaningReportCodInfo actualCodInfo = codTable.readEntity(1);
        verifyCodInfo(expectedCodInfo, actualCodInfo);
    }

    private void verifyCodInfo(RouteCleaningReportCodInfo expectedCodInfo, RouteCleaningReportCodInfo actualCodInfo)
    {
        if (StringUtils.isNotBlank(expectedCodInfo.getCodExpected()))
        {
            Assert.assertThat("COD Inbound", actualCodInfo.getCodInbound(), Matchers.equalTo(expectedCodInfo.getCodInbound()));
        }
        if (StringUtils.isNotBlank(expectedCodInfo.getCodExpected()))
        {
            Assert.assertThat("COD Expected", actualCodInfo.getCodInbound(), Matchers.equalTo(expectedCodInfo.getCodInbound()));
        }
        if (expectedCodInfo.getRouteId() != null)
        {
            Assert.assertThat("Route ID", actualCodInfo.getRouteId(), Matchers.equalTo(expectedCodInfo.getRouteId()));
        }
        if (StringUtils.isNotBlank(expectedCodInfo.getDriverName()))
        {
            Assert.assertThat("Driver Name", actualCodInfo.getDriverName(), Matchers.equalTo(expectedCodInfo.getDriverName()));
        }
    }

    /**
     * Accessor for COD table
     */
    public static class CodTable extends MdVirtualRepeatTable<RouteCleaningReportCodInfo>
    {
        public static final String COLUMN_COD_INBOUND = "codInbound";

        public CodTable(WebDriver webDriver)
        {
            super(webDriver);
            setColumnLocators(ImmutableMap.<String, String>builder()
                    .put(COLUMN_COD_INBOUND, "cod-inbounded")
                    .put("codExpected", "cod-expected")
                    .put("routeId", "route-id")
                    .put("driverName", "driver-name")
                    .build()
            );
            setEntityClass(RouteCleaningReportCodInfo.class);
        }
    }
}
