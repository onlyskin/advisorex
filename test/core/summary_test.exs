defmodule Advisor.Core.SummaryTest do
  use Advisor.DataCase

  alias Advisor.Web.QuestionnaireProposal, as: Proposal
  alias Advisor.Core.Questionnaire.Creator
  alias Advisor.Core.{Answers, Summary}

  setup do
    proposal = Proposal.build(for: "Rabea Gleissner",
                              advisors: ["Chris Jordan", "Priya Patil"],
                              group_lead: "Felipe Sere",
                              questions: [1, 2])

    [proposal: proposal]
  end

  def answer!(advisories, data) when is_list(advisories) do
    advisories
    |> Enum.each(fn(advisory) -> answer!(advisory, data) end)
  end
  def answer!(%{id: id}, [with: data]) do
    Answers.store(Map.put(data, "id", id))
  end

  test "presents tabular data for a given questionnaire", %{proposal: proposal} do
    {:ok, created} = Creator.create(proposal)
    %{advisories: advisories, questionnaire: id} = created

    answer!(advisories, with: %{"1" => "Foo", "2" => "Bar"})

    [_headers, first, _second] = Summary.for_download(id)
    assert length(first) == 5
  end
end
