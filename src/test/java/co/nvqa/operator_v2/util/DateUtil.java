package co.nvqa.operator_v2.util;

import co.nvqa.common.utils.NvTestRuntimeException;
import java.text.Format;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.DayOfWeek;
import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;
import org.apache.commons.lang3.time.DateUtils;

import static co.nvqa.common.utils.StandardTestConstants.DEFAULT_TIMEZONE;

@SuppressWarnings("WeakerAccess")
public class DateUtil {

  public static final SimpleDateFormat ISO8601_DATETIME_FORMAT = new SimpleDateFormat(
      "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
  public static final SimpleDateFormat ISO8601_LITE_DATETIME_FORMAT = new SimpleDateFormat(
      "yyyy-MM-dd'T'HH:mm:ss'Z'");
  public static final SimpleDateFormat ISO8601_LITE_DATETIME_FORMAT2 = new SimpleDateFormat(
      "yyyy-MM-dd'T'HH:mm:ssZ");
  public static final SimpleDateFormat SDF_YYYY_MM_DD = new SimpleDateFormat("yyyy-MM-dd");
  public static final SimpleDateFormat SDF_YYYYMMDD = new SimpleDateFormat("yyyyMMdd");
  public static final DateTimeFormatter DTF_YYYY_MM_DD = DateTimeFormatter.ofPattern("yyyy-MM-dd");
  public static final DateTimeFormatter DTF_EEEE = DateTimeFormatter
      .ofPattern("EEEE", Locale.ENGLISH);
  public static final SimpleDateFormat SDF_YYYY_MM_DD_HH_MM_SS = new SimpleDateFormat(
      "yyyy-MM-dd HH:mm:ss");
  public static final SimpleDateFormat SDF_YYYY_MM_DD_HH_MM_SS_WITH_HYPHEN = new SimpleDateFormat(
      "yyyy-MM-dd-HH:mm:ss");
  public static final SimpleDateFormat SDF_YYYY_MM_DD_HH_MM_SS_WITH_T = new SimpleDateFormat(
      "yyyy-MM-dd'T'HH:mm:ss");
  public static final SimpleDateFormat SDF_YYYY_MM_DD_HH_MM = new SimpleDateFormat(
      "yyyy-MM-dd HH:mm");
  public static final SimpleDateFormat SDF_HH_MM_SS = new SimpleDateFormat("HHmmss");

  private static ZoneId DEFAULT_ZONE_ID = ZoneId.systemDefault();
  private static final ZoneId UTC_ZONE_ID = ZoneId.of("UTC");

  private static final String DATE_TIME_FORMAT = "yyyy-MM-dd HH:mm:ss";
  public static final String DATE_FORMAT = "yyyy-MM-dd";
  private static final String TIME_FORMAT_1 = "HH:mm:ss";
  private static final String TIME_FORMAT_2 = "HH:mm";
  private static final String ISO8601_FORMAT = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
  private static final String ISO8601_FORMAT_2 = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
  private static final String ISO8601_FORMAT_LITE = "yyyy-MM-dd'T'HH:mm:ss'Z'";
  private static final String DATE_FORMAT_SNS = "dd MMM yyyy, EEE";
  public static final String DATE_FORMAT_SNS_1 = "dd/MM/yyyy";
  private static final String DATETIME_REPORT_NAME = "yyyyMMdd_HHmmss";

  public static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter
      .ofPattern(DATE_TIME_FORMAT);
  public static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern(DATE_FORMAT);
  public static final DateTimeFormatter TIME_FORMATTER_1 = DateTimeFormatter
      .ofPattern(TIME_FORMAT_1);
  public static final DateTimeFormatter TIME_FORMATTER_2 = DateTimeFormatter
      .ofPattern(TIME_FORMAT_2);
  public static final DateTimeFormatter ISO8601_FORMATTER = DateTimeFormatter
      .ofPattern(ISO8601_FORMAT);
  public static final DateTimeFormatter ISO8601_FORMATTER_2 = DateTimeFormatter
      .ofPattern(ISO8601_FORMAT_2);
  public static final DateTimeFormatter ISO8601_LITE_FORMATTER = DateTimeFormatter
      .ofPattern(ISO8601_FORMAT_LITE);
  public static final DateTimeFormatter DATE_FORMATTER_SNS = DateTimeFormatter
      .ofPattern(DATE_FORMAT_SNS);
  public static final DateTimeFormatter DATE_FORMATTER_SNS_1 = DateTimeFormatter
      .ofPattern(DATE_FORMAT_SNS_1);
  public static final DateTimeFormatter DATETIME_REPORT_NAME_FORMATTER = DateTimeFormatter
      .ofPattern(DATETIME_REPORT_NAME);

  /**
   * Checks whether the given string representing a date is valid.
   *
   * @param date   e.g.: "2016-01-31T23:59:59.999Z"
   * @param format e.g.: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
   * @return true if the given string is parseable to date. false otherwise.
   */
  public static boolean isValidDateString(String date, String format) {
    if (date == null) {
      return false;
    }

    SimpleDateFormat sdf = new SimpleDateFormat(format);
    sdf.setLenient(false);

    try {
      //if not valid, it will throw ParseException
      sdf.parse(date);
    } catch (ParseException e) {
      return false;
    }
    return true;
  }

  /**
   * Checks whether the given string representing a date is valid.
   *
   * @param date e.g.: "2016-01-31 23:59:59"
   * @return true if the given string is parseable to date. false otherwise.
   */
  public static boolean isValidDateString_yyyy_MM_dd_HH_mm_ss(String date) {
    if (date == null) {
      return false;
    }

    try {
      DATE_TIME_FORMATTER.parse(date);
    } catch (DateTimeParseException e) {
      return false;
    }
    return true;
  }

  /**
   * Return today date string in format yyyy-MM-dd.
   *
   * @return today date string in format yyyy-MM-dd.
   */
  public static String getTodayDate_YYYY_MM_DD() {
    Calendar cal = Calendar.getInstance();
    return SDF_YYYY_MM_DD.format(cal.getTime());
  }

  /**
   * Return today date string in format yyyyMMdd.
   *
   * @return today date string in format yyyyMMdd.
   */
  public static String getTodayDate_YYYYMMDD() {
    Calendar cal = Calendar.getInstance();
    return SDF_YYYYMMDD.format(cal.getTime());
  }

  /**
   * Return today date string in format yyyy-MM-dd with country.
   *
   * @return today date string in format yyyy-MM-dd with country.
   */
  public static String getTodayDateV2_YYYY_MM_DD() {
    ZonedDateTime date = ZonedDateTime.now(ZoneId.of(DEFAULT_TIMEZONE));
    return DTF_YYYY_MM_DD.format(date);
  }

  public static String getTodayDateV2_YYYY_MM_DD(ZoneId zoneId) {
    ZonedDateTime date = ZonedDateTime.now(zoneId);
    return DTF_YYYY_MM_DD.format(date);
  }

  /**
   * Return tomorrow date string in format yyyy-MM-dd.
   *
   * @return tomorrow date string in format yyyy-MM-dd.
   */
  public static String getTomorrowDate_YYYY_MM_DD() {
    Calendar cal = Calendar.getInstance();
    cal.add(Calendar.DATE, 1);
    return SDF_YYYY_MM_DD.format(cal.getTime());
  }

  /**
   * Return yesterday date string in format yyyy-MM-dd.
   *
   * @return yesterday date string in format yyyy-MM-dd.
   */
  public static String getYesterdayDate_YYYY_MM_DD() {
    Calendar cal = Calendar.getInstance();
    cal.add(Calendar.DATE, -1);
    return SDF_YYYY_MM_DD.format(cal.getTime());
  }

  /**
   * Return today date string in format yyyy-MM-dd HH:mm:ss
   *
   * @return today date string in format yyyy-MM-dd HH:mm:ss.
   */
  public static String getTodayDateTime_YYYY_MM_DD_HH_MM_SS() {
    Calendar cal = Calendar.getInstance();
    return SDF_YYYY_MM_DD_HH_MM_SS.format(cal.getTime());
  }

  public static String getTodayDateTime_YYYY_MM_DD_HH_MM_SS_WITH_HYPHEN() {
    Calendar cal = Calendar.getInstance();
    return SDF_YYYY_MM_DD_HH_MM_SS_WITH_HYPHEN.format(cal.getTime());
  }

  public static String getTodayDateTime_YYYY_MM_DD_HH_MM_SS_WITH_T() {
    Calendar cal = Calendar.getInstance();
    return SDF_YYYY_MM_DD_HH_MM_SS_WITH_T.format(cal.getTime());
  }

  public static String getTodayDateTime_YYYY_MM_DD_HH_MM_SS_PLUS_MINUTES(int minutes) {
    Calendar cal = Calendar.getInstance();
    cal.add(Calendar.MINUTE, minutes);
    return SDF_YYYY_MM_DD_HH_MM_SS.format(cal.getTime());
  }

  /**
   * Return today date string in format yyyy-MM-ddTHH:mm:ssZ
   *
   * @return today date string in format yyyy-MM-ddTHH:mm:ssZ.
   */
  public static String getTodayDateTime_ISO8601_LITE() {
    Calendar cal = Calendar.getInstance();
    return ISO8601_LITE_DATETIME_FORMAT.format(cal.getTime());
  }

  /**
   * Return tomorrow date string in format yyyy-MM-dd HH:mm:ss.
   *
   * @return tomorrow date string in format yyyy-MM-dd HH:mm:ss.
   */
  public static String getTomorrowDateTime_YYYY_MM_DD_HH_MM_SS() {
    Calendar cal = Calendar.getInstance();
    cal.add(Calendar.DATE, 1);
    return SDF_YYYY_MM_DD_HH_MM_SS.format(cal.getTime());
  }

  public static String getCurrentTime_HH_MM_SS() {
    return SDF_HH_MM_SS.format(Calendar.getInstance().getTime());
  }

  public static String getTimestamp() {
    return String.valueOf(Calendar.getInstance().getTime().getTime());
  }

  public static ZonedDateTime getDate() {
    return getDate(DEFAULT_ZONE_ID);
  }

  public static ZonedDateTime generateNextSundayDate() {
    ZonedDateTime zdt = co.nvqa.commons.support.DateUtil.getDate();
    while (!zdt.getDayOfWeek().equals(DayOfWeek.SUNDAY)) {
      zdt = zdt.plusDays(1);
    }
    return zdt;
  }

  public static ZonedDateTime getDate(ZoneId zoneId) {
    return ZonedDateTime.now(zoneId);
  }

  public static ZonedDateTime getDate(Instant instant) {
    return getDate(instant, DEFAULT_ZONE_ID);
  }

  public static ZonedDateTime getDate(Instant instant, ZoneId zoneId) {
    return ZonedDateTime.ofInstant(instant, zoneId);
  }

  public static ZonedDateTime getDate(String str) {
    return ZonedDateTime.parse(str);
  }

  public static ZonedDateTime getDate(String str, DateTimeFormatter dtf) {
    return ZonedDateTime.parse(str, dtf);
  }

  public static ZonedDateTime getZdtOf_yyyy_MM_dd_HH_mm_ss(String date) {
    return ZonedDateTime.parse(date, DATE_TIME_FORMATTER.withZone(DEFAULT_ZONE_ID));
  }

  public static ZonedDateTime getDate(LocalDateTime localDateTime, ZoneId zoneId) {
    return ZonedDateTime.of(localDateTime, zoneId);
  }

  public static ZonedDateTime getDate(LocalDateTime localDateTime) {
    return ZonedDateTime.of(localDateTime, DEFAULT_ZONE_ID);
  }

  public static String displayDateTime(ZonedDateTime zdt) {
    return DATE_TIME_FORMATTER.format(zdt);
  }

  public static String displayDateTime(Instant instant, ZoneId zoneId) {
    return displayDateTime(getDate(instant, zoneId));
  }

  public static String displayDate(ZonedDateTime zdt) {
    return DATE_FORMATTER.format(zdt);
  }

  public static String displayDate(Instant instant, ZoneId zoneId) {
    return displayDate(getDate(instant, zoneId));
  }

  /**
   * Return date String in yyy-MM-dd HH:mm:ss.
   *
   * @param zdt Object ZonedDateTime.
   * @return date String in yyy-MM-dd HH:mm:ss.
   */
  public static String displayTime(ZonedDateTime zdt) {
    return displayTime(zdt, true);
  }

  /**
   * @param instant Object Instant.
   * @param zoneId  Object ZoneId.
   * @return date String in yyy-MM-dd HH:mm:ss
   */
  public static String displayTime(Instant instant, ZoneId zoneId) {
    return displayTime(getDate(instant, zoneId));
  }

  /**
   * @param zdt       Object ZonedDateTime.
   * @param useSecond Boolean to indicate to use second or not.
   * @return date String in yyy-MM-dd HH:mm:ss
   */
  public static String displayTime(ZonedDateTime zdt, boolean useSecond) {
    if (useSecond) {
      TIME_FORMATTER_1.format(zdt);
    }
    return TIME_FORMATTER_2.format(zdt);
  }

  /**
   * @param instant   Object Instant.
   * @param zoneId    Object ZoneId.
   * @param useSecond Boolean to indicate to use second or not.
   * @return date String in yyy-MM-dd HH:mm:ss
   */
  public static String displayTime(Instant instant, ZoneId zoneId, boolean useSecond) {
    return displayTime(getDate(instant, zoneId), useSecond);
  }

  public static ZonedDateTime convertEpochToTimestamp(long epoch) {
    Instant instant = Instant.ofEpochSecond(epoch);
    return ZonedDateTime.ofInstant(instant, ZoneId.of(DEFAULT_TIMEZONE));
  }

  public static String displayIso8601(ZonedDateTime zdt) {
    return ISO8601_FORMATTER.format(zdt);
  }

  public static String displayIso8601(Instant instant, ZoneId zoneId) {
    return displayIso8601(getDate(instant, zoneId));
  }

  public static String displayIso8601Lite(ZonedDateTime zdt) {
    return ISO8601_LITE_FORMATTER.format(zdt);
  }

  public static String displayIso8601Lite(Instant instant, ZoneId zoneId) {
    return displayIso8601Lite(getDate(instant, zoneId));
  }

  public static ZonedDateTime getStartOfDay(ZonedDateTime zdt) {
    return zdt.with(LocalTime.MIN);
  }

  public static ZonedDateTime getStartOfDay(Instant instant, ZoneId zoneId) {
    return getStartOfDay(getDate(instant, zoneId));
  }

  public static ZonedDateTime getEndOfDay(ZonedDateTime zdt) {
    return zdt.with(LocalTime.MAX);
  }

  public static ZonedDateTime getEndOfDay(Instant instant, ZoneId zoneId) {
    return getEndOfDay(getDate(instant, zoneId));
  }

  public static ZonedDateTime toUtc(ZonedDateTime zdt) {
    return zdt.withZoneSameInstant(ZoneId.of("UTC"));
  }

  public static ZonedDateTime fromDate(Date date) {
    return ZonedDateTime.ofInstant(Instant.ofEpochMilli(date.getTime()), DEFAULT_ZONE_ID);
  }

  public static ZonedDateTime fromDate(Date date, ZoneId zoneId) {
    return ZonedDateTime.ofInstant(Instant.ofEpochMilli(date.getTime()), zoneId);
  }

  public static void setDefaultZoneId(ZoneId zoneId) {
    DEFAULT_ZONE_ID = zoneId;
  }

  public static String getUTCDateTime(String date) {
    return LocalDateTime.parse(date, co.nvqa.commons.support.DateUtil.DATE_TIME_FORMATTER)
        .atZone(DEFAULT_ZONE_ID)
        .withZoneSameInstant(UTC_ZONE_ID)
        .format(co.nvqa.commons.support.DateUtil.DATE_TIME_FORMATTER);
  }

  public static String getUTCDateTimeDisplayIso8601(String date) {
    return LocalDateTime.parse(date, co.nvqa.commons.support.DateUtil.DATE_TIME_FORMATTER)
        .atZone(DEFAULT_ZONE_ID)
        .withZoneSameInstant(UTC_ZONE_ID)
        .format(co.nvqa.commons.support.DateUtil.ISO8601_FORMATTER_2);
  }

  public static String getUTCDateTimeDisplayIso8601Lite(String date) {
    return LocalDateTime.parse(date, co.nvqa.commons.support.DateUtil.DATE_TIME_FORMATTER)
        .atZone(DEFAULT_ZONE_ID)
        .withZoneSameInstant(UTC_ZONE_ID)
        .format(co.nvqa.commons.support.DateUtil.ISO8601_LITE_FORMATTER);
  }

  public static String getDefaultDateTimeFromUTC(String dateTime) {
    return LocalDateTime.parse(dateTime, co.nvqa.commons.support.DateUtil.DATE_TIME_FORMATTER)
        .atZone(UTC_ZONE_ID)
        .withZoneSameInstant(DEFAULT_ZONE_ID)
        .format(co.nvqa.commons.support.DateUtil.DATE_TIME_FORMATTER);
  }

  public static String getDefaultDateTimeFromUTCIso8601Lite(String dateTime) {
    return LocalDateTime.parse(dateTime, co.nvqa.commons.support.DateUtil.ISO8601_LITE_FORMATTER)
        .atZone(UTC_ZONE_ID)
        .withZoneSameInstant(DEFAULT_ZONE_ID)
        .format(co.nvqa.commons.support.DateUtil.DATE_TIME_FORMATTER);
  }

  public static String getDefaultDateFromUTC(String dateTime) {
    return LocalDateTime.parse(dateTime, co.nvqa.commons.support.DateUtil.DATE_TIME_FORMATTER)
        .atZone(UTC_ZONE_ID)
        .withZoneSameInstant(DEFAULT_ZONE_ID)
        .format(co.nvqa.commons.support.DateUtil.DTF_YYYY_MM_DD);
  }

  public static String getTomorrowDay(ZonedDateTime zdt) {
    return DTF_EEEE.format(zdt.plusDays(1));
  }

  public static String getTodayDay(ZonedDateTime zdt) {
    return DTF_EEEE.format(zdt);
  }

  public static String getTomorrowDay() {
    return getTomorrowDay(getDate());
  }

  public static String getTodayDay() {
    return getTodayDay(getDate());
  }

  public static String displayDateTimeForReport(ZonedDateTime zdt) {
    return DATETIME_REPORT_NAME_FORMATTER.format(zdt);
  }

  /**
   * Return next year of current day current day: 2020-10-10 => 2021-10-10
   *
   * @return string in format yyyy-MM-dd.
   */
  public static String getTodayNextYear_YYYY_MM_DD() {
    Calendar cal = Calendar.getInstance();
    cal.add(Calendar.YEAR, 1);
    return SDF_YYYY_MM_DD.format(cal.getTime());
  }

  /**
   * Return next year of tomorrow current day: 2020-10-10 => 2021-10-11
   *
   * @return string in format yyyy-MM-dd.
   */
  public static String getTomorrowDateNextYear_YYYY_MM_DD() {
    Calendar cal = Calendar.getInstance();
    cal.add(Calendar.YEAR, 1);
    cal.add(Calendar.DATE, 1);
    return SDF_YYYY_MM_DD.format(cal.getTime());
  }

  /**
   * return operator local datetime string from backend datetime string
   *
   * @param backendTimeString String
   * @return
   */
  public static String displayOperatorTime(String backendTimeString, boolean witRounding) {
    ZonedDateTime zdt = getDate(backendTimeString).withZoneSameInstant(ZoneId.of(
        DEFAULT_TIMEZONE));
    if (witRounding && zdt.getNano() > 500) {
      zdt = zdt.plusSeconds(1);
    }
    return zdt.format(DATE_TIME_FORMATTER);
  }

  public static String getAdjustedLocalTimeFromUTC(String timeInUTC, int timeDiff) {
    String adjustedLocalTime = "";
    Calendar cal = Calendar.getInstance();
    try {
      Date utcTime = co.nvqa.commons.support.DateUtil.SDF_YYYY_MM_DD_HH_MM_SS.parse(timeInUTC);
      cal.setTime(utcTime);
      cal.add(Calendar.HOUR, timeDiff);
      adjustedLocalTime = co.nvqa.commons.support.DateUtil.SDF_YYYY_MM_DD_HH_MM_SS.format(
          cal.getTime());
    } catch (ParseException ex) {
      throw new NvTestRuntimeException(ex);
    }
    return adjustedLocalTime;
  }

  public static String getWorkingDay_YYYY_MM_DD(int days) {
    LocalDate localDate = co.nvqa.commons.support.DateUtil.getDate().toLocalDate();
    int addedDays = 0;
    while (addedDays < days) {
      localDate = localDate.plusDays(1);
      if (!(localDate.getDayOfWeek() == DayOfWeek.SATURDAY
          || localDate.getDayOfWeek() == DayOfWeek.SUNDAY)) {
        ++addedDays;
      }
    }
    return localDate.toString();
  }

  /**
   * Return specific {int} date after today string in format yyyy-MM-dd.
   *
   * @return specific {int}  date after today string in format yyyy-MM-dd.
   */
  public static String getSpecificDate_YYYY_MM_DD(int days) {
    Calendar cal = Calendar.getInstance();
    cal.add(Calendar.DATE, days);
    return SDF_YYYY_MM_DD.format(cal.getTime());
  }

  public static String generateUTCTodayDate() {
    ZonedDateTime startDateTime = co.nvqa.commons.support.DateUtil.getStartOfDay(
        co.nvqa.commons.support.DateUtil.getDate());
    return co.nvqa.commons.support.DateUtil
        .displayDateTime(startDateTime.withZoneSameInstant(ZoneId.of("UTC")));
  }

  public static String getUTCTodayDate() {
    return co.nvqa.commons.support.DateUtil
        .displayDate(Calendar.getInstance().toInstant().atZone(ZoneId.of("UTC")));
  }

  public static String generateUTCTodayDateTime() {
    ZonedDateTime startDateTime = co.nvqa.commons.support.DateUtil.getStartOfDay(
        co.nvqa.commons.support.DateUtil.getDate());
    return co.nvqa.commons.support.DateUtil
        .displayDateTime(startDateTime.withZoneSameInstant(ZoneId.of("UTC")));
  }

  public static String generateUTCYesterdayDate() {
    ZonedDateTime startDateTime = co.nvqa.commons.support.DateUtil.getStartOfDay(
        co.nvqa.commons.support.DateUtil.getDate()).minusDays(1);
    return co.nvqa.commons.support.DateUtil
        .displayDateTime(startDateTime.withZoneSameInstant(ZoneId.of("UTC")));
  }

  public static String getPastFutureDate(String reqDate, String format) {
    if (reqDate.contains("D-")) {
      reqDate = reqDate.substring(1);
    } else if (reqDate.contains("D+")) {
      reqDate = reqDate.substring(2);
    }
    int day = Integer.parseInt(reqDate);
    Format dateFormat = new SimpleDateFormat(format);
    reqDate = dateFormat.format(DateUtils.addDays(new Date(), day));
    return reqDate;
  }

  public static String formatDate(String date, String initDateFormat, String requiredDateFormat)
      throws ParseException {
    Date initDate = new SimpleDateFormat(initDateFormat).parse(date);
    SimpleDateFormat formatter = new SimpleDateFormat(requiredDateFormat);
    return formatter.format(initDate);
  }
}

