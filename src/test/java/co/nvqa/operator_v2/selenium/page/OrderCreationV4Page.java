package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.order_create.v4.OrderRequestV4;
import co.nvqa.commons.model.order_create.v4.Timeslot;
import co.nvqa.commons.support.JsonHelper;
import co.nvqa.commons.utils.NvTestRuntimeException;
import co.nvqa.operator_v2.util.TestConstants;
import co.nvqa.operator_v2.util.TestUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.hamcrest.Matchers;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Map;

/**
 *
 * @author Sergey Mishanin
 */
@SuppressWarnings({"WeakerAccess", "unused"})
public class OrderCreationV4Page extends OperatorV2SimplePage
{
    private OrdersTable ordersTable;
    private UploadSummaryTable uploadSummaryTable;

    public OrderCreationV4Page(WebDriver webDriver)
    {
        super(webDriver);
        ordersTable = new OrdersTable(webDriver);
        uploadSummaryTable = new UploadSummaryTable(webDriver);
    }

    public void uploadXlsx(OrderRequestV4 order, int shipperId)
    {
        File createOrderXlsx = buildCreateOrderXlsx(order, shipperId);
        uploadXlsx(createOrderXlsx);
    }

    public void uploadXlsx(File createOrderXlsx)
    {
        clickNvIconTextButtonByName("Create Order");
        waitUntilVisibilityOfMdDialogByTitle("Upload Order CSV");
        sendKeysByAriaLabel("Choose", createOrderXlsx.getAbsolutePath());
        clickNvButtonSaveByNameAndWaitUntilDone("Submit");
        waitUntilInvisibilityOfMdDialogByTitle("Upload Order CSV");
        waitUntilInvisibilityOfElementLocated("//div[@class='md-half-circle']");
    }

    public void verifyOrderIsCreatedSuccessfully(OrderRequestV4 order)
    {
        ordersTable.searchOrderByTrackingId(order.getRequestedTrackingNumber());
        String totalSuccess = uploadSummaryTable.getTotalSuccess();
        Assert.assertEquals("Total Success", "1", totalSuccess);
        String totalOrders = uploadSummaryTable.getTotalOrders();
        Assert.assertEquals("Total Orders", "1", totalOrders);

        int rowNumber = 1;
        Assert.assertThat("Tracking ID", ordersTable.getTrackingId(rowNumber), Matchers.endsWith(order.getRequestedTrackingNumber()));
        Assert.assertThat("Service Level", ordersTable.getServiceLevel(rowNumber), Matchers.equalToIgnoringCase(order.getServiceLevel()));
        Assert.assertThat("From Name", ordersTable.getFromName(rowNumber), Matchers.equalTo(order.getFrom().getName()));
        Assert.assertThat("From Address", ordersTable.getFromAddress(rowNumber), Matchers.equalTo(buildAddress(order.getFrom().getAddress())));
        Assert.assertThat("To Name", ordersTable.getToName(rowNumber), Matchers.equalTo(order.getTo().getName()));
        Assert.assertThat("To Address", ordersTable.getToAddress(rowNumber), Matchers.equalTo(buildAddress(order.getTo().getAddress())));
        Assert.assertThat("Delivery Start Date", ordersTable.getDeliveryStartDate(rowNumber), Matchers.equalTo(order.getParcelJob().getDeliveryStartDate()));
        Assert.assertThat("Delivery Timeslot", ordersTable.getDeliveryTimeslot(rowNumber), Matchers.equalTo(buildTimeslot(order.getParcelJob().getDeliveryTimeslot())));
    }

    private String buildAddress(Map<String, String> addressMap)
    {
        String fromAddress;

        switch(TestConstants.COUNTRY_CODE.toUpperCase())
        {
            case "MNT":
            {
                fromAddress = addressMap.get("address1");
                fromAddress += " " + addressMap.getOrDefault("address2", "");
                fromAddress += " , " + addressMap.getOrDefault("city", "");
                fromAddress += " " + addressMap.getOrDefault("country", "");
                break;
            }
            default:
            {
                fromAddress = addressMap.get("address1");
                fromAddress += " " + addressMap.getOrDefault("address2", "");
                fromAddress += " " + addressMap.getOrDefault("country", "");
            }
        }

        return StringUtils.normalizeSpace(fromAddress.trim());
    }

