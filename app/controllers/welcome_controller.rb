# -*- coding: utf-8 -*-
class WelcomeController < ApplicationController
  def index
    @main = Article.find_by(name: "Главная")
  end
end
