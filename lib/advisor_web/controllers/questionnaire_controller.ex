defmodule AdvisorWeb.QuestionnaireController do
  use AdvisorWeb, :controller
  alias Advisor.Core.Questionnaire

  plug AdvisorWeb.Authentication.Gatekeeper, only: :group_leads

  def delete(conn, %{"id" => id}) do
    Questionnaire.delete(id)
    send_resp(conn, 200, "")
  end
end
