class Response < ActiveRecord::Base
  validates :user_id, presence: true
  validates :answer_choice_id, presence: true
  validate :respondent_has_not_already_answered_question
  validate :respondent_is_not_poll_author

  belongs_to(
    :answer_choice,
    class_name: 'AnswerChoice',
    primary_key: :id,
    foreign_key: :answer_choice_id
  )

  belongs_to(
    :respondent,
    class_name: 'User',
    primary_key: :id,
    foreign_key: :user_id
  )
  
  def respondent_has_not_already_answered_question
    unless existing_responses.empty? || existing_responses == [self]
      errors.add(:answer_choice_id, "shit")
    end
    # (existing_responses.length == 1 && existing_responses[0].id == self.id)
    
  end
  
  def existing_responses
    Response.find_by_sql([<<-SQL, self.respondent.id, self.answer_choice.question_id])
    SELECT responses.*
    FROM responses
    JOIN answer_choices ON responses.answer_choice_id = answer_choices.id
    WHERE responses.user_id = ?
      AND answer_choices.question_id = ?

    SQL
  end 
  
  def respondent_is_not_poll_author
    if user_id == answer_choice.question.poll.author_id
      errors.add(:user_id, "user is question author")
    end
  end
  
end