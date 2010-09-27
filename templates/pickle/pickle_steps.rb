# this file generated by pickle generator

# make and store a reference to a model
#
#   Given a person "Fred"
#     # later...
#     When I go to "Fred"'s page
#
#   Given a product with price: 20.50
#     # later ...
#     Then I should see "20.50" within the product's panel
#     Given another product with site: 1st product's site
#
Given(/^#{pickle_ref}(?: with #{pickle_fields})?$/) do |ref, fields|
  pickle.make_and_store ref, fields
end

# make and store references to n models
#
#   Given 5 people exist
#
Given(/^(\d+) #{pickle_plural}(?: with #{pickle_fields})?$/) do |count, plural, fields|
  count.to_i.times { pickle.make_and_store plural.singularize, fields }
end

# make and store models from a table
#
# An optional column with factory name labels the models
#
#   Given the following people:
#     | person | age |
#     | fred   | 23  |
#     | jim    | 28  |
#
Given(/^the following #{pickle_plural}:$/) do |plural, table|
  factory = plural.singularize
  table.hashes.each {|attrs| pickle.make_and_store({:factory => factory, :label => attrs.delete(factory)}, attrs) }
end

# find and store a reference to a model
#
#   Then there should be an account
#   Then there should be a person "Fred" with status: "on hold"
#
Then(/^there should be #{pickle_ref}(?: with #{pickle_fields})?$/) do |ref, fields|
  pickle.find_and_store(ref, fields)
end

# assert no model exists in db
#
#   Then there should not be an account with holder: "Fred"
#
Then(/^there should not be #{pickle_ref}(?: with #{pickle_fields})?$/) do |ref, fields|
  pickle.should_not be_exist(ref, fields)
end

# find and store models using fields from a table
#
#   Then there should be the following people:
#     | person | status      |
#     | Fred   | "signed up" |
#     | Betty  | "closed"    |
#
Then(/^there should be the following #{pickle_plural}:$/) do |plural, table|
  factory = plural.singularize
  table.hashes.each {|attrs| pickle.find_and_store({:factory => factory, :label => attrs.delete(factory)}, attrs) }
end

# find and store n models
#
#   Then there should be at least 10 people
#   Then there should be 2 people with status: "activated"
#   Then there should be at most 5 products with status: 'discounted'
#
Then(/^there should be (exactly |at most |at least )?(\d+) #{pickle_plural}(?: with #{pickle_fields})?$/) do |comparison, count, plural, fields|
  operator = (comparison =~ /most/ && '<=') || (comparison =~ /least/ && '>=') || '=='
  pickle.find_all_and_store(plural, fields).size.should.send(operator, count.to_i)
end

# store an association of a known model with pickle
#     
#   Given a product
#   And notice the product's site
#   Given another product "Foo"
#   And note the product's site "Foo site"
#
#   Then "Foo" should be amongst "Foo site"'s products
#   And the 1st product should be amongst the 1st site's products
#
Then(/^not(?:ic)?e #{pickle_ref}'s (\w+)(?: #{pickle_label})?$/) do |ref, assoc, label|
  noted = pickle.model(ref).send(assoc)
  pickle.store noted, :label => label
end

# assert equality/inequality of models
#
#    Then the 1st user should be "Betty"
#    And the 2nd user should not be "Betty"
Then(/^#{pickle_ref} (should(?: not)?) be #{pickle_ref}$/) do |a, expectation, b|
  pickle.model(a).send(expectation.sub(' ','_')) == pickle.model(b)
end

# assert model is/is not in another model's collection association
#
#    Then "Fred" should be amongst "Betty"'s friends
#    And "Fred" should not be one of "Betty"'s children

Then(/^#{pickle_ref} (should(?: not)?) be (?:in|one of|amongst) #{pickle_ref}(?:'s)? (\w+)$/) do |target, expectation, owner, association|
  pickle.model(owner).send(association).send expectation.sub(' ','_'), include(pickle.model(target))
end

# assert model has/has not n association members
#    
#    Then "Fred" should have at least 10 children
#    And "Fred" should have exactly 2 parents
#    And "Fred" should have at most 3 dogs
#    And "Fred" should not have 3 parents
#
Then /^#{pickle_ref} (should(?: not)?) have( exactly| at most| at least)? (\d+) (\w+)$/ do |ref, expectation, comparison, count, association|
  operator = (comparison =~ /most/ && '<=') || (comparison =~ /least/ && '>=') || '=='
  pickle.model(ref).send(association).size.send(expectation.sub(' ','_')).send(operator, count.to_i)
end

# assert model is/is not another model's has_one/belongs_to assoc
#
#    Then "Betty"'s "father" should be "Fred"
#    And "Betty"'s "mother" should not be "Fred"
#
Then(/^#{pickle_ref}'s #{pickle_predicate} (should(?: not)?) be #{pickle_ref}$/) do |owner, association, expectation, target|
  pickle.model(owner).send(make_method(association)).send(expectation.sub(' ','_')) == pickle.model(target)
end

# assert model is/is not a predicate
#
#    Then "Fred" should be activated
#    And "Fred" should be "unusually large"
#    And "Fred" should not be a giant
#
#    # when pickle.config.predicates << 'ridiculously small'
#    And "Fred" should not be ridiculously small
#
Then(/^#{pickle_ref} (should(?: not)?) be(?: an?)? #{pickle_predicate}$/) do |ref, expectation, something|
  pickle.model(ref).send expectation.sub(' ','_'), make_matcher(something)
end

# assert model has/has not a predicate
#  
#    Then "Fred" should have creditors
#    And "Fred" should not have arrears
#
Then(/^#{pickle_ref} (should(?: not)?) have(?: an?)? #{pickle_predicate}$/) do |ref, expectation, something|
  pickle.model(ref).send expectation.sub(' ','_'), make_matcher(something, "have")
end

# assert model has/has not an attribute
#
#    Then "Fred"'s status should be "activated"
#    And "Fred"'s balance should not be 0
#    And "Fred"'s mother should be the first person
#
Then(/^#{pickle_ref}'s (\w+) (should(?: not)?) be #{pickle_value}$/) do |ref, attribute, expectation, expected|
  actual = pickle.model(ref).send(attribute)
  expected = pickle.value(expected)
  actual.send expectation.sub(' ','_'), eql(expected)
end

# assert model's attribute same as other model's attribute
#
#    Then "Fred"'s status should be the same as "Betty"'s status
#    And "Fred"'s father should be "Betty"'s grandfather
#
Then(/^#{pickle_ref}'s (\w+) (should(?: not)?) be(?: the same as)? #{pickle_ref}'s (\w+)$/) do |a, a_attr, expectation, b, b_attr|
  a_value = pickle.model(a).send(a_attr)
  b_value = pickle.model(b).send(b_attr)
  a_value.send expectation.sub(' ','_'), eql(b_value)
end


