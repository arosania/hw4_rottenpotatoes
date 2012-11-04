# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
  end
  #assert false, "Unimplmemented"
end

# Make sure that one string (regexp) occurs before or after another one
# on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  # ensure that that e1 occurs before e2.
  # page.content is the entire content of the page as a string.
  x = page.body.split(e1)
  assert x.length == 3 # before title, before more info link, other content
  x = x[2].split(e2)
  assert x.length == 3
end

# Make it easier to express checking or unchecking several boxes at once
# "When I uncheck the following ratings: PG, G, R"
# "When I check the following ratings: G"

#When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  # iterate over the ratings and reuse the "When I check..." or
  # "When I uncheck..." steps in lines 89-95 of web_steps.rb
  
  rating_list.split(%r{\s*,\s*}).each_with_index {
      |name, index|
        if(!index) #first element
          When %Q{I #{uncheck}check "ratings[#{name}]"}
        else
          And %Q{I #{uncheck}check "ratings[#{name}]"}
        end
    }
end

Then /I should( not)? see all of the movies/ do |orNot|
  Movie.all.each_with_index {
    |movie, index|
      name = movie[:title]
      if(!index) #first element
        Then %Q{I should#{orNot} see "#{name}"}
      else
        And %Q{I should#{orNot} see "#{name}"}
      end
  }
end

Then /the director of "(.*)" should be "(.*)"/ do |title, director|
  m = Movie.find_by_title(title)
  assert director == m.director
end
