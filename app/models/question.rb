class Question < ActiveRecord::Base
  
  validates :text, presence: true
  validates :poll_id, presence: true
  
  belongs_to(
    :poll,
    class_name: 'Poll',
    primary_key: :id,
    foreign_key: :poll_id
  )
  
  has_many(
    :answer_choices,
    class_name: 'AnswerChoice',
    primary_key: :id,
    foreign_key: :question_id
  )  
  
  def results
    # question_results = {}
    #
    # self.answer_choices.responses
    result = {}
    a = AnswerChoice.joins(:responses)
    .where("answer_choices.question_id = ?", self.id)
    .group("responses.answer_choice_id")
    .select("answer_choices.*, count(*) AS count")
    
    
    
    a.each do |choice|
      result[choice.text] = choice.count
    end
    
    result
    
    # .each do |answer_choice|
    #
    # a.id
    # Start with AnswerChoice
    # join it with responses
    # filter it to only consider answer choices for this question
    # Do a group by
    # Select out all the normal answer_choices columns, plus a count of the group size.
    # In Ruby, transform this array of AnswerChoices into the desired Hash.

    # => All the responses for this question.
    # SELECT
    #   answer_choice.*, COUNT(*) AS num_responses
    # ...
    # GROUP BY
    #   answer_choice.id
    
    # #group(column_name)
    # #select(...)
    # => array of answer choices, each answer choice has a num_responses attribute
    
    
    # question_results
  end
  
end