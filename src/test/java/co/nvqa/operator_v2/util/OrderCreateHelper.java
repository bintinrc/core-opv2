package co.nvqa.operator_v2.util;

import com.nv.qa.api.client.order_create.OrderCreateAuthenticationClient;
import com.nv.qa.api.client.order_create.OrderCreateV1Client;
import com.nv.qa.api.client.order_create.OrderCreateV2Client;
import com.nv.qa.api.client.order_create.OrderCreateV3Client;
import com.nv.qa.model.order_creation.authentication.AuthRequest;
import com.nv.qa.model.order_creation.authentication.AuthResponse;
import com.nv.qa.commons.utils.NvLogger;
import org.apache.commons.text.CharacterPredicates;
import org.apache.commons.text.RandomStringGenerator;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Random;

/**
 *
 * @author Ferdinand Kurniadi
 *
 * Modified by Daniel Joi Partogi Hutapea
 */
public class OrderCreateHelper
{
    private static final SimpleDateFormat SDF_UNIQUE = new SimpleDateFormat("HHmmssSSS");
    private static final SimpleDateFormat SDF_ORDER_REQUEST = new SimpleDateFormat("yyyy-MM-dd");
    private static final RandomStringGenerator ALPHA_NUMERIC_STRING_GENERATOR = new RandomStringGenerator.Builder().withinRange('0', 'z').filteredBy(CharacterPredicates.LETTERS, CharacterPredicates.DIGITS).build();

    private static String CREATE_ORDER_ACCESS_TOKEN = null; //-- refer to qa-shaun@ninjavan.sg (235)

    //-- these two will be replaced by newer Tracking ID on run
    public static String EXISTING_V2_TRACKING_ID = "SHAUN123456789"; //-- e.g.: SHAUN 123456789 A (post pended with A)
    public static String EXISTING_V3_TRACKING_ID = "NVSGSHAUN123456788"; //-- e.g.: NV SG SHAUN 123456789

    /**
     * Get next valid working days (Mon-Sat).
     *
     * @param dateString
     * @return
     */
    public static String getDateString(String dateString)
    {
        if(dateString == null)
        {
            return dateString;
        }

        Calendar cal = Calendar.getInstance();

        switch(dateString)
        {
            case "TOMORROW":
            case "NEXT_1_DAYS":
                cal.add(Calendar.DATE, 1);
                break;
            case "NEXT_2_DAYS":
                cal.add(Calendar.DATE, 2);
                break;
            case "NEXT_3_DAYS":
                cal.add(Calendar.DATE, 3);
                break;
            case "TODAY":
                //-- no need to add zero days.
                break;
            default:
                return dateString;
        }

        int dayOfWeek = cal.get(Calendar.DAY_OF_WEEK);

        if(dayOfWeek == Calendar.SUNDAY)
        {
            cal.add(Calendar.DATE, 1); //-- move to next available day
        }

        return SDF_ORDER_REQUEST.format(cal.getTime());
    }

    public static String getShipperRef(String word)
    {
        if(word==null)
        {
            return word;
        }

        switch(word)
        {
            case "NEW_UNIQUE":
                TestUtils.pause(2); //-- prevent same ref being generated.
                return SDF_UNIQUE.format(new Date());
            default:
                return word;
        }
    }

    public static String getRequestedTrackingId(String word)
    {
        if(word==null)
        {
            return word;
        }

        String ts = String.valueOf((new Date()).getTime());

        switch(word)
        {
            case "NEW_6":
                return ts.substring(ts.length() - 6);
            case "NEW_10":
                return ts.substring(ts.length() - 10);
            default:
                return word;
        }
    }

