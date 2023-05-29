defmodule PentoWeb.GuessingGameLive do
  use PentoWeb, :live_view

  @make_a_guess "Make a guess"

  defp bad_guess(guess), do: "You guessed #{guess}. You were wrong! Guess again"
  defp good_guess(guess), do: "You guessed #{guess}. You were right. You win!"

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:score, 0)
     |> assign(:message, @make_a_guess)
     |> assign(:number, Enum.random(1..10))
     |> assign(:game_over, false)}
  end

  def handle_event("guess", %{"number" => number}, socket) do
    guess = String.to_integer(number)

    if guess == socket.assigns.number do
      {:noreply,
       socket
       |> assign(:message, good_guess(guess))
       |> assign(:score, socket.assigns.score + 5)
       |> assign(:game_over, true)}
    else
      {:noreply,
       socket
       |> assign(:message, bad_guess(guess))
       |> assign(:score, socket.assigns.score - 1)}
    end
  end

  def handle_event("restart", _params, socket) do
    {:noreply,
     socket
     |> assign(:message, @make_a_guess)
     |> assign(:number, Enum.random(1..10))
     |> assign(:game_over, false)}
  end

  def render(assigns) do
    ~H"""
    <p>Your score: <%= @score %></p>
    <p><%= @message %></p>
    <.guess_buttons disabled={@game_over} />

    <%= if @game_over do %>
      <.restart_button />
    <% end %>
    """
  end

  defp guess_buttons(assigns) do
    ~H"""
    <p class="pt-2">
      <%= for n <- 1..10 do %>
        <button phx-click="guess" phx-value-number={n} class={btn_classes()} disabled={@disabled}>
          <%= n %>
        </button>
      <% end %>
    </p>
    """
  end

  defp restart_button(assigns) do
    ~H"""
    <p class="pt-3">
      <button phx-click="restart" class={btn_classes()}>Restart</button>
    </p>
    """
  end

  defp btn_classes() do
    ~w(middle none center mr-2 rounded bg-blue-500 py-2 px-4
      font-sans text-xs font-bold text-white
      transition-all focus:opacity-[0.85] active:opacity-[0.85]
      disabled:pointer-events-none disabled:opacity-50)
  end
end
