package co.nvqa.plugin

import org.apache.commons.configuration2.CompositeConfiguration
import org.apache.commons.configuration2.PropertiesConfiguration
import org.apache.commons.configuration2.builder.FileBasedConfigurationBuilder
import org.apache.commons.configuration2.builder.fluent.Parameters
import org.apache.commons.lang3.StringUtils
import org.apache.tools.ant.filters.ReplaceTokens
import org.gradle.api.Plugin
import org.gradle.api.Project

import java.text.SimpleDateFormat

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
class CucumberPlugin implements Plugin<Project>
{
    Project project

    void apply(Project project)
    {
        this.project = project
        configureProcessTestResources()
    }

    void configureProcessTestResources()
    {
        Map<String, String> tokens = new HashMap<>()

        project.tasks.getByName("processTestResources") {
            println "Initialize processTestResources..."

            filesMatching(["**/*.feature"]) {
                filter(ReplaceTokens, tokens: tokens, beginToken: "{", endToken: "}")
            }
        }.doFirst {
            println "Load heavy properties here..."

            def environment = "local"

            if(project.hasProperty("environment"))
            {
                environment = project.getProperty("environment")
            }

            def propertiesFileName = "src/test/resources/$environment-config.properties"
            println "[GRADLE_INFO] Resource is filtered and replaced using this properties file: $propertiesFileName"

            Parameters parameters = new Parameters()
            CompositeConfiguration compositeConfiguration = new CompositeConfiguration()

            String environmentConfigFilename = StringUtils.isBlank(environment)? "local-config.properties" :  "$environment-config.properties"
            File environmentConfigFile = new File("src/test/resources/$environmentConfigFilename")

            if(environmentConfigFile.exists())
            {
                println "[GRADLE_INFO] Environment Configuration File: ${environmentConfigFile.getPath()}"

                FileBasedConfigurationBuilder<PropertiesConfiguration> configurationBuilder = new FileBasedConfigurationBuilder<>(PropertiesConfiguration.class)
                        .configure(parameters.properties().setFile(environmentConfigFile))
                compositeConfiguration.addConfiguration(configurationBuilder.getConfiguration())
            }
            else
            {
                println "[GRADLE_INFO] Environment configuration file with name = '$environmentConfigFilename' not found in classpath."
            }

            File defaultConfigFile = new File("src/test/resources/default-config.properties")

            if(defaultConfigFile.exists())
            {
                println "[GRADLE_INFO] Default Configuration File: ${defaultConfigFile.getPath()}"
                println "[GRADLE_INFO] Please take note, the value from \"Environment Configuration\" file will hide (override) the value from \"Default Configuration\" file if the key is same."

                FileBasedConfigurationBuilder<PropertiesConfiguration> configurationBuilder = new FileBasedConfigurationBuilder<>(PropertiesConfiguration.class)
                        .configure(parameters.properties().setFile(defaultConfigFile))
                compositeConfiguration.addConfiguration(configurationBuilder.getConfiguration())
            }
            else
            {
                println "[GRADLE_INFO] Default configuration file not found in classpath."
            }

            Iterator<String> compositeConfigurationKeys = compositeConfiguration.getKeys()

            while(compositeConfigurationKeys.hasNext())
            {
                String key = compositeConfigurationKeys.next()
                String value = compositeConfiguration.getString(key)
                tokens.put(key, value)
            }

            if(project.hasProperty("platform"))
            {
                def platform = project.getProperty("platform").toString().toLowerCase()
                println "[GRADLE_INFO] Platform: $platform"
                tokens.put("platform", platform)
            }

            def defaultTimezone = tokens.get("default-timezone")

            if(defaultTimezone==null || defaultTimezone.isEmpty())
            {
                defaultTimezone = "Asia/Singapore"
            }

            TimeZone.setDefault(TimeZone.getTimeZone(defaultTimezone))

            Date currentDate = new Date()

            Calendar calPreviousDate = Calendar.getInstance()
            calPreviousDate.setTime(currentDate)
            calPreviousDate.add(Calendar.DATE, -1)
            Date previousDate = calPreviousDate.getTime()

            Calendar calPrevious2Date = Calendar.getInstance()
            calPrevious2Date.setTime(currentDate)
            calPrevious2Date.add(Calendar.DATE, -1)
            Date previous2Date = calPrevious2Date.getTime()

            Calendar calNextDate = Calendar.getInstance()
            calNextDate.setTime(currentDate)
            calNextDate.add(Calendar.DATE, 1)
            Date nextDate = calNextDate.getTime()

            Calendar calNext2Date = Calendar.getInstance()
            calNext2Date.setTime(currentDate)
            calNext2Date.add(Calendar.DATE, 2)
            Date next2Date = calNext2Date.getTime()

            println tokens

            tokens.put("gradle-previous-2-day-yyyy-MM-dd", new SimpleDateFormat("yyyy-MM-dd").format(previous2Date))
            tokens.put("gradle-previous-1-day-yyyy-MM-dd", new SimpleDateFormat("yyyy-MM-dd").format(previousDate))
            tokens.put("gradle-current-date-yyyy-MM-dd", new SimpleDateFormat("yyyy-MM-dd").format(currentDate))
            tokens.put("gradle-next-0-day-yyyy-MM-dd", new SimpleDateFormat("yyyy-MM-dd").format(currentDate))
            tokens.put("gradle-next-1-day-yyyy-MM-dd", new SimpleDateFormat("yyyy-MM-dd").format(nextDate))
            tokens.put("gradle-next-2-day-yyyy-MM-dd", new SimpleDateFormat("yyyy-MM-dd").format(next2Date))

            tokens.put("gradle-current-date-yyyyMMddHHmmsss", new SimpleDateFormat("yyyyMMddHHmmsss").format(currentDate))
            tokens.put("gradle-next-0-day-yyyyMMddHHmmsss", new SimpleDateFormat("yyyyMMddHHmmsss").format(currentDate))
            tokens.put("gradle-next-1-day-yyyyMMddHHmmsss", new SimpleDateFormat("yyyyMMddHHmmsss").format(nextDate))
            tokens.put("gradle-next-2-day-yyyyMMddHHmmsss", new SimpleDateFormat("yyyyMMddHHmmsss").format(next2Date))

            tokens.put("gradle-timezone-XXX", new SimpleDateFormat("XXX").format(currentDate))


            tokens.put("hub-id", "111")
        }
    }
}
