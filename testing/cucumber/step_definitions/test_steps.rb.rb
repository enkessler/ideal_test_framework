When(/^pass$/) do
  puts 'Success'
end

When(/^fail$/) do
  raise('Boom!')
end
