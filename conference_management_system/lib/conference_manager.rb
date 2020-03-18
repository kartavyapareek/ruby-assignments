# frozen_string_literal: true

require_relative 'session.rb'
require_relative 'talk.rb'
# Conference Manager Class
class ConferenceManager
  def initialize(session_attributes, given_talks_attributes)
    build_sessions(session_attributes)
    build_talks(given_talks_attributes)
  end

  def allot_session
    sessions.each do |session|
      session.allot_talks(unassigned_talks)
    end
  end

  def unassigned_talks
    talks.reject(&:unassigned?)
  end

  def assigned_talks
    sessions.flat_map(&:assigned_talks)
  end

  private

  def build_sessions(session_attributes)
    @sessions = []
    1.upto(session_attributes['number_of_tracks']) do |track_number|
      morning_session = Session.new(track_number, session_attributes['start_time'], session_attributes['lunch_start_time'])
      evening_session = Session.new(track_number, session_attributes['lunch_end_time'], session_attributes['end_time'])
      @sessions.push(morning_session, evening_session)
    end
  end

  def build_talks(given_talks_attributes)
    @talks = Talk.build_all(given_talks_attributes)
  end

  attr_accessor :sessions, :talks
end
