defmodule RPG do
  defmodule Character do
    defstruct health: 100, mana: 0
  end

  defmodule LoafOfBread do
    defstruct []
  end

  defmodule ManaPotion do
    defstruct strength: 10
  end

  defmodule Poison do
    defstruct []
  end

  defmodule EmptyBottle do
    defstruct []
  end

  defprotocol Edible do
    def eat(item, char)
  end

  defimpl Edible, for: LoafOfBread do
    alias RPG.Edible.LoafOfBread
    alias RPG.Character

    def eat(_, %Character{health: health} = char) do
      {nil, %Character{char | health: health + 5}}
    end
  end

  defimpl Edible, for: ManaPotion do
    alias RPG.Character

    def eat(%ManaPotion{} = potion, %Character{mana: mana} = char) do
      {%EmptyBottle{}, %Character{char | mana: mana + potion.strength}}
    end
  end

  defimpl Edible, for: Poison do
    alias RPG.Poison
    alias RPG.Character

    def eat(%Poison{}, %Character{} = char) do
      {%EmptyBottle{}, %Character{char | health: 0}}
    end
  end
end
