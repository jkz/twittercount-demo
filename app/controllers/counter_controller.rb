class CounterController < ApplicationController
    def index
        @tweets = Tweet.all()
        @count = @tweets.count
    end
end
