package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.commons.model.shipper_support.AggregatedOrder;
import co.nvqa.commons.model.shipper_support.PricedOrder;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.selenium.page.OrderBillingPage;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.runtime.java.guice.ScenarioScoped;

import java.text.ParseException;
import java.util.*;


/**
 * @author Kateryna Skakunova
 */
@ScenarioScoped
public class OrderBillingSteps extends AbstractSteps
{
    private OrderBillingPage orderBillingPage;
    private String shipperIds = null;

    public OrderBillingSteps()
    {
    }

    @Override
    public void init()
    {
        orderBillingPage = new OrderBillingPage(getWebDriver());
    }

    @Given("^Operator generates success billings using data below:$")
    public void operatorGeneratesSuccessBillingsForData(Map<String, String> mapOfData)
    {
        try
        {
            if (Objects.nonNull(mapOfData.get("startDate")))
            {
                String startDate = mapOfData.get("startDate");
                put(KEY_ORDER_BILLING_START_DATE, startDate);
                orderBillingPage.selectStartDate(YYYY_MM_DD_SDF.parse(startDate));
            }
            if (Objects.nonNull(mapOfData.get("endDate")))
            {
                String endDate = mapOfData.get("endDate");
                put(KEY_ORDER_BILLING_END_DATE, endDate);
                orderBillingPage.selectEndDate(YYYY_MM_DD_SDF.parse(endDate));
            }
        } catch (ParseException e)
        {
            throw new NvTestRuntimeException("Failed to parse date.", e);
        }
        if (Objects.nonNull(mapOfData.get("shipper")))
        {
            String shipper = mapOfData.get("shipper");
            orderBillingPage.setSpecificShipper(shipper);
            put(KEY_ORDER_BILLING_SHIPPER_NAME, shipper);

        }
        if (Objects.nonNull(mapOfData.get("uploadCsv")))
        {
            shipperIds = mapOfData.get("uploadCsv");
            orderBillingPage.uploadCsvShippers(shipperIds);
        }
        if (Objects.nonNull(mapOfData.get("parentShipper")))
        {
            String parentShipper = mapOfData.get("parentShipper");
            orderBillingPage.setParentShipper(parentShipper);
            put(KEY_ORDER_BILLING_SHIPPER_NAME, parentShipper);
        }
        if (Objects.nonNull(mapOfData.get("generateFile")))
        {
            orderBillingPage.tickGenerateTheseFilesOption(mapOfData.get("generateFile"));
        }
        if (Objects.nonNull(mapOfData.get("emailAddress")))
        {
            orderBillingPage.setEmailAddress(mapOfData.get("emailAddress"));
        }

        orderBillingPage.clickGenerateSuccessBillingsButton();
        orderBillingPage.verifyNoErrorsAvailable();
    }


    @Then("Operator opens Gmail and checks received email")
    public void operatorOpensGmailAndChecksReceivedEmail()
    {
        String attachmentUrl = orderBillingPage.getOrderBillingAttachmentFromEmail();
        put(KEY_ORDER_BILLING_SSB_URL, attachmentUrl);
    }

    @Then("^Operator verifies zip is attached with multiple CSV files in received email$")
    public void operatorVerifiesAttachedZipFileInReceivedEmail()
    {
        assertTrue("Multiple CSV files are not available in the ZIP", getNoOfFilesInZipAttachment() > 1);
    }

    private int getNoOfFilesInZipAttachment()
    {
        int noOfFilesInZipAttachment = orderBillingPage.getNoOfFilesInZipAttachment(get(KEY_ORDER_BILLING_SSB_URL), get(KEY_ORDER_BILLING_START_DATE), get(KEY_ORDER_BILLING_END_DATE));
        put(KEY_ORDER_BILLING_CSV_FILE_COUNT, noOfFilesInZipAttachment);
        return noOfFilesInZipAttachment;
    }

    @Then("Operator verifies zip is attached with one CSV file in received email")
    public void operatorVerifiesZipAttachedWithOneCSVFilesInReceivedEmail()
    {
        assertTrue("More than one CSV file attached in the ZIP", getNoOfFilesInZipAttachment() == 1);
    }

    @Then("Operator verifies zip is not attached with any CSV files in received email")
    public void operatorVerifiesZipIsNotAttachedWithAnyCSVFilesInReceivedEmail()
    {
        assertTrue("One or more CSV files attached in the ZIP", getNoOfFilesInZipAttachment() == 0);
    }

