# frozen_string_literal: true

require 'json'
require_relative 'lib/conference_manager.rb'

session_input_file = File.open 'input/session_input.json'
session_attributes_hash = JSON.load session_input_file

talks_input_file = File.open 'input/talks_input.json'
talks_attributes_hash = JSON.load talks_input_file

begin
  conf_manager = ConferenceManager.new(session_attributes_hash, talks_attributes_hash['given_talks'])
  conf_manager.allot_session

  # Print Assigned Talks
  assigned_talks = conf_manager.assigned_talks.group_by(&:track_number)

  if !assigned_talks.empty?
    puts "Assigned Talks"
    assigned_talks.each do |key, value|
      puts "\nTrack #{key}"
      value.sort_by(&:start_time).each { |talk| puts "#{talk.start_time&.strftime('%I:%M %p')} #{talk.title} #{talk.printable_duration}".strip }
    end
  end

  # Print unassigned Talks
  unassigned_talks = conf_manager.unassigned_talks.group_by(&:track_number)

  if !unassigned_talks.empty?
    puts "\nUnassigned Talks"
    unassigned_talks.each do |key, value|
      value.sort_by(&:start_time).each { |talk| puts "#{talk.start_time&.strftime('%I:%M %p')} #{talk.title} #{talk.printable_duration}".strip }
    end
  end
rescue StandardError => e
  puts e.message
end
