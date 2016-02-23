class HomeController < ApplicationController
  def index
  end

  def hello
    render text: "hello, World"
  end
end