    @Then("^operator marks gmail messages as read$")
    public void operatorMarkGmailMessageAsRead()
    {
        orderBillingPage.markGmailMessageAsRead();
    }

    @Then("Operator reads the CSV attachment for {string}")
    public void operatorReadsTheCSVAttachmentFor(String reportName)
    {
        orderBillingPage.readOrderBillingCsvAttachment(get(KEY_ORDER_BILLING_SSB_URL), get(KEY_ORDER_BILLING_PRICED_ORDER_DETAILS_DB), reportName);
        if (reportName.equals(OrderBillingPage.AGGREGATED_BILLING_REPORT))
        {
            put(KEY_ORDER_BILLING_SSB_AGGREGATED_DATA, orderBillingPage.getAggregatedOrdersFromCsv());
        } else if (Arrays.asList(OrderBillingPage.SHIPPER_BILLING_REPORT, OrderBillingPage.SCRIPT_BILLING_REPORT).contains(reportName))
        {
            put(KEY_ORDER_BILLING_PRICED_ORDER_DETAILS_CSV, orderBillingPage.getOrderFromCsv());
        }
    }

    @Then("Operator verifies the header using data below:")
    public void operatorVerifiesTheHeaderUsingDataBelow(List<String> headerColumns)
    {
        String expectedHeaderLine = String.join(",", headerColumns);
        String actualHeaderLine = orderBillingPage.getHeaderLine();
        String assertMessage = f("Actual header line does not match with the expected header line. Actual Header is %s , Expected Header is %s", actualHeaderLine, expectedHeaderLine);
        assertEquals(assertMessage, expectedHeaderLine, actualHeaderLine);
    }

