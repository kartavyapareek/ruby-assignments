# frozen_string_literal: true

# Talk Class
class Talk
  attr_accessor :title, :category, :duration, :slot, :start_time

  LIGHTNING_TALK_DURATION = 5
  LIGHTNING_TALKS = []

  def initialize(title, talk_duration)
    @title = title
    assign_category_and_duration(talk_duration)
  end

  class << self
    def build_all(given_talks)
      talks = []

      given_talks.each do |talk|
        new_talk = new(talk.first, talk.last)
        if new_talk.normal?
          talks.push(new_talk)
        else
          lightning_talks_arr.push(new_talk)
        end
      end

      lightning_talks_duration_total = lightning_talks_arr.map(&:duration).sum
      combine_lightning_talk = new('combile_lightning_talk', "#{lightning_talks_duration_total} minutes")
      talks.push(combine_lightning_talk)

      talks.sort_by(&:duration)
    end

    def lightning_talks_arr
      LIGHTNING_TALKS
    end
  end

  def normal?
    category == :normal
  end

  def lightning?
    category == :lightning
  end

  def unassigned?
    !slot.nil?
  end

  def combile_lightning_talk?
    title == 'combile_lightning_talk'
  end

  def track_number
    slot&.track_number
  end

  def printable_duration
    lightning? ? 'lightning talk' : "#{duration} minutes"
  end

  private

  def assign_category_and_duration(talk_duration)
    if talk_duration.to_i.zero?
      @category = :lightning
      @duration = LIGHTNING_TALK_DURATION
    else
      @category = :normal
      @duration = talk_duration.to_i
    end
  end
end
