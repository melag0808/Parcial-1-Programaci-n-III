defmodule Util do

  def convertir(texto, :entero) do
    case Integer.parse(texto) do
      {valor, ""} -> {:ok, valor}
      _ -> {:error, :formato_invalido}
    end
  end

  def convertir(texto, :real) do
    case Float.parse(texto) do
      {valor, ""} -> {:ok, valor}
      _ -> {:error, :formato_invalido}
    end
  end
  def mostrar(mensaje, :mensaje), do: IO.puts(mensaje)
  def mostrar(mensaje, :error), do: IO.puts(:standard_error, mensaje)

  def ordenar(coleccion,sentido \\ :asc, obtener_campo \\ & &1) do
    Enum.sort_by(coleccion,obtener_campo,sentido)
  end

  def aplicar_filtro_longitud(coleccion, longitud) do
    Enum.filter(coleccion,&(String.length(&1) <= longitud))
  end

  def aplicar_filtro_inicio(coleccion, inicio)do
    Enum.filter(coleccion,&String.starts_with?(&1,inicio))
  end

  def convertir_coleccion_mensaje(coleccion,formato\\ fn elemento -> "- #{elemento}\n"  end) do
    Enum.map(coleccion, formato)
  end

  def ingresar(pregunta, :coleccion_reales) do
    ingresar(fn -> ingresar(pregunta, :real)end, :coleccion)
  end

  def ingresar(pregunta, :coleccion_enteros) do
    ingresar(fn -> ingresar(pregunta, :entero)end, :coleccion)
  end

  def ingresar(pregunta, :coleccion_textos) do
    ingresar(fn -> ingresar(pregunta, :texto)end, :coleccion)
  end

  def ingresar(ingresar_elemento, :coleccion) do
    ingresar_coleccion(ingresar_elemento,[])
  end

  def ingresar(mensaje, :boolean) do
    ingresar(
      mensaje,
      fn texto ->
      case String.downcase(texto) do
        "s" ->{true,""}
        "n" ->{false,""}
         _ -> :error
      end
      end,
      :boolean
    )
  end


  def ingresar(mensaje, :entero) do
    ingresar(
      mensaje,
      &Integer.parse/1,
      :entero
    )
  end

  def ingresar(mensaje, :real) do
    ingresar(
      mensaje,
      &Float.parse/1,
      :real
    )
  end

  def ingresar(pregunta, :texto) do
    pregunta
    |> IO.gets()
    |> String.trim()
  end

  defp ingresar(pregunta, parser, tipo_dato) do
    resultado =
      pregunta
      |> ingresar(:texto)
      |> parser.()

    case resultado do
      {valor, ""} ->
        valor

      _ ->
        mostrar(
          "El valor ingresado no es válido para el tipo #{tipo_dato}\n",
          :error
        )

        ingresar(pregunta, tipo_dato)
    end
  end

  defp ingresar_coleccion(ingresar_elemento,coleccion_actual) do
    elemento = ingresar_elemento.()

    nueva_lista= [elemento |coleccion_actual]

    case ingresar("\n ¿Hay mas datos? (s/n)?",:boolean)do
      true ->
        ingresar_coleccion(ingresar_elemento,nueva_lista)
      false ->
        Enum.reverse(nueva_lista)
    end
  end

end
