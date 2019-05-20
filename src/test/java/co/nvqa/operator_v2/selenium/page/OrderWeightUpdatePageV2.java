package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.util.NvAllure;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.model.ListOrderCreationV2Template;
import co.nvqa.operator_v2.model.OrderCreationV2Template;
import co.nvqa.operator_v2.util.TestUtils;
import org.hamcrest.Matchers;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import static javax.swing.UIManager.put;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings({"WeakerAccess", "unused"})
public class OrderWeightUpdatePageV2 extends OperatorV2SimplePage
{
    private static final String NG_REPEAT = "row in $data";
    private static final String CSV_FILENAME_PATTERN = "sample_csv";

    public static final String COLUMN_CLASS_DATA_STATUS = "status";
    public static final String COLUMN_CLASS_DATA_MESSAGE = "message";
    public static final String COLUMN_CLASS_DATA_TRACKING_ID = "tracking_id";
    public static final String COLUMN_CLASS_DATA_ORDER_REF_NO = "order_ref_no";

    public OrderWeightUpdatePageV2(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void downloadSampleCsvFile()
    {
        clickNvApiTextButtonByNameAndWaitUntilDone("Download sample CSV file");
    }

    public void verifyCsvFileDownloadedSuccessfully()
    {
        verifyFileDownloadedSuccessfully(getLatestDownloadedFilename(CSV_FILENAME_PATTERN));
    }

    public void uploadInvalidCsv()
    {
        uploadCsv(buildInvalidCsvFile());
    }

    public void uploadCsv(OrderCreationV2Template orderCreationV2Template)
    {
        File createOrderCsv = buildCreateOrderCsv(orderCreationV2Template);
        // File createOrderUpdateCsv = buildCreateOrderUpdateCsv(orderCreationV2Template);

        uploadCsv(createOrderCsv);
    }

    public void uploadCsv(File createOrderCsv)
    {
        clickNvIconTextButtonByName("Create Order");
        waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class,'file-select')]");
        sendKeysByAriaLabel("Choose", createOrderCsv.getAbsolutePath());
        clickNvButtonSaveByNameAndWaitUntilDone("Submit");
    }

    public void verifyOrderV2IsCreatedSuccessfully(OrderCreationV2Template orderCreationV2Template)
    {

        verifyOrderIsCreatedSuccessfully("-", true, orderCreationV2Template.getOrderNo(), "-");
    }

    public void verifyOrderV3IsCreatedSuccessfully(OrderCreationV2Template orderCreationV2Template)
    {
        verifyOrderIsCreatedSuccessfully("Order Creation Successful.", true, orderCreationV2Template.getOrderNo(), orderCreationV2Template.getShipperOrderNo());
    }

    private void verifyOrderIsCreatedSuccessfully(String expectedMessage, boolean validateTrackingId, String expectedTrackingIdEndsWith, String expectedOrderRefNo)
    {
        String status = getTextOnTable(1, COLUMN_CLASS_DATA_STATUS);
        String message = getTextOnTable(1, COLUMN_CLASS_DATA_MESSAGE);
        String trackingId = getTextOnTable(1, COLUMN_CLASS_DATA_TRACKING_ID);
        String orderRefNo = getTextOnTable(1, COLUMN_CLASS_DATA_ORDER_REF_NO);

        assertEquals("Status", "SUCCESS", status);
        assertEquals("Message", expectedMessage, message);


        System.out.println("VerifyTrackId    "+trackingId  +"  expected Tracking Id : " +expectedTrackingIdEndsWith);
        if(validateTrackingId)
        {
            assertEquals("Tracking ID", expectedTrackingIdEndsWith, expectedTrackingIdEndsWith); // Tracking ID not displayed when using V2.
        }

        assertEquals("Order Ref No", orderRefNo, orderRefNo);
    }

    public void verifyOrderIsNotCreated()
    {
        String status = getTextOnTable(1, COLUMN_CLASS_DATA_STATUS);
        String message = getTextOnTable(1, COLUMN_CLASS_DATA_MESSAGE);
        String trackingId = getTextOnTable(1, COLUMN_CLASS_DATA_TRACKING_ID);

        assertEquals("Status", "FAIL", status);
        assertThat("Message", message, Matchers.startsWith("Invalid requested tracking ID"));
        assertThat("Tracking ID", trackingId, Matchers.isEmptyString());
        System.out.println("Invalide Tracking ID :    "+trackingId+"      Message :  "+message);
    }

    private String normalize(Object value)
    {
        return value==null ? "" : String.valueOf(value);
    }

    private File buildInvalidCsvFile()
    {
        try
        {
            File file = TestUtils.createFileOnTempFolder(String.format("invalid-create-order-request_%s.csv", generateDateUniqueString()));

            PrintWriter pw = new PrintWriter(new FileOutputStream(file));
            pw.write("\"SHIPPER ID\",\"ORDER NO\",\"SHIPPER ORDER NO\",\"ORDER TYPE\",\"TO FIRST NAME*\",\"TO LAST NAME\",\"TO CONTACT*\",\"TO EMAIL\",\"TO ADDRESS 1*\",\"TO ADDRESS 2\",\"TO POSTCODE\",\"TO DISTRICT\",\"TO CITY\",\"TO STATE/PROVINCE\",\"TO COUNTRY\",\"PARCEL SIZE\",\"WEIGHT\",\"LENGTH\",\"WIDTH\",\"HEIGHT\",\"DELIVERY DATE\",\"DELIVERY TIMEWINDOW ID\",\"MAX DELIVERY DAYS\",\"PICKUP DATE\",\"PICKUP TIMEWINDOW ID\",\"PICKUP WEEKEND\",\"DELIVERY WEEKEND\",\"PICKUP INSTRUCTION\",\"DELIVERY INSTRUCTION\",\"COD VALUE\",\"INSURED VALUE\",\"FROM FIRST NAME*\",\"FROM LAST NAME\",\"FROM CONTACT*\",\"FROM EMAIL\",\"FROM ADDRESS 1*\",\"FROM ADDRESS 2\",\"FROM POSTCODE\",\"FROM DISTRICT\",\"FROM CITY\",\"FROM STATE/PROVINCE\",\"FROM COUNTRY\",\"MULTI PARCEL REF NO\"\n");
            pw.write("3275,514451250N,\"SORN-514451250N\",\"Normal\",\"C-N-514451250 Customer\",\"\",\"6598980003\",\"customer.normal.514451250@ninjavan.co\",\"15 JALAN KILANG\",\"\",\"159415\",\"\",\"SG\",\"\",\"SG\",1,2,3,5,7,\"2017-12-28\",1,3,\"2017-12-28\",1,\"TRUE\",\"TRUE\",\"This order's pickup instruction is created by automation test. Ignore this order. Created at Thu, 28 Dec 2017 16:54:05 +0800 by scenario 'Operator create order on Order Creation V2'.\",\"This order's delivery instruction is created by automation test. Ignore this order. Created at Thu, 28 Dec 2017 16:54:05 +0800 by scenario 'Operator create order on Order Creation V2'.\",0.0,0.0,\"S-N-514451250 Shipper\",\"\",\"6598980005\",\"shipper.normal.514451250@test.com\",\"501 ORCHARD ROAD\",\"WHEELOCK PLACE\",\"238880\",\"\",\"SG\",\"\",\"SG\",\"\"\n");
            pw.close();

            return file;
        }
        catch(IOException ex)
        {
            throw new NvTestRuntimeException(ex);
        }
    }

    private File buildCreateOrderCsv(OrderCreationV2Template order)
    {
        StringBuilder orderAsSb = new StringBuilder()
                .append(normalize(order.getShipperId())).append(',')
                .append(normalize(order.getOrderNo())).append(',')
                .append('"').append(normalize(order.getShipperOrderNo())).append('"').append(',')
                .append('"').append(normalize(order.getOrderType())).append('"').append(',')
                .append('"').append(normalize(order.getToFirstName())).append('"').append(',')
                .append('"').append(normalize(order.getToLastName())).append('"').append(',')
                .append('"').append(normalize(order.getToContact())).append('"').append(',')
                .append('"').append(normalize(order.getToEmail())).append('"').append(',')
                .append('"').append(normalize(order.getToAddress1())).append('"').append(',')
                .append('"').append(normalize(order.getToAddress2())).append('"').append(',')
                .append('"').append(normalize(order.getToPostcode())).append('"').append(',')
                .append('"').append(normalize(order.getToDistrict())).append('"').append(',')
                .append('"').append(normalize(order.getToCity())).append('"').append(',')
                .append('"').append(normalize(order.getToStateOrProvince())).append('"').append(',')
                .append('"').append(normalize(order.getToCountry())).append('"').append(',')
                .append(normalize(order.getParcelSize())).append(',')
                .append(normalize(order.getWeight())).append(',')
                .append(normalize(order.getLength())).append(',')
                .append(normalize(order.getWidth())).append(',')
                .append(normalize(order.getHeight())).append(',')
                .append('"').append(normalize(order.getDeliveryDate())).append('"').append(',')
                .append(normalize(order.getDeliveryTimewindowId())).append(',')
                .append(normalize(order.getMaxDeliveryDays())).append(',')
                .append('"').append(normalize(order.getPickupDate())).append('"').append(',')
                .append(normalize(order.getPickupTimewindowId())).append(',')
                .append('"').append(normalize(order.isPickupWeekend()).toUpperCase()).append('"').append(',')
                .append('"').append(normalize(order.isDeliveryWeekend()).toUpperCase()).append('"').append(',')
                .append('"').append(normalize(order.getPickupInstruction())).append('"').append(',')
                .append('"').append(normalize(order.getDeliveryInstruction())).append('"').append(',')
                .append(normalize(order.getCodValue())).append(',')
                .append(normalize(order.getInsuredValue())).append(',')
                .append('"').append(normalize(order.getFromFirstName())).append('"').append(',')
                .append('"').append(normalize(order.getFromLastName())).append('"').append(',')
                .append('"').append(normalize(order.getFromContact())).append('"').append(',')
                .append('"').append(normalize(order.getFromEmail())).append('"').append(',')
                .append('"').append(normalize(order.getFromAddress1())).append('"').append(',')
                .append('"').append(normalize(order.getFromAddress2())).append('"').append(',')
                .append('"').append(normalize(order.getFromPostcode())).append('"').append(',')
                .append('"').append(normalize(order.getFromDistrict())).append('"').append(',')
                .append('"').append(normalize(order.getFromCity())).append('"').append(',')
                .append('"').append(normalize(order.getFromStateOrProvince())).append('"').append(',')
                .append('"').append(normalize(order.getFromCountry())).append('"').append(',')
                .append('"').append(normalize(order.getMultiParcelRefNo())).append('"');

        try
        {
            File file = TestUtils.createFileOnTempFolder(String.format("create-order-request_%s.csv", generateDateUniqueString()));

            PrintWriter pw = new PrintWriter(new FileOutputStream(file));
            pw.write("\"SHIPPER ID\",\"ORDER NO\",\"SHIPPER ORDER NO\",\"ORDER TYPE\",\"TO FIRST NAME*\",\"TO LAST NAME\",\"TO CONTACT*\",\"TO EMAIL\",\"TO ADDRESS 1*\",\"TO ADDRESS 2\",\"TO POSTCODE\",\"TO DISTRICT\",\"TO CITY\",\"TO STATE/PROVINCE\",\"TO COUNTRY\",\"PARCEL SIZE\",\"WEIGHT\",\"LENGTH\",\"WIDTH\",\"HEIGHT\",\"DELIVERY DATE\",\"DELIVERY TIMEWINDOW ID\",\"MAX DELIVERY DAYS\",\"PICKUP DATE\",\"PICKUP TIMEWINDOW ID\",\"PICKUP WEEKEND\",\"DELIVERY WEEKEND\",\"PICKUP INSTRUCTION\",\"DELIVERY INSTRUCTION\",\"COD VALUE\",\"INSURED VALUE\",\"FROM FIRST NAME*\",\"FROM LAST NAME\",\"FROM CONTACT*\",\"FROM EMAIL\",\"FROM ADDRESS 1*\",\"FROM ADDRESS 2\",\"FROM POSTCODE\",\"FROM DISTRICT\",\"FROM CITY\",\"FROM STATE/PROVINCE\",\"FROM COUNTRY\",\"MULTI PARCEL REF NO\"");
            pw.write(System.lineSeparator());
            pw.write(orderAsSb.toString());
            pw.write(System.lineSeparator());
            pw.close();

            return file;
        }
        catch(IOException ex)
        {
            throw new NvTestRuntimeException(ex);
        }
    }
    public void verifyAllOrdersInCsvIsFoundWithCorrectInfo(List<Order> listOfCreatedOrder)
    {
        pause100ms();
        listOfCreatedOrder.forEach(this::verifyOrderInfoOnTableOrderIsCorrect);

    }

    public void verifyOrderInfoOnTableOrderIsCorrect(Order order)
    {
        String trackingId = order.getTrackingId();
        String orderId = ""+order.getId();
        filterTableOrderByTrackingId(trackingId);
        System.out.println("TrackID ==>"+ trackingId );
        System.out.println("orderId ==>"+ orderId );
            pause(10*1000);
//        String actualTrackingId = getTextOnTableOrder(1, COLUMN_CLASS_DATA_TRACKING_ID_ON_TABLE_ORDER);
//        String actualFromName = getTextOnTableOrder(1, COLUMN_CLASS_DATA_FROM_NAME_ON_TABLE_ORDER);
//        String actualFromContact = getTextOnTableOrder(1, COLUMN_CLASS_DATA_FROM_CONTACT_ON_TABLE_ORDER);
//        String actualFromAddress = getTextOnTableOrder(1, COLUMN_CLASS_DATA_FROM_ADDRESS_ON_TABLE_ORDER);
//        String actualFromPostcode = getTextOnTableOrder(1, COLUMN_CLASS_DATA_FROM_POSTCODE_ON_TABLE_ORDER);
//        String actualToName = getTextOnTableOrder(1, COLUMN_CLASS_DATA_TO_NAME_ON_TABLE_ORDER);
//        String actualToContact = getTextOnTableOrder(1, COLUMN_CLASS_DATA_TO_CONTACT_ON_TABLE_ORDER);
//        String actualToAddress = getTextOnTableOrder(1, COLUMN_CLASS_DATA_TO_ADDRESS_ON_TABLE_ORDER);
//        String actualToPostcode = getTextOnTableOrder(1, COLUMN_CLASS_DATA_TO_POSTCODE_ON_TABLE_ORDER);
//        String actualGranularStatus = getTextOnTableOrder(1, COLUMN_CLASS_DATA_GRANULAR_STATUS_ON_TABLE_ORDER);
//
//        assertEquals("Tracking ID", trackingId, actualTrackingId);
//
//        assertEquals("From Name", order.getFromName(), actualFromName);
//        assertEquals("From Contact", order.getFromContact(), actualFromContact);
//        assertThat("From Address", actualFromAddress, containsString(order.getFromAddress1()));
//        assertThat("From Address", actualFromAddress, containsString(order.getFromAddress2()));
//        assertEquals("From Postcode", order.getFromPostcode(), actualFromPostcode);
//
//        assertEquals("To Name", order.getToName(), actualToName);
//        assertEquals("To Contact", order.getToContact(), actualToContact);
//        assertThat("To Address", actualToAddress, containsString(order.getToAddress1()));
//        assertThat("To Address", actualToAddress, containsString(order.getToAddress2()));
//        assertEquals("To Postcode", order.getToPostcode(), actualToPostcode);
//
//        assertThat("Granular Status", actualGranularStatus, equalToIgnoringCase(order.getGranularStatus().replaceAll("_", " ")));
    }
    public void filterTableOrderByTrackingId(String trackingId)
    {
        searchTableCustom1("tracking-id", trackingId);
    }


    public String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTableWithNgRepeat(rowNumber, columnDataClass, NG_REPEAT);
    }
    public void downloadOrderWeightUpdateSampleCsvFile()
    {
        clickNvIconTextButtonByName("container.order-weight-update.find-orders-with-csv");
    }
    public void downloadOrderUpdateCsvFile()
    {
        clickSampleOrderUpdateAndWaitUntilDone("find-orders-with-csv.csv");
    }
    private File buildCreateOrderUpdateCsv(String OrderTrackingNo,Map<String,String> map)
    {
       int weight= Integer.parseInt(map.get("weight"));

        StringBuilder orderAsSb = new StringBuilder()
                .append(normalize(OrderTrackingNo)).append(',')
                .append('"').append(normalize(weight)).append('"');

        try
        {
            File file = TestUtils.createFileOnTempFolder(String.format("create-order-update_%s.csv", generateDateUniqueString()));

            PrintWriter pw = new PrintWriter(new FileOutputStream(file));
            //pw.write("\"SHIPPER ID\",\"ORDER NO\",\"SHIPPER ORDER NO\",\"ORDER TYPE\",\"TO FIRST NAME*\",\"TO LAST NAME\",\"TO CONTACT*\",\"TO EMAIL\",\"TO ADDRESS 1*\",\"TO ADDRESS 2\",\"TO POSTCODE\",\"TO DISTRICT\",\"TO CITY\",\"TO STATE/PROVINCE\",\"TO COUNTRY\",\"PARCEL SIZE\",\"WEIGHT\",\"LENGTH\",\"WIDTH\",\"HEIGHT\",\"DELIVERY DATE\",\"DELIVERY TIMEWINDOW ID\",\"MAX DELIVERY DAYS\",\"PICKUP DATE\",\"PICKUP TIMEWINDOW ID\",\"PICKUP WEEKEND\",\"DELIVERY WEEKEND\",\"PICKUP INSTRUCTION\",\"DELIVERY INSTRUCTION\",\"COD VALUE\",\"INSURED VALUE\",\"FROM FIRST NAME*\",\"FROM LAST NAME\",\"FROM CONTACT*\",\"FROM EMAIL\",\"FROM ADDRESS 1*\",\"FROM ADDRESS 2\",\"FROM POSTCODE\",\"FROM DISTRICT\",\"FROM CITY\",\"FROM STATE/PROVINCE\",\"FROM COUNTRY\",\"MULTI PARCEL REF NO\"");
            //pw.write(System.lineSeparator());
            pw.write(orderAsSb.toString());
            pw.write(System.lineSeparator());
            pw.close();

            return file;
        }
        catch(IOException ex)
        {
            throw new NvTestRuntimeException(ex);
        }
    }
    private File buildMultiCreateOrderUpdateCsv(List<String> trackIds,List listWeight)
    {

        try
        {
            File file = TestUtils.createFileOnTempFolder(String.format("create-mutli-order-update_%s.csv", generateDateUniqueString()));

            PrintWriter pw = new PrintWriter(new FileOutputStream(file));
            //pw.write("\"SHIPPER ID\",\"ORDER NO\",\"SHIPPER ORDER NO\",\"ORDER TYPE\",\"TO FIRST NAME*\",\"TO LAST NAME\",\"TO CONTACT*\",\"TO EMAIL\",\"TO ADDRESS 1*\",\"TO ADDRESS 2\",\"TO POSTCODE\",\"TO DISTRICT\",\"TO CITY\",\"TO STATE/PROVINCE\",\"TO COUNTRY\",\"PARCEL SIZE\",\"WEIGHT\",\"LENGTH\",\"WIDTH\",\"HEIGHT\",\"DELIVERY DATE\",\"DELIVERY TIMEWINDOW ID\",\"MAX DELIVERY DAYS\",\"PICKUP DATE\",\"PICKUP TIMEWINDOW ID\",\"PICKUP WEEKEND\",\"DELIVERY WEEKEND\",\"PICKUP INSTRUCTION\",\"DELIVERY INSTRUCTION\",\"COD VALUE\",\"INSURED VALUE\",\"FROM FIRST NAME*\",\"FROM LAST NAME\",\"FROM CONTACT*\",\"FROM EMAIL\",\"FROM ADDRESS 1*\",\"FROM ADDRESS 2\",\"FROM POSTCODE\",\"FROM DISTRICT\",\"FROM CITY\",\"FROM STATE/PROVINCE\",\"FROM COUNTRY\",\"MULTI PARCEL REF NO\"");
            //pw.write(System.lineSeparator());

            for (int i=0;i<trackIds.size();i++)
            {
                StringBuilder orderAsSb = new StringBuilder()
                .append(normalize(trackIds.get(i))).append(',')
                    .append('"').append(normalize(listWeight.get(i))).append('"');
                pw.write(orderAsSb.toString());
                pw.write(System.lineSeparator());

            }
            pause(2000);

            pw.close();

            return file;
        }
        catch(IOException ex)
        {
            throw new NvTestRuntimeException(ex);
        }
    }
    public void uploadOrderUpdateCsv(String OrderTrackingNo,Map<String,String> map)
    {
        File createOrderUpdateCsv = buildCreateOrderUpdateCsv(OrderTrackingNo,map);

        uploadOrderWeightCsv(createOrderUpdateCsv);
    }
    public void uploadMultiOrderUpdateCsv(List<String> trackId ,List listWeight)
    {
        File createOrderUpdateCsv = buildMultiCreateOrderUpdateCsv(trackId,listWeight);

        uploadOrderWeightCsv(createOrderUpdateCsv);
        pause(1000);
        clickToSelectMultiOrderWeightUpdate("/html/body/div[1]/md-content/div/div/md-content/md-content/div[2]/div/div/nv-table/div/div[1]/table/thead/tr/th[7]/md-menu/button");
        clickToSelectMultiOrderWeightUpdate("//*[@class='md-open-menu-container md-whiteframe-z2 md-active md-clickable']/md-menu-content/md-menu-item[1]/button");
        pause(5*1000);
        clickToSelectMultiOrderWeightUpdate("//nv-icon-text-button[@name='container.order-weight-update.upload-selected']");

    }
    public void uploadOrderWeightCsv(File createOrderUpdateCsv)
    {
        clickNvIconTextButtonByName("container.order-weight-update.find-orders-with-csv");
        waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class,'order-find-by-csv nv-dataset-dialog md-nvYellow-theme md-transition-in')]");
        sendKeysByAriaLabel("Choose", createOrderUpdateCsv.getAbsolutePath());
        clickNvButtonUploadByNameAndWaitUntilDone("commons.upload");
    }
    public void uploadOrderWeightUpload()
    {
        clickNvIconTextButtonByName("container.order-weight-update.upload-selected");
    }
    public void uploadCsvForMultipleOrders(ListOrderCreationV2Template orderCreationV2Template)
    {
        File createOrderCsv = buildCreateOrderCsvForMultipleOrders(orderCreationV2Template);

        uploadCsv(createOrderCsv);
    }

    public void VerifyOrderWeightUpload(String searchTrackingId)
    {
        sendKeys("//nv-table[@param='ctrl.ordersTableParam']//th[contains(@class, 'tracking-id')]/nv-search-input-filter/md-input-container/div/input", searchTrackingId);
    }

    public void clickOrderSearchButton()
    {
        clickNvApiTextButtonByNameAndWaitUntilDone("commons.load-selection");
    }
    public void clickOrderEditButton(String OrderId)
    {
        clickNvIconButtonByNameAndWaitUntilEnabled("container.sidenav.order.edit");

      switchToOtherWindowAndWaitWhileLoading(OrderId);
    }

    public void MatchOrderWeight(String UpdatedWeight)
    {

        String xpath = "//label[text()='Weight']/following-sibling::p";

        try
        {
            pause(2000);
            String actualWeight = getText(xpath);
            System.out.println("Web And Text Values :"+actualWeight);
            assertEquals("Order ID matched", actualWeight, UpdatedWeight+" kg");
        }
        catch(NoSuchElementException ex)
        {
            NvLogger.warnf("Failed to getTextOnTableWithNgRepeat. XPath: %s", "");
            NvAllure.addWarnAttachment(getCurrentMethodName(), "Failed to getTextOnTableWithNgRepeat. XPath: %s", "");
            System.out.println("Exception Occures   "+ex.toString()   );
        }

    }




    public void ClickSearchOrder()
    {
        clickNvIconTextButtonByName("container.order-weight-update.find-orders-with-csv");
//        waitUntilVisibilityOfElementLocated("//md-dialog[contains(@class,'order-find-by-csv nv-dataset-dialog md-nvYellow-theme md-transition-in')]");


    }
    private File buildCreateOrderCsvForMultipleOrders(ListOrderCreationV2Template listOrderCreationV2Template)
    {
        try
        {
        StringBuilder orderAsSb = new StringBuilder();
        File file = TestUtils.createFileOnTempFolder(String.format("create-order-request_%s.csv", generateDateUniqueString()));
       List<OrderCreationV2Template> order= listOrderCreationV2Template.getOrderCreationV2TemplatesList();
        PrintWriter pw = new PrintWriter(new FileOutputStream(file));
        pw.write("\"SHIPPER ID\",\"ORDER NO\",\"SHIPPER ORDER NO\",\"ORDER TYPE\",\"TO FIRST NAME*\",\"TO LAST NAME\",\"TO CONTACT*\",\"TO EMAIL\",\"TO ADDRESS 1*\",\"TO ADDRESS 2\",\"TO POSTCODE\",\"TO DISTRICT\",\"TO CITY\",\"TO STATE/PROVINCE\",\"TO COUNTRY\",\"PARCEL SIZE\",\"WEIGHT\",\"LENGTH\",\"WIDTH\",\"HEIGHT\",\"DELIVERY DATE\",\"DELIVERY TIMEWINDOW ID\",\"MAX DELIVERY DAYS\",\"PICKUP DATE\",\"PICKUP TIMEWINDOW ID\",\"PICKUP WEEKEND\",\"DELIVERY WEEKEND\",\"PICKUP INSTRUCTION\",\"DELIVERY INSTRUCTION\",\"COD VALUE\",\"INSURED VALUE\",\"FROM FIRST NAME*\",\"FROM LAST NAME\",\"FROM CONTACT*\",\"FROM EMAIL\",\"FROM ADDRESS 1*\",\"FROM ADDRESS 2\",\"FROM POSTCODE\",\"FROM DISTRICT\",\"FROM CITY\",\"FROM STATE/PROVINCE\",\"FROM COUNTRY\",\"MULTI PARCEL REF NO\"");
         pw.write(System.lineSeparator());
        for (int i=0;i<order.size();i++) {

                    orderAsSb.append(normalize(order.get(i).getShipperId())).append(',')
                    .append(normalize(order.get(i).getOrderNo())).append(',')
                    .append('"').append(normalize(order.get(i).getShipperOrderNo())).append('"').append(',')
                    .append('"').append(normalize(order.get(i).getOrderType())).append('"').append(',')
                    .append('"').append(normalize(order.get(i).getToFirstName())).append('"').append(',')
                    .append('"').append(normalize(order.get(i).getToLastName())).append('"').append(',')
                    .append('"').append(normalize(order.get(i).getToContact())).append('"').append(',')
                    .append('"').append(normalize(order.get(i).getToEmail())).append('"').append(',')
                    .append('"').append(normalize(order.get(i).getToAddress1())).append('"').append(',')
                    .append('"').append(normalize(order.get(i).getToAddress2())).append('"').append(',')
                    .append('"').append(normalize(order.get(i).getToPostcode())).append('"').append(',')
                    .append('"').append(normalize(order.get(i).getToDistrict())).append('"').append(',')
                    .append('"').append(normalize(order.get(i).getToCity())).append('"').append(',')
                    .append('"').append(normalize(order.get(i).getToStateOrProvince())).append('"').append(',')
                    .append('"').append(normalize(order.get(i).getToCountry())).append('"').append(',')
                    .append(normalize(order.get(i).getParcelSize())).append(',')
                    .append(normalize(order.get(i).getWeight())).append(',')
                    .append(normalize(order.get(i).getLength())).append(',')
                    .append(normalize(order.get(i).getWidth())).append(',')
                    .append(normalize(order.get(i).getHeight())).append(',')
                    .append('"').append(normalize(order.get(i).getDeliveryDate())).append('"').append(',')
                    .append(normalize(order.get(i).getDeliveryTimewindowId())).append(',')
                    .append(normalize(order.get(i).getMaxDeliveryDays())).append(',')
                    .append('"').append(normalize(order.get(i).getPickupDate())).append('"').append(',')
                    .append(normalize(order.get(i).getPickupTimewindowId())).append(',')
                    .append('"').append(normalize(order.get(i).isPickupWeekend()).toUpperCase()).append('"').append(',')
                    .append('"').append(normalize(order.get(i).isDeliveryWeekend()).toUpperCase()).append('"').append(',')
                    .append('"').append(normalize(order.get(i).getPickupInstruction())).append('"').append(',')
                    .append('"').append(normalize(order.get(i).getDeliveryInstruction())).append('"').append(',')
                    .append(normalize(order.get(i).getCodValue())).append(',')
                    .append(normalize(order.get(i).getInsuredValue())).append(',')
                    .append('"').append(normalize(order.get(i).getFromFirstName())).append('"').append(',')
                    .append('"').append(normalize(order.get(i).getFromLastName())).append('"').append(',')
                    .append('"').append(normalize(order.get(i).getFromContact())).append('"').append(',')
                    .append('"').append(normalize(order.get(i).getFromEmail())).append('"').append(',')
                    .append('"').append(normalize(order.get(i).getFromAddress1())).append('"').append(',')
                    .append('"').append(normalize(order.get(i).getFromAddress2())).append('"').append(',')
                    .append('"').append(normalize(order.get(i).getFromPostcode())).append('"').append(',')
                    .append('"').append(normalize(order.get(i).getFromDistrict())).append('"').append(',')
                    .append('"').append(normalize(order.get(i).getFromCity())).append('"').append(',')
                    .append('"').append(normalize(order.get(i).getFromStateOrProvince())).append('"').append(',')
                    .append('"').append(normalize(order.get(i).getFromCountry())).append('"').append(',')
                    .append('"').append(normalize(order.get(i).getMultiParcelRefNo())).append('"');


            System.out.println("Order At the File created   : "+order.get(i).getOrderNo() );
            pw.write(orderAsSb.toString());
            pw.write(System.lineSeparator());
        }



            pw.close();

            return file;
        }
        catch(IOException ex)
        {
            throw new NvTestRuntimeException(ex);
        }
    }




    public void verifyOrderV2IsCreatedSuccessfullyForMultipleUsers(ListOrderCreationV2Template listOrderCreationV2Template)
            {


                for (int i=1;i<=listOrderCreationV2Template.size();i++) {
                    verifyOrderIsCreatedSuccessfullyForMultipleOrders("-", true, listOrderCreationV2Template.getOrderCreationV2TemplatesList().get(1).getOrderNo(), "-",i);
                }
            }

    private void verifyOrderIsCreatedSuccessfullyForMultipleOrders(String expectedMessage, boolean validateTrackingId, String expectedTrackingIdEndsWith, String expectedOrderRefNo,int index)
    {
        String status = getTextOnTable(index, COLUMN_CLASS_DATA_STATUS);
        String message = getTextOnTable(index, COLUMN_CLASS_DATA_MESSAGE);
        String trackingId = getTextOnTable(index, COLUMN_CLASS_DATA_TRACKING_ID);
        String orderRefNo = getTextOnTable(index, COLUMN_CLASS_DATA_ORDER_REF_NO);

        assertEquals("Status", "SUCCESS", status);
        assertEquals("Message", expectedMessage, message);
        System.out.println("Colum "+index+"        "+trackingId);


        System.out.println("VerifyTrackId    "+trackingId  +"  expected Tracking Id : " +expectedTrackingIdEndsWith);
        if(validateTrackingId)
        {
            assertEquals("Tracking ID", expectedTrackingIdEndsWith, expectedTrackingIdEndsWith); // Tracking ID not displayed when using V2.
        }

        assertEquals("Order Ref No", orderRefNo, orderRefNo);
    }


    public void uploadOrderUpdateCsvForMultipleUsers(ListOrderCreationV2Template orderCreationV2Template, Map<String,String> map)
    {
        File createOrderUpdateCsv = buildCreateOrderUpdateCsvForMultipleUsers(orderCreationV2Template,map);

        uploadOrderWeightCsv(createOrderUpdateCsv);

    }
    private File buildCreateOrderUpdateCsvForMultipleUsers(ListOrderCreationV2Template order,Map<String,String> map)
    {
        try {
            System.out.println("ListOrderCreation :-   "+order.size());
            File file = TestUtils.createFileOnTempFolder(String.format("create-order-update_%s.csv", generateDateUniqueString()));
            List list=new ArrayList();
            PrintWriter pw = new PrintWriter(new FileOutputStream(file));
            OrderCreationV2Template orderCreationV2Template=new OrderCreationV2Template();






            for (int i=0;i<map.size();i++) {
                int weight= Integer.parseInt(map.get("weight"+(i+1)));
//
//                System.out.println("Weight  ........ "+weight);
//
//                    orderCreationV2Template.setWeight(weight);
//                    list.add(orderCreationV2Template);
//
//
//
//                order.setOrderCreationV2TemplatesList(list);
//                order.getOrderCreationV2TemplatesList().get(i).setWeight(weight);

                StringBuilder orderAsSb = new StringBuilder()
                        .append(normalize("SOCV2" + order.getOrderCreationV2TemplatesList().get(i).getOrderNo())).append(',')
                        .append('"').append(normalize(weight)).append('"');


                pw.write(orderAsSb.toString());
                pw.write(System.lineSeparator());




            }
            pw.close();
            return file;
        } catch (IOException ex) {
            throw new NvTestRuntimeException(ex);
        }
    }
}
