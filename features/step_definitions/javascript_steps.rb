Then /^I should see a javascript confirmation with text '(.*)'$/ do |text|
  expect(page.driver.browser.switch_to.alert.text).to eq text
end

When /^I accept the javascript confirmation$/ do
  page.driver.browser.switch_to.alert.accept
end

When /^I dismiss the javascript confirmation$/ do
  page.driver.browser.switch_to.alert.dismiss
end
