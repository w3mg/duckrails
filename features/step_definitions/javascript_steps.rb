Then /^I should see a javascript confirmation with text '(.*)'$/ do |text|
  expect(page.driver.browser.switch_to.alert.text).to eq text
end

When /^I accept the javascript confirmation$/ do
  page.driver.browser.switch_to.alert.accept
  # FIXME: we sleep here to allow the rails url helpers to be successfully reloaded with the new routes
  sleep 2
end

When /^I dismiss the javascript confirmation$/ do
  page.driver.browser.switch_to.alert.dismiss
  # FIXME: we sleep here to allow the rails url helpers to be successfully reloaded with the new routes
  sleep 2
end
