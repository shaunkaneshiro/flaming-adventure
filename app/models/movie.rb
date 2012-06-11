class Movie < ActiveRecord::Base
  def self.all_ratings_method
     find(:all, :select => "distinct(rating)", :conditions => "rating is not null").map {|i| i.rating}
  end
end
