class Tweet < ActiveRecord::Base
  attr_accessible :uid, :user, :text
end
