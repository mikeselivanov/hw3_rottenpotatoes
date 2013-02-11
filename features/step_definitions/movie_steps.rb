# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    if !Movie.find_by_title(movie[:title])
      Movie.create movie
    end
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  page_body = page.body.to_s
  if (page.body.index(e1) != nil && page_body.index(e2) != nil)
    if (page_body.index(e1) < page_body.index(e2))
      # thats ok
    else
      assert false, 'fail'
    end
  else
    assert false, "fail"
  end
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(",").each do |rating|
    if uncheck
      uncheck("ratings_#{rating.strip}")
    else
      check("ratings_#{rating.strip}")
    end
  end
end

When /^I press (.*)$/ do |field|
  click_button(field)
end

Then /^I should see all movies$/ do
  page.all("table#movies tr").count.should == Movie.all.length + 1
end

Then /^I should see a movie "(.*)"/ do |text|
  if page.respond_to? :should
    page.should have_content(text)
  else
    assert page.has_content?(text)
  end
end

Then /^I should not see a movie "(.*)"/ do |text|
  if page.respond_to? :should
    page.should have_no_content(text)
  else
    assert page.has_no_content(text)
  end
end
