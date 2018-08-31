import co.nvqa.common_selenium.model.PerformanceLogEntry;
import co.nvqa.commons.support.JsonHelper;
import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;
import org.junit.runner.RunWith;

/**
 * Cucumber - Junit link. Invoke with "gradle test".
 * Sync the configuration here to build.gradle file.
 *
 * @author Ferdinand Kurniadi
 */
@RunWith(Cucumber.class)
@CucumberOptions
(
    plugin =
    {
        "pretty",
        "html:build/reports/cucumber-junit/htmloutput",
        "json:build/reports/cucumber-junit/cucumber.json",
        "junit:build/reports/cucumber-junit/cucumber.xml"
    },
    monochrome = true,
    glue =
    {
        "com.nv.qa.cucumber.glue"
    },
    features =
    {
        "src/test/resources/cucumber/feature"
    }
)
public class TestRunner
{
    @SuppressWarnings("EmptyMethod")
    public static void main(String[] args)
    {
        String data = "{\n" +
                "    \"message\":{\n" +
                "        \"method\":\"Network.responseReceived\",\n" +
                "        \"params\":{\n" +
                "            \"frameId\":\"E494C62BAB84AE1372B07D0C97858983\",\n" +
                "            \"loaderId\":\"0A53A751108ABF93E62861CEA05931B2\",\n" +
                "            \"requestId\":\"1000002055.260\",\n" +
                "            \"response\":{\n" +
                "                \"connectionId\":350,\n" +
                "                \"connectionReused\":true,\n" +
                "                \"encodedDataLength\":539,\n" +
                "                \"fromDiskCache\":false,\n" +
                "                \"fromServiceWorker\":false,\n" +
                "                \"headers\":{\n" +
                "                    \"access-control-allow-credentials\":\"true\",\n" +
                "                    \"access-control-allow-headers\":\"Accept,Authorization,Cache-Control,Content-Type,DNT,If-Modified-Since,Keep-Alive,Origin,User-Agent,X-Mx-ReqToken,X-Requested-With,timezone,csrf_token,version,x-nv-shipper-id,x-nv-firebase-token\",\n" +
                "                    \"access-control-allow-methods\":\"GET, PATCH, POST, PUT, DELETE, OPTIONS\",\n" +
                "                    \"access-control-allow-origin\":\"https://operatorv2-qa.ninjavan.co\",\n" +
                "                    \"access-control-expose-headers\":\"x-nv-total-count,ETag,If-None-Match\",\n" +
                "                    \"content-length\":\"263\",\n" +
                "                    \"content-type\":\"application/json; charset=UTF-8\",\n" +
                "                    \"date\":\"Fri, 31 Aug 2018 08:37:47 GMT\",\n" +
                "                    \"request-time\":\"13\",\n" +
                "                    \"server\":\"openresty/1.11.2.4\",\n" +
                "                    \"status\":\"200\",\n" +
                "                    \"x-nv-artifact-id\":\"36678c4ede63b7ecefd77d835559285fdc42e56f\",\n" +
                "                    \"x-nv-release-id\":\"20180831_072823_36678c4ede63b7ecefd77d835559285fdc42e56f\"\n" +
                "                },\n" +
                "                \"mimeType\":\"application/json\",\n" +
                "                \"protocol\":\"h2\",\n" +
                "                \"remoteIPAddress\":\"35.187.238.65\",\n" +
                "                \"remotePort\":443,\n" +
                "                \"requestHeaders\":{\n" +
                "                    \":authority\":\"api-qa.ninjavan.co\",\n" +
                "                    \":method\":\"POST\",\n" +
                "                    \":path\":\"/sg/core/scans/inbounds\",\n" +
                "                    \":scheme\":\"https\",\n" +
                "                    \"accept\":\"application/json, text/plain, */*\",\n" +
                "                    \"accept-encoding\":\"gzip, deflate, br\",\n" +
                "                    \"accept-language\":\"en\",\n" +
                "                    \"authorization\":\"Bearer 2wh78HIvRsYwouJq4TZfX5flvX3VR5iwCMBvgGLL\",\n" +
                "                    \"content-length\":\"91\",\n" +
                "                    \"content-type\":\"application/json;charset=UTF-8\",\n" +
                "                    \"origin\":\"https://operatorv2-qa.ninjavan.co\",\n" +
                "                    \"referer\":\"https://operatorv2-qa.ninjavan.co/\",\n" +
                "                    \"timezone\":\"Asia/Singapore\",\n" +
                "                    \"user-agent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.106 Safari/537.36\"\n" +
                "                },\n" +
                "                \"securityDetails\":{\n" +
                "                    \"certificateId\":0,\n" +
                "                    \"certificateTransparencyCompliance\":\"not-compliant\",\n" +
                "                    \"cipher\":\"AES_256_GCM\",\n" +
                "                    \"issuer\":\"COMODO RSA Organization Validation Secure Server CA\",\n" +
                "                    \"keyExchange\":\"ECDHE_RSA\",\n" +
                "                    \"keyExchangeGroup\":\"P-256\",\n" +
                "                    \"protocol\":\"TLS 1.2\",\n" +
                "                    \"sanList\":[\n" +
                "                        \"*.ninjavan.co\",\n" +
                "                        \"ninjavan.co\"\n" +
                "                    ],\n" +
                "                    \"signedCertificateTimestampList\":[\n" +
                "\n" +
                "                    ],\n" +
                "                    \"subjectName\":\"*.ninjavan.co\",\n" +
                "                    \"validFrom\":1514419200,\n" +
                "                    \"validTo\":1612828799\n" +
                "                },\n" +
                "                \"securityState\":\"secure\",\n" +
                "                \"status\":200,\n" +
                "                \"statusText\":\"\",\n" +
                "                \"timing\":{\n" +
                "                    \"connectEnd\":-1,\n" +
                "                    \"connectStart\":-1,\n" +
                "                    \"dnsEnd\":-1,\n" +
                "                    \"dnsStart\":-1,\n" +
                "                    \"proxyEnd\":-1,\n" +
                "                    \"proxyStart\":-1,\n" +
                "                    \"pushEnd\":0,\n" +
                "                    \"pushStart\":0,\n" +
                "                    \"receiveHeadersEnd\":35.836,\n" +
                "                    \"requestTime\":15919.588068,\n" +
                "                    \"sendEnd\":0.836,\n" +
                "                    \"sendStart\":0.489,\n" +
                "                    \"sslEnd\":-1,\n" +
                "                    \"sslStart\":-1,\n" +
                "                    \"workerReady\":-1,\n" +
                "                    \"workerStart\":-1\n" +
                "                },\n" +
                "                \"url\":\"https://api-qa.ninjavan.co/sg/core/scans/inbounds\"\n" +
                "            },\n" +
                "            \"timestamp\":15919.625143,\n" +
                "            \"type\":\"XHR\"\n" +
                "        }\n" +
                "    },\n" +
                "    \"webview\":\"E494C62BAB84AE1372B07D0C97858983\"\n" +
                "}";

        PerformanceLogEntry performanceLogEntry = JsonHelper.fromJson(data, PerformanceLogEntry.class);
        System.out.println(performanceLogEntry.getMessage().getParams().getResponse().toCurl());
    }
}
