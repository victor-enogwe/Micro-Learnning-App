[
  { name: 'sinatra', description: 'Sinatra is a DSL for quickly creating web applications in Ruby' },
  { name: 'express', description: 'Fast, unopinionated, minimalist web framework for Node.js' },
  { name: 'angular', description: 'Learn one way to build applications with Angular.' },
  { name: 'ruby', description: 'A dynamic, open source programming language.' },
  { name: 'react', description: 'React makes it painless to create interactive UIs.' },
  { name: 'nodeJs', description: 'Node.js is a JavaScript runtime built on Chrome\'s V8 JavaScript engine.' }
].each do |item|
  Category.create_with(description: item[:description]).find_or_create_by :name => item[:name]
end