    @Then("Operator verifies the priced order details in the body")
    public void operatorVerifiesThePricedOrderDetailsInTheBody()
    {
        if (Objects.isNull(get(KEY_ORDER_BILLING_PRICED_ORDER_DETAILS_CSV)))
        {
            fail("Priced order is not available in the CSV file");
        } else
        {
            PricedOrder pricedOrderCsv = orderBillingPage.pricedOrderCsv(get(KEY_ORDER_BILLING_PRICED_ORDER_DETAILS_CSV));
            PricedOrder pricedOrderDb = get(KEY_ORDER_BILLING_PRICED_ORDER_DETAILS_DB);
            assertEquals("Success Billings Csv file does not contain expected information for column ShipperId", pricedOrderDb.getShipperId(), pricedOrderCsv.getShipperId());
            assertEquals("Success Billings Csv file does not contain expected information for column ShipperName", pricedOrderDb.getShipperName(), pricedOrderCsv.getShipperName());
            assertEquals("Success Billings Csv file does not contain expected information for column BillingName", pricedOrderDb.getBillingName(), pricedOrderCsv.getBillingName());
            assertEquals("Success Billings Csv file does not contain expected information for column TrackingId", pricedOrderDb.getTrackingId(), pricedOrderCsv.getTrackingId());
            assertEquals("Success Billings Csv file does not contain expected information for column ShipperOrderRef", pricedOrderDb.getShipperOrderRef(), pricedOrderCsv.getShipperOrderRef());
            assertEquals("Success Billings Csv file does not contain expected information for column GranularStatus", pricedOrderDb.getGranularStatus(), pricedOrderCsv.getGranularStatus());
            assertEquals("Success Billings Csv file does not contain expected information for column CustomerName", pricedOrderDb.getCustomerName(), pricedOrderCsv.getCustomerName());
            assertEquals("Success Billings Csv file does not contain expected information for column DeliveryTypeName", pricedOrderDb.getDeliveryTypeName(), pricedOrderCsv.getDeliveryTypeName());
            assertEquals("Success Billings Csv file does not contain expected information for column DeliveryTypeId", pricedOrderDb.getDeliveryTypeId(), pricedOrderCsv.getDeliveryTypeId());
            assertEquals("Success Billings Csv file does not contain expected information for column ParcelSizeId", pricedOrderDb.getParcelSizeId(), pricedOrderCsv.getParcelSizeId());
            assertEquals("Success Billings Csv file does not contain expected information for column ParcelWeight", pricedOrderDb.getParcelWeight(), pricedOrderCsv.getParcelWeight());
            assertNotNull("Success Billings Csv file does not contain expected information for column CreatedTime", pricedOrderCsv.getCreatedTime());
            assertThat("Success Billings Csv file does not contain expected information for column DeliveryDate", DateUtil.getDefaultDateTimeFromUTC(pricedOrderDb.getDeliveryDate()), containsString(f("%s", pricedOrderCsv.getDeliveryDate())));
            assertEquals("Success Billings Csv file does not contain expected information for column FromCity", pricedOrderDb.getFromCity(), pricedOrderCsv.getFromCity());
            assertEquals("Success Billings Csv file does not contain expected information for column FromBillingZone", pricedOrderDb.getFromBillingZone(), pricedOrderCsv.getFromBillingZone());
            assertEquals("Success Billings Csv file does not contain expected information for column OriginHub", pricedOrderDb.getOriginHub(), pricedOrderCsv.getOriginHub());
            assertEquals("Success Billings Csv file does not contain expected information for column getL1Name", pricedOrderDb.getL1Name(), pricedOrderCsv.getL1Name());
            assertEquals("Success Billings Csv file does not contain expected information for column getL2Name", pricedOrderDb.getL2Name(), pricedOrderCsv.getL2Name());
            assertEquals("Success Billings Csv file does not contain expected information for column getL3Name", pricedOrderDb.getL3Name(), pricedOrderCsv.getL3Name());
            assertEquals("Success Billings Csv file does not contain expected information for column ToAddress", pricedOrderDb.getToAddress(), pricedOrderCsv.getToAddress());
            assertEquals("Success Billings Csv file does not contain expected information for column ToPostcode", pricedOrderDb.getToPostcode(), pricedOrderCsv.getToPostcode());
            assertEquals("Success Billings Csv file does not contain expected information for column ToBillingZone", pricedOrderDb.getToBillingZone(), pricedOrderCsv.getToBillingZone());
            assertEquals("Success Billings Csv file does not contain expected information for column DestinationHub", pricedOrderDb.getDestinationHub(), pricedOrderCsv.getDestinationHub());
            assertEquals("Success Billings Csv file does not contain expected information for column DeliveryFee", pricedOrderDb.getDeliveryFee(), pricedOrderCsv.getDeliveryFee());
            assertEquals("Success Billings Csv file does not contain expected information for column CodCollected", pricedOrderDb.getCodCollected(), pricedOrderCsv.getCodCollected());
            assertEquals("Success Billings Csv file does not contain expected information for column CodFee", pricedOrderDb.getCodFee(), pricedOrderCsv.getCodFee());
            assertEquals("Success Billings Csv file does not contain expected information for column InsuredValue", pricedOrderDb.getInsuredValue(), pricedOrderCsv.getInsuredValue());
            assertEquals("Success Billings Csv file does not contain expected information for column InsuredFee", pricedOrderDb.getInsuredFee(), pricedOrderCsv.getInsuredFee());
            assertEquals("Success Billings Csv file does not contain expected information for column HandlingFee", pricedOrderDb.getHandlingFee(), pricedOrderCsv.getHandlingFee());
            assertEquals("Success Billings Csv file does not contain expected information for column Gst", pricedOrderDb.getGst(), pricedOrderCsv.getGst());
            assertEquals("Success Billings Csv file does not contain expected information for column Total", pricedOrderDb.getTotal(), pricedOrderCsv.getTotal());
            assertEquals("Success Billings Csv file does not contain expected information for column ScriptId", pricedOrderDb.getScriptId(), pricedOrderCsv.getScriptId());
            assertEquals("Success Billings Csv file does not contain expected information for column ScriptVersion", pricedOrderDb.getScriptVersion(), pricedOrderCsv.getScriptVersion());
            assertThat("Success Billings Csv file does not contain expected information for column LastCalculatedDate", DateUtil.getDefaultDateTimeFromUTC(pricedOrderDb.getLastCalculatedDate()), containsString(f("%s", pricedOrderCsv.getLastCalculatedDate())));
        }
    }