    public static String getStringRequestedTrackingId(String word)
    {
        if(word==null)
        {
            return word;
        }

        if(word.startsWith("RANDOM"))
        {
            int dashPosition = word.indexOf('_');
            int length;

            if(dashPosition>-1)
            {
                length = Integer.valueOf(word.substring(dashPosition + 1));
            }
            else
            {
                length = new Random().nextInt();
            }

            return ALPHA_NUMERIC_STRING_GENERATOR.generate(length);
        }
        else if(word.startsWith("EXISTING_V2_TRACKING_ID"))
        {
            return EXISTING_V2_TRACKING_ID;
        }
        else if(word.startsWith("EXISTING_V3_TRACKING_ID"))
        {
            //-- requested tracking id for V3 is only the last 9 digit.
            return EXISTING_V3_TRACKING_ID.substring(9);
        }
        else
        {
            return word;
        }
    }

    public static void populateRequest(com.nv.qa.model.order_creation.v1.CreateOrderRequest req)
    {
        req.setPickup_date(getDateString(req.getPickup_date()));
        req.setDelivery_date(getDateString(req.getDelivery_date()));
        req.setShipper_order_ref_no(getShipperRef(req.getShipper_order_ref_no()));
    }

    public static void populateRequest(com.nv.qa.model.order_creation.v2.CreateOrderRequest req)
    {
        req.setPickup_date(getDateString(req.getPickup_date()));
        req.setDelivery_date(getDateString(req.getDelivery_date()));
        req.setShipper_order_ref_no(getShipperRef(req.getShipper_order_ref_no()));
        req.setTracking_ref_no(getStringRequestedTrackingId(req.getTracking_ref_no()));
    }

    public static void populateRequest(com.nv.qa.model.order_creation.v3.CreateOrderRequest req)
    {
        req.setPickupDate(getDateString(req.getPickupDate()));
        req.setDeliveryDate(getDateString(req.getDeliveryDate()));
        req.setOrderRefNo(getShipperRef(req.getOrderRefNo()));
        req.setRequestedTrackingId(getRequestedTrackingId(req.getRequestedTrackingId()));
    }

    public static OrderCreateAuthenticationClient getAuthenticationClient()
    {
        return new OrderCreateAuthenticationClient( TestConstants.API_BASE_URL, TestConstants.ORDER_CREATE_BASE_URL);
    }

    public static OrderCreateV1Client getVersion1Client(String accessToken)
    {
        return new OrderCreateV1Client(TestConstants.API_BASE_URL, TestConstants.ORDER_CREATE_BASE_URL, accessToken);
    }

    public static OrderCreateV1Client getVersion1Client() throws IOException
    {
        return getVersion1Client(getOrderCreateAccessToken());
    }

    public static OrderCreateV2Client getVersion2Client(String accessToken)
    {
        return new OrderCreateV2Client(TestConstants.API_BASE_URL, TestConstants.ORDER_CREATE_BASE_URL, accessToken);
    }

    public static OrderCreateV2Client getVersion2Client() throws IOException
    {
        return getVersion2Client(getOrderCreateAccessToken());
    }

    public static OrderCreateV3Client getVersion3Client(String accessToken)
    {
        return new OrderCreateV3Client(TestConstants.API_BASE_URL, TestConstants.ORDER_CREATE_BASE_URL, accessToken);
    }

    public static OrderCreateV3Client getVersion3Client() throws IOException
    {
        return getVersion3Client(getOrderCreateAccessToken());
    }

    /**
     * Shipper's authentication token. Used to access orders, etc.
     *
     * @return
     */
    public static String getOrderCreateAccessToken() throws IOException
    {
        if(CREATE_ORDER_ACCESS_TOKEN==null)
        {
            AuthRequest loginRequest = new AuthRequest(TestConstants.SHIPPER_CLIENT_ID, TestConstants.SHIPPER_CLIENT_SECRET);
            OrderCreateAuthenticationClient client = getAuthenticationClient();
            AuthResponse resp = client.login(loginRequest);
            CREATE_ORDER_ACCESS_TOKEN = resp.getAccess_token();

            /**
             * I deleted this line below because it called deprecated method
             * that does not have any implementation (all code in this method is commented).
             */
            //client.refreshShipperAccountCache(TestConstants.SHIPPER_ID);
        }

        return CREATE_ORDER_ACCESS_TOKEN;
    }
}
