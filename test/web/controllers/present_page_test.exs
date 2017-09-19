defmodule AdvisorWeb.PresentPageTest do
  use AdvisorWeb.ConnCase
  import PageAssertions

  alias Advisor.Core.Questionnaire
  alias AdvisorWeb.QuestionnaireProposal, as: Proposal
  alias AdvisorWeb.Links
  alias Advisor.Core.Questionnaire.Creator

  @sample_questions [1, 2]

  setup do
    proposal = Proposal.build(for: "Rabea Gleissner",
                              advisors: ["Chris Jordan", "Priya Patil"],
                              group_lead: "Felipe Sere",
                              questions: @sample_questions)
    [proposal: proposal]
  end

  test "it displays all four answers to the questionnaire", %{conn: conn, proposal: proposal} do
    questionnaire = {:ok, %{questionnaire: id}} = Creator.create(proposal)

    {[%{link: cj}, %{link: priya}], _, present_link} = questionnaire
                                                       |> Links.generate

    answers = id
              |> Questionnaire.find()
              |> Map.get(:question_ids)
              |> Enum.map(fn(q) -> {q, "fooo"} end)

    conn
    |> ThroughTheWeb.login_as("Chris Jordan")
    |> post(cj, answers)

    conn
    |> ThroughTheWeb.login_as("Priya Patil")
    |> post(priya, answers)

    conn
    |> ThroughTheWeb.login_as("Felipe Sere")
    |> get(present_link)
    |> html_response(200)
    |> has_title("Advice for Rabea Gleissner")
    |> has_feedback_questions(2)
    |> has_answers(["fooo", "fooo"])
  end
end
