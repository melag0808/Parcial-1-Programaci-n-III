# Integrantes:
# [Melany Yiseth Gomez Bacca]
# [David Cuellar Velez]
# [Isabella Ochoa Escobar]


defmodule Validacion do
  @dias_recepcion 6
  @max_litros 800

  @doc """
  Valida una entrega siguiendo exactamente el orden solicitado.

  Primero valida que el productor exista, luego que el tanque exista,
  posteriormente valida el día, la cantidad de litros y finalmente
  el porcentaje de grasa.

  Retorna {:ok, entrega} si todos los datos son válidos.

  Retorna {:error, motivo} si alguna validación falla.
  """
  def validar_entrega(entrega, productores, tanques) do
    with :ok <- validar_productor(entrega, productores),
         :ok <- validar_tanque(entrega, tanques),
         :ok <- validar_dia(entrega),
         :ok <- validar_litros(entrega),
         :ok <- validar_grasa(entrega) do
      {:ok, entrega}
    else
      {:error, motivo} ->
        {:error, motivo}
    end
  end

  @doc """
  Valida todas las entregas de una colección.

  Recorre cada entrega utilizando validar_entrega/3 y separa
  las entregas válidas de las rechazadas.

  Las entregas rechazadas se almacenan junto con el motivo
  por el cual fueron rechazadas.

  Retorna una tupla con la siguiente estructura:

      {validas, rechazadas}
  """
  def validar_todas(entregas, productores, tanques) do
    {validas, rechazadas} =
      Enum.reduce(entregas, {[], []}, fn entrega, {validas, rechazadas} ->
        case validar_entrega(entrega, productores, tanques) do
          {:ok, entrega_valida} ->
            {[entrega_valida | validas], rechazadas}

          {:error, motivo} ->
            {validas, [{entrega, motivo} | rechazadas]}
        end
      end)

    {Enum.reverse(validas), Enum.reverse(rechazadas)}
  end

  @doc """
  Valida que el productor indicado en una entrega exista.

  Busca el código del productor dentro de la colección de productores.

  Retorna :ok si el productor existe.

  Retorna {:error, :productor_desconocido} si el código
  del productor no se encuentra registrado.
  """
  defp validar_productor(%{productor: codigo}, productores) do
    if Enum.any?(productores, fn productor ->
         productor.codigo == codigo
       end) do
      :ok
    else
      {:error, :productor_desconocido}
    end
  end

  @doc """
  Valida que el tanque indicado en una entrega exista.

  Busca el identificador del tanque dentro de la colección de tanques.

  Retorna :ok si el tanque existe.

  Retorna {:error, :tanque_desconocido} si el tanque
  no se encuentra registrado.
  """
  defp validar_tanque(%{tanque: id}, tanques) do
    if Enum.any?(tanques, fn tanque ->
         tanque.id == id
       end) do
      :ok
    else
      {:error, :tanque_desconocido}
    end
  end

  @doc """
  Valida que el día de una entrega sea correcto.

  El día debe ser un número entero y encontrarse entre 1
  y la cantidad de días de recepción establecida.

  Retorna :ok cuando el día es válido.
  """
  defp validar_dia(%{dia: dia})
       when is_integer(dia) and dia >= 1 and dia <= @dias_recepcion do
    :ok
  end

  @doc """
  Maneja las entregas que tienen un día inválido.

  Esta función se ejecuta cuando el día no cumple las condiciones
  establecidas en la validación anterior.

  Retorna:

      {:error, :dia_invalido}
  """
  defp validar_dia(_entrega) do
    {:error, :dia_invalido}
  end

  @doc """
  Valida la cantidad de litros de una entrega.

  Los litros deben ser un valor numérico mayor que cero y no
  pueden superar el máximo de litros permitido por entrega.

  Retorna :ok cuando la cantidad de litros es válida.
  """
  defp validar_litros(%{litros: litros})
       when is_number(litros) and litros > 0 and litros <= @max_litros do
    :ok
  end

  @doc """
  Maneja las entregas cuya cantidad de litros es inválida.

  Se ejecuta cuando los litros no son numéricos, son menores
  o iguales a cero o superan el máximo permitido.

  Retorna:

      {:error, :litros_fuera_de_rango}
  """
  defp validar_litros(_entrega) do
    {:error, :litros_fuera_de_rango}
  end

  @doc """
  Valida el porcentaje de grasa de una entrega.

  El porcentaje de grasa debe ser un valor numérico comprendido
  entre 0 y 15.

  Retorna :ok cuando el porcentaje se encuentra dentro
  del rango permitido.
  """
  defp validar_grasa(%{grasa: grasa})
       when is_number(grasa) and grasa >= 0 and grasa <= 15 do
    :ok
  end

  @doc """
  Maneja las entregas cuyo porcentaje de grasa es inválido.

  Se ejecuta cuando el porcentaje no es numérico o se encuentra
  fuera del rango permitido entre 0 y 15.

  Retorna:

      {:error, :porcentaje_invalido}
  """
  defp validar_grasa(_entrega) do
    {:error, :porcentaje_invalido}
  end

  @doc """
  Convierte una entrega ingresada como texto.

  El texto debe contener cinco campos separados por punto y coma
  siguiendo el formato:

      productor;tanque;dia;litros;grasa

  Ejemplo:

      P03;T2;4;320.5;3.6

  Si existen exactamente cinco campos, estos se envían a
  convertir_campos/1.

  Si el formato no contiene exactamente cinco campos retorna:

      {:error, :formato_invalido}
  """
  def convertir_entrega(texto) do
    campos = String.split(texto, ";")

    if length(campos) == 5 do
      convertir_campos(campos)
    else
      {:error, :formato_invalido}
    end
  end

  defp convertir_campos([productor, tanque, dia, litros, grasa]) do
    with {:ok, dia} <- Util.convertir(dia, :entero),
         {:ok, litros} <- Util.convertir(litros, :real),
         {:ok, grasa} <- Util.convertir(grasa, :real) do

      {:ok,
       %{
         productor: productor,
         tanque: tanque,
         dia: dia,
         litros: litros,
         grasa: grasa
       }}
    else
      _ -> {:error, :formato_invalido}
    end
  end
end
