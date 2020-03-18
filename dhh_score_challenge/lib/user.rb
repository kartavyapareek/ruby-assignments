# frozen_string_literal: true

require_relative '../service/git_hub_service.rb'
# User class
class User
  attr_accessor :username

  def initialize(username)
    @username = username
  end

  def github_score
    scores = GitHubService.find_score_for_user(create_github_url)
    scores.inject(0) { |res, event| res += event.score }
  end

  private

  def create_github_url
    "https://api.github.com/users/#{username}/events/public"
  end
end
