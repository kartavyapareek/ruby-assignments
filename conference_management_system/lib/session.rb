# frozen_string_literal: true

require 'date'

# Session Class
class Session
  attr_accessor :track_number, :remaining_duration, :start_time, :end_time,
                :assigned_talks, :unassigned_talks

  MINUTES_PER_DAY = 24 * 60

  def initialize(track_number, start_time, end_time)
    @track_number = track_number
    @start_time = DateTime.strptime(start_time, '%I:%M %p')
    @end_time = DateTime.strptime(end_time, '%I:%M %p')
    @remaining_duration = total_duration # in minutes
    @assigned_talks = []
  end

  def allot_talks(unassigned_talks)
    @unassigned_talks = unassigned_talks
    select_talks_for_slot
    set_start_time_and_assign_to_session
  end

  private

  def total_duration
    @total_duration ||= ((end_time - start_time) * MINUTES_PER_DAY).to_i
  end

  def select_talks_for_slot
    @unassigned_talks.each do |talk|
      break unless @remaining_duration > talk.duration

      @assigned_talks.push(talk)
      @remaining_duration -= talk.duration
    end
    @unassigned_talks -= @assigned_talks

    @unassigned_talks.each do |talk|
      break if @remaining_duration.zero?

      samll_duration_task = @assigned_talks.find do |small_talk|
        talk.duration > small_talk.duration &&
          (talk.duration - small_talk.duration) <= @remaining_duration
      end
      break unless samll_duration_task

      @assigned_talks.delete(samll_duration_task)
      @assigned_talks.push(talk)
      @remaining_duration -= (talk.duration - samll_duration_task.duration)
    end
  end

  def set_start_time_and_assign_to_session
    assign_attr_lightning_task = @assigned_talks.index(&:combile_lightning_talk?)

    if assign_attr_lightning_task
      @assigned_talks[assign_attr_lightning_task].slot = self
      @assigned_talks[assign_attr_lightning_task, 1] = Talk.lightning_talks_arr
    end

    alloted_minutes = 0
    @assigned_talks.each do |talk|
      talk.slot = self
      talk.start_time = @start_time + (alloted_minutes / MINUTES_PER_DAY.to_f)
      alloted_minutes += talk.duration
    end
  end
end