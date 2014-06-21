class User < ActiveRecord::Base
  
  validates :username, presence: true
  
  has_many(
    :authored_polls,
    class_name: 'Poll',
    primary_key: :id,
    foreign_key: :author_id
  )
  
  has_many(
    :responses,
    class_name: 'Response',
    primary_key: :id,
    foreign_key: :user_id
  )
  
  def completed_polls
    Poll.find_by_sql([<<-SQL, self.id])
     SELECT *
     FROM polls
     WHERE (
       SELECT COUNT(*)
       FROM questions
       WHERE questions.poll_id = polls.id
       ) = (
        SELECT COUNT(*)
        FROM responses
        JOIN answer_choices 
        ON responses.answer_choice_id = answer_choices.id
        JOIN questions 
        ON answer_choices.question_id = questions.id
        WHERE questions.poll_id = polls.id
          AND responses.user_id = ?
        )
    SQL
       
  end
  
  def uncompleted_polls
    Poll.find_by_sql([<<-SQL, self.id])
     SELECT *
     FROM polls
     JOIN (
       SELECT poll.id, COUNT(*)-- poll id, and the count(*)
       FROM responses
       JOIN answer_choices 
       ON responses.answer_choice_id = answer_choices.id
       JOIN questions
       ON answer_choices.question_id = questions.id
         WHERE responses.user_id = ?
         GROUP BY poll.id-- group up the questions by the id the poll 
     ) AS num_answered ON xyz.poll_id = polls.id
     
     WHERE (
       SELECT COUNT(*)
       FROM questions
       WHERE questions.poll_id = polls.id
       ) -- compare against num_answered count
    SQL
  end

end