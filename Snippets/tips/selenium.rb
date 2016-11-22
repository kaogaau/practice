require "selenium-webdriver"
driver = Selenium::WebDriver.for(:remote, :url => "http://localhost:8910")
driver.navigate.to "https://www.facebook.com/"
#element = driver.find_element(:name, 'q')
#element.send_keys "PhantomJS"
#element.submit
puts driver.page_source
driver.quit
