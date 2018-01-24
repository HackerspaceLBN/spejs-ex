defmodule SpejsWeb.LayoutView do
  use SpejsWeb, :view

  def version do
    Application.get_env(:spejs, :revision, '??')
  end
end
