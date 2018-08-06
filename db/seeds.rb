ROOT = File.expand_path(__dir__)

Dir.glob(File.join(ROOT, 'seeds', '*.rb')).sort.each { |seed| load seed }
