require 'delegate'
require 'active_support/inflector'

module SimplePresenter

# Public: Base presenter class for encapsulating view logic and
# data that our data store shouldn't care about.
#
# Inherits from SimpleDelegator class to allow undefined presenter
# methods to fall back to underlying objects.
#
#
  class Base < SimpleDelegator

# Public: Defines a method for the supplied name
# that returns the object that presenter has been
# instantiated with.
#
# Examples
#
#   class LessonPresenter < SimplePresenter::Base
#   presents :lesson
#
#   # Allows you to call `lesson` within your presenter like so:
#   def text
#     lesson.some_attribute
#   end
#
    def self.presents(name)
      define_method(name) do
        __getobj__
      end
    end


# Public: Provides a method to wrap objects in a has_many
# relationship in presenters.
#
# Examples
#
#   # inside LessonStepPresenter
#   presents_many :step_modules
#
#   # inside LessonStepController
#   @lesson_step = LessonStepPresenter.new(LessonStep.find(params[:id]))
#
#   # step_modules queried through LessonStepPresenter
#   # return step_modules wrapped in Presentation class
#   @lesson_step.step_modules.each do |sm|
#     sm.render_module(self)
#   end
#
    def self.presents_many(relation)
      define_method(relation) do
        __getobj__.send(relation).map { |rel| apply_presenter(rel) }
      end
    end

# Internal: Instantiate new presenter for an object
#
# Examples
#
#   apply_presenter(object)
#   # => ObjectPresenter.new(object)
#
    def apply_presenter(obj)
      presenter = relation_presenter_class(obj)
      presenter.new(obj)
    end


# Internal: Finds a presenter class name based on the class name of the
# object that's passed to the method.
#
# Examples
#
#   relation_presenter_class(lesson_step)
#   # => LessonStepPresenter
#
    def relation_presenter_class(relation)
      (relation.class.name.to_s.classify + "Presenter").constantize
    end

  end
end