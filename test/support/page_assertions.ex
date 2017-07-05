defmodule PageAssertions do
  use Phoenix.ConnTest
  import PageQueries
  import ExUnit.Assertions

  def has_title(html, expected_title) do
    assert html |> Floki.find("h1") |> Floki.text() == expected_title
    html
  end

  def has_feedback_questions(html, amount) do
    assert html |> Floki.find(".feedback-question") |> length == amount
    html
  end

  def has_answers(html, answers_to_look_for) do
    html
    |> Floki.find(".feedback-answer > blockquote")
    |> Enum.map(&Floki.text/1)
    |> Enum.each(&(assert Enum.member?(answers_to_look_for, &1)))
    html
  end

  def has_continue_button_with(html, text) do
    button = html
             |> Floki.find(".button")
             |> Floki.text

    assert button =~ text
    html
  end

  def has_requester(html, requester_name) do
    assert requester(html) =~ requester_name
    html
  end

  def has_advisors(html, advisors_names) do
    assert advisors(html) == advisors_names
    html
  end

  def has_completed_advice(html) do
    assert html
           |> Floki.find(".completeness")
           |> Enum.map(&Floki.text/1)
           |> Enum.any?(&(&1 =~ "Completed"))

    html
  end

  def has_header(html, header) do
    value = html
            |> Floki.find("h1")
            |> Floki.text

    assert value ==  header
  end

end