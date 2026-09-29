# Integrantes:
# [Melany Yiseth Gomez Bacca]
# [David Cuellar Velez]
# [Isabella Ochoa Escobar]


defmodule Validacion do
  @dias_recepcion 6
  @max_litros 800

  @doc """
  Valida una entrega siguiendo exactamente el orden solicitado.
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

  defp validar_productor(%{productor: codigo}, productores) do
    if Enum.any?(productores, fn productor ->
         productor.codigo == codigo
       end) do
      :ok
    else
      {:error, :productor_desconocido}
    end
  end

  defp validar_tanque(%{tanque: id}, tanques) do
    if Enum.any?(tanques, fn tanque ->
         tanque.id == id
       end) do
      :ok
    else
      {:error, :tanque_desconocido}
    end
  end

  defp validar_dia(%{dia: dia})
       when is_integer(dia) and dia >= 1 and dia <= @dias_recepcion do
    :ok
  end

  defp validar_dia(_entrega) do
    {:error, :dia_invalido}
  end

  defp validar_litros(%{litros: litros})
       when is_number(litros) and litros > 0 and litros <= @max_litros do
    :ok
  end

  defp validar_litros(_entrega) do
    {:error, :litros_fuera_de_rango}
  end

  defp validar_grasa(%{grasa: grasa})
       when is_number(grasa) and grasa >= 0 and grasa <= 15 do
    :ok
  end

  defp validar_grasa(_entrega) do
    {:error, :porcentaje_invalido}
  end
end