    @Then("Operator verifies the orders grouped by shipper and parcel size and weight")
    public void operatorVerifiesTheOrdersGroupedByShipperAndParcelSizeAndWeight()
    {
        List<AggregatedOrder> expectedResultsInDB = Objects.isNull(get(KEY_ORDER_BILLING_SHIPPER_NAME)) ? get(KEY_ORDER_BILLING_DB_AGGREGATED_DATA_ALL_SHIPPERS) : get(KEY_ORDER_BILLING_DB_AGGREGATED_DATA_BY_SHIPPER);
        List<AggregatedOrder> actualSsbOrderRows = get(KEY_ORDER_BILLING_SSB_AGGREGATED_DATA);

        for (int i = 0; i < expectedResultsInDB.size(); i++)
        {
            assertEquals("Actual data in CSV does not match with the expected data for column ShipperId, row " + i, expectedResultsInDB.get(i).getShipperId(), actualSsbOrderRows.get(i).getShipperId());
            assertEquals("Actual data in CSV does not match with the expected data for column ShipperName, row " + i, expectedResultsInDB.get(i).getShipperName(), actualSsbOrderRows.get(i).getShipperName());
            assertEquals("Actual data in CSV does not match with the expected data for column ShipperBillingName, row " + i, expectedResultsInDB.get(i).getShipperBillingName(), actualSsbOrderRows.get(i).getShipperBillingName());
            assertEquals("Actual data in CSV does not match with the expected data for column DeliveryTypeName, row " + i, expectedResultsInDB.get(i).getDeliveryTypeName(), actualSsbOrderRows.get(i).getDeliveryTypeName());
            assertEquals("Actual data in CSV does not match with the expected data for column DeliveryTypeId, row " + i, expectedResultsInDB.get(i).getDeliveryTypeId(), actualSsbOrderRows.get(i).getDeliveryTypeId());
            assertEquals("Actual data in CSV does not match with the expected data for column ParcelSize, row " + i, expectedResultsInDB.get(i).getParcelSize(), actualSsbOrderRows.get(i).getParcelSize());
            assertEquals("Actual data in CSV does not match with the expected data for column ParcelWeight, row " + i, actualSsbOrderRows.get(i).getParcelWeight(), expectedResultsInDB.get(i).getParcelWeight(), actualSsbOrderRows.get(i).getParcelWeight());
            assertEquals("Actual data in CSV does not match with the expected data for column Count, row " + i, expectedResultsInDB.get(i).getCount(), actualSsbOrderRows.get(i).getCount());
            assertEquals("Actual data in CSV does not match with the expected data for column Cost, row " + i, expectedResultsInDB.get(i).getCost(), actualSsbOrderRows.get(i).getCost());
        }
    }

    @Then("Operator verifies the count of files in zip")
    public void operatorVerifiesTheCountOfFilesInZip()
    {
        assertEquals("Actual file count in Zip does not match with the expected file count in DB", get(KEY_ORDER_BILLING_DB_FILE_COUNT), get(KEY_ORDER_BILLING_CSV_FILE_COUNT));
    }

    @Then("Operator verifies the report only contains orders from the shipper IDs in the uploaded file")
    public void operatorVerifiesTheReportOnlyContainsOrdersFromTheShipperIDsInTheUploadedFile()
    {

        Set<String> expectedShipperIds = new HashSet<>(Arrays.asList(shipperIds.split(",")));
        Set<String> actualShipperIds = orderBillingPage.getShipperIdsInCsv();
        assertEquals(expectedShipperIds, actualShipperIds);

    }

    @Then("Operator verifies the report only contains valid shipper IDs like below:")
    public void operatorVerifiesTheReportOnlyContainsValidShipperIDsLikeBelow(List<String> validShipperIds)
    {
        Set<String> expectedShipperIds = new HashSet<>(validShipperIds);
        Set<String> actualShipperIds = orderBillingPage.getShipperIdsInCsv();
        assertEquals(expectedShipperIds, actualShipperIds);
    }

    @Then("Operator tries to upload a PDF and verifies that any other file except csv is not allowed")
    public void operatorTriesToUploadAPDFAndVerifiesThatAnyOtherFileExceptCsvIsNotAllowed()
    {
        orderBillingPage.uploadPDFShippersAndVerifyErrorMsg();
    }

    @Then("Operator chooses Select by Parent Shippers option and search for normal shipper ID like below:")
    public void operatorChoosesSelectByParentShippersOptionAndSearchForNormalShipperIDLikeBelow(String shipperId)
    {
        orderBillingPage.setInvalidParentShipper(shipperId);
    }

    @Then("Operator verifies that the name of normal shipper suggestion is not displayed")
    public void operatorVerifiesThatTheNameOfNormalShipperSuggestionIsNotDisplayed()
    {
        assertThat("The displayed error msg does not match with the expected error msg", orderBillingPage.getNoParentErrorMsg(), containsString("No Parent Shipper matching"));
    }
}
