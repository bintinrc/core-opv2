package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.ChangeDeliveryTiming;
import co.nvqa.operator_v2.util.TestUtils;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

import java.util.Set;

/**
 *
 * @author Tristania Siagian
 */
public class AllOrdersPage extends SimplePage
{
    public AllOrdersPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void searchTrackingId(String trackingId)
    {
        sendKeysById("searchTerm", trackingId);
        clickNvApiTextButtonByName("commons.search");
    }

    public void switchToNewOpenedWindow(String mainWindowHandle)
    {
        Set<String> windowHandles = TestUtils.retryIfRuntimeExceptionOccurred(()->
        {
            pause100ms();
            Set<String> windowHandlesTemp = getwebDriver().getWindowHandles();

            if(windowHandlesTemp.size()<=1)
            {
                throw new RuntimeException("WebDriver only contains 1 Window.");
            }

            return windowHandlesTemp;
        });

        String newOpenedWindowHandle = null;

        for(String windowHandle : windowHandles)
        {
            if(!windowHandle.equals(mainWindowHandle))
            {
                newOpenedWindowHandle = windowHandle; // Do not break, because we need to get the latest one.
            }
        }

        getwebDriver().switchTo().window(newOpenedWindowHandle);
    }

    public void closeAllWindowsAcceptTheMainWindow(String mainWindowHandle)
    {
        Set<String> windowHandles = getwebDriver().getWindowHandles();

        for(String windowHandle : windowHandles)
        {
            if(!windowHandle.equals(mainWindowHandle))
            {
                getwebDriver().switchTo().window(windowHandle);
                getwebDriver().close();
            }
        }

        getwebDriver().switchTo().window(mainWindowHandle);
    }

    public void verifyDeliveryTimingIsUpdatedSuccessfully(ChangeDeliveryTiming changeDeliveryTiming)
    {
        String mainWindowHandle = getwebDriver().getWindowHandle();

        try
        {
            searchTrackingId(changeDeliveryTiming.getTrackingId());
            switchToNewOpenedWindow(mainWindowHandle);
            waitUntilVisibilityOfElementLocated("//div[text()='Edit Order']");

            String actualStartDate = getText("//div[@id='delivery-details']//div[label/text()='Start Date / Time']/p");
            String actualEndDate = getText("//div[@id='delivery-details']//div[label/text()='End Date / Time']/p");

            String expectedStartDate = changeDeliveryTiming.getStartDate();
            String expectedEndDate = changeDeliveryTiming.getEndDate();
            String expectedStartTime = "";
            String expectedEndTime = "";
            Integer timewindow = changeDeliveryTiming.getTimewindow();

            if(timewindow==null)
            {
                actualStartDate = actualStartDate.substring(0, 10);
                actualEndDate = actualEndDate.substring(0, 10);
            }
            else
            {
                expectedStartTime = TestUtils.getStartTime(timewindow);
                expectedEndTime = TestUtils.getEndTime(timewindow);
            }

            String expectedStartDateWithTime = concatDateWithTime(expectedStartDate, expectedStartTime);
            String expectedEndDateWithTime = concatDateWithTime(expectedEndDate, expectedEndTime);

            boolean isDateEmpty = isBlank(changeDeliveryTiming.getStartDate()) || isBlank(changeDeliveryTiming.getEndDate());

            if(!isDateEmpty)
            {
                Assert.assertEquals("Start Date does not match.", expectedStartDateWithTime, actualStartDate);
                Assert.assertEquals("End Date does not match.", expectedEndDateWithTime, actualEndDate);
            }
            else
            {
                /**
                 * If date is empty, check only the start/end time.
                 */
                String actualStartTime = actualStartDate.substring(11, 19);
                String actualEndTime = actualEndDate.substring(11, 19);

                Assert.assertEquals("Start Date does not match.", expectedStartDateWithTime, actualStartTime);
                Assert.assertEquals("End Date does not match.", expectedEndDateWithTime, actualEndTime);
            }
        }
        finally
        {
            closeAllWindowsAcceptTheMainWindow(mainWindowHandle);
        }
    }

    private String concatDateWithTime(String date, String time)
    {
        if(time==null)
        {
            time = "";
        }

        return (date + " " + time).trim();
    }

    public void verifyInboundIsSucceed(String trackingId) {
        String mainWindowHandle = getwebDriver().getWindowHandle();

        try {
            searchTrackingId(trackingId);
            switchToNewOpenedWindow(mainWindowHandle);
            waitUntilVisibilityOfElementLocated("//div[text()='Edit Order']");

            pause3s();
            String actualLatestEvent = getTextOnTableWithNgRepeat(1, "name", "event in getTableData()");
            Assert.assertTrue("Different Result Returned", actualLatestEvent.contains("Van Inbound Scan"));
        }
        finally {
            closeAllWindowsAcceptTheMainWindow(mainWindowHandle);
        }
    }
}
