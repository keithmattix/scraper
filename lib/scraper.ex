defmodule Scraper do
  use Hound.Helpers
  @months ["january", "february", "march", "april", "may", "june", "july",
           "august", "september", "october", "november", "december"]

  def start do
    IO.puts "Starting scraper..."
    Hound.start_session
    data = Enum.reduce(@months, %{}, fn(month, accum) ->
      navigate_to "http://alafricanamerican.com/calendar/#{month}2016"
      events =
        find_all_elements(:css, ".post-content table:nth-child(6) tbody tr")
        |> Enum.with_index(1)
        |> Enum.map(fn({element, index}) ->
          :css
          |> find_element(".post-content table:nth-child(6) tbody tr:nth-child(#{index}) td:nth-child(2)")
          |> visible_text
        end)
      Map.put(accum, month, events)
    end)
    Hound.Helpers.Session.end_session
    File.write("data.json", Poison.encode!(data), [:binary])
  end
end
