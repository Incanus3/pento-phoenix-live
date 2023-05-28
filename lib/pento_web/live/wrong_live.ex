defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, score: 0, message: "Make a guess", number: Enum.random(1..10))}
  end

  def handle_event("guess", %{"number" => number}, socket) do
    guess = String.to_integer(number)

    if guess == socket.assigns.number do
      {:noreply,
       socket
       |> assign(:message, "You guessed #{guess}. You were right. You win!")
       |> assign(:score, socket.assigns.score + 5)}
    else
      {:noreply,
       socket
       |> assign(:message, "You guessed #{guess}. You were wrong! Guess again")
       |> assign(:score, socket.assigns.score - 1)}
    end
  end

  def handle_event("restart", _params, socket) do
    {:noreply, assign(socket, score: 0, message: "Make a guess", number: Enum.random(1..10))}
  end

  def render(assigns) do
    ~H"""
    <p>Your score: <%= @score %></p>
    <p><%= @message %></p>

    <p class="pt-2">
      <%= for n <- 1..10 do %>
        <button phx-click="guess" phx-value-number={n} class={btn_classes()}>
          <%= n %>
        </button>
      <% end %>
    </p>

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
