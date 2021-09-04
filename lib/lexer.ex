defmodule Shell.Lexer do
	alias Shell.Token
	def tokenize(input) do
		chars = String.split(input, "", trim: true)
		tokenize(chars, [])
	end

	defp tokenize(chars = [head_char | rest], tokens) do
		cond do
			is_whitespace(head_char) -> tokenize(rest, tokens)
			is_char(head_char) -> read_identifier(chars, tokens)
			is_num(head_char) -> read_number(chars, tokens)
			is_two_char_operator(chars) -> read_two_char_operator(chars, tokens)
			is_quote(head_char) -> read_string(chars, tokens)
			true -> read_next_char(chars, tokens)
		end
	end

	defp read_identifier(chars, tokens) do
		{ identifier, rest } = Enum.split_while(chars, &is_char/1)
	  identifier = Enum.join identifier
		token = Token.new(type: Token.check_identifier(identifier), literal: identifier)

		tokenize(rest, [token | tokens])
	end

	defp read_number(chars, tokens) do
		{ number, rest } = Enum.split_while(chars, &is_num/1)
		number = Enum.join(number)
		token = Token.new(type: :number, literal: number)

		tokenize(rest, [token, tokens])
	end

	defp read_two_char_operator(chars, tokens) do
		{ literal, rest } = Enum.split(chars, 2)
		literal = Enum.join(literal)

		token = case literal do
			"==" -> Token.new(type: :eq, literal: literal)
			"!=" -> Token.new(type: :not_eq, literal: literal)
		end

		tokenize(rest, [token | tokens])
	end

	defp read_string([_quote, rest], tokens) do
		{ string, [_quote | rest] } = Enum.split_while(rest, &is_quote(&1))
		string = Enum.join string
		token = Token.new(type: :string, literal: string)

		tokenize(rest, [token | tokens])
	end

	defp is_two_char_operator(chars) do
		first = Enum.at(chars, 0)
		sec = Enum.at(chars, 1)
		(first == "=" || first == "!") && sec == "="
	end

	defp is_char(ch) do
		String.match?(ch, ~r/^[a-zA-Z_]+$/)
	end

	defp is_num(ch) do
		ch >= "0" && ch <= "9"
	end

	defp is_whitespace(ch) do
		ch == " " || ch == "\n"
	end

	defp is_quote(str) do
		str == "\""
	end

	defp read_next_char(_chars = [ch | rest], tokens) do
    token =
      case ch do
        "=" -> Token.new(type: :assign, literal: ch)
        ";" -> Token.new(type: :semicolon, literal: ch)
        ":" -> Token.new(type: :colon, literal: ch)
        "(" -> Token.new(type: :lparen, literal: ch)
        ")" -> Token.new(type: :rparen, literal: ch)
        "+" -> Token.new(type: :plus, literal: ch)
        "-" -> Token.new(type: :minus, literal: ch)
        "!" -> Token.new(type: :bang, literal: ch)
        "*" -> Token.new(type: :asterisk, literal: ch)
        "/" -> Token.new(type: :slash, literal: ch)
        "<" -> Token.new(type: :lt, literal: ch)
        ">" -> Token.new(type: :gt, literal: ch)
        "," -> Token.new(type: :comma, literal: ch)
        "{" -> Token.new(type: :lbrace, literal: ch)
        "}" -> Token.new(type: :rbrace, literal: ch)
        "[" -> Token.new(type: :lbracket, literal: ch)
        "]" -> Token.new(type: :rbracket, literal: ch)
        _ -> Token.new(type: :illegal, literal: "")
      end

    tokenize(rest, [token | tokens])
  end
end
