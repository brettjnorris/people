class MainController < ApplicationController
  def index
    @people = Person.all
  end

  def frequency
    @character_counts = Person.character_frequency
  end
end