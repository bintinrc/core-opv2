package co.nvqa.operator_v2.util;

import co.nvqa.commons.client.auth.AuthClient;
import co.nvqa.commons.client.order_create.OrderCreateClientV3;
import co.nvqa.commons.client.order_create.OrderCreateClientV4;
import co.nvqa.commons.model.auth.AuthResponse;
import co.nvqa.commons.model.auth.ClientCredentialsAuth;
import co.nvqa.commons.model.order_create.v3.OrderRequestV3;
import org.apache.commons.text.CharacterPredicates;
import org.apache.commons.text.RandomStringGenerator;

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
@SuppressWarnings("WeakerAccess")
public class OrderCreateHelper
{
    private static final SimpleDateFormat SDF_UNIQUE = new SimpleDateFormat("HHmmssSSS");
    private static final SimpleDateFormat SDF_ORDER_REQUEST = new SimpleDateFormat("yyyy-MM-dd");
    private static final RandomStringGenerator ALPHA_NUMERIC_STRING_GENERATOR = new RandomStringGenerator.Builder().withinRange('0', 'z').filteredBy(CharacterPredicates.LETTERS, CharacterPredicates.DIGITS).build();

    private static String CREATE_ORDER_ACCESS_TOKEN; // Refer to qa-shaun@ninjavan.sg (235)
    private static String CREATE_ORDER_V4_ACCESS_TOKEN;
    private static String CREATE_ORDER_V2_ACCESS_TOKEN;
    private static String CREATE_ORDER_V3_ACCESS_TOKEN;

    // These two will be replaced by newer Tracking ID on run.
    public static final String EXISTING_V2_TRACKING_ID = "SHAUN123456789"; // e.g.: SHAUN 123456789 A (post pended with A)
    public static final String EXISTING_V3_TRACKING_ID = "NVSGSHAUN123456788"; // e.g.: NV SG SHAUN 123456789

    /**
     * Get next valid working days (Mon-Sat).
     *
     * @param dateString Object String.
     * @return Date String.
     */
    public static String getDateString(String dateString)
    {
        if(dateString==null)
        {
            return null;
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
                // No need to add zero days.
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
            return null;
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
            return null;
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
            return null;
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

    public static void populateRequest(OrderRequestV3 orderRequestV3)
    {
        orderRequestV3.setPickupDate(getDateString(orderRequestV3.getPickupDate()));
        orderRequestV3.setDeliveryDate(getDateString(orderRequestV3.getDeliveryDate()));
        orderRequestV3.setOrderRefNo(getShipperRef(orderRequestV3.getOrderRefNo()));
        orderRequestV3.setRequestedTrackingId(getRequestedTrackingId(orderRequestV3.getRequestedTrackingId()));
    }

    public static OrderCreateClientV3 getOrderCreateClientV3()
    {
        return new OrderCreateClientV3(TestConstants.API_BASE_URL, getShipperAccessToken());
    }

    public static OrderCreateClientV4 getOrderCreateClientV4()
    {
        return new OrderCreateClientV4(TestConstants.API_BASE_URL, getShipperAccessToken("V4"));
    }

    /**
     * Shipper's authentication token. Used to access orders, etc.
     *
     * @return Shipper's access token.
     */
    public static String getShipperAccessToken()
    {
        if(CREATE_ORDER_ACCESS_TOKEN==null)
        {
            ClientCredentialsAuth clientCredentialsAuth = new ClientCredentialsAuth(TestConstants.SHIPPER_V3_CLIENT_ID, TestConstants.SHIPPER_V3_CLIENT_SECRET);
            AuthClient authClient = new AuthClient(TestConstants.API_BASE_URL);
            AuthResponse authResponse = authClient.authenticate(clientCredentialsAuth);
            CREATE_ORDER_ACCESS_TOKEN = authResponse.getAccessToken();
        }

        return CREATE_ORDER_ACCESS_TOKEN;
    }

    /**
     * Shipper's authentication token. Used to access orders, etc.
     *
     * @return Shipper's access token.
     */
    public static String getShipperAccessToken(String version)
    {
        switch(version.toUpperCase())
        {
            case "V2":
                if(CREATE_ORDER_V2_ACCESS_TOKEN==null)
                {
                    CREATE_ORDER_V2_ACCESS_TOKEN = getCreateOrderAccessToken(TestConstants.SHIPPER_V2_CLIENT_ID, TestConstants.SHIPPER_V2_CLIENT_SECRET);
                }
                return CREATE_ORDER_V2_ACCESS_TOKEN;
            case "V4":
                if(CREATE_ORDER_V4_ACCESS_TOKEN==null)
                {
                    CREATE_ORDER_V4_ACCESS_TOKEN = getCreateOrderAccessToken(TestConstants.SHIPPER_V4_CLIENT_ID, TestConstants.SHIPPER_V4_CLIENT_SECRET);
                }
                return CREATE_ORDER_V4_ACCESS_TOKEN;
            case "V3":
            default:
                if(CREATE_ORDER_V3_ACCESS_TOKEN==null)
                {
                    CREATE_ORDER_V3_ACCESS_TOKEN = getCreateOrderAccessToken(TestConstants.SHIPPER_V3_CLIENT_ID, TestConstants.SHIPPER_V3_CLIENT_SECRET);
                }
                return CREATE_ORDER_V3_ACCESS_TOKEN;
        }
    }

    private static String getCreateOrderAccessToken(String clientId, String clientSecret)
    {
        ClientCredentialsAuth clientCredentialsAuth = new ClientCredentialsAuth(clientId, clientSecret);
        AuthClient authClient = new AuthClient(TestConstants.API_BASE_URL);
        AuthResponse authResponse = authClient.authenticate(clientCredentialsAuth);
        return authResponse.getAccessToken();
    }
}
