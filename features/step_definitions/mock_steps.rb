Given /^There are (\d*) mocks$/ do |number|
  number.to_i.times do |i|
    FactoryGirl.create :mock, route_path: "/cucumber/#{i}", name: "Mock:#{i}", id: i
  end
end

When /^I click the edit link for mock with id (\d*)$/ do |mock_id|
  page.find("table.mocks tbody tr[data-mock-id='#{mock_id}']").find('a.edit').click
end

When /^I click the delete link for mock with id (\d*)$/ do |mock_id|
  page.find("table.mocks tbody tr[data-mock-id='#{mock_id}']").find('a.delete').click
end

Then /^There should( not)? be an entry for mock with id (\d*)$/ do |should_not, mock_id|
  should_mode = should_not ? :not_to : :to
  expect(page).send should_mode, have_css("table.mocks tbody tr[data-mock-id='#{mock_id}']")
end

Then /^The mock form should( not)? have errors$/ do |should_not|
  should_mode = should_not ? :not_to : :to
  expect(page).send(should_mode, have_css('form.mock-form small.error'))
end

When /^I submit the mock form$/ do
  page.find('form.mock-form input[type="submit"]').click
end

Then /^The (General|Response body|Headers|Advanced) tab of the mock form should( not)? have errors$/ do |tab, should_not|
  should_mode = should_not ? :not_to : :to
  expect(page).send should_mode, have_css('form.mock-form ul.tabs li.tab-title a.error', text: tab)
end

And /^The (General|Response body|Headers|Advanced) tab of the mock form should be selected$/ do |tab|
  expect(page).to have_css("form.mock-form div.active##{tab.parameterize.underscore}")
  expect(page).to have_css('form.mock-form ul.tabs li.tab-title.active a', text: tab)
end

Then /^The (.*) field of the mock form should have an error message "(.*)"$/ do |field, error|
  field_id = "duckrails_mock_#{field.parameterize.underscore}"
  expect(page).to have_css "form.mock-form div.error.#{field_id} small.error", text: error
end

When /^I click the (General|Response body|Headers|Advanced) tab of the mock form$/ do |tab|
  page.find('form.mock-form ul.tabs li a', text: tab).click
end

When /^I fill in the (.*) field of the mock form with value "([^"]*)"$/ do |field, value|
  field_id = "duckrails_mock_#{field.parameterize.underscore}"
  fill_in field_id, with: value
end

When /^I select the value "([^"]*)" on the (.*) of the mock form$/ do |value, field|
  field_id = "duckrails_mock_#{field.parameterize.underscore}"
  select value, from: field_id
end