    private String buildTimeslot(Timeslot timeslot)
    {
        return timeslot.getStartTime() + " - " + timeslot.getEndTime();
    }

    private static void addXlsxCell(XSSFRow row, int columnIndex, String value)
    {
        XSSFCell cell = row.createCell(columnIndex);
        cell.setCellValue(value);
    }

    private static void addXlsxPair(XSSFRow headerRow, XSSFRow valueRow, int columnIndex, String header, String value)
    {
        addXlsxCell(headerRow, columnIndex, header);
        addXlsxCell(valueRow, columnIndex, value);
    }

    private File buildCreateOrderXlsx(OrderRequestV4 order, int shipperId)
    {
        Map<String, Object> data = JsonHelper.fromJsonToFlatMap(JsonHelper.toJson(JsonHelper.getDefaultSnakeCaseMapper(), order));
        File excelFileName = TestUtils.createFileOnTempFolder(String.format("create-order-request_%s.xlsx", generateDateUniqueString()));
        data.put("shipper_id", shipperId);

        String sheetName = "Sheet 1";

        XSSFWorkbook wb = new XSSFWorkbook();
        XSSFSheet sheet = wb.createSheet(sheetName);
        XSSFRow headerRow = sheet.createRow(0);
        XSSFRow valueRow = sheet.createRow(1);

        int i = 0;

        for(Map.Entry<String, Object> entry : data.entrySet())
        {
            String header = entry.getKey();
            Object value = entry.getValue();
            addXlsxPair(headerRow, valueRow, i, header, value.toString());
            i++;
        }

        try(FileOutputStream fileOut = new FileOutputStream(excelFileName))
        {
            wb.write(fileOut);
            fileOut.flush();
        }
        catch(IOException ex)
        {
            throw new NvTestRuntimeException(ex);
        }

        return excelFileName;
    }

    public static class OrdersTable extends OperatorV2SimplePage
    {
        private static final String MD_VIRTUAL_REPEAT = "order in getTableData()";
        private static final String COLUMN_TRACKING_ID_CLASS = "tracking_number";
        private static final String COLUMN_SERVICE_LEVEL_CLASS = "service_level";
        private static final String COLUMN_FROM_NAME_CLASS = "from-name";
        private static final String COLUMN_FROM_ADDRESS_CLASS = "from_address";
        private static final String COLUMN_TO_NAME_CLASS = "to-name";
        private static final String COLUMN_TO_ADDRESS_CLASS = "to_address";
        private static final String COLUMN_DELIVERY_START_DATE_CLASS = "parcel_job-delivery_start_date";
        private static final String COLUMN_DELIVERY_TIMESLOT_CLASS = "delivery_timeslot_time";

        public OrdersTable(WebDriver webDriver)
        {
            super(webDriver);
        }

        public void searchOrderByTrackingId(String trackingId)
        {
            searchTableCustom1(COLUMN_TRACKING_ID_CLASS, trackingId);
        }

        public String getTrackingId(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_TRACKING_ID_CLASS);
        }

        public String getServiceLevel(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_SERVICE_LEVEL_CLASS);
        }

        public String getFromName(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_FROM_NAME_CLASS);
        }

        public String getFromAddress(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_FROM_ADDRESS_CLASS);
        }

        public String getToName(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_TO_NAME_CLASS);
        }

        public String getToAddress(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_TO_ADDRESS_CLASS);
        }

        public String getDeliveryStartDate(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_DELIVERY_START_DATE_CLASS);
        }

        public String getDeliveryTimeslot(int rowNumber)
        {
            return getTextOnTable(rowNumber, COLUMN_DELIVERY_TIMESLOT_CLASS);
        }

        private String getTextOnTable(int rowNumber, String columnDataClass)
        {
            return getTextOnTableWithMdVirtualRepeat(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT);
        }
    }

    public static class UploadSummaryTable extends OperatorV2SimplePage
    {
        private static final String XPATH_TOTAL_ORDERS = "//div[label[.='Total Orders']]/p";
        private static final String XPATH_TOTAL_SUCCESS = "//div[label[.='Total Success']]/p";

        public UploadSummaryTable(WebDriver webDriver)
        {
            super(webDriver);
        }

        public String getTotalOrders()
        {
            return getText(XPATH_TOTAL_ORDERS);
        }

        public String getTotalSuccess()
        {
            return getText(XPATH_TOTAL_SUCCESS);
        }
    }
}
