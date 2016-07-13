package com.nv.qa.support;

import org.testng.Assert;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/**
 * Created by ferdinand on 3/30/16.
 */
public class DateUtil {

    public static final SimpleDateFormat ISO8601_DATETIME_FORMAT = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    static final SimpleDateFormat SDF_YYYY_MM_DD = new SimpleDateFormat("yyyy-MM-dd");
    static final SimpleDateFormat SDF_YYYY_MM_DD_HH_MM_SS = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    static final SimpleDateFormat SDF_HH_MM_SS = new SimpleDateFormat("HHmmss");

    /**
     * Checks whether the given string representing a date is valid.
     *
     * @param date e.g.: "2016-01-31T23:59:59.999Z"
     * @param format e.g.: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
     * @return true if the given string is parseable to date. false otherwise.
     */
    public static boolean isValidDateString(String date, String format){
        if(date == null){
            return false;
        }

        SimpleDateFormat sdf = new SimpleDateFormat(format);
        sdf.setLenient(false);

        try {
            //if not valid, it will throw ParseException
            Date x = sdf.parse(date);
        } catch (ParseException e) {
            e.printStackTrace();
            return false;
        }
        return true;
    }

    public static void assertDateString(String date, String format, String fieldname){
        Assert.assertTrue(
                DateUtil.isValidDateString(date, format),
                String.format("Unparseable %s value against %s format : %s", fieldname, format, date)
        );
    }

    /**
     * return today date string in format yyyy-MM-dd
     * @return
     */
    public static String getTodayDate_YYYY_MM_DD() {
        Calendar cal = Calendar.getInstance();
        return SDF_YYYY_MM_DD.format(cal.getTime());
    }

    /**
     * return tomorrow date string in format yyyy-MM-dd
     * @return
     */
    public static String getTomorrowDate_YYYY_MM_DD() {
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DATE, 1);
        return SDF_YYYY_MM_DD.format(cal.getTime());
    }

    /**
     * return today date string in format yyyy-MM-dd HH:mm:ss
     * @return
     */
    public static String getTodayDateTime_YYYY_MM_DD_HH_MM_SS() {
        Calendar cal = Calendar.getInstance();
        return SDF_YYYY_MM_DD_HH_MM_SS.format(cal.getTime());
    }

    /**
     * return tomorrow date string in format yyyy-MM-dd HH:mm:ss
     * @return
     */
    public static String getTomorrowDateTime_YYYY_MM_DD_HH_MM_SS() {
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DATE, 1);
        return SDF_YYYY_MM_DD_HH_MM_SS.format(cal.getTime());
    }

    public static String getCurrentTime_HH_MM_SS() {
        return SDF_HH_MM_SS.format(Calendar.getInstance().getTime());
    }

}
