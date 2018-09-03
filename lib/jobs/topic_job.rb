# Topic Job Class
class TopicJob
  include SendGrid
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
        send_topic topic, user_course[:id], user[:email]
        mark_topic_as_sent topic, user
        update_last_sent_time user_course
        break
      end
    end
  end

  def topic_already_sent(topic, user_id, course_id)
    UserTopic.exists? topic_id: topic[:id], user_id: user_id, course_id: course_id
  end

  def send_topic(topic, course_id, user_email)
    url = "#{ENV['HOST_NAME']}/dashboard/courses/#{course_id}/topics/#{topic[:id]}"
    mail = Mail.new
    mail.from = Email.new(email: ENV['ADMIN_EMAIL'])
    mail.subject = 'Something New To Learn'
    personalization = Personalization.new
    personalization.add_to(Email.new(email: user_email))
    data = { title: topic[:title], description: topic[:description], url: url }
    mail.add_personalization(personalization)
    mail.template_id = ENV['SENDGRID_TEMPLATE_ID']
    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    mail.personalizations[0]['dynamic_template_data'] = data
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    raise 'delivery failed' if response.status_code.to_i > 399
  end

  def mark_topic_as_sent(topic, user)
    user_topic = { topic_id: topic[:id], course_id: topic[:course_id], user_id: user[:id] }
    user.user_topics.create user_topic
  end

  def update_last_sent_time(user_course)
    user_course.update last_sent_time: Time.now.strftime('%Y-%m-%d %H:%M:%S')
  end
end
