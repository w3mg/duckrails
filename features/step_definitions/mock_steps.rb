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
