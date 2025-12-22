defmodule AresWeb.AppLive.Profile do
  use AresWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-5xl mx-auto pt-8">
      <div class="text-center mb-12">
        <div class="w-32 h-32 rounded-full bg-gradient-to-bl from-primary to-darkest-pink mx-auto mb-6 flex items-center justify-center shadow-2xl">
          <span class="text-6xl font-bold">
            {String.first(@user.name)}
          </span>
        </div>
        <h1 class="text-4xl sm:text-6xl font-extrabold tracking-tight mb-2">{@user.name}</h1>
        <p class="text-2xl text-gray-300">{@user.email}</p>
      </div>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, %{assigns: %{current_scope: %{user: user}}} = socket)
      when not is_nil(user) do
    {:ok, assign(socket, user: user)}
  end
end
