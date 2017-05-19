class ReposController < ApplicationController
  def index
    result = FetchReposWithIssues.call
    render json: { repos: result.repos }
  end

  private

  def serialized_repos
    result = FetchReposWithIssues.call
    result.repos.map do |repo|
      {
        name: repo.split("/").last,
        path: repo
      }
    end
  end
end
