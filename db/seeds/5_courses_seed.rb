def generateCourses(number)
  category_ids = Category.limit(6).map { |category| category[:id] }
  creator = User.find_by(email: ENV['ADMIN_EMAIL'])
  Array(1..number).map do
    {
      title: Faker::Lorem.paragraph_by_chars(70, false),
      description: Faker::Lorem.paragraph_by_chars(500, false),
      category_id: category_ids[rand(category_ids.length)],
      creator_id: creator[:id]
    }
  end
end

def generateTopics(course, number)
  topics = Array(1..number).map do
    {
      title: Faker::Lorem.paragraph_by_chars(70, false),
      description: Faker::Lorem.paragraph_by_chars(500, false),
      url: Faker::Internet.url
    }
  end
  course.topics.create topics
end

courses = Course.create generateCourses(20)
courses.each do |course|
  generateTopics(course, 6)
end
