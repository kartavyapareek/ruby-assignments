# frozen_string_literal: true

require_relative 'rest_client.rb'
require 'json'

# GitHub Service Class
class GitHubService
  attr_accessor :score

  DEFAULT_SCORE = 1

  SCORES = {
    'IssuesEvent' => 7,
    'IssueCommentEvent' => 6,
    'PushEvent' => 5,
    'PullRequestReviewCommentEvent' => 4,
    'WatchEvent' => 3,
    'CreateEvent' => 2
  }

  SCORES.default = DEFAULT_SCORE

  def initialize(type)
    @score = SCORES[type]
  end

  class << self
    def find_score_for_user(url_for_get_score)
      raw_scores_data = RestClient.get(url_for_get_score)
      parsed_scores_data = JSON.parse(raw_scores_data)
      all_scores = []

      parsed_scores_data.each do |data|
        git_score = new(data['type'])
        all_scores.push(git_score)
      end

      all_scores
    end
  end
end
