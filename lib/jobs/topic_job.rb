# Topic Job Class
class TopicJob
  def start
    midnight = Date.today.midnight
    end_of_day = Date.today.end_of_day
    query = "(last_sent_time + learning_interval_days * interval '1 day' >= '#{midnight}' "
    query += "AND last_sent_time + learning_interval_days * interval '1 day' <= '#{end_of_day}') "
    query += 'OR last_sent_time is NULL'
    users_course = UserCourse.includes({ course: %i[topics] }, :user)
    users_course = users_course.where(query)
    users_course.find_in_batches do |group|
      process_group group
    end
  end

  private

  def process_group(group)
    group.each do |user_course|
      user = user_course.user
      course = user_course.course
      user_course.course.topics.each do |topic|
        next if topic_already_sent topic, user[:id], course[:id]
        next unless Time.now.hour == user_course[:daily_delivery_time]
        send_topic topic
        mark_topic_as_sent topic, user
        update_last_sent_time user_course
        break
      end
    end
  end

  def topic_already_sent(topic, user_id, course_id)
    UserTopic.exists? topic_id: topic[:id], user_id: user_id, course_id: course_id
  end

  def send_topic(topic)
    # send mail
    print topic.to_json
  end

  def mark_topic_as_sent(topic, user)
    user_topic = { topic_id: topic[:id], course_id: topic[:course_id], user_id: user[:id] }
    user.user_topics.create user_topic
  end

  def update_last_sent_time(user_course)
    user_course.update last_sent_time: Time.now.strftime('%Y-%m-%d %H:%M:%S')
  end
end
