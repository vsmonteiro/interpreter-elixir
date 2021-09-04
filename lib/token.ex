defmodule Shell.Token do
  defstruct [:type, :literal]

  @keywords %{
    "function" => :function,
    "let" => :let,
    "const" => :const,
    "true" => true,
    "false" => false,
    "if" => :if,
    "else" => :else,
    "return" => :return
  }

  @types %{
    int: "INT",
    float: "FLOAT",
    plus: "+",
    minus: "-",
    mul: "*",
    div: "/",
    lparen: "(",
    rparen: ")",
    semicolon: ";",
    eq: "==",
    not_eq: "!="
  }

  def new(type: type, literal: literal) when is_atom(type) and is_binary(literal) do
    if Map.has_key?(@types, type) do
      %__MODULE__{type: type, literal: literal}
    else
      raise "Token not found"
    end
  end

  def check_identifier(ident) do
    Map.get(@keywords, ident, :ident)
  end
end
